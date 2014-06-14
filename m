Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaFNQTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:19:25 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43855 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaFNQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:19:09 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>
Cc: selinux@tycho.nsa.gov, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] selinux: fix a possible memory leak in cond_read_node()
Date: Sun, 15 Jun 2014 01:19:02 +0900
Message-Id: <1402762742-2808-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402762742-2808-1-git-send-email-namhyung@kernel.org>
References: <1402762742-2808-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cond_read_node() should free the given node on error path as it's
not linked to p->cond_list yet.  This is done via cond_node_destroy()
but it's not called when next_entry() fails before the expr loop.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 security/selinux/ss/conditional.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index 4766a38fae9a..470d5cca8d14 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -404,7 +404,7 @@ static int cond_read_node(struct policydb *p, struct cond_node *node, void *fp)
 
 	rc = next_entry(buf, fp, sizeof(buf));
 	if (rc)
-		return rc;
+		goto err;
 
 	node->cur_state = le32_to_cpu(buf[0]);
 
-- 
2.0.0

