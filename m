Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbbALS5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:57:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbbALSaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 140/216] x86/tls: Disallow unusual TLS segments
Date: Mon, 12 Jan 2015 18:28:38 +0000
Message-Id: <1421087394-2712-28-git-send-email-luis.henriques@canonical.com>
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
Cc: security@kernel.org <security@kernel.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

