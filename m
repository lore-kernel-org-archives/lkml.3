Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaHYKZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:25:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55116 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaHYKZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:25:34 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/2] modpost: reduce visibility of symbols and constify r/o arrays
Date: Mon, 25 Aug 2014 12:25:15 +0200
Message-Id: <1408962316-19921-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408962316-19921-1-git-send-email-minipli@googlemail.com>
References: <1408962316-19921-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Internally used symbols of modpost don't need to be externally visible;
make them static. Also constify the string arrays so they resist in the
r/o section instead of being runtime writable.

Those changes lead to a small size reduction as can be seen below:

   text    data     bss     dec     hex filename
  51381    2640   12416   66437   10385 scripts/mod/modpost.old
  51765    2224   12416   66405   10365 scripts/mod/modpost.new

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
...checkpatch warnings grossly ignored to comply to the coding style of
modpost.c

 scripts/mod/modpost.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 091d90573b..c2ebdc788f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -24,9 +24,9 @@
 #include "../../include/linux/export.h"
 
 /* Are we using CONFIG_MODVERSIONS? */
-int modversions = 0;
+static int modversions = 0;
 /* Warn about undefined symbols? (do so if we have vmlinux) */
-int have_vmlinux = 0;
+static int have_vmlinux = 0;
 /* Is CONFIG_MODULE_SRCVERSION_ALL set? */
 static int all_versions = 0;
 /* If we are modposting external module set to 1 */
@@ -229,7 +229,7 @@ static struct symbol *find_symbol(const char *name)
 	return NULL;
 }
 
-static struct {
+static const struct {
 	const char *str;
 	enum export export;
 } export_list[] = {
@@ -805,7 +805,7 @@ static int match(const char *sym, const char * const pat[])
 }
 
 /* sections that we do not want to do full section mismatch check on */
-static const char *section_white_list[] =
+static const char *const section_white_list[] =
 {
 	".comment*",
 	".debug*",
@@ -882,17 +882,18 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define MEM_EXIT_SECTIONS  ".memexit.*"
 
 /* init data sections */
-static const char *init_data_sections[] = { ALL_INIT_DATA_SECTIONS, NULL };
+static const char *const init_data_sections[] =
+	{ ALL_INIT_DATA_SECTIONS, NULL };
 
 /* all init sections */
-static const char *init_sections[] = { ALL_INIT_SECTIONS, NULL };
+static const char *const init_sections[] = { ALL_INIT_SECTIONS, NULL };
 
 /* All init and exit sections (code + data) */
-static const char *init_exit_sections[] =
+static const char *const init_exit_sections[] =
 	{ALL_INIT_SECTIONS, ALL_EXIT_SECTIONS, NULL };
 
 /* data section */
-static const char *data_sections[] = { DATA_SECTIONS, NULL };
+static const char *const data_sections[] = { DATA_SECTIONS, NULL };
 
 
 /* symbols in .data that may refer to init/exit sections */
@@ -906,8 +907,8 @@ static const char *data_sections[] = { DATA_SECTIONS, NULL };
 	"*_probe_one",							\
 	"*_console"
 
-static const char *head_sections[] = { ".head.text*", NULL };
-static const char *linker_symbols[] =
+static const char *const head_sections[] = { ".head.text*", NULL };
+static const char *const linker_symbols[] =
 	{ "__init_begin", "_sinittext", "_einittext", NULL };
 
 enum mismatch {
@@ -929,7 +930,7 @@ struct sectioncheck {
 	const char *symbol_white_list[20];
 };
 
-const struct sectioncheck sectioncheck[] = {
+static const struct sectioncheck sectioncheck[] = {
 /* Do not reference init/exit code/data from
  * normal code and data
  */
-- 
1.7.10.4

