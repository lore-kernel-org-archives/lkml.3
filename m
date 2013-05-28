Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab3E1VWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:22:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59543 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 15/78] ext4: limit group search loop for non-extent files
Date: Tue, 28 May 2013 14:19:24 -0700
Message-Id: <1369776027-17859-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan McIlroy <lmcilroy@redhat.com>

commit e6155736ad76b2070652745f9e54cdea3f0d8567 upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/mballoc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b443e62..1206682 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1983,7 +1983,11 @@ repeat:
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
1.8.1.2

