Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3KGEP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:15:27 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42974 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3KGEPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:15:24 -0500
MIME-Version: 1.0
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Thu, 7 Nov 2013 12:15:01 +0800
Message-ID: <CAC8teKX4kSFBdDzGSqTT=6K3d7g=TVOL0RcmxdcLx0bMP-jZow@mail.gmail.com>
Subject: Xen PV ABI on FPU doesn't match with pvops kernel FPU code, reducing
 to a serious memory data damage
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: virtualization@lists.linux-foundation.org, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        George Dunlap <George.Dunlap@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
The PV ABI of xen will clear CR0.TS before trapping into the PV guest
kernel's exception handler, so the exception handler in guest kernel
runs with CR0.TS clear at the very beginning (which is different with
on baremetal). In Xenolinux and mainline Linux kernel before 2.6.26
everything is fine since they don't sleep nor enable interrupts during
the handler, however the current mainline pvops kernel has a schedule
window opened within it.

[Pls see the code below,

void math_state_restore(void)
{
    struct task_struct *tsk = current;

    if (!tsk_used_math(tsk)) {
        local_irq_enable();                       <<<< Here it might
open a schedule window
        /*
         * does a slab alloc which can sleep
         */
        if (init_fpu(tsk)) {
            /*
             * ran out of memory!
             */
            do_group_exit(SIGKILL);
            return;
        }
        local_irq_disable();                      <<<< Here it closes
    }

    __thread_fpu_begin(tsk);

    /*
     * Paranoid restore. send a SIGSEGV if we fail to restore the state.
     */
    if (unlikely(restore_fpu_checking(tsk))) {
        drop_init_fpu(tsk);
        force_sig(SIGSEGV, tsk);
        return;
    }

    tsk->fpu_counter++;
}
]

This can cause serious data damage against xen pv guests (including
dom0 kernel), we have encountered this issue both in stress test and
production systems. Please take a look at
http://comments.gmane.org/gmane.comp.emulators.xen.devel/176970 for
more discussions and test cases.

Ian and George, we have confirmed this is the very root cause of
http://comments.gmane.org/gmane.comp.emulators.xen.devel/175491

The xen ABI is part of history which can't be changed, as well as
simply adding a couple of stts()-clts() around the enabling/disabling
interrupts is a really ugly hack.
Maintainers, any thoughts?

--
Thanks,
Zhu Yanhai
