Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab3FLRaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:30:03 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:39943 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3FLRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:30:00 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] module: don't modify argument of module_kallsyms_lookup_name()
Date: Wed, 12 Jun 2013 19:29:41 +0200
Message-Id: <1371058181-23788-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass a pointer to a const string of the form "module:symbol"
module_kallsyms_lookup_name() will try to split the string at the colon,
i.e., will try to modify r/o data. That will, in fact, fail on a kernel
with enabled CONFIG_DEBUG_RODATA.

Avoid modifying the string passed as argument and operate on a copy
instead in case we need to split the string.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 kernel/module.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index cab4bce..5ce0784 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3557,16 +3557,17 @@ static unsigned long mod_find_symname(struct module *mod, const char *name)
 unsigned long module_kallsyms_lookup_name(const char *name)
 {
 	struct module *mod;
-	char *colon;
+	char *colon, *mod_name;
 	unsigned long ret = 0;
 
 	/* Don't lock: we're in enough trouble already. */
 	preempt_disable();
 	if ((colon = strchr(name, ':')) != NULL) {
-		*colon = '\0';
-		if ((mod = find_module(name)) != NULL)
+		mod_name = kstrndup(name, colon - name, GFP_ATOMIC);
+		if (mod_name && (mod = find_module(mod_name)) != NULL) {
 			ret = mod_find_symname(mod, colon+1);
-		*colon = ':';
+			kfree(mod_name);
+		}
 	} else {
 		list_for_each_entry_rcu(mod, &modules, list) {
 			if (mod->state == MODULE_STATE_UNFORMED)
-- 
1.7.10.4

