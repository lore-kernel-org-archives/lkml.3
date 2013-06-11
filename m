Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3FKUOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:14:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3FKUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [ 38/79] ARM: Kirkwood: TS219: Fix crash by double PCIe instantiation
Date: Tue, 11 Jun 2013 13:03:04 -0700
Message-Id: <20130611195320.940236718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit e89b4058096569c999fa599370162022a5a2b3d2 upstream.

When creating the DT based boards-ts219.c the none DT ts219-setup.c
was used as a template. This includes a lateinit() call to initialize
the PCIe bus. The code makes use of machine_is_ts219() which is never
true on DT, so a FIXME was added and the code left as is. This was
unproblematic until b73690c8f8b5d: "ARM: Kirkwood: Support basic
hotplug for PCI-E" which changes the way the PCIe bus is
initialized. The non-DT ts219-setup.c now crashes during boot.  The
lateinit() call in the DT boards-ts219.c is being called,
machine_is_ts219() is true and so the PCIe is initialized a second
time.

This patch removes the useless, and now clearly dangerous, code from
boards-ts219.c, making ts219-setup.c work again.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-kirkwood/board-ts219.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/arch/arm/mach-kirkwood/board-ts219.c
+++ b/arch/arm/mach-kirkwood/board-ts219.c
@@ -41,13 +41,3 @@ void __init qnap_dt_ts219_init(void)
 
 	pm_power_off = qnap_tsx1x_power_off;
 }
-
-/* FIXME: Will not work with DT. Maybe use MPP40_GPIO? */
-static int __init ts219_pci_init(void)
-{
-	if (machine_is_ts219())
-		kirkwood_pcie_init(KW_PCIE0);
-
-	return 0;
-}
-subsys_initcall(ts219_pci_init);


