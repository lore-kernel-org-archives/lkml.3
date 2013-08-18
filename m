Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3HRUd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3HRUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Rostedt <rostedt@goodmis.org>, Chris Zankel <chris@zankel.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 30/34] xtensa: replace xtensa-specific _f{data,text} by _s{data,text}
Date: Sun, 18 Aug 2013 13:34:43 -0700
Message-Id: <20130818203301.742116883@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 5e7b6ed8e9bf3c8e3bb579fd0aec64f6526f8c81 upstream.

commit a2d063ac216c161 ("extable, core_kernel_data(): Make sure all archs
define _sdata") missed xtensa.  Xtensa does have a start of data marker,
but calls it _fdata, causing

    kernel/built-in.o:(.text+0x964): undefined reference to `_sdata'

_stext was already defined, but it was duplicated by _fdata.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/vmlinux.lds.S |    3 +--
 arch/xtensa/mm/init.c            |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -83,7 +83,6 @@ SECTIONS
 
   _text = .;
   _stext = .;
-  _ftext = .;
 
   .text :
   {
@@ -112,7 +111,7 @@ SECTIONS
   EXCEPTION_TABLE(16)
   /* Data section */
 
-  _fdata = .;
+  _sdata = .;
   RW_DATA_SECTION(XCHAL_ICACHE_LINESIZE, PAGE_SIZE, THREAD_SIZE)
   _edata = .;
 
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -29,7 +29,7 @@
 
 /* References to section boundaries */
 
-extern char _ftext, _etext, _fdata, _edata, _rodata_end;
+extern char _stext, _etext, _sdata, _edata, _rodata_end;
 extern char __init_begin, __init_end;
 
 /*
@@ -197,8 +197,8 @@ void __init mem_init(void)
 			reservedpages++;
 	}
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_ftext;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_fdata;
+	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
+	datasize =  (unsigned long) &_edata - (unsigned long) &_sdata;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "


