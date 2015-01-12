Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbbALSaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58105 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbbALSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 139/216] x86/tls: Validate TLS entries to protect espfix
Date: Mon, 12 Jan 2015 18:28:37 +0000
Message-Id: <1421087394-2712-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/tls.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index f7fec09e3e3a..e7650bd71109 100644
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
2.1.4

