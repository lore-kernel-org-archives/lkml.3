Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab3JKTos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:44:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3JKTmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 129/135] Btrfs: remove ourselves from the cluster list under lock
Date: Fri, 11 Oct 2013 12:40:10 -0700
Message-Id: <20131011193959.290585404@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit b8d0c69b9469ffd33df30fee3e990f2d4aa68a09 upstream.

A user was reporting weird warnings from btrfs_put_delayed_ref() and I noticed
that we were doing this list_del_init() on our head ref outside of
delayed_refs->lock.  This is a problem if we have people still on the list, we
could end up modifying old pointers and such.  Fix this by removing us from the
list before we do our run_delayed_ref on our head ref.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2403,6 +2403,8 @@ static noinline int run_clustered_refs(s
 			default:
 				WARN_ON(1);
 			}
+		} else {
+			list_del_init(&locked_ref->cluster);
 		}
 		spin_unlock(&delayed_refs->lock);
 
@@ -2425,7 +2427,6 @@ static noinline int run_clustered_refs(s
 		 * list before we release it.
 		 */
 		if (btrfs_delayed_ref_is_head(ref)) {
-			list_del_init(&locked_ref->cluster);
 			btrfs_delayed_ref_unlock(locked_ref);
 			locked_ref = NULL;
 		}


