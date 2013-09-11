Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3IKTcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:32:12 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40724 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754885Ab3IKTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:32:10 -0400
X-Greylist: delayed 15318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 15:32:10 EDT
Message-ID: <5230C52E.3050801@hurleysoftware.com>
Date: Wed, 11 Sep 2013 15:31:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: BUG: sleeping function called from invalid context on 3.10.10-rt7
References: <20130911102809.GA31663@uudg.org> <20130911092623.42efd930@gandalf.local.home> <5230895B.5070400@hurleysoftware.com> <20130911113845.6d56a556@gandalf.local.home>
In-Reply-To: <20130911113845.6d56a556@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc dri-devel]

On 09/11/2013 11:38 AM, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 11:16:43 -0400
> Peter Hurley <peter@hurleysoftware.com> wrote:
>
>>> The funny part is, there's a comment there that shows that this was
>>> done even for "PREEMPT_RT". Unfortunately, the call to
>>> "get_scanout_position()" can call functions that use the rt-mutex
>>> "sleeping spin locks" and it breaks there.
>>>
>>> I guess we need to ask the authors of the mainline patch exactly why
>>> that preempt_disable() is needed?
>>
>> The drm core associates a timestamp with each vertical blank frame #.
>> Drm drivers can optionally support a 'high resolution' hw timestamp.
>> The vblank frame #/timestamp tuple is user-space visible.
>>
>> The i915 drm driver supports a hw timestamp via this drm helper function
>> which computes the timestamp from the crtc scan position (based on the
>> pixel clock).
>>
>> For mainline, the preempt_disable/_enable() isn't actually necessary
>> because every call tree that leads here already has preemption disabled.
>>
>> For -RT, the maybe i915 register spinlock (uncore.lock) should be raw?
>>
>
> No, it should not. Note, any other lock that can be held when it is
> held would also need to be raw.

By that, you mean "any other lock" that might be claimed "would also need
to be raw"?  Hopefully not "any other lock" already held?

> And by taking a quick audit of the code, I see this:
>
> 	spin_lock_irqsave(&dev_priv->uncore.lock, irqflags);
>
> 	/* Reset the chip */
>
> 	/* GEN6_GDRST is not in the gt power well, no need to check
> 	 * for fifo space for the write or forcewake the chip for
> 	 * the read
> 	 */
> 	__raw_i915_write32(dev_priv, GEN6_GDRST, GEN6_GRDOM_FULL);
>
> 	/* Spin waiting for the device to ack the reset request */
> 	ret = wait_for((__raw_i915_read32(dev_priv, GEN6_GDRST) & GEN6_GRDOM_FULL) == 0, 500);
>
> That spin is unacceptable in RT with preemption and interrupts disabled.

Yep. That would be bad.

AFAICT the registers read in i915_get_crtc_scanoutpos() aren't included
in the force-wake set, so raw reads of the registers would
probably be acceptable (thus obviating the need for claiming the uncore.lock).

Except that _ALL_ register access is disabled with the uncore.lock
during a gpu reset. Not sure if that's meant to include crtc registers
or not, or what other synchronization/serialization issues are being
handled/hidden by forcing all register accesses to wait during a gpu reset.

Hopefully an i915 expert can weigh in here?

> What's the real issue here?

That the vblank timestamp needs to be an accurate measurement of a
realtime event. Sleeping/servicing interrupts while reading
the registers necessary to compute the timestamp would be bad too.

(edit: which hopefully Mario Kleiner clarified in his reply)

My point earlier was three-fold:
1. Don't need the preempt_disable() for mainline: all callers are already
    holding interrupt-disabling spinlocks.
2. -RT still needs to prevent scheduling there.
3. the problem is i915-specific.

[update: the radeon driver should also BUG like the i915 driver but probably
should have mmio_idx_lock spinlock as raw]

> Does it have something to do with this dump?

