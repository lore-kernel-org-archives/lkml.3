Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaGGXUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:20:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaGGXUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:20:10 -0400
Date: Mon, 7 Jul 2014 16:20:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] lib: bitmap: Various improvements
Message-Id: <20140707162008.e5b2e1446b2266b50182c723@linux-foundation.org>
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jul 2014 00:42:46 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Many functions in lib/bitmap.c start with an expression such as lim =
> bits/BITS_PER_LONG. Since bits has type (signed) int, and since gcc
> cannot know that it is in fact non-negative, it generates worse code
> than it could. These patches, mostly consisting of changing various
> parameters to unsigned, gives a slight overall code reduction:

Yes, we have a bad habit of using signed types for things where
negative values are absurd.

The patches look OK to me.

> A few issues I thought about, but didn't know what to do with:
> 
> * Many of the functions misbehave if nbits is compile-time 0; the
>   out-of-line functions generally handle 0 correctly. bitmap_fill() is
>   particularly bad, whether the 0 is known at compile time or not. It
>   would probably be nice to add detection of at least compile-time 0
>   and handle that appropriately.

The best option here would be a compile-time check.  Presumably
BUILD_BUG_ON().  That will catch the errant use and will add no runtime
overhead.

> * I didn't change __bitmap_shift_{left,right} to use unsigned because
>   I want to fully understand why the algorithm works before making
>   that change. However, AFAICT, they behave correctly for all
>   (positive) shift amounts. This is not the case for the
>   small_const_nbits versions. If for example nbits = n =
>   BITS_PER_LONG, the shift operators turn into no-ops (at least on
>   x86), so one get *dst = *src, whereas one would expect to get
>   *dst=0. That difference in behaviour is somewhat annoying.

yup.
