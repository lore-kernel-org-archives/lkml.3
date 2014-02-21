Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaBUSN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:13:57 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34702 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaBUSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:13:55 -0500
MIME-Version: 1.0
In-Reply-To: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 21 Feb 2014 10:13:54 -0800
X-Google-Sender-Auth: e1JRtk7FD5I9b_7Rg9FlBpMgaB0
Message-ID: <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
Subject: Re: [PATCH] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 9:28 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
>
> This patch is a continuation of efforts trying to optimize find_vma(),
> avoiding potentially expensive rbtree walks to locate a vma upon faults.

Ok, so I like this one much better than the previous version.

However, I do wonder if the per-mm vmacache is actually worth it.
Couldn't the per-thread one replace it entirely?

Also, the hash you use for the vmacache index is *particularly* odd.

        int idx =  (addr >> 10) & 3;

you're using the top two bits of the address *within* the page.
There's a lot of places that round addresses down to pages, and in
general it just looks really odd to use an offset within a page as an
index, since in some patterns (linear accesses, whatever), the page
faults will always be to the beginning of the page, so index 0 ends up
being special.

What am I missing?

               Linus
