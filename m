Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaDAQPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:15:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaDAQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:13:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel J Blueman <daniel@numascale.com>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 74/86] x86/amd/numa: Fix northbridge quirk to assign correct NUMA node
Date: Tue,  1 Apr 2014 09:08:27 -0700
Message-Id: <1396368519-12728-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@numascale.com>

commit 847d7970defb45540735b3fb4e88471c27cacd85 upstream.

For systems with multiple servers and routed fabric, all
northbridges get assigned to the first server. Fix this by also
using the node reported from the PCI bus. For single-fabric
systems, the northbriges are on PCI bus 0 by definition, which
are on NUMA node 0 by definition, so this is invarient on most
systems.

Tested on fam10h and fam15h single and multi-fabric systems and
candidate for stable.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
Acked-by: Steffen Persvold <sp@numascale.com>
Acked-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1394710981-3596-1-git-send-email-daniel@numascale.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 26ee48a..b9ef5d9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -525,7 +525,7 @@ static void quirk_amd_nb_node(struct pci_dev *dev)
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = val & 7;
+	node = pcibus_to_node(dev->bus) | (val & 7);
 	/*
 	 * Some hardware may return an invalid node ID,
 	 * so check it first:
-- 
1.8.3.2

