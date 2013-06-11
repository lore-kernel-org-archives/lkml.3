Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3FKURF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:17:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3FKUDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 44/79] powerpc/perf: Fix deadlock caused by calling printk() in PMU exception
Date: Tue, 11 Jun 2013 13:03:10 -0700
Message-Id: <20130611195321.682207518@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 6772faa1ba22eba18d087c2459030a683b65be57 upstream.

In commit bc09c21 "Fix finding overflowed PMC in interrupt" we added
a printk() to the PMU exception handler. Unfortunately that is not safe.

The problem is that the PMU exception may run even when interrupts are
soft disabled, aka NMI context. We do this so that we can profile parts
of the kernel that have interrupts soft-disabled.

But by calling printk() from the exception handler, we can potentially
deadlock in the printk code on logbuf_lock, eg:

  [c00000038ba575c0] c000000000081928 .vprintk_emit+0xa8/0x540
  [c00000038ba576a0] c0000000007bcde8 .printk+0x48/0x58
  [c00000038ba57710] c000000000076504 .perf_event_interrupt+0x2d4/0x490
  [c00000038ba57810] c00000000001f6f8 .performance_monitor_exception+0x48/0x60
  [c00000038ba57880] c0000000000032cc performance_monitor_common+0x14c/0x180
  --- Exception: f01 (Performance Monitor) at c0000000007b25d4 ._raw_spin_lock_irq
  +0x64/0xc0
  [c00000038ba57bf0] c00000000007ed90 .devkmsg_read+0xd0/0x5a0
  [c00000038ba57d00] c0000000001c2934 .vfs_read+0xc4/0x1e0
  [c00000038ba57d90] c0000000001c2cd8 .SyS_read+0x58/0xd0
  [c00000038ba57e30] c000000000009d54 syscall_exit+0x0/0x98
  --- Exception: c01 (System Call) at 00001fffffbf6f7c
  SP (3ffff6d4de10) is in userspace

Fix it by making sure we only call printk() when we are not in NMI
context.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1528,7 +1528,7 @@ static void perf_event_interrupt(struct
 			}
 		}
 	}
-	if ((!found) && printk_ratelimit())
+	if (!found && !nmi && printk_ratelimit())
 		printk(KERN_WARNING "Can't find PMC that caused IRQ\n");
 
 	/*


