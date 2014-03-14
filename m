Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaCNBTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 21:19:45 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36820 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaCNBTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 21:19:44 -0400
Message-ID: <5322592B.6060104@gmail.com>
Date: Fri, 14 Mar 2014 09:19:39 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/kernel/clock.c: add readl() and writel() for
 'PM_' macros
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add readl() and writel() for 'PM_' macros, just like another areas have
done within unicored32, or will cause compiling issue.

The related error (allmodconfig for unicored32):

    CC      arch/unicore32/kernel/clock.o
  arch/unicore32/kernel/clock.c: In function ‘clk_set_rate’:
  arch/unicore32/kernel/clock.c:182: warning: initialization makes integer from pointer without a cast
  arch/unicore32/kernel/clock.c:204: error: lvalue required as left operand of assignment
  arch/unicore32/kernel/clock.c:206: error: lvalue required as left operand of assignment
  arch/unicore32/kernel/clock.c:207: error: invalid operands to binary & (have ‘void *’ and ‘long unsigned int’)
  make[1]: *** [arch/unicore32/kernel/clock.o] Error 1
  make: *** [arch/unicore32/kernel] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/clock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/unicore32/kernel/clock.c b/arch/unicore32/kernel/clock.c
index 18d4563..b1ca775 100644
--- a/arch/unicore32/kernel/clock.c
+++ b/arch/unicore32/kernel/clock.c
@@ -179,7 +179,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	}
 #ifdef CONFIG_CPU_FREQ
 	if (clk == &clk_mclk_clk) {
-		u32 pll_rate, divstatus = PM_DIVSTATUS;
+		u32 pll_rate, divstatus = readl(PM_DIVSTATUS);
 		int ret, i;
 
 		/* lookup mclk_clk_table */
@@ -201,10 +201,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 				/ (((divstatus & 0x0000f000) >> 12) + 1);
 
 		/* set pll sys cfg reg. */
-		PM_PLLSYSCFG = pll_rate;
+		writel(pll_rate, PM_PLLSYSCFG);
 
-		PM_PMCR = PM_PMCR_CFBSYS;
-		while ((PM_PLLDFCDONE & PM_PLLDFCDONE_SYSDFC)
+		writel(PM_PMCR_CFBSYS, PM_PMCR);
+		while ((readl(PM_PLLDFCDONE) & PM_PLLDFCDONE_SYSDFC)
 				!= PM_PLLDFCDONE_SYSDFC)
 			udelay(100);
 			/* about 1ms */
-- 
1.7.9.5
