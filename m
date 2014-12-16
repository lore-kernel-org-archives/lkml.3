Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLPHw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:52:27 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60459 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaLPHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:52:25 -0500
Date: Tue, 16 Dec 2014 08:53:00 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] vt: fix console lock vs. kernfs s_active lock
 order
Message-ID: <20141216075300.GI2711@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Peter Hurley <peter@hurleysoftware.com>,
	linux-kernel@vger.kernel.org
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
 <1418681761-3709-3-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418681761-3709-3-git-send-email-imre.deak@intel.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:16:01AM +0200, Imre Deak wrote:
> Currently there is a lock order problem between the console lock and the
> kernfs s_active lock of the console driver's bind sysfs entry. When
> writing to the sysfs entry the lock order is first s_active then console
> lock, when unregistering the console driver via
> do_unregister_con_driver() the order is the opposite. See the below
> bugzilla reference for one instance of a lockdep backtrace.
> 
> Fix this by unregistering the console driver from a deferred work, where
> we can safely drop the console lock while unregistering the device and
> corresponding sysfs entries (which in turn acquire s_active). Note that
> we have to keep the console driver slot in the registered_con_driver
> array reserved for the driver that's being unregistered until it's fully
> removed. Otherwise a concurrent call to do_register_con_driver could
> try to reuse the same slot and fail when registering the corresponding
> device with a minor index that's still in use.
> 
> Note that the referenced bug report contains two dmesg logs with two
> distinct lockdep reports: [1] is about a locking scenario involving
> s_active, console_lock and the fb_notifier list lock, while [2] is
> about a locking scenario involving only s_active and console_lock.
> In [1] locking fb_notifier triggers the lockdep warning only because
> of its dependence on console_lock, otherwise case [1] is the same
> s_active<->console_lock dependency problem fixed by this patch.
> Before this change we have the following locking scenarios involving
> the 3 locks:
> 
> a) via do_unregister_framebuffer()->...->do_unregister_con_driver():
>    1. console lock 2. fb_notifier lock 3. s_active lock
> b) for example via give_up_console()->do_unregister_con_driver():
>    1. console lock 2. s_active lock
> c) via vt_bind()/vt_unbind():
>    1. s_active lock 2. console lock
> 
> Since c) is the console bind sysfs entry's write code path we can't
> change the locking order there. We can only fix this issue by removing
> s_active's dependence on the other two locks in a) and b). We can do
> this only in the vt code which owns the corresponding sysfs entry, so
> that after the change we have:
> 
> a) 1. console lock 2. fb_notifier lock
> b) 1. console lock
> c) 1. s_active lock 2. console lock
> d) in the new con_driver_unregister_callback():
>    1. s_active lock
> 
> [1] https://bugs.freedesktop.org/attachment.cgi?id=87716
> [2] https://bugs.freedesktop.org/attachment.cgi?id=107602
> 
> v2:
> - get console_lock earlier in con_driver_unregister_callback(), so we
>   protect the following console driver field assignments there
> - add code coment explaining the reason for deferring the sysfs entry
>   removal
> - add a third paragraph to the commit message explaining why there are
>   two distinct lockdep reports and that this issue is independent of
>   fb/fbcon. (Peter Hurley)
> v3:
> - clarify further the third paragraph
> v4:
> - rebased on v4 of patch 1/3
> 
> Reference: https://bugs.freedesktop.org/show_bug.cgi?id=70523
> Signed-off-by: Imre Deak <imre.deak@intel.com>

So the normal/simple solution would be to remove the con driver from the
registration while holding required locks, but destroy sysfs stuff after
the critical section.

The problem is that console unbind/bind/reg/unreg are all done with the
locks held already, and the reason for that is the fbcon/fbdev notifier
chain. You can read up on the story by chasing the commits that added the
various locked do_* functions over the past years.

Short story is that the notifier chain has it's own mutex and any call
mediated through it introces that lock into the chain, which creates a
massive pile of additional depencies. The only solution is to grab _all_
required locks outside of that notifier chain, which means we've spent a
lot of patches growing the scope of console_lock. Which is bad, since
anything holding console_lock can't get dmesg lines out when it dies.

This patch here is another step into the wrong direction imo. It's also
for a feature that mere users should never use (even though it's in
sysfs). Heck it's a regression which has been introduced by pulling
console_lock out&up, before that effort sysfs files worked correctly and
implemented locking as described.

The right solution imo here is to at least cut up the fbdev notifier into
the different uses so that the locking artificial locking inversions go
away. Most of the calls are used to go from fbdev core (fbmem.c) to the
fbcon.c. Apparently someone though it would be great to allow fb.ko and
fbcon.ko to be able to load in any order whatsoever. Then there's various
other calls that go the other direction (e.g. fbcon calling into backlight
logic) and those introduce the locking inversion. So if we split things
into 2 notifier chais, one to exclusively call into fbcon and the other
for everything else we could revert all the patche that move console_lock
out and fix this bug here properly.

