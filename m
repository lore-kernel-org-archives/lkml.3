Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbbAOWK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:10:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbbAOWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 05/19] x86/tls: Validate TLS entries to protect espfix
Date: Thu, 15 Jan 2015 14:09:41 -0800
Message-Id: <1421359795-11155-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/tls.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index f7fec09..e7650bd 100644
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
 
@@ -192,6 +210,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 {
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
+	int i;
 
 	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
@@ -205,6 +224,10 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
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

