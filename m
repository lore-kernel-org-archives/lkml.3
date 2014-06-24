Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaFXUrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:47:25 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58996 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaFXUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:47:06 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/2] x86,vdso2c: Error out if DT_RELA is present
Date: Tue, 24 Jun 2014 13:46:53 -0700
Message-Id: <74ef0c00b4d2a3b573e00a4113874e62f772e348.1403642755.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403642755.git.luto@amacapital.net>
References: <53A9C6EB.50900@zytor.com>
 <cover.1403642755.git.luto@amacapital.net>
In-Reply-To: <cover.1403642755.git.luto@amacapital.net>
References: <cover.1403642755.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

My toolchain emits explicit-addent (RELA) instead of implicit-addent
(REL) relocations for data access, and vdso2c forgot to detect those.

Whether these bad relocations would actually fail at runtime depends
on what the linker sticks in the unrelocated references.  Nonetheless,
these relocations have no business existing in the vDSO and should be
fixed rather than silently ignored.

This error could trigger on some configurations due to branch
profiling.  The previous patch fixed that.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
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
-- 
1.9.3

