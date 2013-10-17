Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3JQKSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:18:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab3JQKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:18:38 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 7/7] init: execute jump_label_init() earlier
Date: Thu, 17 Oct 2013 12:10:30 +0200
Message-Id: <1382004631-25895-8-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patching of jump labels does not have to depend on any other init code,
so we should do it as soon as possible because static_keys cannot be
used before that.

If we find it does depend on something, the init case of patching should
be modified.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
There should be no reason to use static_key_enabled() now, I'll remove
it from api in following series if there are no objections.

I would also feel a bit safer with disabled interrupts, but it might not
be required.

 init/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 63d3e8f..c84fbb9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -489,6 +489,11 @@ asmlinkage void __init start_kernel(void)
 	 */
 	boot_init_stack_canary();
 
+	/*
+	 * Jump labels have undefined semantics before initialization
+	 */
+	jump_label_init();
+
 	cgroup_init_early();
 
 	local_irq_disable();
@@ -518,7 +523,6 @@ asmlinkage void __init start_kernel(void)
 		   __stop___param - __start___param,
 		   -1, -1, &unknown_bootoption);
 
-	jump_label_init();
 
 	/*
 	 * These use large bootmem allocations and must precede
-- 
1.8.3.1

