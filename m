Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab3IHDTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab3IHDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steve French" <smfrench@gmail.com>,
        "Sachin Prabhu" <sprabhu@redhat.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        "Jeff Layton" <jlayton@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.833065181@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [059/121] cifs: don't instantiate new dentries in readdir for
 inodes that need to be revalidated immediately
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: need to return NULL]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/readdir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -96,6 +96,14 @@ cifs_readdir_lookup(struct dentry *paren
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

