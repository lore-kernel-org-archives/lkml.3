Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965595AbaCSQEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:04:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46021 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:04:42 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: penberg@iki.fi
Cc: mingo@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kvm tools: treat uids and gids in stat structure properly
Date: Wed, 19 Mar 2014 12:04:18 -0400
Message-Id: <1395245058-11154-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit "9p: Modify the stat structures to use kuid_t and kgid_t"
has modified the type of uid and gid in the stat structure, which breaks
build for us.

This is a rather trivial conversion from u32 to kuid_t and kgid_t.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/kvm/virtio/9p-pdu.c |    4 +++-
 tools/kvm/virtio/9p.c     |   11 ++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/kvm/virtio/9p-pdu.c b/tools/kvm/virtio/9p-pdu.c
index 9e95f3b..cc2e871 100644
--- a/tools/kvm/virtio/9p-pdu.c
+++ b/tools/kvm/virtio/9p-pdu.c
@@ -129,7 +129,9 @@ static int virtio_p9_decode(struct p9_pdu *pdu, const char *fmt, va_list ap)
 		{
 			struct p9_wstat *stbuf = va_arg(ap, struct p9_wstat *);
 			memset(stbuf, 0, sizeof(struct p9_wstat));
-			stbuf->n_uid = stbuf->n_gid = stbuf->n_muid = -1;
+			stbuf->n_uid = KUIDT_INIT(-1);
+			stbuf->n_gid = KGIDT_INIT(-1);
+			stbuf->n_muid = KUIDT_INIT(-1);
 			retval = virtio_p9_pdu_readf(pdu, "wwdQdddqssss",
 						&stbuf->size, &stbuf->type,
 						&stbuf->dev, &stbuf->qid,
diff --git a/tools/kvm/virtio/9p.c b/tools/kvm/virtio/9p.c
index 25cdd8c..847eddb 100644
--- a/tools/kvm/virtio/9p.c
+++ b/tools/kvm/virtio/9p.c
@@ -441,8 +441,8 @@ static void virtio_p9_fill_stat(struct p9_dev *p9dev,
 	memset(statl, 0, sizeof(*statl));
 	statl->st_mode		= st->st_mode;
 	statl->st_nlink		= st->st_nlink;
-	statl->st_uid		= st->st_uid;
-	statl->st_gid		= st->st_gid;
+	statl->st_uid		= KUIDT_INIT(st->st_uid);
+	statl->st_gid		= KGIDT_INIT(st->st_gid);
 	statl->st_rdev		= st->st_rdev;
 	statl->st_size		= st->st_size;
 	statl->st_blksize	= st->st_blksize;
@@ -668,12 +668,13 @@ static void virtio_p9_setattr(struct p9_dev *p9dev,
 	    ((p9attr.valid & ATTR_CTIME)
 	     && !((p9attr.valid & ATTR_MASK) & ~ATTR_CTIME))) {
 		if (!(p9attr.valid & ATTR_UID))
-			p9attr.uid = -1;
+			p9attr.uid = KUIDT_INIT(-1);
 
 		if (!(p9attr.valid & ATTR_GID))
-			p9attr.gid = -1;
+			p9attr.gid = KGIDT_INIT(-1);
 
-		ret = lchown(fid->abs_path, p9attr.uid, p9attr.gid);
+		ret = lchown(fid->abs_path, __kuid_val(p9attr.uid),
+				__kgid_val(p9attr.gid));
 		if (ret < 0)
 			goto err_out;
 	}
-- 
1.7.2.5

