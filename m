Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaCJUnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:43:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46296 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaCJUnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:43:19 -0400
Date: Mon, 10 Mar 2014 13:42:48 -0700
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Honig <ahonig@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jianguo Wu <wujianguo@huawei.com>,
        David Rientjes <rientjes@google.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] x86, kaslr: fix module lock ordering problem
Message-ID: <20140310204248.GA1958@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a potential lock ordering problem with the module kASLR patch
("x86, kaslr: randomize module base load address"). This patch removes
the usage of the module_mutex and creates a new mutex to protect the
module base address offset value.

Chain exists of:
  text_mutex --> kprobe_insn_slots.mutex --> module_mutex

[    0.515561]  Possible unsafe locking scenario:
[    0.515561]
[    0.515561]        CPU0                    CPU1
[    0.515561]        ----                    ----
[    0.515561]   lock(module_mutex);
[    0.515561]                                lock(kprobe_insn_slots.mutex);
[    0.515561]                                lock(module_mutex);
[    0.515561]   lock(text_mutex);
[    0.515561]
[    0.515561]  *** DEADLOCK ***

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andy Honig <ahonig@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/module.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 49483137371f..e69f9882bf95 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -48,6 +48,9 @@ do {							\
 static unsigned long module_load_offset;
 static int randomize_modules = 1;
 
+/* Mutex protects the module_load_offset. */
+static DEFINE_MUTEX(module_kaslr_mutex);
+
 static int __init parse_nokaslr(char *p)
 {
 	randomize_modules = 0;
@@ -58,7 +61,7 @@ early_param("nokaslr", parse_nokaslr);
 static unsigned long int get_module_load_offset(void)
 {
 	if (randomize_modules) {
-		mutex_lock(&module_mutex);
+		mutex_lock(&module_kaslr_mutex);
 		/*
 		 * Calculate the module_load_offset the first time this
 		 * code is called. Once calculated it stays the same until
@@ -67,7 +70,7 @@ static unsigned long int get_module_load_offset(void)
 		if (module_load_offset == 0)
 			module_load_offset =
 				(get_random_int() % 1024 + 1) * PAGE_SIZE;
-		mutex_unlock(&module_mutex);
+		mutex_unlock(&module_kaslr_mutex);
 	}
 	return module_load_offset;
 }
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
