Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaDXW17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:27:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaDXVqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 23/33] Btrfs: check for an extent_op on the locked ref
Date: Thu, 24 Apr 2014 14:48:36 -0700
Message-Id: <20140424214452.985741037@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214449.423169713@linuxfoundation.org>
References: <20140424214449.423169713@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 573a075567f0174551e2fad2a3164afd2af788f2 upstream.

We could have possibly added an extent_op to the locked_ref while we dropped
locked_ref->lock, so check for this case as well and loop around.  Otherwise we
could lose flag updates which would lead to extent tree corruption.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2444,7 +2444,8 @@ static noinline int __btrfs_run_delayed_
 			spin_unlock(&locked_ref->lock);
 			spin_lock(&delayed_refs->lock);
 			spin_lock(&locked_ref->lock);
-			if (rb_first(&locked_ref->ref_root)) {
+			if (rb_first(&locked_ref->ref_root) ||
+			    locked_ref->extent_op) {
 				spin_unlock(&locked_ref->lock);
 				spin_unlock(&delayed_refs->lock);
 				continue;


