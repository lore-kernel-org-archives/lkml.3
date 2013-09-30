Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3I3KMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3I3KMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Stefan (metze) Metzmacher" <metze@samba.org>,
        Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 035/104] cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately
Date: Mon, 30 Sep 2013 11:10:12 +0100
Message-Id: <1380535881-9239-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: added 'NULL' return ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/readdir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 6cb83b9..8ae4457 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -107,6 +107,14 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		dput(dentry);
 	}
 
+	/*
+	 * If we know that the inode will need to be revalidated immediately,
+	 * then don't create a new dentry for it. We'll end up doing an on
+	 * the wire call either way and this spares us an invalidation.
+	 */
+	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
+		return NULL;
+
 	dentry = d_alloc(parent, name);
 	if (dentry == NULL)
 		return NULL;
-- 
1.8.3.2

