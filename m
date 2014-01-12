Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaALR7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:59:16 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48234 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaALR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:59:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] x86: don't use module_init for non-modular core bootflag code
Date: Sun, 12 Jan 2014 12:57:48 -0500
Message-ID: <1389549468-26534-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bootflag.o is obj-y (always built in).  It will never be
modular, so using module_init as an alias for __initcall is
somewhat misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of arch_initcall (which
makes sense for arch code) will thus change this registration
from level 6-device to level 3-arch (i.e. slightly earlier).
However no observable impact of that small difference has
been observed during testing, or is expected.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/x86/kernel/bootflag.c b/arch/x86/kernel/bootflag.c
index 5de7f4c56971..52c8e3c7789d 100644
--- a/arch/x86/kernel/bootflag.c
+++ b/arch/x86/kernel/bootflag.c
@@ -98,4 +98,4 @@ static int __init sbf_init(void)
 
 	return 0;
 }
-module_init(sbf_init);
+arch_initcall(sbf_init);
-- 
1.8.5.2

