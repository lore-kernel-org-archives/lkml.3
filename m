Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3FDWn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:28 -0400
Received: from 1wt.eu ([62.212.114.60]:35681 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab3FDWnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:12 -0400
Message-Id: <20130604172135.654491516@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 129/184] ext4: limit group search loop for non-extent files
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/mballoc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c7e8bdb..cecf2a5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2070,7 +2070,11 @@ repeat:
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
1.7.12.2.21.g234cd45.dirty



