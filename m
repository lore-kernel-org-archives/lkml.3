Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3CARnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:43:39 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38534 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3CARnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:43:37 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201303011716.43148.arnd@arndb.de>
References: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au>
	<201302152005.51575.arnd@arndb.de>
	<CA+icZUUCRb9DafSj0Vhtq68mNxBPHVpSkeau+UEkfVb3Jv0k6g@mail.gmail.com>
	<201303011716.43148.arnd@arndb.de>
Date: Fri, 1 Mar 2013 18:43:33 +0100
Message-ID: <CA+icZUU_FYnF8Sgq6UGOqW3ug2cnwuNyaHiUNBCEpu3EvdA2Mw@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the char-misc tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevenson <david@avoncliff.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 6:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 01 March 2013, Sedat Dilek wrote:
>> I have seen a lot of such failures when using the Freetz (a small
>> router project) build-system with gcc-4.7-x where "-Os" is default
>> optimization-level.
>>
>> Last, when I tried to integrate ltrace GIT snapshots into Freetz.
>> All these "build-errors" could be solved in changing ltrace code.
>> So, I would not talk about "false positives".
>
> But the point is that we should not be changing the source code to
> unnecessary initializations, because that may hide real bugs if the
> code is modified in a way that relies on a sane value of some
> variable. They are false positives if the code is actually correct
> and does not need to be changed.
>
> I actually have a newer version of my patch (see below) that uses
> the cc-disable-warning macro in order to avoid some of the
> side-effects of setting an unknown option on older gcc versions.
>
>> Furthermore, "-Wno-maybe-uninitialized" gcc-option is available
>> gcc-4-7+, so your patch is incomplete.
>
> O don't understand. The patch avoids the warnings when building
> with gcc-4.7 or higher with -Os.
>

If the ...$(call cc-disable-warning...) line is checking $compiler for
$feature_is-available than I have misunderstood it.

Looks good, thanks.

- Sedat -

>         Arnd
>
>
> From d313219a2f2e0753b8e96105b7a944e1c22566ae Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri, 15 Feb 2013 21:23:58 +0100
> Subject: [PATCH] Turn off -Wmaybe-uninitialized when building with -Os
>
> gcc-4.7 and higher add a lot of false positive warnings about
> potential uses of uninitialized warnings, but only when optimizing
> for size (-Os). This is the default when building allyesconfig,
> which turns on CONFIG_CC_OPTIMIZE_FOR_SIZE.
>
> In order to avoid getting a lot of patches that initialize such
> variables and accidentally hide real errors along the way, let's
> just turn off this warning on the respective gcc versions
> when building with size optimizations. The -Wmaybe-uninitialized
> option was introduced in the same gcc version (4.7) that is now
> causing the false positives, so there is no effect on older compilers.
>
> A side effect is that when building with CONFIG_CC_OPTIMIZE_FOR_SIZE,
> we might now see /fewer/ warnings about possibly uninitialized
> warnings than with -O2, but that is still much better than seeing
> warnings known to be bogus.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/Makefile b/Makefile
> index 473beb1..f0ec9bc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -570,7 +570,7 @@ endif # $(dot-config)
>  all: vmlinux
>
>  ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
> -KBUILD_CFLAGS  += -Os
> +KBUILD_CFLAGS  += -Os $(call cc-disable-warning,maybe-uninitialized,)
>  else
>  KBUILD_CFLAGS  += -O2
>  endif
