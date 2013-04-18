Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967307Ab3DRJdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:33:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40100 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3DRJRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Wolf <mjw@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 20/72] powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test
Date: Thu, 18 Apr 2013 10:16:05 +0100
Message-Id: <1366276617-3553-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Wolf <mjw@linux.vnet.ibm.com>

commit 9fb2640159f9d4f5a2a9d60e490482d4cbecafdb upstream.

Some versions of pHyp will perform the adjunct partition test before the
ANDCOND test.  The result of this is that H_RESOURCE can be returned and
cause the BUG_ON condition to occur. The HPTE is not removed.  So add a
check for H_RESOURCE, it is ok if this HPTE is not removed as
pSeries_lpar_hpte_remove is looking for an HPTE to remove and not a
specific HPTE to remove.  So it is ok to just move on to the next slot
and try again.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/pseries/lpar.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 5f3ef87..9cfdcc9 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -187,7 +187,13 @@ static long pSeries_lpar_hpte_remove(unsigned long hpte_group)
 					   (0x1UL << 4), &dummy1, &dummy2);
 		if (lpar_rc == H_SUCCESS)
 			return i;
-		BUG_ON(lpar_rc != H_NOT_FOUND);
+
+		/*
+		 * The test for adjunct partition is performed before the
+		 * ANDCOND test.  H_RESOURCE may be returned, so we need to
+		 * check for that as well.
+		 */
+		BUG_ON(lpar_rc != H_NOT_FOUND && lpar_rc != H_RESOURCE);
 
 		slot_offset++;
 		slot_offset &= 0x7;
-- 
1.8.1.2

