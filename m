Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaAWTNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:13:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaAWTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.12 27/27] ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling
Date: Thu, 23 Jan 2014 11:07:04 -0800
Message-Id: <20140123190651.584568157@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taras Kondratiuk <taras.kondratiuk@linaro.org>

commit b25f3e1c358434bf850220e04f28eebfc45eb634 upstream.

Kexec disables outer cache before jumping to reboot code, but it doesn't
flush it explicitly. Flush is done implicitly inside of l2x0_disable().
But some SoC's override default .disable handler and don't flush cache.
This may lead to a corrupted memory during Kexec reboot on these
platforms.

This patch adds cache flush inside of OMAP4 and Highbank outer_cache.disable()
handlers to make it consistent with default l2x0_disable().

Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-highbank/highbank.c  |    1 +
 arch/arm/mach-omap2/omap4-common.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -66,6 +66,7 @@ void highbank_set_cpu_jump(int cpu, void
 
 static void highbank_l2x0_disable(void)
 {
+	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	highbank_smc1(0x102, 0x0);
 }
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -163,6 +163,7 @@ void __iomem *omap4_get_l2cache_base(voi
 
 static void omap4_l2x0_disable(void)
 {
+	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	omap_smc1(0x102, 0x0);
 }


