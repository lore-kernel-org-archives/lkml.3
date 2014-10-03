Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbaJDApj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:45:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaJCVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shawn Guo <shawn.guo@freescale.com>,
        Anson Huang <Anson.Huang@freescale.com>
Subject: [PATCH 3.16 037/357] ARM: imx: fix TLB missing of IOMUXC base address during suspend
Date: Fri,  3 Oct 2014 14:27:03 -0700
Message-Id: <20141003212934.580948979@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@freescale.com>

commit 59d05b518321618177b898a6801503e31b15b25b upstream.

After the suspend routine running in OCRAM puts DDR into self-refresh,
it will access IOMUXC block to float DDR IO for power saving.  A TLB
missing of IOMUXC base address may happen in this case, and triggers an
access to DDR, and thus hangs the system.

The failure is discovered by running suspend/resume on a Cubox-i board.
Though the issue is not Cubox-i specific, it can be hit the on the board
quite easily with the 3.15 or 3.16 kernel.

Fix the issue with a dummy access to IOMUXC block at the beginning of
suspend routine, so that the address translation can be filled into TLB
before DDR is put into self-refresh.

Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Acked-by: Anson Huang <Anson.Huang@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/suspend-imx6.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-imx/suspend-imx6.S
+++ b/arch/arm/mach-imx/suspend-imx6.S
@@ -172,6 +172,8 @@ ENTRY(imx6_suspend)
 	ldr	r6, [r11, #0x0]
 	ldr	r11, [r0, #PM_INFO_MX6Q_GPC_V_OFFSET]
 	ldr	r6, [r11, #0x0]
+	ldr	r11, [r0, #PM_INFO_MX6Q_IOMUXC_V_OFFSET]
+	ldr	r6, [r11, #0x0]
 
 	/* use r11 to store the IO address */
 	ldr	r11, [r0, #PM_INFO_MX6Q_SRC_V_OFFSET]


