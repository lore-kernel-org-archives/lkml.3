Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaF0O6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:58:36 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42040 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaF0O6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:58:09 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, Sneha Priya <sneha.cse@hotmail.com>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/3] ARM: perf: disable the pagefault handler when reading from user space
Date: Fri, 27 Jun 2014 16:57:46 +0200
Message-Id: <1403881067-22690-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
References: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As done on other architectures (ARM64, x86, Sparc etc.).

This prevents a deadlock on down_read in do_page_fault when unwinding
using fp and triggering on kernel tracepoints:

  INFO: task stress:2116 blocked for more than 120 seconds.
        Not tainted 3.15.0-rc4-00364-g3401dfb-dirty #43
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  stress          D c04b41e8     0  2116   2115 0x00000000
  [<c04b41e8>] (__schedule) from [<c04b46dc>] (schedule+0x40/0x90)
  [<c04b46dc>] (schedule) from [<c04b6ec8>] (__down_read+0xc4/0xfc)
  [<c04b6ec8>] (__down_read) from [<c04b69c0>] (down_read+0x18/0x1c)
  [<c04b69c0>] (down_read) from [<c001d41c>] (do_page_fault+0xac/0x420)
  [<c001d41c>] (do_page_fault) from [<c0008444>] (do_DataAbort+0x44/0xa8)
  [<c0008444>] (do_DataAbort) from [<c00136b8>] (__dabt_svc+0x38/0x60)
  Exception stack(0xecbc3af8 to 0xecbc3b40)
  3ae0:                                                       ecbc3b74 b6d72ff4
  3b00: ffffffec 00000000 b6d72ff4 ec0fc000 00000000 ec0fc000 0000007e 00000000
  3b20: ecbc2000 ecbc3bac 00000014 ecbc3b44 c0019e78 c021ef44 00000013 ffffffff
  [<c00136b8>] (__dabt_svc) from [<c021ef44>] (__copy_from_user+0xa4/0x3a0)

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/perf_event.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 6493c4c..f5aeca2 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -560,11 +560,16 @@ user_backtrace(struct frame_tail __user *tail,
 	       struct perf_callchain_entry *entry)
 {
 	struct frame_tail buftail;
+	unsigned long err;
 
-	/* Also check accessibility of one struct frame_tail beyond */
 	if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
 		return NULL;
-	if (__copy_from_user_inatomic(&buftail, tail, sizeof(buftail)))
+
+	pagefault_disable();
+	err = __copy_from_user_inatomic(&buftail, tail, sizeof(buftail));
+	pagefault_enable();
+
+	if (err)
 		return NULL;
 
 	perf_callchain_store(entry, buftail.lr);
-- 
1.8.1.2

