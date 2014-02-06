Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaBFCcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 21:32:54 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:34704 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaBFCcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 21:32:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140206005534.GA27848@node.dhcp.inet.fi>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
	<20140206005534.GA27848@node.dhcp.inet.fi>
Date: Wed, 5 Feb 2014 18:32:51 -0800
X-Google-Sender-Auth: 8EMO4gzLvQfFaQwxfpQdFon4sQU
Message-ID: <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 4:55 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> One thing that could help is THP for file-backed pages. And there's
> prototype with basic infrasturure and support for ramfs and
> shmem/tmpfs (by Ning Qu). Work in progress.

THP isn't really realistic for any general-purpose loads. 2MB pages
are just too big of a granularity.

On a machine with just a few gigs (ie anything but big servers), you
count the number of large pages in a few thousands. That makes
fragmentation a big issue. Also, ELF sections aren't actually
2MB-aligned, nor do you really want to throw away 9 bits of virtual
address space randomization. Plus common binaries aren't even big
enough. Look at "bash", which is a pig - it's still less than a
megabyte as just the binary, with the code segment being 900kB or so
for me. For something like "perl", it's even smaller, with a number of
shared object files that get loaded dynamically etc.

IOW, THP is completely useless for any kind of scripting. It can be
good for individual large binaries that have long lifetimes (DB
processes, HPC, stuff like that), but no, it is *not* the answer to
complex loads. And almost certainly never will be.

It's possible that some special case (glibc for example) could be
reasonably hacked to use a THP code segment, but that sounds unlikely.
And the virtual address randomization really gets hurt.

No, I was thinking "try to optimistically map 8 adjacent aligned pages
at a time" - that would be the same cacheline in the page tables, so
it would be fairly cheap if we couple it with a gang-lookup of the
pages in the page cache (or, for anonymous pages, by just
optimistically trying to do an order-3 page allocation, and if that
works, just map the 32kB allocation you got as eight individual
pages).

I know it's been discussed at some point, and I even have a dim memory
of having seen some really ugly patches.

             Linus
