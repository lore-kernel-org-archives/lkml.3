Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab3CZPXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028Ab3CZPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: CQ Tang <cq.tang@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/150] x86-64: Fix the failure case in copy_user_handle_tail()
Date: Tue, 26 Mar 2013 15:19:40 +0000
Message-Id: <1364311249-14454-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/lib/usercopy_64.c | 4 ++--
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
1.8.1.2

