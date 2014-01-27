Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaA0TJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:09:31 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48986 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaA0TJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:09:29 -0500
From: Tom Gundersen <teg@jklm.no>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, kay@vrfy.org, Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC][PATCH] module: allow multiple calls to MODULE_DEVICE_TABLE() per module
Date: Mon, 27 Jan 2014 20:09:55 +0100
Message-Id: <1390849795-2155-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
the modaliases being exposed.

This fixes the problem by including the name of the device_id table in the
__mod_*_device_table alias, allowing us to export several device_id tables
per module.

Suggested-by: Kay Sievers <kay@vrfy.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h   |  2 +-
 scripts/mod/file2alias.c | 14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 15cd6b1..7732d76 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -143,7 +143,7 @@ extern const struct gtype##_id __mod_##gtype##_table		\
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
 
 #define MODULE_DEVICE_TABLE(type,name)		\
-  MODULE_GENERIC_TABLE(type##_device,name)
+  MODULE_GENERIC_TABLE(type##__##name##_device,name)
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 2370863..6778381 100644
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
1.8.5.3

