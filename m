Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaKTP1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:27:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:7562 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757419AbaKTP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:21 -0500
Message-Id: <20141120152717.725803185@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Nov 2014 10:21:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 12/15] seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
References: <20141120152120.168868031@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0012-seq-buf-Make-seq_buf_bprintf-conditional-on-CONFIG_B.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function bstr_printf() from lib/vsprnintf.c is only available if
CONFIG_BINARY_PRINTF is defined. This is due to the only user currently
being the tracing infrastructure, which needs to select this config
when tracing is configured. Until there is another user of the binary
printf formats, this will continue to be the case.

Since seq_buf.c is now lives in lib/ and is compiled even without
tracing, it must encompass its use of bstr_printf() which is used
by seq_buf_printf(). This too is only used by the tracing infrastructure
and is still encapsulated by the CONFIG_BINARY_PRINTF.

Link: http://lkml.kernel.org/r/20141104160222.969013383@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 7 +++++--
 kernel/trace/seq_buf.c  | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 12c64282aa98..9aafe0e24c68 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -115,8 +115,6 @@ extern __printf(2, 3)
 int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
 extern __printf(2, 0)
 int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
-extern int
-seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
 extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
 extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
 			   int cnt);
@@ -130,4 +128,9 @@ extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *
 extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
 			   int nmaskbits);
 
+#ifdef CONFIG_BINARY_PRINTF
+extern int
+seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
+#endif
+
 #endif /* _LINUX_SEQ_BUF_H */
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index 086f594ac890..4eedfedb9e31 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -127,6 +127,7 @@ int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
 	return -1;
 }
 
+#ifdef CONFIG_BINARY_PRINTF
 /**
  * seq_buf_bprintf - Write the printf string from binary arguments
  * @s: seq_buf descriptor
@@ -161,6 +162,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 	seq_buf_set_overflow(s);
 	return -1;
 }
+#endif /* CONFIG_BINARY_PRINTF */
 
 /**
  * seq_buf_puts - sequence printing of simple string
-- 
2.1.1


