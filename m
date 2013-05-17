Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3EQV5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:57:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab3EQVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lachlan McIlroy <lmcilroy@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 10/33] ext4: limit group search loop for non-extent files
Date: Fri, 17 May 2013 14:49:54 -0700
Message-Id: <20130517214917.953753833@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/ext4/mballoc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2026,7 +2026,11 @@ repeat:
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


