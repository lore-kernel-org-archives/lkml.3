Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbaCDViq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:38:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaCDUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.13 022/172] ARM: imx6: build pm-imx6q.c independently of CONFIG_PM
Date: Tue,  4 Mar 2014 12:01:46 -0800
Message-Id: <20140304200300.443039323@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 28a9f3b078c545064dcf4b46d2c6917554d1642e upstream.

When building a kernel image with only CONFIG_CPU_IDLE but no CONFIG_PM,
we will get the following link error.

  LD      init/built-in.o
arch/arm/mach-imx/built-in.o: In function `imx6q_enter_wait':
platform-spi_imx.c:(.text+0x25c0): undefined reference to `imx6q_set_lpm'
platform-spi_imx.c:(.text+0x25d4): undefined reference to `imx6q_set_lpm'
arch/arm/mach-imx/built-in.o: In function `imx6q_cpuidle_init':
platform-spi_imx.c:(.init.text+0x75d4): undefined reference to `imx6q_set_chicken_bit'
make[1]: *** [vmlinux] Error 1

Since pm-imx6q.c has been a collection of library functions that access
CCM low-power registers used by not only suspend but also cpuidle and
other drivers, let's build pm-imx6q.c independently of CONFIG_PM to fix
above error.

Reported-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/Makefile |    2 --
 arch/arm/mach-imx/common.h |    4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -100,11 +100,9 @@ obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SOC_IMX6Q) += clk-imx6q.o mach-imx6q.o
 obj-$(CONFIG_SOC_IMX6SL) += clk-imx6sl.o mach-imx6sl.o
 
-ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o headsmp.o
 # i.MX6SL reuses i.MX6Q code
 obj-$(CONFIG_SOC_IMX6SL) += pm-imx6q.o headsmp.o
-endif
 
 # i.MX5 based machines
 obj-$(CONFIG_MACH_MX51_BABBAGE) += mach-mx51_babbage.o
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -143,13 +143,11 @@ void imx6q_set_chicken_bit(void);
 void imx_cpu_die(unsigned int cpu);
 int imx_cpu_kill(unsigned int cpu);
 
-#ifdef CONFIG_PM
 void imx6q_pm_init(void);
 void imx6q_pm_set_ccm_base(void __iomem *base);
+#ifdef CONFIG_PM
 void imx5_pm_init(void);
 #else
-static inline void imx6q_pm_init(void) {}
-static inline void imx6q_pm_set_ccm_base(void __iomem *base) {}
 static inline void imx5_pm_init(void) {}
 #endif
 


