Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3ETKyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:54:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ETKyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 099/115] ext4: limit group search loop for non-extent files
Date: Mon, 20 May 2013 11:51:39 +0100
Message-Id: <1369047116-9378-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/mballoc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9777e2f..4986dd3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1980,7 +1980,11 @@ repeat:
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

