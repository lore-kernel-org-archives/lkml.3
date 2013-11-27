Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab3K0Bhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:37:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab3K0A6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michael Marineau <michael.marineau@coreos.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 3.12 001/116] prepend_path() needs to reinitialize dentry/vfsmount/mnt on restarts
Date: Tue, 26 Nov 2013 16:56:14 -0800
Message-Id: <20131127005737.019716878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit ede4cebce16f5643c61aedd6d88d9070a1d23a68 upstream.

... and equivalent is needed in 3.12; it's broken there as well

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Michael Marineau <michael.marineau@coreos.com>
Tested-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2881,9 +2881,9 @@ static int prepend_path(const struct pat
 			const struct path *root,
 			char **buffer, int *buflen)
 {
-	struct dentry *dentry = path->dentry;
-	struct vfsmount *vfsmnt = path->mnt;
-	struct mount *mnt = real_mount(vfsmnt);
+	struct dentry *dentry;
+	struct vfsmount *vfsmnt;
+	struct mount *mnt;
 	int error = 0;
 	unsigned seq = 0;
 	char *bptr;
@@ -2893,6 +2893,9 @@ static int prepend_path(const struct pat
 restart:
 	bptr = *buffer;
 	blen = *buflen;
+	dentry = path->dentry;
+	vfsmnt = path->mnt;
+	mnt = real_mount(vfsmnt);
 	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;


