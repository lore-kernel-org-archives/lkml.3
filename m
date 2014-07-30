Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaG3Gxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:53:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbaG3Gxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:53:30 -0400
Date: Wed, 30 Jul 2014 08:53:12 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of
 load_balance()  in scheduler
Message-ID: <20140730065312.GA1652@laptop.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730014829.344302554@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730014829.344302554@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:49:09PM -0700, Greg Kroah-Hartman wrote:
> 3.15-stable review patch.  If anyone has any objections, please let me know.

IMNSHO this is a too big hammer approach.  The bug happened on a single
file only (right?), so if anything, IMHO it could be disabled for that
single file only, and better do it only for compilers with the bug.
If there are wrong code bugs with -O2 (we've fixed many in the past), you
also don't turn off -O2 everywhere, similarly for -Os or any other options.
Disabling it just in case the same bug happens elsewhere when it actually
took 5 years before the bug caused miscompilation of something is too
defensive.  We had at least 15 other wrong-code bugfixes just in between
4.9.0 and 4.9.1.  -fvar-tracking-assignments doesn't make a small difference
in debug info, but significant for optimized code.
If you build the kernel without and with -fno-var-tracking-assignments,
you can use e.g. the dwlocstat tool to see what kind of difference it makes
for the kernel in particular in variable debug info coverage.
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -669,6 +669,8 @@ KBUILD_CFLAGS	+= -fomit-frame-pointer
>  endif
>  endif
>  
> +KBUILD_CFLAGS   += $(call cc-option, -fno-var-tracking-assignments)
> +
>  ifdef CONFIG_DEBUG_INFO
>  KBUILD_CFLAGS	+= -g
>  KBUILD_AFLAGS	+= -Wa,--gdwarf-2
> 

	Jakub
