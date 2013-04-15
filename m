Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3DOOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:14:23 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:34633 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3DOOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:14:20 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] menuconfig: Fix memory leak introduced by jump keys feature
Date: Mon, 15 Apr 2013 10:13:50 -0400
Message-Id: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the memory leak of struct jump_key allocated in get_prompt_str()

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/list.h  |   13 +++++++++++++
 scripts/kconfig/mconf.c |    3 +++
 2 files changed, 16 insertions(+)

diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
index 0ae730b..b87206c 100644
--- a/scripts/kconfig/list.h
+++ b/scripts/kconfig/list.h
@@ -51,6 +51,19 @@ struct list_head {
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+		n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);					\
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
  * list_empty - tests whether a list is empty
  * @head: the list to test.
  */
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 566288a..c5418d6 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -389,6 +389,7 @@ again:
 			.targets = targets,
 			.keys = keys,
 		};
+		struct jump_key *pos, *tmp;
 
 		res = get_relations_str(sym_arr, &head);
 		dres = show_textbox_ext(_("Search Results"), (char *)
@@ -402,6 +403,8 @@ again:
 				again = true;
 			}
 		str_free(&res);
+		list_for_each_entry_safe(pos, tmp, &head, entries)
+			free(pos);
 	} while (again);
 	free(sym_arr);
 	str_free(&title);
-- 
1.7.10.4

