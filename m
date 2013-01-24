Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224Ab3AXUVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:21:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49628 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202Ab3AXUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:20:57 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/35] x86: Handle multiple exactmaps and out of order exactmap
Date: Thu, 24 Jan 2013 12:19:43 -0800
Message-Id: <1359058816-7615-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code expect that we only have one exactmap and exactmap need to
first one in memmap=.

memmap=exactmap will throw away all original entries, but also until
then user defined (through other provided memmap= parameters) areas.
That means all memmap= boot parameters passed before a memmap=exactmap
parameter are not recognized.

Without this fix:
	memmap=x@y memmap=exactmap memmap=i#k
only i#k would get recognized.  This is wrong.

This fix will scan the boot_command_line to find if there is exactmap at
first and only throw away all original e820 entries once, and then parse
other memmap= option.

-v2: incorporate change log from Thomas Renninger.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/e820.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d32abea..dc0b9f0 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -835,6 +835,8 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
+static bool __initdata exactmap_parsed;
+
 static int __init parse_memmap_one(char *p)
 {
 	char *oldp;
@@ -844,6 +846,10 @@ static int __init parse_memmap_one(char *p)
 		return -EINVAL;
 
 	if (!strncmp(p, "exactmap", 8)) {
+		if (exactmap_parsed)
+			return 0;
+
+		exactmap_parsed = true;
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know
@@ -879,6 +885,12 @@ static int __init parse_memmap_one(char *p)
 }
 static int __init parse_memmap_opt(char *str)
 {
+	char *p = boot_command_line;
+
+	p = strstr(p, "exactmap");
+	if (p)
+		parse_memmap_one("exactmap");
+
 	while (str) {
 		char *k = strchr(str, ',');
 
-- 
1.7.10.4

