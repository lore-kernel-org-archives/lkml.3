Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3IPLmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:42:32 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62521 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab3IPLma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:42:30 -0400
X-Nat-Received: from [202.181.97.72]:60520 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379331696.15929
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: joe@perches.com, linux@horizon.com, dan.carpenter@oracle.com,
        viro@zeniv.linux.org.uk, JBeulich@suse.com, kosaki.motohiro@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1379317437-28329-2-git-send-email-keescook@chromium.org>
Message-Id: <201309162041.HHG69783.FLFMJFtSOQOHVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 16 Sep 2013 20:41:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16092013 #11059130, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> -	seq_printf(m, "%s%d%n", con->name, con->index, &len);
> -	len = 21 - len;
> +	len = m->count;
> +	seq_printf(m, "%s%d", con->name, con->index);
> +	len = 21 - (m->count - len);

Why not to create a new function which returns bytes written?
The new function does not need to return negative value for indicating errors.
---------- patch start ----------
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 4e32edc..c889cf1 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -91,6 +91,7 @@ int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
 __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
+__printf(2, 3) int seq_new_printf(struct seq_file *m, const char *f, ...);
 
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..7af75ec 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -419,6 +419,27 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 EXPORT_SYMBOL(seq_printf);
 
 /**
+ *	seq_new_printf - seq_printf() which returns bytes written.
+ *	@m:	target buffer
+ *	@f:	format
+ *
+ *      Returns bytes written to @m.
+ */
+int seq_new_printf(struct seq_file *m, const char *f, ...)
+{
+	const int count = m->count;
+	int ret;
+	va_list args;
+
+	va_start(args, f);
+	ret = seq_vprintf(m, f, args);
+	va_end(args);
+
+	return ret ? 0 : m->count - count;
+}
+EXPORT_SYMBOL(seq_new_printf);
+
+/**
  *	mangle_path -	mangle and copy path to buffer beginning
  *	@s: buffer start
  *	@p: beginning of path in above buffer
---------- patch end ----------
With new function, we can do:

-	len = m->count;
-	seq_printf(m, "%s%d", con->name, con->index);
-	len = 21 - (m->count - len);
+	len = 21 - seq_new_printf(m, "%s%d", con->name, con->index);
