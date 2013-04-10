Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937441Ab3DJW5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:57:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937496Ab3DJWuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Wolf <mjw@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [ 17/29] powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test
Date: Wed, 10 Apr 2013 15:49:35 -0700
Message-Id: <20130410224805.866952080@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/lpar.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -187,7 +187,13 @@ static long pSeries_lpar_hpte_remove(uns
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


