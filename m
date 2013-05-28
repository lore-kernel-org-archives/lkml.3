Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3E1Vnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:43:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab3E1VVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Poirier <bpoirier@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 06/78] menuconfig: Fix memory leak introduced by jump keys feature
Date: Tue, 28 May 2013 14:19:15 -0700
Message-Id: <1369776027-17859-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@suse.de>

commit edb749f4390b3c1604233dc7c4fb0361f472e712 upstream.

Fixes the memory leak of struct jump_key allocated in get_prompt_str()

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 scripts/kconfig/list.h  | 13 +++++++++++++
 scripts/kconfig/mconf.c |  3 +++
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
index 53975cf..07afe0b 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -383,6 +383,7 @@ again:
 			.targets = targets,
 			.keys = keys,
 		};
+		struct jump_key *pos, *tmp;
 
 		res = get_relations_str(sym_arr, &head);
 		dres = show_textbox_ext(_("Search Results"), (char *)
@@ -396,6 +397,8 @@ again:
 				again = true;
 			}
 		str_free(&res);
+		list_for_each_entry_safe(pos, tmp, &head, entries)
+			free(pos);
 	} while (again);
 	free(sym_arr);
 }
-- 
1.8.1.2

