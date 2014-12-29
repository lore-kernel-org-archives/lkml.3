Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaL2BQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:16:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Willy Tarreau" <w@1wt.eu>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "security@kernel.org" <security@kernel.org>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.155068126@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 10/27] x86/tls: Validate TLS entries to protect espfix
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/tls.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -28,6 +28,21 @@ static int get_free_idx(void)
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
@@ -67,6 +82,9 @@ int do_set_thread_area(struct task_struc
 	if (copy_from_user(&info, u_info, sizeof(info)))
 		return -EFAULT;
 
+	if (!tls_desc_okay(&info))
+		return -EINVAL;
+
 	if (idx == -1)
 		idx = info.entry_number;
 
@@ -197,6 +215,7 @@ int regset_tls_set(struct task_struct *t
 {
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
+	int i;
 
 	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
@@ -210,6 +229,10 @@ int regset_tls_set(struct task_struct *t
 	else
 		info = infobuf;
 
+	for (i = 0; i < count / sizeof(struct user_desc); i++)
+		if (!tls_desc_okay(info + i))
+			return -EINVAL;
+
 	set_tls_desc(target,
 		     GDT_ENTRY_TLS_MIN + (pos / sizeof(struct user_desc)),
 		     info, count / sizeof(struct user_desc));

