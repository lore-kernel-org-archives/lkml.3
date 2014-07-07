Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaGGKxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:53:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48941 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGGKxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:53:42 -0400
Date: Mon, 7 Jul 2014 12:53:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Matz <matz@suse.de>,
        linux-kbuild@vger.kernel.org, x86-ml <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Move -Wmaybe-uninitialized to W=1
Message-ID: <20140707105339.GA4776@pd.tnic>
References: <20140616132045.GE8170@pd.tnic>
 <20140616211405.GA7914@ravnborg.org>
 <20140624213835.GD15068@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140624213835.GD15068@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's a v2 which goes ontop of

http://lkml.kernel.org/r/1404175346-12330-1-git-send-email-behanw@converseincode.com

After this, all warnings stuff should be back to normal.

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH -v2] Kbuild: Move -Wmaybe-uninitialized to W=1

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
 Makefile                   | 5 ++++-
 scripts/Makefile           | 1 +
 scripts/Makefile.extrawarn | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 4d75b4bceedd..b58c94261960 100644
--- a/Makefile
+++ b/Makefile
@@ -613,7 +613,7 @@ include $(srctree)/arch/$(SRCARCH)/Makefile
 KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
+KBUILD_CFLAGS	+= -Os
 else
 KBUILD_CFLAGS	+= -O2
 endif
@@ -742,6 +742,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
+# disable -Wmaybe-uninitialized as too noisy, see Makefile.extrawarn instead
+KBUILD_CFLAGS   += $(call cc-disable-warning, maybe-uninitialized)
+
 # check for 'asm goto'
 ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
diff --git a/scripts/Makefile b/scripts/Makefile
index 890df5c6adfb..a483d9988a2e 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -19,6 +19,7 @@ hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
+HOSTCFLAGS_sortextable.o += $(call cc-disable-warning, maybe-uninitialized)
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
 
 always		:= $(hostprogs-y) $(hostprogs-m)
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index e3501272cd93..9657d5778e06 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -25,6 +25,7 @@ warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
+warning-1 += $(call cc-option, -Wmaybe-uninitialized)
 
 ifeq ($(COMPILER),clang)
 warning-1 += $(call cc-disable-warning, initializer-overrides)
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