So NACK from me for this.
-Daniel

> ---
>  drivers/tty/vt/vt.c | 61 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 5d36c23..921854e 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -108,6 +108,7 @@
>  #define CON_DRIVER_FLAG_MODULE 1
>  #define CON_DRIVER_FLAG_INIT   2
>  #define CON_DRIVER_FLAG_ATTR   4
> +#define CON_DRIVER_FLAG_ZOMBIE 8
>  
>  struct con_driver {
>  	const struct consw *con;
> @@ -153,6 +154,7 @@ static int set_vesa_blanking(char __user *p);
>  static void set_cursor(struct vc_data *vc);
>  static void hide_cursor(struct vc_data *vc);
>  static void console_callback(struct work_struct *ignored);
> +static void con_driver_unregister_callback(struct work_struct *ignored);
>  static void blank_screen_t(unsigned long dummy);
>  static void set_palette(struct vc_data *vc);
>  
> @@ -182,6 +184,7 @@ static int blankinterval = 10*60;
>  core_param(consoleblank, blankinterval, int, 0444);
>  
>  static DECLARE_WORK(console_work, console_callback);
> +static DECLARE_WORK(con_driver_unregister_work, con_driver_unregister_callback);
>  
>  /*
>   * fg_console is the current virtual console,
> @@ -3603,7 +3606,8 @@ static int do_register_con_driver(const struct consw *csw, int first, int last)
>  	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
>  		con_driver = &registered_con_driver[i];
>  
> -		if (con_driver->con == NULL) {
> +		if (con_driver->con == NULL &&
> +		    !(con_driver->flag & CON_DRIVER_FLAG_ZOMBIE)) {
>  			con_driver->con = csw;
>  			con_driver->desc = desc;
>  			con_driver->node = i;
> @@ -3665,16 +3669,20 @@ int do_unregister_con_driver(const struct consw *csw)
>  		struct con_driver *con_driver = &registered_con_driver[i];
>  
>  		if (con_driver->con == csw) {
> -			vtconsole_deinit_device(con_driver);
> -			device_destroy(vtconsole_class,
> -				       MKDEV(0, con_driver->node));
> +			/*
> +			 * Defer the removal of the sysfs entries since that
> +			 * will acquire the kernfs s_active lock and we can't
> +			 * acquire this lock while holding the console lock:
> +			 * the unbind sysfs entry imposes already the opposite
> +			 * order. Reset con already here to prevent any later
> +			 * lookup to succeed and mark this slot as zombie, so
> +			 * it won't get reused until we complete the removal
> +			 * in the deferred work.
> +			 */
>  			con_driver->con = NULL;
> -			con_driver->desc = NULL;
> -			con_driver->dev = NULL;
> -			con_driver->node = 0;
> -			con_driver->flag = 0;
> -			con_driver->first = 0;
> -			con_driver->last = 0;
> +			con_driver->flag = CON_DRIVER_FLAG_ZOMBIE;
> +			schedule_work(&con_driver_unregister_work);
> +
>  			return 0;
>  		}
>  	}
> @@ -3683,6 +3691,39 @@ int do_unregister_con_driver(const struct consw *csw)
>  }
>  EXPORT_SYMBOL_GPL(do_unregister_con_driver);
>  
> +static void con_driver_unregister_callback(struct work_struct *ignored)
> +{
> +	int i;
> +
> +	console_lock();
> +
> +	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
> +		struct con_driver *con_driver = &registered_con_driver[i];
> +
> +		if (!(con_driver->flag & CON_DRIVER_FLAG_ZOMBIE))
> +			continue;
> +
> +		console_unlock();
> +
> +		vtconsole_deinit_device(con_driver);
> +		device_destroy(vtconsole_class, MKDEV(0, con_driver->node));
> +
> +		console_lock();
> +
> +		if (WARN_ON_ONCE(con_driver->con))
> +			con_driver->con = NULL;
> +		con_driver->desc = NULL;
> +		con_driver->dev = NULL;
> +		con_driver->node = 0;
> +		WARN_ON_ONCE(con_driver->flag != CON_DRIVER_FLAG_ZOMBIE);
> +		con_driver->flag = 0;
> +		con_driver->first = 0;
> +		con_driver->last = 0;
> +	}
> +
> +	console_unlock();
> +}
> +
>  /*
>   *	If we support more console drivers, this function is used
>   *	when a driver wants to take over some existing consoles
> -- 
> 1.8.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
