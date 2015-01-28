Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbbA2DLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:11:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965075AbbA2Cgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 137/139] mnt: Fix a memory stomp in umount
Date: Wed, 28 Jan 2015 14:21:20 -0800
Message-Id: <1422483682-15393-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit c297abfdf15b4480704d6b566ca5ca9438b12456 upstream.

While reviewing the code of umount_tree I realized that when we append
to a preexisting unmounted list we do not change pprev of the former
first item in the list.

Which means later in namespace_unlock hlist_del_init(&mnt->mnt_hash) on
the former first item of the list will stomp unmounted.first leaving
it set to some random mount point which we are likely to free soon.

This isn't likely to hit, but if it does I don't know how anyone could
track it down.

[ This happened because we don't have all the same operations for
  hlist's as we do for normal doubly-linked lists. In particular,
  list_splice() is easy on our standard doubly-linked lists, while
  hlist_splice() doesn't exist and needs both start/end entries of the
  hlist.  And commit 38129a13e6e7 incorrectly open-coded that missing
  hlist_splice().

  We should think about making these kinds of "mindless" conversions
  easier to get right by adding the missing hlist helpers   - Linus ]

Fixes: 38129a13e6e71f666e0468e99fdd932a687b4d7e switch mnt_hash to hlist
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index a67e3c0..289c216 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1286,6 +1286,8 @@ void umount_tree(struct mount *mnt, int how)
 	}
 	if (last) {
 		last->mnt_hash.next = unmounted.first;
+		if (unmounted.first)
+			unmounted.first->pprev = &last->mnt_hash.next;
 		unmounted.first = tmp_list.first;
 		unmounted.first->pprev = &unmounted.first;
 	}
-- 
1.9.1

