Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989Ab3DKUvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:51:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935934Ab3DKUth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:37 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=24lAvUMYYecA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4sA1DRgU9ZsA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202556.405566685@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: CQ Tang <cq.tang@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 062/171 ] x86-64: Fix the failure case in copy_user_handle_tail()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0062-x86-64-Fix-the-failure-case-in-copy_user_handle_tail.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: CQ Tang <cq.tang@intel.com>

[ Upstream commit 66db3feb486c01349f767b98ebb10b0c3d2d021b ]

The increment of "to" in copy_user_handle_tail() will have incremented
before a failure has been noted.  This causes us to skip a byte in the
failure case.

Only do the increment when assured there is no failure.

Signed-off-by: CQ Tang <cq.tang@intel.com>
Link: http://lkml.kernel.org/r/20130318150221.8439.993.stgit@phlsvslse11.ph.intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/lib/usercopy_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index e5b130b..cc9de31 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -72,10 +72,10 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	char c;
 	unsigned zero_len;
 
-	for (; len; --len) {
+	for (; len; --len, to++) {
 		if (__get_user_nocheck(c, from++, sizeof(char)))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user_nocheck(c, to, sizeof(char)))
 			break;
 	}
 
-- 
1.7.10.4


