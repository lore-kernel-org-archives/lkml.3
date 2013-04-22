Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3DVObx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:31:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51704 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127Ab3DVOa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Wolf" <mjw@linux.vnet.ibm.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.396857836@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [26/75] powerpc: pSeries_lpar_hpte_remove fails from Adjunct
 partition being performed before the ANDCOND test
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/platforms/pseries/lpar.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -186,7 +186,13 @@ static long pSeries_lpar_hpte_remove(uns
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

