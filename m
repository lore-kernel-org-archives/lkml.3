Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab3EGEGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892Ab3EGD6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:49 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YNrnxm9wvQkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RqxSJzTtC18A:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=rOUgymgbAAAA:8 a=Y8YdqA6ryhf90p4iqFQA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035844.074522326@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Wolf <mjw@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [019/126] powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being
 performed before the ANDCOND test
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0019-powerpc-pSeries_lpar_hpte_remove-fails-from-Adjunct-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Wolf <mjw@linux.vnet.ibm.com>

[ Upstream commit 9fb2640159f9d4f5a2a9d60e490482d4cbecafdb ]

Some versions of pHyp will perform the adjunct partition test before the
ANDCOND test.  The result of this is that H_RESOURCE can be returned and
cause the BUG_ON condition to occur. The HPTE is not removed.  So add a
check for H_RESOURCE, it is ok if this HPTE is not removed as
pSeries_lpar_hpte_remove is looking for an HPTE to remove and not a
specific HPTE to remove.  So it is ok to just move on to the next slot
and try again.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/platforms/pseries/lpar.c |    8 +++++++-
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
1.7.10.4


