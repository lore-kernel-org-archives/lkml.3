Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaCNKKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:10:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaCNKKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:10:10 -0400
Date: Fri, 14 Mar 2014 03:09:42 -0700
From: tip-bot for Daniel J Blueman <tipbot@zytor.com>
Message-ID: <tip-847d7970defb45540735b3fb4e88471c27cacd85@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, sp@numascale.com, daniel@numascale.com,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sp@numascale.com, stable@vger.kernel.org, daniel@numascale.com,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1394710981-3596-1-git-send-email-daniel@numascale.com>
References: <1394710981-3596-1-git-send-email-daniel@numascale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/amd/numa:
  Fix northbridge quirk to assign correct NUMA node
Git-Commit-ID: 847d7970defb45540735b3fb4e88471c27cacd85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  847d7970defb45540735b3fb4e88471c27cacd85
Gitweb:     http://git.kernel.org/tip/847d7970defb45540735b3fb4e88471c27cacd85
Author:     Daniel J Blueman <daniel@numascale.com>
AuthorDate: Thu, 13 Mar 2014 19:43:01 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 14 Mar 2014 11:05:36 +0100

x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1394710981-3596-1-git-send-email-daniel@numascale.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 7c6acd4..ff898bb 100644
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
