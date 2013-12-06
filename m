Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226Ab3LFNAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:00:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137Ab3LFNAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 033/272] powerpc/eeh: Enable PCI_COMMAND_MASTER for PCI bridges
Date: Fri,  6 Dec 2013 12:55:22 +0000
Message-Id: <1386334761-25517-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit bf898ec5cbd33be11147743bee27b66b10cb2f85 upstream.

On PHB3, we will fail to fetch IODA tables without PCI_COMMAND_MASTER
on PCI bridges. According to one experiment I had, the MSIx interrupts
didn't raise from the adapter without the bit applied to all upstream
PCI bridges including root port of the adapter. The patch forces to
have that bit enabled accordingly.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/eeh.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 55593ee..c766cf5 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -687,6 +687,15 @@ void eeh_save_bars(struct eeh_dev *edev)
 
 	for (i = 0; i < 16; i++)
 		eeh_ops->read_config(dn, i * 4, 4, &edev->config_space[i]);
+
+	/*
+	 * For PCI bridges including root port, we need enable bus
+	 * master explicitly. Otherwise, it can't fetch IODA table
+	 * entries correctly. So we cache the bit in advance so that
+	 * we can restore it after reset, either PHB range or PE range.
+	 */
+	if (edev->mode & EEH_DEV_BRIDGE)
+		edev->config_space[1] |= PCI_COMMAND_MASTER;
 }
 
 /**
-- 
1.8.3.2

