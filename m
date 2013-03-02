Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3CBNht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:37:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:25288 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab3CBNhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="293917641"
Date: Sat, 2 Mar 2013 21:37:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [usb gadget] WARNING: at kernel/mutex.c:198 __mutex_lock_common()
Message-ID: <20130302133736.GA13058@localhost>
References: <20130206020424.GB1175@localhost>
 <20130227104935.GZ8016@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227104935.GZ8016@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 12:49:35PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Feb 06, 2013 at 10:04:24AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below warning and the first bad commit is
> 
> can you send a fixup patch ?

Sorry I don't have the fix. Maarten once proposed

: Can you change __mutex_lock_common from inline to __always_inline and
: check if that gets rid of the warning?

and it worked at that time, however it does not work today when I
go out to double check the below patch...

---
mutex: fix mutex_lock_nested() warning by always inline __mutex_lock_common()

Proposed by Maarten Lankhorst.

[   46.942158] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   48.395515] ------------[ cut here ]------------
[   48.400015] WARNING: at /c/kernel-tests/src/stable/kernel/mutex.c:199 mutex_lock_nested+0x336/0x390()
[   48.400015] Hardware name: Bochs
[   48.400015] Pid: 1, comm: swapper Not tainted 3.8.0-06406-g16281d9 #47
[   48.400015] Call Trace:
[   48.400015]  [<ffffffff8105f36a>] warn_slowpath_common+0x7a/0xb0
[   48.400015]  [<ffffffff8105f48a>] warn_slowpath_null+0x1a/0x20
[   48.400015]  [<ffffffff81bb5d26>] mutex_lock_nested+0x336/0x390
[   48.400015]  [<ffffffff81968e1a>] ? gserial_alloc_line+0x4a/0x230
[   48.400015]  [<ffffffff81ae9bf5>] ? netdev_run_todo+0x55/0x390
[   48.400015]  [<ffffffff81968e1a>] gserial_alloc_line+0x4a/0x230
[   48.400015]  [<ffffffff823eecc0>] nokia_bind+0x39/0x15e
[   48.400015]  [<ffffffff819501ef>] composite_bind+0xcf/0x1c0
[   48.400015]  [<ffffffff823ee33e>] ? udc_driver_init+0x12/0x12
[   48.400015]  [<ffffffff8194c427>] udc_bind_to_driver+0x47/0x100
[   48.400015]  [<ffffffff8194d048>] usb_gadget_probe_driver+0x88/0xf0
[   48.400015]  [<ffffffff823ee32c>] ? m66592_probe+0x422/0x422
[   48.400015]  [<ffffffff8195036b>] usb_composite_probe+0x8b/0xb0
[   48.400015]  [<ffffffff823ee34e>] nokia_init+0x10/0x12
[   48.400015]  [<ffffffff823b7002>] do_one_initcall+0x78/0x136
[   48.400015]  [<ffffffff823b71b1>] kernel_init_freeable+0xf1/0x180
[   48.400015]  [<ffffffff823b686e>] ? do_early_param+0x8c/0x8c
[   48.400015]  [<ffffffff81ba1780>] ? rest_init+0xd0/0xd0
[   48.400015]  [<ffffffff81ba178e>] kernel_init+0xe/0xf0
[   48.400015]  [<ffffffff81bba32a>] ret_from_fork+0x7a/0xb0
[   48.400015]  [<ffffffff81ba1780>] ? rest_init+0xd0/0xd0
[   48.400015] ---[ end trace 6b9f844cfecfc556 ]---

---
 kernel/mutex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/kernel/mutex.c	2013-01-30 07:42:40.894224217 +0800
+++ linux/kernel/mutex.c	2013-03-02 21:25:48.809244384 +0800
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(mutex_unlock);
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
-static inline int __sched
+static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip)
 {
