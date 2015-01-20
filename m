Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbATP0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbbATP0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:26:30 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] livepatch: enforce patch stacking semantics
Date: Tue, 20 Jan 2015 09:26:18 -0600
Message-Id: <639bc445741cfed3aa49753c7155e47fa16f222f.1421767360.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1421767360.git.jpoimboe@redhat.com>
References: <cover.1421767360.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only allow the topmost patch on the stack to be enabled or disabled, so
that patches can't be removed or added in an arbitrary order.

Suggested-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3d9c00b..2401e7f 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -379,6 +379,11 @@ static int __klp_disable_patch(struct klp_patch *patch)
 	struct klp_object *obj;
 	int ret;
 
+	/* enforce stacking: only the last enabled patch can be disabled */
+	if (!list_is_last(&patch->list, &klp_patches) &&
+	    list_next_entry(patch, list)->state == KLP_ENABLED)
+		return -EBUSY;
+
 	pr_notice("disabling patch '%s'\n", patch->mod->name);
 
 	for (obj = patch->objs; obj->funcs; obj++) {
@@ -435,6 +440,11 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	if (WARN_ON(patch->state != KLP_DISABLED))
 		return -EINVAL;
 
+	/* enforce stacking: only the first disabled patch can be enabled */
+	if (patch->list.prev != &klp_patches &&
+	    list_prev_entry(patch, list)->state == KLP_DISABLED)
+		return -EBUSY;
+
 	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
 	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
 
-- 
2.1.0

