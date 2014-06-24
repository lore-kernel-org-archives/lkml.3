Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaFXVik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:38:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38447 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbaFXVii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:38:38 -0400
Date: Tue, 24 Jun 2014 23:38:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Matz <matz@suse.de>,
        linux-kbuild@vger.kernel.org, x86-ml <x86@kernel.org>
Subject: [PATCH] Kbuild: Move -Wmaybe-uninitialized to W=1
Message-ID: <20140624213835.GD15068@pd.tnic>
References: <20140616132045.GE8170@pd.tnic>
 <20140616211405.GA7914@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616211405.GA7914@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:14:05PM +0200, Sam Ravnborg wrote:
> Agreed.
> The noise ratio is too high - so move it to W=1.

Ok, how about the below?

It still needs this hunk to work:

@@ -33,7 +34,7 @@ warning-1 += $(call cc-disable-warning, format)
 warning-1 += $(call cc-disable-warning, unknown-warning-option)
 warning-1 += $(call cc-disable-warning, sign-compare)
 warning-1 += $(call cc-disable-warning, format-zero-length)
-warning-1 += $(call cc-disable-warning, uninitialized)
+#warning-1 += $(call cc-disable-warning, uninitialized)
 warning-1 += $(call cc-option, -fcatch-undefined-behavior)
 
 warning-2 := -Waggregate-return

but that's another story which is still WIP here:
http://lkml.kernel.org/r/20140616130751.GD8170@pd.tnic

After it is sorted out, we can do something like the below. (Note:
I'm not filtering out the previous -Wno-maybe-uninitialized from
KBUILD_CFLAGS because it is not necessary - apparently the following
-Wmaybe-uninitialized reenables it again).

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] Kbuild: Move -Wmaybe-uninitialized to W=1

This warning is enabled by -Wall or -Wextra, says the gcc manpage. It
also says that gcc cannot always know whether the warning is issued
correctly:

"These warnings are made optional because GCC is not smart enough to see
all the reasons why the code might be correct in spite of appearing to
have an error."

And, as expected, it fires for perfectly valid use cases, thus making it
not really useful. Let's move it to the W=1 bunch in case people want to
enable it with the additional checks.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Makefile                   | 2 ++
 scripts/Makefile.extrawarn | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index b11e2d504a00..63033545d7f6 100644
--- a/Makefile
+++ b/Makefile
@@ -402,6 +402,8 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security
 
+KBUILD_CFLAGS   += $(call cc-disable-warning, maybe-uninitialized)
+
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 65643506c71c..e61678c40d41 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -25,6 +25,7 @@ warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
+warning-1 += $(call cc-option, -Wmaybe-uninitialized)
 
 # Clang
 warning-1 += $(call cc-disable-warning, initializer-overrides)
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
