Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3LZOa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:30:59 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:56481 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3LZOav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:30:51 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Milosz Tanski <milosz@adfin.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
        Min Chen <minchen@ubuntukylin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 3/3] Ceph fscache: Wait for completion of object initialization
Date: Thu, 26 Dec 2013 06:29:28 -0800
Message-Id: <c2d6ad79005983f3834fbe5b8e241281f74296fe.1388066937.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1388066937.git.liwang@ubuntukylin.com>
References: <cover.1388066937.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1388066937.git.liwang@ubuntukylin.com>
References: <cover.1388066937.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU9MVUhKSUJCTkJKS01PT05IV1kJDhceCFlBWS
	grPSQoND0vPToyNyQyNSQzPjo*PilBTVVKSEJANiMkIj4oJDI1JDM#Oj8#KUFLVUhPSUArLykkNT
	QkMjUkMz46Pz4pQUlVQ05DQDg0LjUvKSIkODVBS1VJTUNAKT48MjQ1JDooMjpBSFVPT01AKyk0LT
	I1OD4kMy41OjVBQlVCSk5APyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VMQ0JAPzAyNiQ1NDU#QU
	tVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBTFVLS0NANi43LzIkKTgrLyQ*Mj09Pik#NS8kMj
	UkMz46Pz4pQU9VS0tJQDIrJC80PzoiJDg1LyRLJEpLS0FLVUxKTUAyKyRKJDM0LikkODUvJEskSk
	tLQUtVS0AyKyRKJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQD
	IrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtANTQvJD06NjQuKCQ*NDY6MjUkKCs9JD06MjdBSktVS0
	AoLjkkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0pBS1VJQ1kG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	S01DSU9NSk1CVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlNSU03V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>

The object store limit needs to be updated after writing,
and this can be done provided the corresponding object has already
been initialized. Current object initialization is done asynchrously,
which introduce a race if a file is opened, then immediately followed
by a writing, the initialization may have not completed, the code will
reach the ASSERT in fscache_submit_exclusive_op() to cause kernel
bug.

Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Signed-off-by: Min Chen <minchen@ubuntukylin.com>
Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/cache.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 8c44fdd..834f9f3 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -205,6 +205,7 @@ void ceph_fscache_register_inode_cookie(struct ceph_fs_client* fsc,
 	ci->fscache = fscache_acquire_cookie(fsc->fscache,
 					     &ceph_fscache_inode_object_def,
 					     ci, true);
+	fscache_check_consistency(ci->fscache);
 done:
 	mutex_unlock(&inode->i_mutex);
 
-- 
1.7.9.5

