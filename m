Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaE2Jvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:51:48 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaE2Jvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:51:46 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] um: Detect kernel userspace access
Date: Thu, 29 May 2014 11:51:29 +0200
Message-Id: <1401357089-24959-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1401357089-24959-1-git-send-email-richard@nod.at>
References: <1401357089-24959-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From time to time users report that UML hangs and consumes 100% CPU
on the host side.
Analyzing such an issue uncovered a bug in UML's page fault
handler. If the kernel tries to access userspace memory without
copy_from/to_user() UML receives a SIGSEGV and tries to handle
it. As the page fault handler is not designed to fix such faults the
SIGSEGV stays and UML consumes all CPU handling SIGSEGV.
The only sane thing we can do here is calling panic().

This patch helps to detect bad memory access from the kernel side.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/trap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index b0a3017..04a6de4 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -222,6 +222,9 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 		if (!is_user && address < PAGE_SIZE) {
 			show_regs(container_of(regs, struct pt_regs, regs));
 			panic("NULL pointer dereference at ip:0x%lx address:0x%lx", ip, address);
+		} else if (!is_user && address < task_size) {
+			show_regs(container_of(regs, struct pt_regs, regs));
+			panic("Kernel tried to access userspace at ip:0x%lx address:0x%lx", ip, address);
 		}
 
 		err = handle_page_fault(address, ip, is_write, is_user,
-- 
1.8.4.2

