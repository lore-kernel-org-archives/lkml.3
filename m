Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaC3Xn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795AbaC3Xnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel J Blueman" <daniel@numascale.com>,
        "Steffen Persvold" <sp@numascale.com>,
        "Ingo Molnar" <mingo@kernel.org>, "Borislav Petkov" <bp@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.629684280@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 176/200] x86/amd/numa: Fix northbridge quirk to assign
 correct NUMA node
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -525,7 +525,7 @@ static void __init quirk_amd_nb_node(str
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = val & 7;
+	node = pcibus_to_node(dev->bus) | (val & 7);
 	/*
 	 * Some hardware may return an invalid node ID,
 	 * so check it first:

