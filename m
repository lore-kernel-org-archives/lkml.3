Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3CYB3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:29:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33951 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab3CYBP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:56 -0400
Message-Id: <20130325010530.887150435@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:31 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, CQ Tang <cq.tang@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 067/104] x86-64: Fix the failure case in copy_user_handle_tail()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: CQ Tang <cq.tang@intel.com>

commit 66db3feb486c01349f767b98ebb10b0c3d2d021b upstream.

The increment of "to" in copy_user_handle_tail() will have incremented
before a failure has been noted.  This causes us to skip a byte in the
failure case.

Only do the increment when assured there is no failure.

Signed-off-by: CQ Tang <cq.tang@intel.com>
Link: http://lkml.kernel.org/r/20130318150221.8439.993.stgit@phlsvslse11.ph.intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/lib/usercopy_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -169,10 +169,10 @@ copy_user_handle_tail(char *to, char *fr
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
 


