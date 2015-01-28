Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429AbbA1E0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:26:51 -0500
Received: from mail.kernel.org ([198.145.29.136]:41599 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965406AbbA1E0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:46 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 177/177] x86/tls: Validate TLS entries to protect espfix
Date: Wed, 28 Jan 2015 12:10:35 +0800
Message-Id: <1422418236-12852-268-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 41bdc78544b8a93a9c6814b8bbbfef966272abbe upstream.

Installing a 16-bit RW data segment into the GDT defeats espfix.
AFAICT this will not affect glibc, Wine, or dosemu at all.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: security@kernel.org <security@kernel.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kernel/tls.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 9d9d2f9..1bf424d 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -27,6 +27,21 @@ static int get_free_idx(void)
 	return -ESRCH;
 }
 
+static bool tls_desc_okay(const struct user_desc *info)
+{
+	if (LDT_empty(info))
+		return true;
+
+	/*
+	 * espfix is required for 16-bit data segments, but espfix
+	 * only works for LDT segments.
+	 */
+	if (!info->seg_32bit)
+		return false;
+
+	return true;
+}
+
 static void set_tls_desc(struct task_struct *p, int idx,
 			 const struct user_desc *info, int n)
 {
@@ -66,6 +81,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	if (copy_from_user(&info, u_info, sizeof(info)))
 		return -EFAULT;
 
+	if (!tls_desc_okay(&info))
+		return -EINVAL;
+
 	if (idx == -1)
 		idx = info.entry_number;
 
@@ -196,6 +214,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 {
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
+	int i;
 
 	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
@@ -209,6 +228,10 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 	else
 		info = infobuf;
 
+	for (i = 0; i < count / sizeof(struct user_desc); i++)
+		if (!tls_desc_okay(info + i))
+			return -EINVAL;
+
 	set_tls_desc(target,
 		     GDT_ENTRY_TLS_MIN + (pos / sizeof(struct user_desc)),
 		     info, count / sizeof(struct user_desc));
-- 
1.9.1

