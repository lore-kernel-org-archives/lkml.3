Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3HMGok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:44:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab3HMGdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [ 49/60] cifs: dont instantiate new dentries in readdir for inodes that need to be revalidated immediately
Date: Mon, 12 Aug 2013 23:34:16 -0700
Message-Id: <20130813063338.280568949@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

Reported-and-Tested-by: David McBride <dwm37@cam.ac.uk>
Cc: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/readdir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -111,6 +111,14 @@ cifs_prime_dcache(struct dentry *parent,
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


