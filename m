Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3JaXxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:53:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42238 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3JaXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:53:42 -0400
Date: Thu, 31 Oct 2013 23:53:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address
	space
Message-ID: <20131031235329.GK16735@n2100.arm.linux.org.uk>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com> <20131031154311.e65d16d79ba540ced736413b@linux-foundation.org> <20131031225022.GJ16735@n2100.arm.linux.org.uk> <20131031155831.4dce58a80c621cf450967de0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031155831.4dce58a80c621cf450967de0@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:58:31PM -0700, Andrew Morton wrote:
> On Thu, 31 Oct 2013 22:50:22 +0000 Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Thu, Oct 31, 2013 at 03:43:11PM -0700, Andrew Morton wrote:
> > > On Mon, 28 Oct 2013 23:48:59 +0800 Ming Lei <tom.leiming@gmail.com> wrote:
> > > 
> > > > This patch uses CONFIG_PAGE_OFFSET to filter symbols which
> > > > are not in kernel address space because these symbols are
> > > > generally for generating code purpose and can't be run at
> > > > kernel mode, so we needn't keep them in /proc/kallsyms.
> > > > 
> > > > For example, on ARM there are some symbols which are
> > > > linked in relocatable code section, then perf can't parse
> > > > symbols any more from /proc/kallsyms, and this patch fixes
> > > > the problem.
> > > 
> > > This is a non-back-compatible change and I'd like to see a much
> > > stronger assurance that it is safe to merge and will not break any
> > > existing application on the planet, please.
> > > 
> > > For a start, please describe with great precision what these excluded
> > > symbols are (examples would help) and explain why no application will
> > > conceivably have had any use for them.
> > 
> > These symbols are used to build what is relocatable code; the code which
> > ends up being placed in the machine vectors and the following page.
> > 
> > Rather than have to manually calculate them, I merged a patch which used
> > the tools we have, namely the assembler and linker, to do the job for us.
> 
> OK.  Do you recall which patch that was?  And is it the case that this
> patch excludes only the symbols which that patch accidentally added?

It's not a case of "accidentally added" - as we include all symbols in
kallsyms which are marked as text/data etc, irrespective of whether they
are local or global.

b9b32bf70f2fb made the change, backported to stable trees.  e39e3f3ebfef
depended on that change so that it could get at the correct offset to
copy FIQ code.

Both commits are part of closing an information leak from the kernel
as part of a security report back in July.
