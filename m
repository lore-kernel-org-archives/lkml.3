Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbbAYSjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:39:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbbAYSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linda Walsh <suse@tlinx.org>, NeilBrown <neilb@suse.de>,
        Jeff Layton <jlayton@primarydata.com>
Subject: [PATCH 3.18 114/183] locks: fix NULL-deref in generic_delete_lease
Date: Sun, 25 Jan 2015 10:07:16 -0800
Message-Id: <20150125180815.150914668@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 52d304eb4eaced9ad04b64ba7cd6ceb5153bbf18 upstream.

commit 0efaa7e82f02fe69c05ad28e905f31fc86e6f08e
  locks: generic_delete_lease doesn't need a file_lock at all

moves the call to fl->fl_lmops->lm_change() to a place in the
code where fl might be a non-lease lock.
When that happens, fl_lmops is NULL and an Oops ensures.

So add an extra test to restore correct functioning.

Reported-by: Linda Walsh <suse@tlinx.org>
Link: https://bugzilla.suse.com/show_bug.cgi?id=912569
Fixes: 0efaa7e82f02fe69c05ad28e905f31fc86e6f08e
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1702,7 +1702,7 @@ static int generic_delete_lease(struct f
 			break;
 	}
 	trace_generic_delete_lease(inode, fl);
-	if (fl)
+	if (fl && IS_LEASE(fl))
 		error = fl->fl_lmops->lm_change(before, F_UNLCK, &dispose);
 	spin_unlock(&inode->i_lock);
 	locks_dispose_list(&dispose);


