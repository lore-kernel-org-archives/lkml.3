Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3IKUDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:03:53 -0400
Received: from fmailer.gwdg.de ([134.76.11.16]:33794 "EHLO fmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab3IKUDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:03:50 -0400
Message-ID: <5230B673.6090800@tuebingen.mpg.de>
Date: Wed, 11 Sep 2013 20:29:07 +0200
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: BUG: sleeping function called from invalid context on 3.10.10-rt7
References: <20130911102809.GA31663@uudg.org> <20130911092623.42efd930@gandalf.local.home> <5230895B.5070400@hurleysoftware.com>
In-Reply-To: <5230895B.5070400@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.09.13 17:16, Peter Hurley wrote:
> On 09/11/2013 09:26 AM, Steven Rostedt wrote:
>> On Wed, 11 Sep 2013 07:28:09 -0300
>> "Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:
>>
>>> Hello,
>>>
>>> I saw two different occurrences of "BUG: sleeping function called from
>>> invalid context" happening on 3.10.10-rt7. The first one happened on
>>> drm_vblank_get() -> i915_get_vblank_timestamp() and was flooding dmesg
>>> after Xorg started. I silenced that with a hackish patch, just for
>>> fun, and
>>> found a second problem, this time on tty_ldisc_reinit().
>>>
>>> The logs:
>>>
>>> [   23.973991] BUG: sleeping function called from invalid context at
>>> /home/lclaudio/SANDBOX/mrg-rt-v2-devel/kernel/rtmutex.c:659
>>> [   23.973992] in_atomic(): 1, irqs_disabled(): 0, pid: 517, name: Xorg
>>> [   23.973993] 2 locks held by Xorg/517:
>>> [   23.973993]  #0:
>>> [   23.973994]  (
>>> [   23.973994] &dev->vbl_lock
>>> [   23.973995] ){......}
>>> [   23.973995] , at:
>>> [   23.974007] [<ffffffffa0024c60>] drm_vblank_get+0x30/0x2b0 [drm]
>>> [   23.974008]  #1:
>>> [   23.974008]  (
>>> [   23.974008] &dev->vblank_time_lock
>>> [   23.974008] ){......}
>>> [   23.974009] , at:
>>> [   23.974013] [<ffffffffa0024ce1>] drm_vblank_get+0xb1/0x2b0 [drm]
>>> [   23.974013] Preemption disabled at:
>>> [   23.974021] [<ffffffffa008bc95>]
>>> i915_get_vblank_timestamp+0x45/0xa0 [i915]
>>> [   23.974023] CPU: 3 PID: 517 Comm: Xorg Not tainted 3.10.10-rt7+ #5
>>> [   23.974024] Hardware name: Hewlett-Packard p7-1512/2ADA, BIOS 8.15
>>> 02/05/2013
>>> [   23.974024]  0000000000070008
>>> [   23.974025]  ffff88017a08bae0
>>> [   23.974025]  ffffffff8164b790
>>> [   23.974025]  ffff88017a08baf8
>>> [   23.974026]  ffffffff8107e62f
>>> [   23.974026]  ffff880179840040
>>> [   23.974026]  ffff88017a08bb18
>>> [   23.974027]  ffffffff81651ac4
>>> [   23.974027]  0000000000000002
>>> [   23.974027]  ffff880179840000
>>> [   23.974028]  ffff88017a08bb48
>>> [   23.974028]  ffffffffa0084e67
>>> [   23.974028] Call Trace:
>>> [   23.974033]  [<ffffffff8164b790>] dump_stack+0x19/0x1b
>>> [   23.974035]  [<ffffffff8107e62f>] __might_sleep+0xff/0x170
>>> [   23.974037]  [<ffffffff81651ac4>] rt_spin_lock+0x24/0x60
>>> [   23.974043]  [<ffffffffa0084e67>] i915_read32+0x27/0x170 [i915]
>>> [   23.974048]  [<ffffffffa008a591>] i915_pipe_enabled+0x31/0x40 [i915]
>>> [   23.974054]  [<ffffffffa008a6be>]
>>> i915_get_crtc_scanoutpos+0x3e/0x1b0 [i915]
>>> [   23.974056]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
>>> [   23.974062]  [<ffffffffa00245d4>]
>>> drm_calc_vbltimestamp_from_scanoutpos+0xf4/0x430 [drm]
>>> [   23.974068]  [<ffffffffa008bc95>]
>>> i915_get_vblank_timestamp+0x45/0xa0 [i915]
>>> [   23.974073]  [<ffffffffa0024998>]
>>> drm_get_last_vbltimestamp+0x48/0x70 [drm]
>>> [   23.974078]  [<ffffffffa0024db5>] drm_vblank_get+0x185/0x2b0 [drm]
>>> [   23.974079]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
>>> [   23.974085]  [<ffffffffa0025d03>] drm_wait_vblank+0x83/0x5d0 [drm]
>>> [   23.974086]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
>>> [   23.974088]  [<ffffffff810af143>] ?
>>> __lock_acquire.isra.31+0x273/0xa70
>>> [   23.974093]  [<ffffffffa00212a2>] drm_ioctl+0x552/0x6a0 [drm]
>>> [   23.974096]  [<ffffffff8128d886>] ? avc_has_perm_flags+0x126/0x1c0
>>> [   23.974098]  [<ffffffff8128d788>] ? avc_has_perm_flags+0x28/0x1c0
>>> [   23.974099]  [<ffffffff810ad49e>] ? put_lock_stats.isra.23+0xe/0x40
>>> [   23.974101]  [<ffffffff811a0095>] do_vfs_ioctl+0x325/0x5b0
>>> [   23.974103]  [<ffffffff8128fc3e>] ? file_has_perm+0x8e/0xa0
>>> [   23.974105]  [<ffffffff811a03a1>] SyS_ioctl+0x81/0xa0
>>> [   23.974107]  [<ffffffff8165a342>] tracesys+0xdd/0xe2
>>>
>>>
>>> and
>>>
>>>
>>> [   25.423675] BUG: sleeping function called from invalid context at
>>> /home/lclaudio/SANDBOX/mrg-rt-v2-devel/kernel/rtmutex.c:659
>>> [   25.423676] in_atomic(): 1, irqs_disabled(): 1, pid: 188, name:
>>> plymouthd
>>> [   25.423676] 3 locks held by plymouthd/188:
>>> [   25.423682]  #0:  (&tty->legacy_mutex){......}, at:
>>> [<ffffffff816528d0>] tty_lock_nested+0x40/0x90
>>> [   25.423686]  #1:  (&tty->ldisc_mutex){......}, at:
>>> [<ffffffff8139b482>] tty_ldisc_hangup+0x152/0x300
>>> [   25.423688]  #2:  (tty_ldisc_lock){......}, at:
>>> [<ffffffff8139a9c2>] tty_ldisc_reinit+0x72/0x130
>>> [   25.423689] Preemption disabled at:[<ffffffff8139a9c2>]
>>> tty_ldisc_reinit+0x72/0x130
>>> [   25.423691] CPU: 2 PID: 188 Comm: plymouthd Not tainted
>>> 3.10.10-rt7+ #6
>>> [   25.423692] Hardware name: Hewlett-Packard p7-1512/2ADA, BIOS 8.15
>>> 02/05/2013
>>> [   25.423694]  005ff00000000000 ffff8801788ada68 ffffffff8164b790
>>> ffff8801788ada80
>>> [   25.423695]  ffffffff8107e62f ffff8801991ce1a0 ffff8801788adaa0
>>> ffffffff81651ac4
>>> [   25.423696]  0000000000000000 ffffea0005e26680 ffff8801788adaf8
>>> ffffffff81130984
>>> [   25.423696] Call Trace:
>>> [   25.423700]  [<ffffffff8164b790>] dump_stack+0x19/0x1b
>>> [   25.423702]  [<ffffffff8107e62f>] __might_sleep+0xff/0x170
>>> [   25.423704]  [<ffffffff81651ac4>] rt_spin_lock+0x24/0x60
>>> [   25.423707]  [<ffffffff81130984>] free_hot_cold_page+0xb4/0x3c0
>>> [   25.423710]  [<ffffffff81178209>]
>>> ?unfreeze_partials.isra.42+0x229/0x2b0
>>> [   25.423711]  [<ffffffff81130dc7>] __free_pages+0x47/0x70
>>> [   25.423713]  [<ffffffff81130fb2>] __free_memcg_kmem_pages+0x22/0x50
>>> [   25.423714]  [<ffffffff81177528>] __free_slab+0xe8/0x1e0
>>> [   25.423716]  [<ffffffff81177654>] free_delayed+0x34/0x50
>>> [   25.423717]  [<ffffffff81649633>] __slab_free+0x273/0x36b
>>> [   25.423719]  [<ffffffff810acde9>] ? get_lock_stats+0x19/0x60
>>> [   25.423721]  [<ffffffff810ad49e>] ? put_lock_stats.isra.23+0xe/0x40
>>> [   25.423722]  [<ffffffff81178794>] kfree+0x1c4/0x210
>>> [   25.423724]  [<ffffffff8139a9f5>] ? tty_ldisc_reinit+0xa5/0x130
>>> [   25.423725]  [<ffffffff8139a9f5>] tty_ldisc_reinit+0xa5/0x130
>>> [   25.423726]  [<ffffffff8139b49f>] tty_ldisc_hangup+0x16f/0x300
>>> [   25.423728]  [<ffffffff81082e1d>] ? get_parent_ip+0xd/0x50
>>> [   25.423731]  [<ffffffff8104d736>] ? unpin_current_cpu+0x16/0x70
>>> [   25.423732]  [<ffffffff81392136>] __tty_hangup+0x346/0x460
>>> [   25.423733]  [<ffffffff81392260>] tty_vhangup+0x10/0x20
>>> [   25.423735]  [<ffffffff8139d6e1>] pty_close+0x131/0x180
>>> [   25.423736]  [<ffffffff813936ad>] tty_release+0x11d/0x5f0
>>> [   25.423737]  [<ffffffff810acde9>] ? get_lock_stats+0x19/0x60
>>> [   25.423747]  [<ffffffff81009d84>] ? native_sched_clock+0x24/0x80
>>> [   25.423749]  [<ffffffff81087025>] ? sched_clock_cpu+0xb5/0x100
>>> [   25.423750]  [<ffffffff810acde9>] ? get_lock_stats+0x19/0x60
>>> [   25.423752]  [<ffffffff8118eb45>] __fput+0xf5/0x250
>>> [   25.423762]  [<ffffffff8118ed6e>] ____fput+0xe/0x10
>>> [   25.423764]  [<ffffffff8106f1cc>] task_work_run+0xac/0xe0
>>> [   25.423765]  [<ffffffff81002a11>] do_notify_resume+0x91/0xf0
>>> [   25.423767]  [<ffffffff8165a41c>] int_signal+0x12/0x17
>>>
>>>
>>> About the hackish patch I used to silence the constant i915 complaints,
>>> even though the comments on drm_calc_vbltimestamp_from_scanoutpos()
>>> state
>>> the preempt_disable is there for a reason, I removed it for the RT
>>> case. I
>>> really wanted to confirm if there was anything else after that
>>> complaint.
>>
>> The funny part is, there's a comment there that shows that this was
>> done even for "PREEMPT_RT". Unfortunately, the call to
>> "get_scanout_position()" can call functions that use the rt-mutex
>> "sleeping spin locks" and it breaks there.
>>
>> I guess we need to ask the authors of the mainline patch exactly why
>> that preempt_disable() is needed?
>
> The drm core associates a timestamp with each vertical blank frame #.
> Drm drivers can optionally support a 'high resolution' hw timestamp.
> The vblank frame #/timestamp tuple is user-space visible.
>
> The i915 drm driver supports a hw timestamp via this drm helper function
> which computes the timestamp from the crtc scan position (based on the
> pixel clock).
>
> For mainline, the preempt_disable/_enable() isn't actually necessary
> because every call tree that leads here already has preemption disabled.
>
> For -RT, the maybe i915 register spinlock (uncore.lock) should be raw?
>

Hi

Just to give some context why i wrote that routine the way it is written:

The preempt_disable() / _enable() there is intended to try to make sure 
that the etime = ktime_get() query and get_crtc_scanoutpos() query 
happen as closely together in time as possible, because time delays 
between those queries directly translate into noise/uncertainty in the 
calculated vblank timestamps.

Those timestamps are now used by userspace apps like desktop compositors 
or media players for smooth animation and audio-video sync, but the main 
reason i implemented those patches was to support scientific 
neuro-science research applications which need very precise ( << 100 
usecs, ideally < 20 usecs ) vblank timestamps (see 
<https://github.com/Psychtoolbox-3/Psychtoolbox-3/blob/master/Psychtoolbox/PsychDocumentation/ECVP2010Poster_VisualTimingPrecision.pdf?raw=true> 
for more background). The code checks how big the uncertainty is and 
retries the query up to three times if the delay is greater than 20 
microseconds by default.

The retry is meant as a last resort measure for isolated unavoidable 
outliers, e.g., interruption by NMI irq's or maybe system management 
interrupts. We can only retry a few times, because the code is also 
called from the vblank irq handler every video refresh cycle 
(drm_handle_vblank()), and we can't report failure to userspace due to a 
client api (OML_sync_control and INTEL_swap_events GLX extension specs 
at www.opengl.org) which didn't anticipate error cases -- essentially 
reporting failure was not an option.

As far as the typical timing sensitive scientific applications go, those 
users who need this vblank timestamping to be the most precise and 
robust are also the same users who will likely need to install a 
lowlatency or even realtime kernel, so for this to be useful, that 
routine should be really well protected against preemption on a rt kernel.

That said, maybe preempt_disable is no longer the optimal choice there 
and there's some better way to achieve good protection against 
interruptions of that bit of code? My knowledge here is a bit rusty, and 
the intel kms drivers and rt stuff has changed quite a bit.

thanks,
-mario


> Regards,
> Peter Hurley
>
>
>>>
>>> diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
>>> index f92da0a..bd2e8e2 100644
>>> --- a/drivers/gpu/drm/drm_irq.c
>>> +++ b/drivers/gpu/drm/drm_irq.c
>>> @@ -631,7 +631,7 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct
>>> drm_device *dev, int crtc,
>>>           /* Disable preemption to make it very likely to
>>>            * succeed in the first iteration even on PREEMPT_RT kernel.
>>>            */
>>> -        preempt_disable();
>>> +        preempt_disable_nort();
>>>
>>>           /* Get system timestamp before query. */
>>>           stime = ktime_get();
>>> @@ -644,7 +644,7 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct
>>> drm_device *dev, int crtc,
>>>           if (!drm_timestamp_monotonic)
>>>               mono_time_offset = ktime_get_monotonic_offset();
>>>
>>> -        preempt_enable();
>>> +        preempt_enable_nort();
>>>
>>>           /* Return as no-op if scanout query unsupported or failed. */
>>>           if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
>>>
>
