Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935467Ab3DHJvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935415Ab3DHJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/102] NFSv4: Fix the string length returned by the idmapper
Date: Mon,  8 Apr 2013 10:49:23 +0100
Message-Id: <1365414657-29191-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit cf4ab538f1516606d3ae730dce15d6f33d96b7e1 upstream.

Functions like nfs_map_uid_to_name() and nfs_map_gid_to_group() are
expected to return a string without any terminating NUL character.
Regression introduced by commit 57e62324e469e092ecc6c94a7a86fe4bd6ac5172
(NFS: Store the legacy idmapper result in the keyring).

Reported-by: Dave Chiluk <dave.chiluk@canonical.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Bryan Schumaker <bjschuma@netapp.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/idmap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index a0972e9..e4476dc 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -710,9 +710,9 @@ out1:
 	return ret;
 }
 
-static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *data)
+static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *data, size_t datalen)
 {
-	return key_instantiate_and_link(key, data, strlen(data) + 1,
+	return key_instantiate_and_link(key, data, datalen,
 					id_resolver_cache->thread_keyring,
 					authkey);
 }
@@ -720,15 +720,18 @@ static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *dat
 static int nfs_idmap_read_message(struct idmap_msg *im, struct key *key, struct key *authkey)
 {
 	char id_str[NFS_UINT_MAXLEN];
+	size_t len;
 	int ret = -EINVAL;
 
 	switch (im->im_conv) {
 	case IDMAP_CONV_NAMETOID:
-		sprintf(id_str, "%d", im->im_id);
-		ret = nfs_idmap_instantiate(key, authkey, id_str);
+		/* Note: here we store the NUL terminator too */
+		len = sprintf(id_str, "%d", im->im_id) + 1;
+		ret = nfs_idmap_instantiate(key, authkey, id_str, len);
 		break;
 	case IDMAP_CONV_IDTONAME:
-		ret = nfs_idmap_instantiate(key, authkey, im->im_name);
+		len = strlen(im->im_name);
+		ret = nfs_idmap_instantiate(key, authkey, im->im_name, len);
 		break;
 	}
 
-- 
1.8.1.2

