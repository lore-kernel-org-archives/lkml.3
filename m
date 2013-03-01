Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3CARRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:17:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CARRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:17:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: sedat.dilek@gmail.com
Subject: Re: linux-next: build warning after merge of the char-misc tree
Date: Fri, 1 Mar 2013 17:16:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevenson <david@avoncliff.com>
References: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au> <201302152005.51575.arnd@arndb.de> <CA+icZUUCRb9DafSj0Vhtq68mNxBPHVpSkeau+UEkfVb3Jv0k6g@mail.gmail.com>
In-Reply-To: <CA+icZUUCRb9DafSj0Vhtq68mNxBPHVpSkeau+UEkfVb3Jv0k6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201303011716.43148.arnd@arndb.de>
X-Provags-ID: V02:K0:K0v3CDX8d76Ty+3jnZ7W26BsVv/ebOLiSyQvr3oe134
 8LE8hpBbKlkOc4icN1yHSJ51+3BYnVGy9FtWfzrj2Iqgwpc0gI
 1Qm5TqyUd6iseX7/3ku4CdcnhQn7MF7XlI1/Bz1QEOmBaJKQbL
 7jhAZR44RdlYFpStsBnn1Ou9JAYqFI4Uwibp5+Iv3GcUHcI+za
 Ghp2LJvO3wKHMqoR+DyIuh59R/y0s1nnr9ukaMrIckUXvKpQNQ
 NJq71hSLJpvoxNsPrTftmWOUd4MESZs+ALsD1CviRLeC9o62r6
 Dg1NVr18eZLUKTBdUj9TSr9S1QkLGsmL/XvZ4dj8BW3ZKEGjQW
 7pBGAS9n6w/A3OF3nxwM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013, Sedat Dilek wrote:
> I have seen a lot of such failures when using the Freetz (a small
> router project) build-system with gcc-4.7-x where "-Os" is default
> optimization-level.
> 
> Last, when I tried to integrate ltrace GIT snapshots into Freetz.
> All these "build-errors" could be solved in changing ltrace code.
> So, I would not talk about "false positives".

But the point is that we should not be changing the source code to
unnecessary initializations, because that may hide real bugs if the
code is modified in a way that relies on a sane value of some
variable. They are false positives if the code is actually correct
and does not need to be changed.

I actually have a newer version of my patch (see below) that uses
the cc-disable-warning macro in order to avoid some of the
side-effects of setting an unknown option on older gcc versions.

> Furthermore, "-Wno-maybe-uninitialized" gcc-option is available
> gcc-4-7+, so your patch is incomplete.

O don't understand. The patch avoids the warnings when building
with gcc-4.7 or higher with -Os. 

	Arnd


>From d313219a2f2e0753b8e96105b7a944e1c22566ae Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 15 Feb 2013 21:23:58 +0100
Subject: [PATCH] Turn off -Wmaybe-uninitialized when building with -Os

gcc-4.7 and higher add a lot of false positive warnings about
potential uses of uninitialized warnings, but only when optimizing
for size (-Os). This is the default when building allyesconfig,
which turns on CONFIG_CC_OPTIMIZE_FOR_SIZE.

In order to avoid getting a lot of patches that initialize such
variables and accidentally hide real errors along the way, let's
just turn off this warning on the respective gcc versions
when building with size optimizations. The -Wmaybe-uninitialized
option was introduced in the same gcc version (4.7) that is now
causing the false positives, so there is no effect on older compilers.

A side effect is that when building with CONFIG_CC_OPTIMIZE_FOR_SIZE,
we might now see /fewer/ warnings about possibly uninitialized
warnings than with -O2, but that is still much better than seeing
warnings known to be bogus.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/Makefile b/Makefile
index 473beb1..f0ec9bc 100644
--- a/Makefile
+++ b/Makefile
@@ -570,7 +570,7 @@ endif # $(dot-config)
 all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os
+KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
 else
 KBUILD_CFLAGS	+= -O2
 endif
