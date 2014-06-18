Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966176AbaFRLOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:14:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50104 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376AbaFRLOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:14:31 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@linux.intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [RFT 1/2] printk: make dynamic kernel ring buffer alignemnt explicit
Date: Wed, 18 Jun 2014 04:14:24 -0700
Message-Id: <1403090065-13879-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We have to consider alignment for the ring buffer both for the
default static size, and then also for when an dynamic allocation
is made when the log_buf_len=n kernel parameter is passed to set
the size specifically to a size larger than the default size set
by the architecture through CONFIG_LOG_BUF_SHIFT.

The default static kernel ring buffer can be aligned properly if
architectures set CONFIG_LOG_BUF_SHIFT properly, we provide ranges
for the size though so even if CONFIG_LOG_BUF_SHIFT has a sensible
aligned value it can be reduced to a non aligned value. Commit
6ebb017de9 by Andrew ensures the static buffer is always aligned
and the decision of alignment is done by the compiler by using
__alignof__(struct log) (curious what value caused the crash?).

When log_buf_len=n is used we allocate the ring buffer dynamically.
Dynamic allocation varies, for the early allocation called
before setup_arch() memblock_virt_alloc() requests a page aligment
and for the default kernel allocation memblock_virt_alloc_nopanic()
requests no special alignment, which in turn ends up aligning the
allocation to SMP_CACHE_BYTES, which is L1 cache aligned.

Since we already have the required alignment for the kernel ring
buffer though we can do better and request explicit alignment for
LOG_ALIGN. Do that and also put the power of 2 practice of
the ring buffer size into a helper which we'll use later.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>
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

This is perhaps not required given that we stick to powers of 2
and the min LOG_BUF_SHIFT is 12, if the min LOG_BUF_SHIFT is
aligned then I think any passed log_buf_len=n would be aligned
as well as we don't make log_buf_len=n take effect unless
its > than the default size, and we round to the produced size
to the next power of 2. If the min length produced by
LOG_BUF_SHIFT is aligned, multiples of 2 of this should be as
well I think.

This might be perhaps safest thing to do though given we'll
add other alloc entries next.

 kernel/printk/printk.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ea2d5f6..af164a7 100644
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
@@ -853,9 +859,10 @@ void __init setup_log_buf(int early)
 
 	if (early) {
 		new_log_buf =
-			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
+			memblock_virt_alloc(new_log_buf_len, LOG_ALIGN);
 	} else {
-		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len, 0);
+		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len,
+							  LOG_ALIGN);
 	}
 
 	if (unlikely(!new_log_buf)) {
-- 
1.9.3

