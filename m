Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaEVK2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:28:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36500 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbaEVK2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:28:02 -0400
Date: Thu, 22 May 2014 11:27:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@linaro.org
Subject: Runtime PM workqueue killing system performance with USB
Message-ID: <20140522102747.GB14641@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Although I don't think this is a new issue, booting mainline on my vexpress
a9x4 (Quad ARMv7 Cortex-A9 board) with USB and PM_RUNTIME results in each
CPU being constantly 20-50% loaded. A bit of investigation shows that this
is due to the runtime-pm callbacks trying to autosuspend USB, despite this
being unsupported by the host-controller (isp1760, which doesn't have a
->bus_suspend callback). I've included a backtrace at the bottom of this mail.

Anyway, since ->bus_suspend is not implemented, hcd_bus_suspend returns
-ENOENT, which propagates back up to usb_runtime_suspend via usb_suspend_both.
At this point, we override the return value with -EBUSY:

drivers/usb/core/driver.c:usb_runtime_suspend:

	/* The PM core reacts badly unless the return code is 0,
	 * -EAGAIN, or -EBUSY, so always return -EBUSY on an error.
	 */
	if (status != 0)
		return -EBUSY;

This then tells the runtime PM code to try again:

drivers/base/power/runtime.c

	if (retval == -EAGAIN || retval == -EBUSY) {
		dev->power.runtime_error = 0;

		/*
		 * If the callback routine failed an autosuspend, and
		 * if the last_busy time has been updated so that there
		 * is a new autosuspend expiration time, automatically
		 * reschedule another autosuspend.
		 */
		if ((rpmflags & RPM_AUTO) &&
		    pm_runtime_autosuspend_expiration(dev) != 0)
			goto repeat;

Consequently, I see a kworker thread on each CPU consuming a significant
amount of the system resources. Worse, if I enable something like kmemleak
(which adds more work to the failed suspend operation), I end up failing
to boot entirely (NFS bombs out).

Reverting db7c7c0aeef5 ("usb: Always return 0 or -EBUSY to the runtime
PM core.") fixes this for me, but the commit log suggests that will break
lsusb. That patch has also been in for three and a half years...

Any ideas on how to fix this properly? In what ways does the PM core react
badly to -ENOENT?

Cheers,

Will

--->8

[  161.385424] CPU: 0 PID: 51 Comm: kworker/0:1 Not tainted 3.15.0-rc5 #2
[  161.405009] Workqueue: pm pm_runtime_work
[  161.417019] task: ed0bec00 ti: ed470000 task.ti: ed470000
[  161.433195] PC is at kmemleak_free+0x8/0x4c
[  161.445737] LR is at kfree+0xbc/0x154
[  161.456699] pc : [<c05be7e0>]    lr : [<c00ecc14>]    psr: 400f0013
[  161.456699] sp : ed471c58  ip : 0000001c  fp : ed39adc0
[  161.491098] r10: 00000000  r9 : ed59a300  r8 : c09df324
[  161.506743] r7 : c03e7960  r6 : ee59b340  r5 : ed59a300  r4 : ed001f00
[  161.526294] r3 : 0000f0e0  r2 : edff0000  r1 : ed59a300  r0 : ed59a300
[  161.545848] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  161.567743] Control: 10c5387d  Table: 8d5e004a  DAC: 00000015
[  161.584955] CPU: 0 PID: 51 Comm: kworker/0:1 Not tainted 3.15.0-rc5 #2
[  161.604512] Workqueue: pm pm_runtime_work
[  161.616572] [<c0015e90>] (unwind_backtrace) from [<c0011b14>] (show_stack+0x10/0x14)
[  161.639794] [<c0011b14>] (show_stack) from [<c05c1444>] (dump_stack+0x88/0x98)
[  161.661449] [<c05c1444>] (dump_stack) from [<c02b89a8>] (sysrq_handle_showallcpus+0x5c/0x64)
[  161.686744] [<c02b89a8>] (sysrq_handle_showallcpus) from [<c02b8fe4>] (__handle_sysrq+0x128/0x17c)
[  161.713600] [<c02b8fe4>] (__handle_sysrq) from [<c02d2124>] (pl011_fifo_to_tty+0x174/0x1c4)
[  161.738631] [<c02d2124>] (pl011_fifo_to_tty) from [<c02d32f4>] (pl011_int+0x298/0x5a8)
[  161.762362] [<c02d32f4>] (pl011_int) from [<c0086ac8>] (handle_irq_event_percpu+0x78/0x134)
[  161.787393] [<c0086ac8>] (handle_irq_event_percpu) from [<c0086bc4>] (handle_irq_event+0x40/0x60)
[  161.813991] [<c0086bc4>] (handle_irq_event) from [<c0089c30>] (handle_fasteoi_irq+0xa8/0x1a8)
[  161.839562] [<c0089c30>] (handle_fasteoi_irq) from [<c00861c4>] (generic_handle_irq+0x2c/0x3c)
[  161.865377] [<c00861c4>] (generic_handle_irq) from [<c000ef40>] (handle_IRQ+0x40/0x90)
[  161.889105] [<c000ef40>] (handle_IRQ) from [<c00087e8>] (gic_handle_irq+0x2c/0x5c)
[  161.911788] [<c00087e8>] (gic_handle_irq) from [<c0012680>] (__irq_svc+0x40/0x50)
[  161.934204] Exception stack(0xed471c10 to 0xed471c58)
[  161.949333] 1c00:                                     ed59a300 ed59a300 edff0000 0000f0e0
[  161.973840] 1c20: ed001f00 ed59a300 ee59b340 c03e7960 c09df324 ed59a300 00000000 ed39adc0
[  161.998345] 1c40: 0000001c ed471c58 c00ecc14 c05be7e0 400f0013 ffffffff
[  162.018168] [<c0012680>] (__irq_svc) from [<c05be7e0>] (kmemleak_free+0x8/0x4c)
[  162.040082] [<c05be7e0>] (kmemleak_free) from [<c00ecc14>] (kfree+0xbc/0x154)
[  162.061490] [<c00ecc14>] (kfree) from [<c03e7960>] (usb_hcd_submit_urb+0x2d4/0x804)
[  162.084447] [<c03e7960>] (usb_hcd_submit_urb) from [<c03e94b4>] (usb_start_wait_urb+0x4c/0xbc)
[  162.110264] [<c03e94b4>] (usb_start_wait_urb) from [<c03e95c4>] (usb_control_msg+0xa0/0xd0)
[  162.135298] [<c03e95c4>] (usb_control_msg) from [<c03dfb10>] (hub_port_status+0x74/0xfc)
[  162.159548] [<c03dfb10>] (hub_port_status) from [<c03e139c>] (hub_activate+0x164/0x500)
[  162.183537] [<c03e139c>] (hub_activate) from [<c03e179c>] (hub_resume+0x14/0x1c)
[  162.205709] [<c03e179c>] (hub_resume) from [<c03ec474>] (usb_resume_interface.isra.6+0xe8/0x118)
[  162.232041] [<c03ec474>] (usb_resume_interface.isra.6) from [<c03ec560>] (usb_suspend_both+0xbc/0x19c)
[  162.259938] [<c03ec560>] (usb_suspend_both) from [<c03ed418>] (usb_runtime_suspend+0x28/0x58)
[  162.285497] [<c03ed418>] (usb_runtime_suspend) from [<c032888c>] (__rpm_callback+0x38/0x84)
[  162.310530] [<c032888c>] (__rpm_callback) from [<c03288f8>] (rpm_callback+0x20/0x74)
[  162.333739] [<c03288f8>] (rpm_callback) from [<c0328d54>] (rpm_suspend+0xd0/0x4e8)
[  162.356428] [<c0328d54>] (rpm_suspend) from [<c032a048>] (__pm_runtime_suspend+0x70/0x98)
[  162.380939] [<c032a048>] (__pm_runtime_suspend) from [<c03ed480>] (usb_runtime_idle+0x24/0x2c)
[  162.406750] [<c03ed480>] (usb_runtime_idle) from [<c032888c>] (__rpm_callback+0x38/0x84)
[  162.431001] [<c032888c>] (__rpm_callback) from [<c0329320>] (rpm_idle+0xf8/0x19c)
[  162.453428] [<c0329320>] (rpm_idle) from [<c032a16c>] (pm_runtime_work+0x90/0xa0)
[  162.475860] [<c032a16c>] (pm_runtime_work) from [<c005d674>] (process_one_work+0x108/0x374)
[  162.500891] [<c005d674>] (process_one_work) from [<c005e384>] (worker_thread+0x130/0x3e4)
[  162.525412] [<c005e384>] (worker_thread) from [<c0063a30>] (kthread+0xd8/0xf0)
[  162.547063] [<c0063a30>] (kthread) from [<c000e6f8>] (ret_from_fork+0x14/0x3c)

