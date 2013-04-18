Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967001Ab3DROYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:24:05 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966753Ab3DROYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:24:02 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Kay Sievers <kay@vrfy.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH RFC] ARM: don't allow to register the early_console twice
Date: Thu, 18 Apr 2013 16:23:39 +0200
Message-Id: <1366295019-30335-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366295019-30335-1-git-send-email-gregory.clement@free-electrons.com>
References: <1366295019-30335-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If on the kernel command line the parameter "earlyprintk" is written
twice, then setup_early_printk is called twice. This can happen for
example with the option CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is
selected, and the "earlyprintk" is passed from the ATAG_CMDLINE and
from the dtb.

This lead to an infinite loop on the message "Booting Linux on
physical CPU 0" displayed from smp_setup_processor_id() in
arch/arm/kernel/setup.c. This behavior as been reproduced on ARMv7
architecture (Armada XP and Armada 370), and on a ARMv5 one
(AT91SAMG35 thanks to Richard Genoud), with and with CONFIG_SMP
selected.

This patch simply doesn't allow to call twice register_console() with
the early_console.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/kernel/early_printk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/early_printk.c b/arch/arm/kernel/early_printk.c
index 85aa2b2..435577a 100644
--- a/arch/arm/kernel/early_printk.c
+++ b/arch/arm/kernel/early_printk.c
@@ -50,7 +50,11 @@ asmlinkage void early_printk(const char *fmt, ...)
 
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
+	static int done;
+	if (!done) {
+		register_console(&early_console);
+		done = 1;
+	}
 	return 0;
 }
 
-- 
1.7.9.5

