Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaHMLej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:34:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42247 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaHMLeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:34:36 -0400
X-AuditID: cbfee61a-f79e46d00000134f-e3-53eb4d3ffcd4
From: shivnandan.k@samsung.com
To: sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org,
        selinux@tycho.nsa.gov
Cc: cpgs@samsung.com, shivnandan.k@samsung.com, ashish.kalra@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        shiv.jnumca08@gmail.com, linux-kernel@vger.kernel.org,
        vidushi.koul@samsung.com, narendra.m1@samsung.com
Subject: [PATCH] Security: List corruption occured during file system
 automation test
Date: Wed, 13 Aug 2014 17:04:13 +0530
Message-id: <1407929653-27228-1-git-send-email-shivnandan.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jAV1739fBBg/mS1jcn/aN3eLlIU2L
	zodnmS36HgdZXN41h81iwty/zBZLz59htvg8fy2rxeHdi5ktJj85xGJxesMhdotdbesYLf5e
	vMTmwOuxc9Zddo+PT2+xeJz9GuXRt2UVo8fW6f9ZPT5vkgtgi+KySUnNySxLLdK3S+DK6P2y
	lrFgB1fFpsUXmBoY93N0MXJySAiYSCzr+cMEYYtJXLi3nq2LkYtDSGARo8TzbadYIJyfjBL7
	5x9lBqliE5CTmLfyHSuILSKQIHHx4HxWkCJmgeeMEpNutQGN4uAQFgiXeDqbBaSGRUBVYuXt
	q2A2r4CHxMofMxlBSiQEFCTmTLKZwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	kD2T2sG4ssHiEKMAB6MSD28F76tgIdbEsuLK3EOMEhzMSiK8h21eBwvxpiRWVqUW5ccXleak
	Fh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgDMqZdDJrRY/A+0OSUrNspkfazjS4
	nrn3Q7Zl5O7NFpcmr1pr1r/mss9qwdNf2vUkHLf766/6ovq3xtRu2uYtiZHz7QTct+uWnVgo
	m7wsMm9G6cecps9Mfct+V8yWK2ba/Fili2W797bkxhUxPx7sYg4/8CdZ2Ngi2vAGQ5jnwopq
	XqZb/XF9SizFGYmGWsxFxYkAJBn66C4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shivnandan Kumar <shivnandan.k@samsung.com>

List element was freed by  inode_free_security and then it uses rcu
element to point inode_free_rcu, since it inside a union so it
shares memory, sb_finish_set_opts now also try to free list element,
but since it is overriden by rcu element , it found list is corrupted
which leads to kernel panic, We have removed union element so now
memory is not shared by list and rcu element

Signed-off-by: Shivnandan Kumar <shivnandan.k@samsung.com>
---
 selinux/include/objsec.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/selinux/include/objsec.h b/selinux/include/objsec.h
index 7b1830b..2ba21ca 100644
--- a/selinux/include/objsec.h
+++ b/selinux/include/objsec.h
@@ -38,10 +38,8 @@ struct task_security_struct {
 
 struct inode_security_struct {
 	struct inode *inode;	/* back pointer to inode object */
-	union {
-		struct list_head list;	/* list of inode_security_struct */
-		struct rcu_head rcu;	/* for freeing the inode_security_struct */
-	};
+	struct list_head list;	/* list of inode_security_struct */
+	struct rcu_head rcu;	/* for freeing the inode_security_struct */
 	u32 task_sid;		/* SID of creating task */
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */
-- 
1.7.9.5

