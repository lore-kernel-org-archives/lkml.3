Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbbAVCRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:17:40 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39619 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbAVCRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:17:31 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v3 0/2] x86/xen: add xen hypercall preemption
Date: Wed, 21 Jan 2015 18:17:17 -0800
Message-Id: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

After my last respin Andy provided some ideas as how to skip
IRQ context hacks for preemption, this v3 spin addresses that
and a bit more.

This is based on both Andrew Cooper's and David Vrabel's work,
further modified based on ideas by Andy Lutomirski to avoid
having to deal with preemption on IRQ context. Ian had originally
suggested to avoid the pt_regs stuff by using a CPU variable but
based on Andy's observations it is difficult to prove we will
avoid recursing or bad nesting when dealing with preemption out
of IRQ context. This is specially true given that after a hypercall
gets preempted the hypercall may end up another CPU.

This uses NOKPROBE_SYMBOL and notrace since based on Andy's advice
I am not confident that tracing and kprobes are safe to use in what
might be an extended RCU quiescent state (i.e. where we're outside
irq_enter and irq_exit).

I've tested this on 64-bit, some testing on 32-bit would be
appreciated.

Luis R. Rodriguez (2):
  x86/xen: add xen_is_preemptible_hypercall()
  x86/xen: allow privcmd hypercalls to be preempted

 arch/x86/include/asm/xen/hypercall.h | 20 ++++++++++++++++++++
 arch/x86/kernel/entry_32.S           |  2 ++
 arch/x86/kernel/entry_64.S           |  2 ++
 arch/x86/xen/enlighten.c             |  7 +++++++
 arch/x86/xen/xen-head.S              | 18 +++++++++++++++++-
 drivers/xen/events/events_base.c     | 13 +++++++++++++
 include/xen/events.h                 |  1 +
 7 files changed, 62 insertions(+), 1 deletion(-)

-- 
2.1.1

