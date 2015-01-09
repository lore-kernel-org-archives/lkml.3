Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbbAIK6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:58:44 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44514 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757386AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 38/78] x86/tls: Disallow unusual TLS segments
Date: Fri,  9 Jan 2015 11:31:47 +0100
Message-Id: <3be3bc12d15c49969b8d81e89cb191e62813a15e.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0e58af4e1d2166e9e33375a0f121e4867010d4f8 upstream.

Users have no business installing custom code segments into the
GDT, and segments that are not present but are otherwise valid
are a historical source of interesting attacks.

For completeness, block attempts to set the L bit.  (Prior to
this patch, the L bit would have been silently dropped.)

This is an ABI break.  I've checked glibc, musl, and Wine, and
none of them look like they'll have any trouble.

Note to stable maintainers: this is a hardening patch that fixes
no known bugs.  Given the possibility of ABI issues, this
probably shouldn't be backported quickly.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/tls.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index e7650bd71109..3e551eee87b9 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -39,6 +39,28 @@ static bool tls_desc_okay(const struct user_desc *info)
 	if (!info->seg_32bit)
 		return false;
 
+	/* Only allow data segments in the TLS array. */
+	if (info->contents > 1)
+		return false;
+
+	/*
+	 * Non-present segments with DPL 3 present an interesting attack
+	 * surface.  The kernel should handle such segments correctly,
+	 * but TLS is very difficult to protect in a sandbox, so prevent
+	 * such segments from being created.
+	 *
+	 * If userspace needs to remove a TLS entry, it can still delete
+	 * it outright.
+	 */
+	if (info->seg_not_present)
+		return false;
+
+#ifdef CONFIG_X86_64
+	/* The L bit makes no sense for data. */
+	if (info->lm)
+		return false;
+#endif
+
 	return true;
 }
 
-- 
2.2.1

