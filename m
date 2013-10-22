Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3JVREO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:04:14 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60750 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3JVREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:04:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzwRoM4w8mGqSeeVuDGhQgnnomu=vxoWC6dbHD9w-9A+Q@mail.gmail.com>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
	<20131022154802.GA25490@localhost>
	<CA+55aFzwRoM4w8mGqSeeVuDGhQgnnomu=vxoWC6dbHD9w-9A+Q@mail.gmail.com>
Date: Tue, 22 Oct 2013 10:04:12 -0700
Message-ID: <CANN689EyWqCsr2rDBtHohMYwXG81dny+iQBKSt4AWqjEWnUkow@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm,vdso: preallocate new vmas
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 9:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Oct 22, 2013 at 4:48 PM,  <walken@google.com> wrote:
>> Generally the problems I see with mmap_sem are related to long latency
>> operations. Specifically, the mmap_sem write side is currently held
>> during the entire munmap operation, which iterates over user pages to
>> free them, and can take hundreds of milliseconds for large VMAs.
>
> So this would be the *perfect* place to just downgrade the semaphore
> from a write to a read.

It's not as simple as that, because we currently rely on mmap_sem
write side being held during page table teardown in order to exclude
things like follow_page() which may otherwise access page tables while
we are potentially freeing them.

I do think it's solvable, but it gets complicated fast. Hugh & I have
been talking about it; the approach I'm looking at would involve
unwiring the page tables first (under protection of the mmap_sem write
lock) and then iterating on the unwired page tables to free the data
pages, issue TLB shootdowns and free the actual page tables (we
probably don't need even the mmap_sem read side at that point). But,
that's nowhere like a 10 line change anymore at that point...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
