Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaCHBS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:18:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaCHBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 58/99] cifs: dont instantiate new dentries in readdir for inodes that need to be revalidated immediately
Date: Fri,  7 Mar 2014 17:07:54 -0800
Message-Id: <20140308010613.461603336@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/readdir.c |    8 ++++++++
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


