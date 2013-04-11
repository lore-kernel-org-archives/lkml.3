Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765431Ab3DKDQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:16:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:22616 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3DKDP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:15:59 -0400
X-Spam-Score: -100.8
Message-ID: <51662AC7.1090004@asianux.com>
Date: Thu, 11 Apr 2013 11:15:19 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: kallsyms: memory override issue, need check destination
 buffer length
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  We don't export any symbols > 128 characters, but if we did then
  kallsyms_expand_symbol() would overflow the buffer handed to it.
  So we need check destination buffer length when copying.

  the related test:
    if we define an EXPORT function which name more than 128.
    will panic when call kallsyms_lookup_name by init_kprobes on booting.
    after check the length (provide this patch), it is ok.

  Implementaion:
    add additional destination buffer length parameter (maxlen)
    if uncompressed string is too long (>= maxlen), it will be truncated.
    not check the parameters whether valid, since it is a static function.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/kallsyms.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 2169fee..ae7b90d 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -84,12 +84,15 @@ static int is_ksym_addr(unsigned long addr)
  /*
  * Expand a compressed symbol data into the resulting uncompressed string,
+ * if uncompressed string is too long (>= maxlen), it will be truncated,
  * given the offset to where the symbol is in the compressed stream.
  */
-static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
+static unsigned int kallsyms_expand_symbol(unsigned int off,
+					   char *result, int maxlen)
 {
 	int len, skipped_first = 0;
 	const u8 *tptr, *data;
+	char *begin = result;
  	/* Get the compressed symbol length from the first symbol byte. */
 	data = &kallsyms_names[off];
@@ -113,14 +116,16 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
  		while (*tptr) {
 			if (skipped_first) {
-				*result = *tptr;
-				result++;
+				*result++ = *tptr;
+				if (result - begin == maxlen - 1)
+					goto tail;
 			} else
 				skipped_first = 1;
 			tptr++;
 		}
 	}
 +tail:
 	*result = '\0';
  	/* Return to offset to the next symbol. */
@@ -176,7 +181,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	unsigned int off;
  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
-		off = kallsyms_expand_symbol(off, namebuf);
+		off = kallsyms_expand_symbol(off, namebuf, sizeof(namebuf));
  		if (strcmp(namebuf, name) == 0)
 			return kallsyms_addresses[i];
@@ -195,7 +200,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	int ret;
  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
-		off = kallsyms_expand_symbol(off, namebuf);
+		off = kallsyms_expand_symbol(off, namebuf, sizeof(namebuf));
 		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
 		if (ret != 0)
 			return ret;
@@ -294,7 +299,8 @@ const char *kallsyms_lookup(unsigned long addr,
  		pos = get_symbol_pos(addr, symbolsize, offset);
 		/* Grab name */
-		kallsyms_expand_symbol(get_symbol_offset(pos), namebuf);
+		kallsyms_expand_symbol(get_symbol_offset(pos),
+				       namebuf, sizeof(namebuf));
 		if (modname)
 			*modname = NULL;
 		return namebuf;
@@ -315,7 +321,8 @@ int lookup_symbol_name(unsigned long addr, char *symname)
  		pos = get_symbol_pos(addr, NULL, NULL);
 		/* Grab name */
-		kallsyms_expand_symbol(get_symbol_offset(pos), symname);
+		kallsyms_expand_symbol(get_symbol_offset(pos),
+				       symname, sizeof(symname));
 		return 0;
 	}
 	/* See if it's in a module. */
@@ -333,7 +340,8 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
  		pos = get_symbol_pos(addr, size, offset);
 		/* Grab name */
-		kallsyms_expand_symbol(get_symbol_offset(pos), name);
+		kallsyms_expand_symbol(get_symbol_offset(pos),
+				       name, sizeof(name));
 		modname[0] = '\0';
 		return 0;
 	}
@@ -463,7 +471,7 @@ static unsigned long get_ksymbol_core(struct kallsym_iter *iter)
  	iter->type = kallsyms_get_symbol_type(off);
 -	off = kallsyms_expand_symbol(off, iter->name);
+	off = kallsyms_expand_symbol(off, iter->name, sizeof(iter->name));
  	return off - iter->nameoff;
 }
-- 
1.7.7.6
