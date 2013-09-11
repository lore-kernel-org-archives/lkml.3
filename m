Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3IKN01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:26:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5901 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3IKN0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:26:25 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wRe-vSF1Ob0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kSsn7R9otuIA:10 a=oExj5NFNAAAA:8 a=97CWKrAFWwtIgTIf3yEA:9 a=CjuIK1q_8ugA:10 a=r0HesoeFUbUA:10 a=i1XarcQiEwcA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 09:26:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context on
 3.10.10-rt7
Message-ID: <20130911092623.42efd930@gandalf.local.home>
In-Reply-To: <20130911102809.GA31663@uudg.org>
References: <20130911102809.GA31663@uudg.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 07:28:09 -0300
"Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:

> Hello,
> 
> I saw two different occurrences of "BUG: sleeping function called from
> invalid context" happening on 3.10.10-rt7. The first one happened on
> drm_vblank_get() -> i915_get_vblank_timestamp() and was flooding dmesg
> after Xorg started. I silenced that with a hackish patch, just for fun, and
> found a second problem, this time on tty_ldisc_reinit().
> 
> The logs:
> 
> [   23.973991] BUG: sleeping function called from invalid context at /home/lclaudio/SANDBOX/mrg-rt-v2-devel/kernel/rtmutex.c:659
> [   23.973992] in_atomic(): 1, irqs_disabled(): 0, pid: 517, name: Xorg
> [   23.973993] 2 locks held by Xorg/517:
> [   23.973993]  #0: 
> [   23.973994]  (
> [   23.973994] &dev->vbl_lock
> [   23.973995] ){......}
> [   23.973995] , at: 
> [   23.974007] [<ffffffffa0024c60>] drm_vblank_get+0x30/0x2b0 [drm]
> [   23.974008]  #1: 
> [   23.974008]  (
> [   23.974008] &dev->vblank_time_lock
> [   23.974008] ){......}
> [   23.974009] , at: 
> [   23.974013] [<ffffffffa0024ce1>] drm_vblank_get+0xb1/0x2b0 [drm]
> [   23.974013] Preemption disabled at:
> [   23.974021] [<ffffffffa008bc95>] i915_get_vblank_timestamp+0x45/0xa0 [i915]
> [   23.974023] CPU: 3 PID: 517 Comm: Xorg Not tainted 3.10.10-rt7+ #5
> [   23.974024] Hardware name: Hewlett-Packard p7-1512/2ADA, BIOS 8.15 02/05/2013
> [   23.974024]  0000000000070008
> [   23.974025]  ffff88017a08bae0
> [   23.974025]  ffffffff8164b790
> [   23.974025]  ffff88017a08baf8
> [   23.974026]  ffffffff8107e62f
> [   23.974026]  ffff880179840040
> [   23.974026]  ffff88017a08bb18
> [   23.974027]  ffffffff81651ac4
> [   23.974027]  0000000000000002
> [   23.974027]  ffff880179840000
> [   23.974028]  ffff88017a08bb48
> [   23.974028]  ffffffffa0084e67
> [   23.974028] Call Trace:
> [   23.974033]  [<ffffffff8164b790>] dump_stack+0x19/0x1b
> [   23.974035]  [<ffffffff8107e62f>] __might_sleep+0xff/0x170
> [   23.974037]  [<ffffffff81651ac4>] rt_spin_lock+0x24/0x60
> [   23.974043]  [<ffffffffa0084e67>] i915_read32+0x27/0x170 [i915]
> [   23.974048]  [<ffffffffa008a591>] i915_pipe_enabled+0x31/0x40 [i915]
> [   23.974054]  [<ffffffffa008a6be>] i915_get_crtc_scanoutpos+0x3e/0x1b0 [i915]
> [   23.974056]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
> [   23.974062]  [<ffffffffa00245d4>] drm_calc_vbltimestamp_from_scanoutpos+0xf4/0x430 [drm]
> [   23.974068]  [<ffffffffa008bc95>] i915_get_vblank_timestamp+0x45/0xa0 [i915]
> [   23.974073]  [<ffffffffa0024998>] drm_get_last_vbltimestamp+0x48/0x70 [drm]
> [   23.974078]  [<ffffffffa0024db5>] drm_vblank_get+0x185/0x2b0 [drm]
> [   23.974079]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
> [   23.974085]  [<ffffffffa0025d03>] drm_wait_vblank+0x83/0x5d0 [drm]
> [   23.974086]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
> [   23.974088]  [<ffffffff810af143>] ? __lock_acquire.isra.31+0x273/0xa70
> [   23.974093]  [<ffffffffa00212a2>] drm_ioctl+0x552/0x6a0 [drm]
> [   23.974096]  [<ffffffff8128d886>] ? avc_has_perm_flags+0x126/0x1c0
> [   23.974098]  [<ffffffff8128d788>] ? avc_has_perm_flags+0x28/0x1c0
> [   23.974099]  [<ffffffff810ad49e>] ? put_lock_stats.isra.23+0xe/0x40
> [   23.974101]  [<ffffffff811a0095>] do_vfs_ioctl+0x325/0x5b0
> [   23.974103]  [<ffffffff8128fc3e>] ? file_has_perm+0x8e/0xa0
> [   23.974105]  [<ffffffff811a03a1>] SyS_ioctl+0x81/0xa0
> [   23.974107]  [<ffffffff8165a342>] tracesys+0xdd/0xe2
> 
> 
> and
> 
> 
> [   25.423675] BUG: sleeping function called from invalid context at /home/lclaudio/SANDBOX/mrg-rt-v2-devel/kernel/rtmutex.c:659
> [   25.423676] in_atomic(): 1, irqs_disabled(): 1, pid: 188, name: plymouthd
> [   25.423676] 3 locks held by plymouthd/188:
> [   25.423682]  #0:  (&tty->legacy_mutex){......}, at: [<ffffffff816528d0>] tty_lock_nested+0x40/0x90
> [   25.423686]  #1:  (&tty->ldisc_mutex){......}, at: [<ffffffff8139b482>] tty_ldisc_hangup+0x152/0x300
> [   25.423688]  #2:  (tty_ldisc_lock){......}, at: [<ffffffff8139a9c2>] tty_ldisc_reinit+0x72/0x130
> [   25.423689] Preemption disabled at:[<ffffffff8139a9c2>] tty_ldisc_reinit+0x72/0x130
> [   25.423691] CPU: 2 PID: 188 Comm: plymouthd Not tainted 3.10.10-rt7+ #6
> [   25.423692] Hardware name: Hewlett-Packard p7-1512/2ADA, BIOS 8.15 02/05/2013
> [   25.423694]  005ff00000000000 ffff8801788ada68 ffffffff8164b790 ffff8801788ada80
> [   25.423695]  ffffffff8107e62f ffff8801991ce1a0 ffff8801788adaa0 ffffffff81651ac4
> [   25.423696]  0000000000000000 ffffea0005e26680 ffff8801788adaf8 ffffffff81130984
> [   25.423696] Call Trace:
> [   25.423700]  [<ffffffff8164b790>] dump_stack+0x19/0x1b
> [   25.423702]  [<ffffffff8107e62f>] __might_sleep+0xff/0x170
> [   25.423704]  [<ffffffff81651ac4>] rt_spin_lock+0x24/0x60
> [   25.423707]  [<ffffffff81130984>] free_hot_cold_page+0xb4/0x3c0
> [   25.423710]  [<ffffffff81178209>] ?unfreeze_partials.isra.42+0x229/0x2b0
> [   25.423711]  [<ffffffff81130dc7>] __free_pages+0x47/0x70
> [   25.423713]  [<ffffffff81130fb2>] __free_memcg_kmem_pages+0x22/0x50
> [   25.423714]  [<ffffffff81177528>] __free_slab+0xe8/0x1e0
> [   25.423716]  [<ffffffff81177654>] free_delayed+0x34/0x50
> [   25.423717]  [<ffffffff81649633>] __slab_free+0x273/0x36b
> [   25.423719]  [<ffffffff810acde9>] ? get_lock_stats+0x19/0x60
> [   25.423721]  [<ffffffff810ad49e>] ? put_lock_stats.isra.23+0xe/0x40
> [   25.423722]  [<ffffffff81178794>] kfree+0x1c4/0x210
> [   25.423724]  [<ffffffff8139a9f5>] ? tty_ldisc_reinit+0xa5/0x130
> [   25.423725]  [<ffffffff8139a9f5>] tty_ldisc_reinit+0xa5/0x130
> [   25.423726]  [<ffffffff8139b49f>] tty_ldisc_hangup+0x16f/0x300
> [   25.423728]  [<ffffffff81082e1d>] ? get_parent_ip+0xd/0x50
> [   25.423731]  [<ffffffff8104d736>] ? unpin_current_cpu+0x16/0x70
> [   25.423732]  [<ffffffff81392136>] __tty_hangup+0x346/0x460
> [   25.423733]  [<ffffffff81392260>] tty_vhangup+0x10/0x20
> [   25.423735]  [<ffffffff8139d6e1>] pty_close+0x131/0x180
> [   25.423736]  [<ffffffff813936ad>] tty_release+0x11d/0x5f0
> [   25.423737]  [<ffffffff810acde9>] ? get_lock_stats+0x19/0x60
> [   25.423747]  [<ffffffff81009d84>] ? native_sched_clock+0x24/0x80
> [   25.423749]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
> [   25.423750]  [<ffffffff810acde9>] ? get_lock_stats+0x19/0x60
> [   25.423752]  [<ffffffff8118eb45>] __fput+0xf5/0x250
> [   25.423762]  [<ffffffff8118ed6e>] ____fput+0xe/0x10
> [   25.423764]  [<ffffffff8106f1cc>] task_work_run+0xac/0xe0
> [   25.423765]  [<ffffffff81002a11>] do_notify_resume+0x91/0xf0
> [   25.423767]  [<ffffffff8165a41c>] int_signal+0x12/0x17
> 
> 
> About the hackish patch I used to silence the constant i915 complaints,
> even though the comments on drm_calc_vbltimestamp_from_scanoutpos() state
> the preempt_disable is there for a reason, I removed it for the RT case. I
> really wanted to confirm if there was anything else after that complaint.

The funny part is, there's a comment there that shows that this was
done even for "PREEMPT_RT". Unfortunately, the call to
"get_scanout_position()" can call functions that use the rt-mutex
"sleeping spin locks" and it breaks there.

I guess we need to ask the authors of the mainline patch exactly why
that preempt_disable() is needed?

-- Steve

> 
> diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
> index f92da0a..bd2e8e2 100644
> --- a/drivers/gpu/drm/drm_irq.c
> +++ b/drivers/gpu/drm/drm_irq.c
> @@ -631,7 +631,7 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
>  		/* Disable preemption to make it very likely to
>  		 * succeed in the first iteration even on PREEMPT_RT kernel.
>  		 */
> -		preempt_disable();
> +		preempt_disable_nort();
>  
>  		/* Get system timestamp before query. */
>  		stime = ktime_get();
> @@ -644,7 +644,7 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
>  		if (!drm_timestamp_monotonic)
>  			mono_time_offset = ktime_get_monotonic_offset();
>  
> -		preempt_enable();
> +		preempt_enable_nort();
>  
>  		/* Return as no-op if scanout query unsupported or failed. */
>  		if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
> 

