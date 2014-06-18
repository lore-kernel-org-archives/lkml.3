Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaFRUpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:45:50 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38985 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaFRUps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:45:48 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH v8 1/4] printk: make dynamic kernel ring buffer alignment explicit
Date: Wed, 18 Jun 2014 13:45:34 -0700
Message-Id: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
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
__alignof__(struct log).

When log_buf_len=n is used we allocate the ring buffer dynamically.
Dynamic allocation varies, for the early allocation called
before setup_arch() memblock_virt_alloc() requests a page aligment
and for the default kernel allocation memblock_virt_alloc_nopanic()
requests no special alignment, which in turn ends up aligning the
allocation to SMP_CACHE_BYTES, which is L1 cache aligned.

Since we already have the required alignment for the kernel ring
buffer though we can do better and request explicit alignment for
LOG_ALIGN. This does that to be safe and make dynamic allocation
alignment explicit.

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
Acked-by: Petr Mladek <pmladek@suse.cz>
Tested-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/printk/printk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ea2d5f6..78ceccf 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -853,9 +853,10 @@ void __init setup_log_buf(int early)
 
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