Not sure [but I didn't realize the query was regarding 3.0].

> [    3.932060] ------------[ cut here ]------------
> [    3.936809] WARNING: at /home/rostedt/work/git/linux-rt.git/drivers/gpu/drm/i915/i915_drv.c:322 gen6_gt_force_wake_get+0x4d/0x50 [i915]()
> [    3.949229] Hardware name: HP Compaq Pro 6300 SFF
> [    3.953988] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
> [    3.961943] Pid: 220, comm: udevd Not tainted 3.0.89-test-rt117 #117
> [    3.968343] Call Trace:
> [    3.970851]  [<ffffffff810671bf>] warn_slowpath_common+0x7f/0xc0
> [    3.970852]  [<ffffffff8106721a>] warn_slowpath_null+0x1a/0x20
> [    3.970857]  [<ffffffffa006569d>] gen6_gt_force_wake_get+0x4d/0x50 [i915]
> [    3.970865]  [<ffffffffa00962ab>] ivybridge_init_clock_gating+0xcb/0x2f0 [i915]
> [    3.970870]  [<ffffffffa0090209>] ? intel_crtc_disable+0x29/0x60 [i915]
> [    3.970877]  [<ffffffffa009f741>] intel_modeset_init+0x751/0x10e0 [i915]
> [    3.970882]  [<ffffffffa006a158>] i915_driver_load+0xfc8/0x17f0 [i915]
> [    3.970885]  [<ffffffff8137909e>] ? device_register+0x1e/0x30
> [    3.970892]  [<ffffffffa001f596>] ? drm_sysfs_device_add+0x86/0xb0 [drm]
> [    3.970896]  [<ffffffffa001b8b3>] ? drm_get_minor+0x233/0x300 [drm]
> [    3.970900]  [<ffffffffa001dd49>] drm_get_pci_dev+0x189/0x2a0 [drm]
> [    3.970902]  [<ffffffff8105e31b>] ? migrate_enable+0x8b/0x1c0
> [    3.970910]  [<ffffffffa00c5f27>] i915_pci_probe+0x1b/0x1d [i915]
> [    3.970913]  [<ffffffff812c5b6c>] local_pci_probe+0x5c/0xd0
> [    3.970915]  [<ffffffff812c73f9>] pci_device_probe+0x109/0x130
> [    3.970917]  [<ffffffff8137bc6c>] driver_probe_device+0x9c/0x2b0
> [    3.970918]  [<ffffffff8137bf2b>] __driver_attach+0xab/0xb0
> [    3.970919]  [<ffffffff8137be80>] ? driver_probe_device+0x2b0/0x2b0
> [    3.970920]  [<ffffffff8137be80>] ? driver_probe_device+0x2b0/0x2b0
> [    3.970921]  [<ffffffff8137aa34>] bus_for_each_dev+0x64/0xa0
> [    3.970923]  [<ffffffff8137b87e>] driver_attach+0x1e/0x20
> [    3.970924]  [<ffffffff8137b490>] bus_add_driver+0x1b0/0x290
> [    3.970925]  [<ffffffff8137c4a6>] driver_register+0x76/0x140
> [    3.970927]  [<ffffffff812c70a2>] __pci_register_driver+0x82/0x100
> [    3.970930]  [<ffffffff815b1f6d>] ? notifier_call_chain+0x4d/0x70
> [    3.970934]  [<ffffffffa001df7a>] drm_pci_init+0x11a/0x130 [drm]
> [    3.970935]  [<ffffffffa00f4000>] ? 0xffffffffa00f3fff
> [    3.970940]  [<ffffffffa00f408b>] i915_init+0x8b/0x8d [i915]
> [    3.970943]  [<ffffffff81002040>] do_one_initcall+0x40/0x180
> [    3.970946]  [<ffffffff810aa4ae>] sys_init_module+0xbe/0x230
> [    3.970948]  [<ffffffff815b5a82>] system_call_fastpath+0x16/0x1b
> [    3.970949] ---[ end trace 0000000000000002 ]---
> [    4.164458] ------------[ cut here ]------------
>
> -- Steve
>

