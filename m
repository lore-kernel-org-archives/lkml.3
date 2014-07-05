Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaGEOeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 10:34:04 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41066 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaGEOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 10:34:03 -0400
Date: Sat, 5 Jul 2014 20:03:56 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] powerpc/fsl-pci: Correct use of ! and &
Message-ID: <20140705143356.GA3321@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit ae91d60ba88ef0bdb1b5e9b2363bd52fc45d2af7, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
This is not tested and clearly changes the semantics, so it is only
something to consider.

 arch/powerpc/sysdev/fsl_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 4bd091a..c507767 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -853,8 +853,8 @@ u64 fsl_pci_immrbar_base(struct pci_controller *hose)
 		in = pcie->cfg_type0 + PEX_RC_INWIN_BASE;
 		for (i = 0; i < 4; i++) {
 			/* not enabled, skip */
-			if (!in_le32(&in[i].ar) & PEX_RCIWARn_EN)
-				 continue;
+			if (!(in_le32(&in[i].ar) & PEX_RCIWARn_EN))
+				continue;
 
 			if (get_immrbase() == in_le32(&in[i].tar))
 				return (u64)in_le32(&in[i].barh) << 32 |
-- 
1.9.1

