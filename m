Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104Ab3DJXHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:07:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937351Ab3DJWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Abraham <thomas.ab@samsung.com>,
        Girish K S <ks.giri@samsung.com>, Kukjin <kgene.kim@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 55/64] ARM: EXYNOS: Fix crash on soft reset on EXYNOS5440
Date: Wed, 10 Apr 2013 15:46:52 -0700
Message-Id: <20130410224346.271371149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Abraham <thomas.ab@samsung.com>

commit 60db7e5f9c9a25a7a9b01007e6e3f5a93bc16a3a upstream.

The soft-reset control register is located in the XMU controller space.
Map this controller space before writing to the soft-reset controller
register.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Signed-off-by: Girish K S <ks.giri@samsung.com>
Signed-off-by: Kukjin <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-exynos/common.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -299,6 +299,7 @@ void exynos4_restart(char mode, const ch
 
 void exynos5_restart(char mode, const char *cmd)
 {
+	struct device_node *np;
 	u32 val;
 	void __iomem *addr;
 
@@ -306,8 +307,9 @@ void exynos5_restart(char mode, const ch
 		val = 0x1;
 		addr = EXYNOS_SWRESET;
 	} else if (of_machine_is_compatible("samsung,exynos5440")) {
-		val = (0x10 << 20) | (0x1 << 16);
-		addr = EXYNOS5440_SWRESET;
+		np = of_find_compatible_node(NULL, NULL, "samsung,exynos5440-clock");
+		addr = of_iomap(np, 0) + 0xcc;
+		val = (0xfff << 20) | (0x1 << 16);
 	} else {
 		pr_err("%s: cannot support non-DT\n", __func__);
 		return;


