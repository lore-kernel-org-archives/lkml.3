Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3GPFX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:23:27 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:55522
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab3GPFX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:23:26 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bh8275dhz2dh87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@kernel.org>
To: <torvalds@linux-foundation.org>, <geert@linux-m68k.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH] smp: blackfin: fix check error, using atomic_ops to handle atomic_t type
Date: Tue, 16 Jul 2013 13:25:21 +0800
Message-ID: <1373952321-22903-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 arch/blackfin/mach-common/smp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 961d839..b5f9ed7 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -147,7 +147,7 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 	platform_clear_ipi(cpu, IRQ_SUPPLE_1);
 
 	bfin_ipi_data = &__get_cpu_var(bfin_ipi);
-	while ((pending = xchg(&bfin_ipi_data->bits, 0)) != 0) {
+	while ((pending = atomic_xchg(&bfin_ipi_data->bits, 0)) != 0) {
 		msg = 0;
 		do {
 			msg = find_next_bit(&pending, BITS_PER_LONG, msg + 1);
@@ -182,8 +182,8 @@ static void bfin_ipi_init(void)
 	struct ipi_data *bfin_ipi_data;
 	for_each_possible_cpu(cpu) {
 		bfin_ipi_data = &per_cpu(bfin_ipi, cpu);
-		bfin_ipi_data->bits = 0;
-		bfin_ipi_data->count = 0;
+		atomic_set(&bfin_ipi_data->bits, 0);
+		atomic_set(&bfin_ipi_data->count, 0);
 	}
 }
 
-- 
1.7.9.5


