Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3AVPU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:20:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab3AVPUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:20:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/2] x86 e820: Check for exactmap appearance when parsing first memmap option
Date: Tue, 22 Jan 2013 16:20:48 +0100
Message-Id: <1358868049-19884-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1358868049-19884-1-git-send-email-trenn@suse.de>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

memmap=exactmap will throw away all original, but also until then
user defined (through other provided memmap= parameters) areas.
That means all memmap= boot parameters passed before a memmap=exactmap
parameter are not recognized.
Without this fix:
memmap=x@y memmap=exactmap memmap=i#k
only i#k would get recognized.

This is wrong, this fix will only throw away all original e820 areas once
when memmap=exactmap is found in the whole boot command line and before
any other memmap= option is parsed.

Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/e820.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

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
1.7.6.1

