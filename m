Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3JaW6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:58:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3JaW6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:58:32 -0400
Date: Thu, 31 Oct 2013 15:58:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address
 space
Message-Id: <20131031155831.4dce58a80c621cf450967de0@linux-foundation.org>
In-Reply-To: <20131031225022.GJ16735@n2100.arm.linux.org.uk>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
	<20131031154311.e65d16d79ba540ced736413b@linux-foundation.org>
	<20131031225022.GJ16735@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 22:50:22 +0000 Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Oct 31, 2013 at 03:43:11PM -0700, Andrew Morton wrote:
> > On Mon, 28 Oct 2013 23:48:59 +0800 Ming Lei <tom.leiming@gmail.com> wrote:
> > 
> > > This patch uses CONFIG_PAGE_OFFSET to filter symbols which
> > > are not in kernel address space because these symbols are
> > > generally for generating code purpose and can't be run at
> > > kernel mode, so we needn't keep them in /proc/kallsyms.
> > > 
> > > For example, on ARM there are some symbols which are
> > > linked in relocatable code section, then perf can't parse
> > > symbols any more from /proc/kallsyms, and this patch fixes
> > > the problem.
> > 
> > This is a non-back-compatible change and I'd like to see a much
> > stronger assurance that it is safe to merge and will not break any
> > existing application on the planet, please.
> > 
> > For a start, please describe with great precision what these excluded
> > symbols are (examples would help) and explain why no application will
> > conceivably have had any use for them.
> 
> These symbols are used to build what is relocatable code; the code which
> ends up being placed in the machine vectors and the following page.
> 
> Rather than have to manually calculate them, I merged a patch which used
> the tools we have, namely the assembler and linker, to do the job for us.

OK.  Do you recall which patch that was?  And is it the case that this
patch excludes only the symbols which that patch accidentally added?

> Unfortunately, these symbols have ended up in kallsyms, which various
> programs read, and having symbols down at the lower 8k is not what they
> expect.

> What it means is we don't have to play these kinds of games in the
> assembler:
> 
> -       .equ    stubs_offset, __vectors_start + 0x1000 - __stubs_start
>  __vectors_start:
> -       W(b)    vector_rst + stubs_offset
> -       W(b)    vector_und + stubs_offset
> -       W(ldr)  pc, .LCvswi + stubs_offset
> -       W(b)    vector_pabt + stubs_offset
> -       W(b)    vector_dabt + stubs_offset
> -       W(b)    vector_addrexcptn + stubs_offset
> -       W(b)    vector_irq + stubs_offset
> -       W(b)    vector_fiq + stubs_offset
> 
> where each vector_* symbol is located at an address greater than
> __stubs_start.  Here's the obvious question: can you understand what's
> going on with all that?

Nope ;)
