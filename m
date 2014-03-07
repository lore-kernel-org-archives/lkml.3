Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaCGTj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaCGTjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:39:54 -0500
From: Don Zickus <dzickus@redhat.com>
To: hpa@zytor.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, vgoyal@redhat.com,
        ebiederm@xmission.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] x86: Skip latched NMIs on early boot in kdump
Date: Fri,  7 Mar 2014 14:39:03 -0500
Message-Id: <1394221143-29713-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A customer generated an external NMI using their iLO to test kdump worked.
Unfortunately, the machine hung.  Disabling the nmi_watchdog made things work.

I speculated the external NMI fired, caused the machine to panic (as expected)
and the perf NMI from the watchdog came in and was latched.  My guess was this
somehow caused the hang.

Debugging this with outb's and debug_putstr, I learned the following

- the machine hung during the first memcpy in copy_bootdata (in
arch/x86/kernel/head64.c)
- early_make_pgtable was called during this memcpy
- after early_make_pgtable, an exception vector 2 (NMI) came in
- the IP of this vector was in copy_bootdata's range
- because there was no fixup associated with this IP, the machine
  is sitting in a 'hlt' instruction (in arch/x86/kernel/head_64.S)

(copy and paste from arch/x86/kernel/head_64.S)
/* This is global to keep gas from relaxing the jumps */
ENTRY(early_idt_handler)

<snip>

        cmpl $14,72(%rsp)       # Page fault?
        jnz 10f
        GET_CR2_INTO(%rdi)      # can clobber any volatile register if pv
        call early_make_pgtable
        andl %eax,%eax
        jz 20f                  # All good

10:
        leaq 88(%rsp),%rdi      # Pointer to %rip
        call early_fixup_exception
        andl %eax,%eax
        jnz 20f                 # Found an exception entry

11:
	<snip>
1:      hlt
	^^^^^^^^^^^^ sitting here

        jmp 1b

I added the below hack, which says if the exception is an NMI just return and
things seem to work.

Now, I don't expect this to be the correct solution.  Nor do I fully understand
what this early boot code is doing, so hopefully folks wiser than me can
provide me a better patch to test. :-)

I also do not fully understand why the latched NMI is not happening immediately
after the load idt call or why it comes after a page fault (the
early_make_pgtable).  Further adding to my confusion is why the early printk
magic didn't dump a stack as I believe I had that setup on my commandline.
But I figured I would just report what I have observed.

My testing and debugging were based off a 3.10 kernel (RHEL-7) but has included
Seiji's tracepoint cleanups to arch/x86/kernel/head_64.S|head64.c.  Not much
has changed upstream here.  Also 3.14-rc4 still has the same hang.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/head_64.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 77e6d3e..05306c8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -368,6 +368,8 @@ ENTRY(early_idt_handler)
 	jz 20f			# All good
 
 10:
+	cmpl $2,72(%rsp)	# NMI?
+	jz 20f			# skip NMIs
 	leaq 88(%rsp),%rdi	# Pointer to %rip
 	call early_fixup_exception
 	andl %eax,%eax
-- 
1.7.1

