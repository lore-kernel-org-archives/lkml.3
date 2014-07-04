Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbaGDXJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:09:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303AbaGDWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.15 15/66] MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremapd region
Date: Fri,  4 Jul 2014 15:14:14 -0700
Message-Id: <20140704221423.528702950@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit ab6c15bc6620ebe220970cc040b29bcb2757f373 upstream.

Previously, the lower limit for the MIPS SC initialization loop was
set incorrectly allowing one extra loop leading to writes
beyond the MSC ioremap'd space. More precisely, the value of the 'imp'
in the last loop increased beyond the msc_irqmap_t boundaries and
as a result of which, the 'n' variable was loaded with an incorrect
value. This value was used later on to calculate the offset in the
MSC01_IC_SUP which led to random crashes like the following one:

CPU 0 Unable to handle kernel paging request at virtual address e75c0200,
epc == 8058dba4, ra == 8058db90
[...]
Call Trace:
[<8058dba4>] init_msc_irqs+0x104/0x154
[<8058b5bc>] arch_init_irq+0xd8/0x154
[<805897b0>] start_kernel+0x220/0x36c

Kernel panic - not syncing: Attempted to kill the idle task!

This patch fixes the problem

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7118/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/irq-msc01.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/irq-msc01.c
+++ b/arch/mips/kernel/irq-msc01.c
@@ -131,7 +131,7 @@ void __init init_msc_irqs(unsigned long
 
 	board_bind_eic_interrupt = &msc_bind_eic_interrupt;
 
-	for (; nirq >= 0; nirq--, imp++) {
+	for (; nirq > 0; nirq--, imp++) {
 		int n = imp->im_irq;
 
 		switch (imp->im_type) {


