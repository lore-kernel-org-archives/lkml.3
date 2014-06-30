Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaF3MBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:01:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52063 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/181] module: allow multiple calls to MODULE_DEVICE_TABLE() per module
Date: Mon, 30 Jun 2014 13:51:46 +0200
Message-Id: <8d7fd909f03b6d5c935bec435a278cf9c403a8c5.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 21bdd17b21b45ea48e06e23918d681afbe0622e9 upstream.

Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
the modaliases being exposed.

This fixes the problem by including the name of the device_id table in the
__mod_*_device_table alias, allowing us to export several device_id tables
per module.

Suggested-by: Kay Sievers <kay@vrfy.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Conflicts:
	include/linux/module.h
---
 include/linux/module.h   |  2 +-
 scripts/mod/file2alias.c | 14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 05f2447f8c15..54aef1b38463 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -143,7 +143,7 @@ extern const struct gtype##_id __mod_##gtype##_table		\
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
 
 #define MODULE_DEVICE_TABLE(type,name)		\
-  MODULE_GENERIC_TABLE(type##_device,name)
+  MODULE_GENERIC_TABLE(type##__##name##_device, name)
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 25e5cb0aaef6..ce164044f0cc 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -42,7 +42,7 @@ typedef unsigned char	__u8;
 
 /* This array collects all instances that use the generic do_table */
 struct devtable {
-	const char *device_id; /* name of table, __mod_<name>_device_table. */
+	const char *device_id; /* name of table, __mod_<name>__*_device_table. */
 	unsigned long id_size;
 	void *function;
 };
@@ -146,7 +146,8 @@ static void device_id_check(const char *modname, const char *device_id,
 
 	if (size % id_size || size < id_size) {
 		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
-		      "of the size of section __mod_%s_device_table=%lu.\n"
+		      "of the size of "
+		      "section __mod_%s__<identifier>_device_table=%lu.\n"
 		      "Fix definition of struct %s_device_id "
 		      "in mod_devicetable.h\n",
 		      modname, device_id, id_size, device_id, size, device_id);
@@ -1206,7 +1207,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 {
 	void *symval;
 	char *zeros = NULL;
-	const char *name;
+	const char *name, *identifier;
 	unsigned int namelen;
 
 	/* We're looking for a section relative symbol */
@@ -1217,7 +1218,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
 		return;
 
-	/* All our symbols are of form <prefix>__mod_XXX_device_table. */
+	/* All our symbols are of form <prefix>__mod_<name>__<identifier>_device_table. */
 	name = strstr(symname, "__mod_");
 	if (!name)
 		return;
@@ -1227,7 +1228,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		return;
 	if (strcmp(name + namelen - strlen("_device_table"), "_device_table"))
 		return;
-	namelen -= strlen("_device_table");
+	identifier = strstr(name, "__");
+	if (!identifier)
+		return;
+	namelen = identifier - name;
 
 	/* Handle all-NULL symbols allocated into .bss */
 	if (info->sechdrs[get_secindex(info, sym)].sh_type & SHT_NOBITS) {
-- 
2.0.0

