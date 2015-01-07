Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbbAGCHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:07:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbbAGCHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 03/52] x86/tls: Disallow unusual TLS segments
Date: Tue,  6 Jan 2015 18:06:31 -0800
Message-Id: <20150107020555.569634784@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tls.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -39,6 +39,28 @@ static bool tls_desc_okay(const struct u
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
 


