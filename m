Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaHNFo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:44:29 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38974 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaHNFo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:44:26 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v6 3/7] random: Reseed pools on resume
Date: Wed, 13 Aug 2014 22:43:57 -0700
Message-Id: <265a39104b5e75407aba489e2edc04437b807f1f.1407994704.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net>
In-Reply-To: <cover.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a suspend/resume cycle, and especially after hibernating, we
should assume that the random pools might have leaked.  To minimize
the risk this poses, try to collect fresh architectural entropy on
resume.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8dc3e3a..0811ad4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -257,6 +257,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -1279,6 +1280,26 @@ static void init_std_data(struct entropy_store *r)
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
 }
 
+static void init_all_pools(void)
+{
+	init_std_data(&input_pool);
+	init_std_data(&blocking_pool);
+	init_std_data(&nonblocking_pool);
+}
+
+static void random_resume(void)
+{
+	/*
+	 * After resume (and especially after hibernation / kexec resume),
+	 * make a best-effort attempt to collect fresh entropy.
+	 */
+	init_all_pools();
+}
+
+static struct syscore_ops random_syscore_ops = {
+	.resume = random_resume,
+};
+
 /*
  * Note that setup_arch() may call add_device_randomness()
  * long before we get here. This allows seeding of the pools
@@ -1291,9 +1312,8 @@ static void init_std_data(struct entropy_store *r)
  */
 static int rand_initialize(void)
 {
-	init_std_data(&input_pool);
-	init_std_data(&blocking_pool);
-	init_std_data(&nonblocking_pool);
+	init_all_pools();
+	register_syscore_ops(&random_syscore_ops);
 	return 0;
 }
 early_initcall(rand_initialize);
-- 
1.9.3

