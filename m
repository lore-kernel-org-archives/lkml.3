Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaLPHek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:34:40 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34052 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaLPHej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:34:39 -0500
Date: Tue, 16 Dec 2014 08:35:14 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] vt: fix check for system/busy console drivers
 when unregistering them
Message-ID: <20141216073514.GG2711@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Peter Hurley <peter@hurleysoftware.com>,
	linux-kernel@vger.kernel.org
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:15:59AM +0200, Imre Deak wrote:
> The default console driver (conswitchp) and busy drivers bound to a
> console (as reported by con_is_bound()) shouldn't be unregistered.
> System console drivers (without the CON_DRIVER_FLAG_MODULE flag) can be
> unregistered, provided they are neither default nor busy. The current
> code checks for the CON_DRIVER_FLAG_INIT flag but this doesn't make
> sense: this flag is set for a driver whenever its associated console's
> con_startup() function is called, which first happens when the console
> driver is registered (so before the console gets bound) and gets cleared
> when the console gets unbound. The purpose of this flag is to show if we
> need to call con_startup() on a console before we use it.
> 
> Based on the above, do_unregister_con_driver() in its current form will
> allow unregistering a console driver only if it was never bound, but
> will refuse to unregister one that was bound and later unbound.
> 
> Fix this by dropping the CON_DRIVER_FLAG_INIT check, allowing
> unregistering of any console driver provided that it's not the default
> one and it's not busy.
> 
> v2:
> - reword the third paragraph to clarify how the fix works (Peter Hurley)
> v3:
> - unchanged
> v4:
> - Allow unregistering a system console driver too, needed by i915 to
>   unregister vgacon. Update commit description accordingly. (Daniel)
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>

You've successufully tricked me to again look at vt.c. Argh!!

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/tty/vt/vt.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index f3fbbbc..9c046fb 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3665,8 +3665,7 @@ int do_unregister_con_driver(const struct consw *csw)
>  	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
>  		struct con_driver *con_driver = &registered_con_driver[i];
>  
> -		if (con_driver->con == csw &&
> -		    con_driver->flag & CON_DRIVER_FLAG_INIT) {
> +		if (con_driver->con == csw) {
>  			vtconsole_deinit_device(con_driver);
>  			device_destroy(vtconsole_class,
>  				       MKDEV(0, con_driver->node));
> -- 
> 1.8.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
