Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaIPVhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbaIPVhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:37:52 -0400
Date: Tue, 16 Sep 2014 17:37:18 -0400
From: Kyle McMartin <kyle@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, rusty@rustcorp.com.au
Subject: [PATCH] aarch64: filter $x from kallsyms
Message-ID: <20140916213718.GR22012@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to ARM, AArch64 is generating $x and $d syms... which isn't
terribly helpful when looking at %pF output and the like. Filter those
out in kallsyms, modpost and when looking at module symbols.

Seems simplest since none of these check EM_ARM anyway, to just add it
to the strchr used, rather than trying to make things overly
complicated.

initcall_debug improves:
dmesg_before.txt: initcall $x+0x0/0x154 [sg] returned 0 after 26331 usecs
dmesg_after.txt: initcall init_sg+0x0/0x154 [sg] returned 0 after 15461 usecs

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3388,7 +3388,7 @@ static inline int is_arm_mapping_symbol(const char *str)
 {
 	if (str[0] == '.' && str[1] == 'L')
 		return true;
-	return str[0] == '$' && strchr("atd", str[1])
+	return str[0] == '$' && strchr("axtd", str[1])
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -84,7 +84,7 @@ static void usage(void)
  */
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("atd", str[1])
+	return str[0] == '$' && strchr("axtd", str[1])
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1146,7 +1146,7 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf64_Sword addr,
 
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("atd", str[1])
+	return str[0] == '$' && strchr("axtd", str[1])
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
