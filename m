Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbbAGCXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:23:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbbAGCSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 41/73] mnt: Fix a memory stomp in umount
Date: Tue,  6 Jan 2015 18:16:02 -0800
Message-Id: <20150107021558.767860836@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1286,6 +1286,8 @@ void umount_tree(struct mount *mnt, int
 	}
 	if (last) {
 		last->mnt_hash.next = unmounted.first;
+		if (unmounted.first)
+			unmounted.first->pprev = &last->mnt_hash.next;
 		unmounted.first = tmp_list.first;
 		unmounted.first->pprev = &unmounted.first;
 	}


