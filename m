Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaCMLni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:43:38 -0400
Received: from numascale.com ([213.162.240.84]:58231 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbaCMLnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:43:35 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale.com>
Subject: [PATCH] Fix northbridge quirk to assign correct NUMA node
Date: Thu, 13 Mar 2014 19:43:01 +0800
Message-Id: <1394710981-3596-1-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.8.3.2
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For systems with multiple servers and routed fabric, all northbridges get
assigned to the first server. Fix this by also using the node reported from
the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
by definition, which are on NUMA node 0 by definition, so this is invarient
on most systems.

Tested on fam10h and fam15h single and multi-fabric systems and candidate
for stable.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
Acked-by: Steffen Persvold <sp@numascale.com>
---
 arch/x86/kernel/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 04ee1e2..52dbf1e 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -529,7 +529,7 @@ static void quirk_amd_nb_node(struct pci_dev *dev)
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = val & 7;
+	node = pcibus_to_node(dev->bus) | (val & 7);
 	/*
 	 * Some hardware may return an invalid node ID,
 	 * so check it first:
-- 
1.8.3.2

