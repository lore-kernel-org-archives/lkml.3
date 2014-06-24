Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaFXWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:16:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaFXWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:16:56 -0400
Date: Tue, 24 Jun 2014 15:16:39 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-6a89d71078dad9b1c49ccdf1ffa656fbe36ccd1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <74ef0c00b4d2a3b573e00a4113874e62f772e348.1403642755.git.luto@amacapital.net>
References: <74ef0c00b4d2a3b573e00a4113874e62f772e348.1403642755.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/vdso:
  Error out in vdso2c if DT_RELA is present
Git-Commit-ID: 6a89d71078dad9b1c49ccdf1ffa656fbe36ccd1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a89d71078dad9b1c49ccdf1ffa656fbe36ccd1e
Gitweb:     http://git.kernel.org/tip/6a89d71078dad9b1c49ccdf1ffa656fbe36ccd1e
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 24 Jun 2014 13:46:53 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 24 Jun 2014 13:53:57 -0700

x86/vdso: Error out in vdso2c if DT_RELA is present

vdso2c was checking for various types of relocations to detect when
the vdso had undefined symbols or was otherwise dependent on
relocation at load time.  Undefined symbols in the vdso would fail if
accessed at runtime, and certain implementation errors (e.g. branch
profiling or incorrect symbol visibilities) could result in data
access through the GOT that requires relocations.  This could be
as simple as:

    extern char foo;
    return foo;

Without some kind of visibility control, the compiler would assume
that foo could be interposed at load time and would generate a
relocation.

x86-64 and x32 (as opposed to i386) use explicit-addent (RELA) instead
of implicit-addent (REL) relocations for data access, and vdso2c
forgot to detect those.

Whether these bad relocations would actually fail at runtime depends
on what the linker sticks in the unrelocated references.  Nonetheless,
these relocations have no business existing in the vDSO and should be
fixed rather than silently ignored.

This error could trigger on some configurations due to branch
profiling.  The previous patch fixed that.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/74ef0c00b4d2a3b573e00a4113874e62f772e348.1403642755.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index f42e2dd..df95a2f 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -164,7 +164,7 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	for (i = 0; dyn + i < dyn_end &&
 		     GET_LE(&dyn[i].d_tag) != DT_NULL; i++) {
 		typeof(dyn[i].d_tag) tag = GET_LE(&dyn[i].d_tag);
-		if (tag == DT_REL || tag == DT_RELSZ ||
+		if (tag == DT_REL || tag == DT_RELSZ || tag == DT_RELA ||
 		    tag == DT_RELENT || tag == DT_TEXTREL)
 			fail("vdso image contains dynamic relocations\n");
 	}
