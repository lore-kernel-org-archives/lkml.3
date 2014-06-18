Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbaFRUp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:45:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35658 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbaFRUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:45:53 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH v8 2/4] printk: move power of 2 practice of ring buffer size to a helper
Date: Wed, 18 Jun 2014 13:45:35 -0700
Message-Id: <1403124337-14886-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

In practice the power of 2 practice of the size of the kernel ring
buffer remains purely historical but not a requirement, specially
now that we have LOG_ALIGN and use it for both static and dynamic
allocations. It could have helped with implicit alignment back in
the days given the even the dynamically sized ring buffer was
guaranteed to be aligned so long as CONFIG_LOG_BUF_SHIFT was set to
produce a __LOG_BUF_LEN which is architecture aligned, since
log_buf_len=n would be allowed only if it was > __LOG_BUF_LEN and
we always ended up rounding the log_buf_len=n to the next power
of 2 with roundup_pow_of_two(), any multiple of 2 then should be also
architecture aligned. These assumptions of course relied heavily
on CONFIG_LOG_BUF_SHIFT producing an aligned value but users can
always change this.

We now have precise alignment requirements set for the log buffer
size for both static and dynamic allocations, but lets upkeep the
old practice of using powers of 2 for its size to help with easy
expected scalable values and the allocators for dynamic allocations.
We'll reuse this later so move this into a helper.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/printk/printk.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 78ceccf..af164a7 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -828,15 +828,21 @@ void log_buf_kexec_setup(void)
 /* requested log_buf_len from kernel cmdline */
 static unsigned long __initdata new_log_buf_len;
 
-/* save requested log_buf_len since it's too early to process it */
-static int __init log_buf_len_setup(char *str)
+/* we practice scaling the ring buffer by powers of 2 */
+static void __init log_buf_len_update(unsigned size)
 {
-	unsigned size = memparse(str, &str);
-
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len)
 		new_log_buf_len = size;
+}
+
+/* save requested log_buf_len since it's too early to process it */
+static int __init log_buf_len_setup(char *str)
+{
+	unsigned size = memparse(str, &str);
+
+	log_buf_len_update(size);
 
 	return 0;
 }
-- 
1.9.3

