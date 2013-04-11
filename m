Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435Ab3DKVF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:05:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935722Ab3DKUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:15 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qM-UFpwvO98A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SjTHzbZEtv8A:10 a=JDjsHSkAAAAA:8 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=fl-NfxdDmfoU_9gv9iwA:9 a=Hf6muOzgCGQA:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202602.819728198@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Chiluk <dave.chiluk@canonical.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: [ 102/171 ] NFSv4: Fix the string length returned by the idmapper
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0102-NFSv4-Fix-the-string-length-returned-by-the-idmapper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit cf4ab538f1516606d3ae730dce15d6f33d96b7e1 ]

Functions like nfs_map_uid_to_name() and nfs_map_gid_to_group() are
expected to return a string without any terminating NUL character.
Regression introduced by commit 57e62324e469e092ecc6c94a7a86fe4bd6ac5172
(NFS: Store the legacy idmapper result in the keyring).

Reported-by: Dave Chiluk <dave.chiluk@canonical.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: stable@vger.kernel.org [>=3.4]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfs/idmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index a850079..e720df5 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -707,9 +707,9 @@ out1:
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
@@ -717,15 +717,18 @@ static int nfs_idmap_instantiate(struct key *key, struct key *authkey, char *dat
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
1.7.10.4


