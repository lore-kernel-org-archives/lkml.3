Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3IKPiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:38:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab3IKPis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:38:48 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wRe-vSF1Ob0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kSsn7R9otuIA:10 a=xGRsDScCAAAA:8 a=gm1sT7aFn5OOLS-P8YAA:9 a=CjuIK1q_8ugA:10 a=A4LuvFU5fKoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 11:38:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context on
 3.10.10-rt7
Message-ID: <20130911113845.6d56a556@gandalf.local.home>
In-Reply-To: <5230895B.5070400@hurleysoftware.com>
References: <20130911102809.GA31663@uudg.org>
	<20130911092623.42efd930@gandalf.local.home>
	<5230895B.5070400@hurleysoftware.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 11:16:43 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> > The funny part is, there's a comment there that shows that this was
> > done even for "PREEMPT_RT". Unfortunately, the call to
> > "get_scanout_position()" can call functions that use the rt-mutex
> > "sleeping spin locks" and it breaks there.
> >
> > I guess we need to ask the authors of the mainline patch exactly why
> > that preempt_disable() is needed?
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

No, it should not. Note, any other lock that can be held when it is
held would also need to be raw. And by taking a quick audit of the
code, I see this:

	spin_lock_irqsave(&dev_priv->uncore.lock, irqflags);

	/* Reset the chip */

	/* GEN6_GDRST is not in the gt power well, no need to check
	 * for fifo space for the write or forcewake the chip for
	 * the read
	 */
	__raw_i915_write32(dev_priv, GEN6_GDRST, GEN6_GRDOM_FULL);

	/* Spin waiting for the device to ack the reset request */
	ret = wait_for((__raw_i915_read32(dev_priv, GEN6_GDRST) & GEN6_GRDOM_FULL) == 0, 500);

That spin is unacceptable in RT with preemption and interrupts disabled.


What's the real issue here? Does it have something to do with this
dump?

[    3.932060] ------------[ cut here ]------------
[    3.936809] WARNING: at /home/rostedt/work/git/linux-rt.git/drivers/gpu/drm/i915/i915_drv.c:322 gen6_gt_force_wake_get+0x4d/0x50 [i915]()
[    3.949229] Hardware name: HP Compaq Pro 6300 SFF
[    3.953988] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    3.961943] Pid: 220, comm: udevd Not tainted 3.0.89-test-rt117 #117
[    3.968343] Call Trace:
[    3.970851]  [<ffffffff810671bf>] warn_slowpath_common+0x7f/0xc0
[    3.970852]  [<ffffffff8106721a>] warn_slowpath_null+0x1a/0x20
[    3.970857]  [<ffffffffa006569d>] gen6_gt_force_wake_get+0x4d/0x50 [i915]
[    3.970865]  [<ffffffffa00962ab>] ivybridge_init_clock_gating+0xcb/0x2f0 [i915]
[    3.970870]  [<ffffffffa0090209>] ? intel_crtc_disable+0x29/0x60 [i915]
[    3.970877]  [<ffffffffa009f741>] intel_modeset_init+0x751/0x10e0 [i915]
[    3.970882]  [<ffffffffa006a158>] i915_driver_load+0xfc8/0x17f0 [i915]
[    3.970885]  [<ffffffff8137909e>] ? device_register+0x1e/0x30
[    3.970892]  [<ffffffffa001f596>] ? drm_sysfs_device_add+0x86/0xb0 [drm]
[    3.970896]  [<ffffffffa001b8b3>] ? drm_get_minor+0x233/0x300 [drm]
[    3.970900]  [<ffffffffa001dd49>] drm_get_pci_dev+0x189/0x2a0 [drm]
[    3.970902]  [<ffffffff8105e31b>] ? migrate_enable+0x8b/0x1c0
[    3.970910]  [<ffffffffa00c5f27>] i915_pci_probe+0x1b/0x1d [i915]
[    3.970913]  [<ffffffff812c5b6c>] local_pci_probe+0x5c/0xd0
[    3.970915]  [<ffffffff812c73f9>] pci_device_probe+0x109/0x130
[    3.970917]  [<ffffffff8137bc6c>] driver_probe_device+0x9c/0x2b0
[    3.970918]  [<ffffffff8137bf2b>] __driver_attach+0xab/0xb0
[    3.970919]  [<ffffffff8137be80>] ? driver_probe_device+0x2b0/0x2b0
[    3.970920]  [<ffffffff8137be80>] ? driver_probe_device+0x2b0/0x2b0
[    3.970921]  [<ffffffff8137aa34>] bus_for_each_dev+0x64/0xa0
[    3.970923]  [<ffffffff8137b87e>] driver_attach+0x1e/0x20
[    3.970924]  [<ffffffff8137b490>] bus_add_driver+0x1b0/0x290
[    3.970925]  [<ffffffff8137c4a6>] driver_register+0x76/0x140
[    3.970927]  [<ffffffff812c70a2>] __pci_register_driver+0x82/0x100
[    3.970930]  [<ffffffff815b1f6d>] ? notifier_call_chain+0x4d/0x70
[    3.970934]  [<ffffffffa001df7a>] drm_pci_init+0x11a/0x130 [drm]
[    3.970935]  [<ffffffffa00f4000>] ? 0xffffffffa00f3fff
[    3.970940]  [<ffffffffa00f408b>] i915_init+0x8b/0x8d [i915]
[    3.970943]  [<ffffffff81002040>] do_one_initcall+0x40/0x180
[    3.970946]  [<ffffffff810aa4ae>] sys_init_module+0xbe/0x230
[    3.970948]  [<ffffffff815b5a82>] system_call_fastpath+0x16/0x1b
[    3.970949] ---[ end trace 0000000000000002 ]---
[    4.164458] ------------[ cut here ]------------

-- Steve
