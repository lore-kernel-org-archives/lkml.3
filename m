Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3HQAWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:22:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3HPWjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Stefan (metze) Metzmacher" <metze@samba.org>,
        Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 116/133] cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately
Date: Fri, 16 Aug 2013 15:34:18 -0700
Message-Id: <1376692475-28413-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 757c4f6260febff982276818bb946df89c1105aa upstream.

David reported that commit c2b93e06 (cifs: only set ops for inodes in
I_NEW state) caused a regression with mfsymlinks. Prior to that patch,
if a mfsymlink dentry was instantiated at readdir time, the inode would
get a new set of ops when it was revalidated. After that patch, this
did not occur.

This patch addresses this by simply skipping instantiating dentries in
the readdir codepath when we know that they will need to be immediately
revalidated. The next attempt to use that dentry will cause a new lookup
to occur (which is basically what we want to happen anyway).

Cc: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Sachin Prabhu <sprabhu@redhat.com>
Reported-and-Tested-by: David McBride <dwm37@cam.ac.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/readdir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index cdd6ff4..5e636a8 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -113,6 +113,14 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			return;
 	}
 
+	/*
+	 * If we know that the inode will need to be revalidated immediately,
+	 * then don't create a new dentry for it. We'll end up doing an on
+	 * the wire call either way and this spares us an invalidation.
+	 */
+	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
+		return;
+
 	dentry = d_alloc(parent, name);
 	if (!dentry)
 		return;
-- 
1.8.1.2

