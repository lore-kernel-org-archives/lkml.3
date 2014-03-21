Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966931AbaCUBSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:18:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760466AbaCUADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel J Blueman <daniel@numascale.com>,
        Steffen Persvold <sp@numascale.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.13 063/149] x86/amd/numa: Fix northbridge quirk to assign correct NUMA node
Date: Thu, 20 Mar 2014 17:03:46 -0700
Message-Id: <20140321000439.141541061@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -529,7 +529,7 @@ static void quirk_amd_nb_node(struct pci
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = val & 7;
+	node = pcibus_to_node(dev->bus) | (val & 7);
 	/*
 	 * Some hardware may return an invalid node ID,
 	 * so check it first:


