Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbbAKWH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:07:58 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38182 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbbAKWFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:21 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 0/11 BROKEN] move FPU context loading to userspace switch
Date: Sun, 11 Jan 2015 16:46:22 -0500
Message-Id: <1421012793-30106-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel will always load the FPU context, even
when switching to a kernel thread, or to an idle thread. In
the case of a task on a KVM VCPU going idle for a bit, and
waking up again later, this creates a vastly inefficient
chain of FPU context saves & loads:

1) save task FPU context, load idle task FPU context (in KVM guest)
2) trap to host
3) save VCPU guest FPU context, load VCPU userspace context (__kernel_fpu_end)
4) save VCPU userspace context, load idle thread FPU context
5) save idle thread FPU context, load VCPU userspace FPU context
6) save VCPU userspace FPU context, load guest FPU context (__kernel_fpu_begin)
7) enter guest
8) save idle task FPU context, load task FPU context (in KVM guest)

This is a total of 6 FPU saves and 6 restores, touching 4 different
FPU contexts, only one of which is ever used. The hardware optimizes
FPU load and restore pretty well, but 12 operations involving 384
bytes of data adds substantial overhead. Additionally, the XSTOROPT
optimization does not work across VMENTER / VMEXIT boundaries, so
things are slower than they would be on bare metal.

This patch series reduces it to two saves (1) and (3), and one load
(6), if the VCPU and the task inside the guest both stay on the same
CPU. The load could be optimized away in a subsequent series, by
recognizing that the emulator did not touch the in-memory FPU state
for the guest.

This could also give a small performance gain for bare metal
applications that wake up and go idle repeatedly, staying on the
same CPU.

Where it all falls apart (probably due to a stupid mistake on my end)
is the signal handling code.

In the signal handling code, the registers (including FPU state) are
all saved to the user space stack, and on sigreturn they are loaded
back in. The signal handler setup code needs to be fixed to deal with
the other changes, but I am apparently doing that incorrectly.

I have been staring at the code for a few weeks now, and do not
appear to be any closer to figuring out what I did wrong in the last
patch of this series.

I would really appreciate it if people with better knowledge of the
signal handler and/or FPU code could take a look :)

