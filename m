Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3HFVlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:41:37 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58983 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HFVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:41:36 -0400
From: Doug Anderson <dianders@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olof@lixom.net>, Mike Frysinger <vapier@gentoo.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Add ".text.unlikely" and ".text.hot" to arm unwind tables
Date: Tue,  6 Aug 2013 14:41:15 -0700
Message-Id: <1375825275-21962-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that gcc may put some code in ".text.unlikely" or
".text.hot" sections.  Right now those aren't accounted for in unwind
tables.  Add them.

I found some docs about this at:
  http://gcc.gnu.org/onlinedocs/gcc-4.6.2/gcc.pdf

Without this, if you have slub_debug turned on, you can get messages
that look like this:
  unwind: Index not found 7f008c50

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/include/asm/module.h | 2 ++
 arch/arm/kernel/module.c      | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 0d3a28d..ed690c4 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -12,6 +12,8 @@ enum {
 	ARM_SEC_CORE,
 	ARM_SEC_EXIT,
 	ARM_SEC_DEVEXIT,
+	ARM_SEC_HOT,
+	ARM_SEC_UNLIKELY,
 	ARM_SEC_MAX,
 };
 
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 85c3fb6..084dc88 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -292,12 +292,20 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
 			maps[ARM_SEC_CORE].unw_sec = s;
 		else if (strcmp(".ARM.exidx.exit.text", secname) == 0)
 			maps[ARM_SEC_EXIT].unw_sec = s;
+		else if (strcmp(".ARM.exidx.text.unlikely", secname) == 0)
+			maps[ARM_SEC_UNLIKELY].unw_sec = s;
+		else if (strcmp(".ARM.exidx.text.hot", secname) == 0)
+			maps[ARM_SEC_HOT].unw_sec = s;
 		else if (strcmp(".init.text", secname) == 0)
 			maps[ARM_SEC_INIT].txt_sec = s;
 		else if (strcmp(".text", secname) == 0)
 			maps[ARM_SEC_CORE].txt_sec = s;
 		else if (strcmp(".exit.text", secname) == 0)
 			maps[ARM_SEC_EXIT].txt_sec = s;
+		else if (strcmp(".text.unlikely", secname) == 0)
+			maps[ARM_SEC_UNLIKELY].txt_sec = s;
+		else if (strcmp(".text.hot", secname) == 0)
+			maps[ARM_SEC_HOT].txt_sec = s;
 	}
 
 	for (i = 0; i < ARM_SEC_MAX; i++)
-- 
1.8.3

