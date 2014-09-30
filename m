Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaI3EgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:36:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54452 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaI3EgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:36:01 -0400
Date: Tue, 30 Sep 2014 05:35:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe/page fault oddness.
Message-ID: <20140930043556.GS7996@ZenIV.linux.org.uk>
References: <20140930033327.GA14558@redhat.com>
 <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 09:27:09PM -0700, Linus Torvalds wrote:
> On Mon, Sep 29, 2014 at 8:33 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > Looking at the dump, there's only one running trinity child,
> > with all the others blocking on it.
> >
> > trinity-c49     R  running task    12856 19464   7633 0x00000004
> > ffff8800a09bf960 0000000000000002 ffff8800a09bf9f8 ffff880219650000
> > 00000000001d4080 0000000000000000 ffff8800a09bffd8 00000000001d4080
> > ffff88023f755bc0 ffff880219650000 ffff8800a09bffd8 ffff88010b017e00
> > Call Trace:
> > [<ffffffff911c3c67>] handle_mm_fault+0x3a7/0xcd0
> > [<ffffffff91042c84>] __do_page_fault+0x1a4/0x600
> > [<ffffffff910430fe>] do_page_fault+0x1e/0x70
> > [<ffffffff918264b2>] page_fault+0x22/0x30
> > [<ffffffff911bd7e3>] ? copy_page_to_iter+0x3b3/0x500
> > [<ffffffff9120eddf>] pipe_read+0xdf/0x330
> >
> > Running the function tracer on that pid shows it spinning forever..
> > http://codemonkey.org.uk/junk/pipe-trace.txt
> >
> > Kernel bug (missing EFAULT check somewhere perhaps?), or is this a
> > case where the fuzzer asked the kernel to do something stupid, and it obliged ?
> 
> Hmm. It looks like copy_page_to_iter_iovec() is broken and keeps not
> making any progress while just faulting.
> 
> I don't see how that could happen, though. All the loops there are
> conditional on the user copies *not* failing (ie "!left"), and they
> seem to properly update "iov".
> 
> Mind sending a disassembly of your "copy_page_to_iter" function, in
> particular around that whole "0x3b3/0x500" area which is where the
> page fault seems to happen?
> 
> Adding Al to the cc, since this code is from his commit 6e58e79db8a1
> ("introduce copy_page_to_iter, kill loop over iovec in
> generic_file_aio_read()") but I don't see anything obviously wrong
> there.
> 
> Al? Do you see something I don't? Dave's function trace does seem to
> say that it doesn't even get back to pipe_read(), though, so the loop
> really must be inside copy_page_to_iter().

I'll take a look tomorrow morning after I get some sleep - 19 hours of uptime,
on top of 5 hours of sleep, on top of ~20 hours of uptime ;-/
