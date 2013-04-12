Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3DLPrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64618 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3DLPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:41 -0400
Date: Fri, 12 Apr 2013 17:47:30 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
To: Carsten Emde <C.Emde@osadl.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [ANNOUNCE] 3.6.11.1-rt32
In-Reply-To: <515A4CE4.9050607@osadl.org>
Message-ID: <alpine.LFD.2.03.1304121746340.5703@tycho>
References: <1364527527.10629.10.camel@gandalf.local.home> <515A4CE4.9050607@osadl.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806542-124736334-1365781656=:5703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806542-124736334-1365781656=:5703
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 2 Apr 2013, Carsten Emde wrote:

> Steven,
> 
> > I'm pleased to announce the 3.6.11.1-rt32 stable release.
> Unfortunately, there is another compile error:
> drivers/gpu/drm/i915/i915_gem.c: In function ‘i915_gem_wait_for_error’:
> drivers/gpu/drm/i915/i915_gem.c:118:3: warning: passing argument 1 of
> ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                  from include/linux/wait.h:24,
>                  from include/linux/fs.h:396,
>                  from include/drm/drmP.h:47,
>                  from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:21:24: note: expected ‘struct spinlock_t *’ but
> argument is of type ‘struct raw_spinlock_t *’
> drivers/gpu/drm/i915/i915_gem.c:120:3: warning: passing argument 1 of
> ‘rt_spin_unlock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                  from include/linux/wait.h:24,
>                  from include/linux/fs.h:396,
>                  from include/drm/drmP.h:47,
>                  from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:24:24: note: expected ‘struct spinlock_t *’ but
> argument is of type ‘struct raw_spinlock_t *’
> drivers/gpu/drm/i915/i915_gem.c: In function ‘i915_gem_check_wedge’:
> drivers/gpu/drm/i915/i915_gem.c:1890:3: warning: passing argument 1 of
> ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                  from include/linux/wait.h:24,
>                  from include/linux/fs.h:396,
>                  from include/drm/drmP.h:47,
>                  from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:21:24: note: expected ‘struct spinlock_t *’ but
> argument is of type ‘struct raw_spinlock_t *’
> drivers/gpu/drm/i915/i915_gem.c:1892:3: warning: passing argument 1 of
> ‘rt_spin_unlock’ from incompatible pointer type [enabled by default]
> In file included from include/linux/spinlock.h:273:0,
>                  from include/linux/wait.h:24,
>                  from include/linux/fs.h:396,
>                  from include/drm/drmP.h:47,
>                  from drivers/gpu/drm/i915/i915_gem.c:28:
> include/linux/spinlock_rt.h:24:24: note: expected ‘struct spinlock_t *’ but
> argument is of type ‘struct raw_spinlock_t *’
> 
> I would propose to adopt the mechanism that Sebastian introduced in
> 3.8.4-rt2 (https://lkml.org/lkml/2013/3/26/600). The kernel compiles
> and runs without any problem with the below patch on a system that
> requires the i915 driver module.
> 
> 	-Carsten.
> 
> 
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Subject: gpu/i915: don't open code these things
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/gpu/drm/i915/i915_gem.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> Index: linux-3.6.11.1-rt32/drivers/gpu/drm/i915/i915_gem.c
> ===================================================================
> --- linux-3.6.11.1-rt32.orig/drivers/gpu/drm/i915/i915_gem.c
> +++ linux-3.6.11.1-rt32/drivers/gpu/drm/i915/i915_gem.c
> @@ -90,7 +90,6 @@ i915_gem_wait_for_error(struct drm_devic
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	struct completion *x = &dev_priv->error_completion;
> -	unsigned long flags;
>  	int ret;
> 
>  	if (!atomic_read(&dev_priv->mm.wedged))
> @@ -115,9 +114,7 @@ i915_gem_wait_for_error(struct drm_devic
>  		 * end up waiting upon a subsequent completion event that
>  		 * will never happen.
>  		 */
> -		spin_lock_irqsave(&x->wait.lock, flags);
> -		x->done++;
> -		spin_unlock_irqrestore(&x->wait.lock, flags);
> +		complete(x);
>  	}
>  	return 0;
>  }
> @@ -1884,12 +1881,9 @@ i915_gem_check_wedge(struct drm_i915_pri
>  	if (atomic_read(&dev_priv->mm.wedged)) {
>  		struct completion *x = &dev_priv->error_completion;
>  		bool recovery_complete;
> -		unsigned long flags;
> 
>  		/* Give the error handler a chance to run. */
> -		spin_lock_irqsave(&x->wait.lock, flags);
> -		recovery_complete = x->done > 0;
> -		spin_unlock_irqrestore(&x->wait.lock, flags);
> +		recovery_complete = completion_done(x);
> 
>  		/* Non-interruptible callers can't handle -EAGAIN, hence
> return
>  		 * -EIO unconditionally for these. */
> 
> 

Is there a reason you left off the last hunk?

@@ -4366,7 +4360,7 @@ static bool mutex_is_locked_by(struct mu
 	if (!mutex_is_locked(mutex))
 		return false;
 
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_MUTEXES)
+#if (defined(CONFIG_SMP) || defined(CONFIG_DEBUG_MUTEXES)) && 
!defined(CONFIG_PREEMPT_RT_BASE)
 	return mutex->owner == task;
 #else
 	/* Since UP may be pre-empted, we cannot assume that we own the 
lock */
---1463806542-124736334-1365781656=:5703--
