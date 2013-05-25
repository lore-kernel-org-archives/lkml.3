Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3EYIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 04:09:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3EYIJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 04:09:55 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au
Subject: [PATCH] modules: insert mods sorted
Date: Sat, 25 May 2013 10:09:46 +0200
Message-Id: <1369469386-3215-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While there isn't a big difference between typing 'lsmod' and
'lsmod | sort', the module listing in Oopses isn't so easily sorted.
Attempting to search these quickly by eye for particular modules while
rapidly triaging bugs can be a pain. Sort the list and reduce the pain.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 kernel/module.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index cab4bce49c23d..7914d8ef2e09c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3146,7 +3146,7 @@ static int may_init_module(void)
 static int add_unformed_module(struct module *mod)
 {
 	int err;
-	struct module *old;
+	struct module *old, *m;
 
 	mod->state = MODULE_STATE_UNFORMED;
 
@@ -3166,7 +3166,13 @@ again:
 		err = -EEXIST;
 		goto out;
 	}
-	list_add_rcu(&mod->list, &modules);
+	if (!list_empty(&modules)) {
+		list_for_each_entry(m, &modules, list)
+			if (strcmp(mod->name, m->name) < 0)
+				break;
+		list_add_tail_rcu(&mod->list, &m->list);
+	} else
+		list_add_rcu(&mod->list, &modules);
 	err = 0;
 
 out:
-- 
1.8.1.4

