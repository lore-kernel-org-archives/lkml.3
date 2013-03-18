Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3CRUG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:06:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3CRUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:06:56 -0400
Date: Mon, 18 Mar 2013 13:05:25 -0700
From: tip-bot for CQ Tang <tipbot@zytor.com>
Message-ID: <tip-66db3feb486c01349f767b98ebb10b0c3d2d021b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cq.tang@intel.com, stable@vger.kernel.org, tglx@linutronix.de,
        mike.marciniszyn@intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cq.tang@intel.com, stable@vger.kernel.org, tglx@linutronix.de,
        mike.marciniszyn@intel.com, hpa@linux.intel.com
In-Reply-To: <20130318150221.8439.993.stgit@phlsvslse11.ph.intel.com>
References: <20130318150221.8439.993.stgit@phlsvslse11.ph.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64:
  Fix the failure case in copy_user_handle_tail()
Git-Commit-ID: 66db3feb486c01349f767b98ebb10b0c3d2d021b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 13:05:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66db3feb486c01349f767b98ebb10b0c3d2d021b
Gitweb:     http://git.kernel.org/tip/66db3feb486c01349f767b98ebb10b0c3d2d021b
Author:     CQ Tang <cq.tang@intel.com>
AuthorDate: Mon, 18 Mar 2013 11:02:21 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 18 Mar 2013 11:32:03 -0700

x86-64: Fix the failure case in copy_user_handle_tail()

The increment of "to" in copy_user_handle_tail() will have incremented
before a failure has been noted.  This causes us to skip a byte in the
failure case.

Only do the increment when assured there is no failure.

Signed-off-by: CQ Tang <cq.tang@intel.com>
Link: http://lkml.kernel.org/r/20130318150221.8439.993.stgit@phlsvslse11.ph.intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/lib/usercopy_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 05928aa..906fea3 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -74,10 +74,10 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
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
 
