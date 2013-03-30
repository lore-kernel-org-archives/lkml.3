Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3C3TRq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 15:17:46 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17704 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3C3TRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 15:17:45 -0400
Date: Sat, 30 Mar 2013 20:17:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: sparclinux@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: usr/include/linux/types.h:27:1: error: unknown type name
	'__u16'
Message-ID: <20130330191743.GA20756@merkur.ravnborg.org>
References: <5152d3ed.vW9X0QzDTVkW7Gck%fengguang.wu@intel.com> <20130327154453.GA27576@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327154453.GA27576@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:44:53PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> The below errors show up in both upstream and linux-next.
> 
>    make ARCH=sparc allyesconfig
>    make ARCH=sparc
> 
>    In file included from usr/include/linux/genetlink.h:4:0,
>                     from Documentation/accounting/getdelays.c:27:
> >> usr/include/linux/types.h:27:1: error: unknown type name '__u16'
> >> usr/include/linux/types.h:28:1: error: unknown type name '__u16'
> >> usr/include/linux/types.h:29:1: error: unknown type name '__u32'
> >> usr/include/linux/types.h:30:1: error: unknown type name '__u32'
> >> usr/include/linux/types.h:31:1: error: unknown type name '__u64'
> >> usr/include/linux/types.h:32:1: error: unknown type name '__u64'
> >> usr/include/linux/types.h:34:1: error: unknown type name '__u16'
> >> usr/include/linux/types.h:35:1: error: unknown type name '__u32'
>    In file included from usr/include/linux/genetlink.h:5:0,


This turned out to be something fundamental in types.h.
My fix is appended.

I will do a proper submission to davem later as part of
a few other trivial fixes.

	Sam

Subject: [PATCH] sparc: use asm-generic version of types.h

This fixes build errors in samples/

We failed to include the header file that define __u16 because __sparc__
was not defined.
This check is not required - and removing this made us
compatible with the generic types.h version. So use that.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/include/asm/Kbuild       |    1 +
 arch/sparc/include/uapi/asm/Kbuild  |    1 -
 arch/sparc/include/uapi/asm/types.h |   17 -----------------
 3 files changed, 1 insertions(+), 18 deletions(-)
 delete mode 100644 arch/sparc/include/uapi/asm/types.h

diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index f73884b..ff18e3c 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -13,4 +13,5 @@ generic-y += local.h
 generic-y += module.h
 generic-y += serial.h
 generic-y += trace_clock.h
+generic-y += types.h
 generic-y += word-at-a-time.h
diff --git a/arch/sparc/include/uapi/asm/Kbuild b/arch/sparc/include/uapi/asm/Kbuild
index ce175af..b5843ee 100644
--- a/arch/sparc/include/uapi/asm/Kbuild
+++ b/arch/sparc/include/uapi/asm/Kbuild
@@ -44,7 +44,6 @@ header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
 header-y += traps.h
-header-y += types.h
 header-y += uctx.h
 header-y += unistd.h
 header-y += utrap.h
diff --git a/arch/sparc/include/uapi/asm/types.h b/arch/sparc/include/uapi/asm/types.h
deleted file mode 100644
index 383d156..0000000
--- a/arch/sparc/include/uapi/asm/types.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _SPARC_TYPES_H
-#define _SPARC_TYPES_H
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-
-#if defined(__sparc__)
-
-#include <asm-generic/int-ll64.h>
-
-#endif /* defined(__sparc__) */
-
-#endif /* defined(_SPARC_TYPES_H) */
-- 
1.6.0.6
