Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab3DBXOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:14:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab3DBWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chiluk <dave.chiluk@canonical.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: [ 037/124] NFSv4: Fix the string length returned by the idmapper
Date: Tue,  2 Apr 2013 15:10:19 -0700
Message-Id: <20130402221108.508665117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/idmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -725,9 +725,9 @@ out1:
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
@@ -737,6 +737,7 @@ static int nfs_idmap_read_and_verify_mes
 		struct key *key, struct key *authkey)
 {
 	char id_str[NFS_UINT_MAXLEN];
+	size_t len;
 	int ret = -ENOKEY;
 
 	/* ret = -ENOKEY */
@@ -746,13 +747,15 @@ static int nfs_idmap_read_and_verify_mes
 	case IDMAP_CONV_NAMETOID:
 		if (strcmp(upcall->im_name, im->im_name) != 0)
 			break;
-		sprintf(id_str, "%d", im->im_id);
-		ret = nfs_idmap_instantiate(key, authkey, id_str);
+		/* Note: here we store the NUL terminator too */
+		len = sprintf(id_str, "%d", im->im_id) + 1;
+		ret = nfs_idmap_instantiate(key, authkey, id_str, len);
 		break;
 	case IDMAP_CONV_IDTONAME:
 		if (upcall->im_id != im->im_id)
 			break;
-		ret = nfs_idmap_instantiate(key, authkey, im->im_name);
+		len = strlen(im->im_name);
+		ret = nfs_idmap_instantiate(key, authkey, im->im_name, len);
 		break;
 	default:
 		ret = -EINVAL;


