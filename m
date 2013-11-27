Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3K0BI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:08:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab3K0A77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.12 092/116] powerpc/eeh: Enable PCI_COMMAND_MASTER for PCI bridges
Date: Tue, 26 Nov 2013 16:57:45 -0800
Message-Id: <20131127005743.266792420@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/eeh.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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


