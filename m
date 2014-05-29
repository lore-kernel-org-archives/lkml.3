Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaE2ENR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:13:17 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49224 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaE2ENQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140529034625.GB10092@bbox>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140529034625.GB10092@bbox>
Date: Wed, 28 May 2014 21:13:15 -0700
X-Google-Sender-Auth: w41OdC9XKxv4wXcFUoH1G95mrF4
Message-ID: <CA+55aFyoT1xuM-HsZ4GKt=FfDYs76oD7U-RBkZn-2PErj6ZZVw@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 8:46 PM, Minchan Kim <minchan@kernel.org> wrote:
>
> Yes. For example, with mark __alloc_pages_slowpath noinline_for_stack,
> we can reduce 176byte.

Well, but it will then call that __alloc_pages_slowpath() function,
which has a 176-byte stack frame.. Plus the call frame.

Now, that only triggers for when the initial "__GFP_HARDWALL" case
fails, but that's exactly what happens when we do need to do direct
reclaim.

That said, I *have* seen cases where the gcc spill code got really
confused, and simplifying the function (by not inlining excessively)
actually causes a truly smaller stack overall, despite the actual call
frames etc.  But I think the gcc people fixed the kinds of things that
caused *that* kind of stack slot explosion.

And avoiding inlining can end up resulting in less stack, if the
really deep parts don't happen to go through that function that got
inlined (ie any call chain that wouldn't have gone through that
"slowpath" function at all).

But in this case, __alloc_pages_slowpath() is where we end up doing
the actual direct reclaim anyway, so just uninlining doesn't actually
help. Although it would probably make the asm code more readable ;)

              Linus
