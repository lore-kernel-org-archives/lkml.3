Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3FCWUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:20:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab3FCWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:10 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XzVCprq8OFMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aEtvxhUO1MwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221154.998760819@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [17/65] ext4: limit group search loop for non-extent files
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0017-ext4-limit-group-search-loop-for-non-extent-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lachlan McIlroy <lmcilroy@redhat.com>

[ Upstream commit e6155736ad76b2070652745f9e54cdea3f0d8567 ]

In the case where we are allocating for a non-extent file,
we must limit the groups we allocate from to those below
2^32 blocks, and ext4_mb_regular_allocator() attempts to
do this initially by putting a cap on ngroups for the
subsequent search loop.

However, the initial target group comes in from the
allocation context (ac), and it may already be beyond
the artificially limited ngroups.  In this case,
the limit

	if (group == ngroups)
		group = 0;

at the top of the loop is never true, and the loop will
run away.

Catch this case inside the loop and reset the search to
start at group 0.

[sandeen@redhat.com: add commit msg & comments]

Signed-off-by: Lachlan McIlroy <lmcilroy@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/mballoc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 773d341..bd62716 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1979,7 +1979,11 @@ repeat:
 		group = ac->ac_g_ex.fe_group;
 
 		for (i = 0; i < ngroups; group++, i++) {
-			if (group == ngroups)
+			/*
+			 * Artificially restricted ngroups for non-extent
+			 * files makes group > ngroups possible on first loop.
+			 */
+			if (group >= ngroups)
 				group = 0;
 
 			/* This now checks without needing the buddy page */
-- 
1.7.10.4


