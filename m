Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaFDJLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:11:31 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7781 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbaFDJKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:10:02 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392159600"; 
   d="scan'208";a="65385501"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: kernel-janitors@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] s390/pci: use safer test on the result of find_first_zero_bit
Date: Wed,  4 Jun 2014 11:07:58 +0200
Message-Id: <1401872880-23685-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
return a larger number than the maximum position argument if that position
is not a multiple of BITS_PER_LONG.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3;
statement S1,S2;
@@

e1 = find_first_zero_bit(e2,e3)
...
if (e1 
- ==
+ >=
  e3)
S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/s390/pci/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -566,7 +566,7 @@ static int zpci_alloc_iomap(struct zpci_
 
 	spin_lock(&zpci_iomap_lock);
 	entry = find_first_zero_bit(zpci_iomap, ZPCI_IOMAP_MAX_ENTRIES);
-	if (entry == ZPCI_IOMAP_MAX_ENTRIES) {
+	if (entry >= ZPCI_IOMAP_MAX_ENTRIES) {
 		spin_unlock(&zpci_iomap_lock);
 		return -ENOSPC;
 	}
@@ -746,7 +746,7 @@ static int zpci_alloc_domain(struct zpci
 {
 	spin_lock(&zpci_domain_lock);
 	zdev->domain = find_first_zero_bit(zpci_domain, ZPCI_NR_DEVICES);
-	if (zdev->domain == ZPCI_NR_DEVICES) {
+	if (zdev->domain >= ZPCI_NR_DEVICES) {
 		spin_unlock(&zpci_domain_lock);
 		return -ENOSPC;
 	}

