Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbaGRWuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:50:12 -0400
Received: from infernal.debian.net ([176.28.9.132]:51118 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbaGRWuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:50:10 -0400
Date: Sat, 19 Jul 2014 00:50:05 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-ID: <20140718225005.GA17140@amos.fritz.box>
References: <20140628225050.GA3484@amos.fritz.box>
 <20140714083527.GA30550@quack.suse.cz>
 <20140716213408.GA8749@amos.fritz.box>
 <20140717083137.GA1649@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717083137.GA1649@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:31:37AM +0200, Jan Kara wrote:
> On Wed 16-07-14 23:34:08, Andreas Bombe wrote:
> > On Mon, Jul 14, 2014 at 10:35:27AM +0200, Jan Kara wrote:
> > > On Sun 29-06-14 00:50:50, Andreas Bombe wrote:
> > > > None of the post 3.15 kernel boot for me. They all hang at the GRUB
> > > > screen telling me it loaded and started the kernel, but the kernel
> > > > itself stops before it prints anything (or even replaces the GRUB
> > > > background graphics).
> > > > 
> > > > I bisected it down to 939f04bec1a4ef6ba4370b0f34b01decc844b1b1 "printk:
> > > > enable interrupts before calling console_trylock_for_printk()".
> > > > Reverting that patch on the latest kernel (git 24b414d5a7) allows me to
> > > > boot normally. I fixed the conflict in the revert by leaving in the "if
> > > > (in_sched) return printed_len;".
> > > > 
> > > > I have the "early printk via the EFI framebuffer" option enabled,
> > > > disabling it made no difference however.
> > >   Thanks for report. I've been on vacation so I'm replying with a delay. I
> > > believe this is one of the issues where this patch just uncovers underlying
> > > problem - I belive lockdep tries to report some locking issue in console
> > > driver code (this patch increased lockdep coverage of console driver code)
> > > however we are holding some locks in printk code which make lockdep
> > > deadlock. Can you try running with the attached patch?
> > 
> > EUNABLE
> > 
> > You forgot to attach a patch.
>   Bah, sorry. Attaching now.

I don't see anything in /sys/kernel/debug/tracing/trace_pipe or
.../trace (besides the header) with your patch applied. In case you
meant to test it with the problematic printk change, I also tried with
the revert reverted. That still hangs as before without any error report
to see.

I checked the kernel logs and there is also no lockdep report anywhere.
I get the "trace_printk() being used" notice but nothing else of
interest around there. Though the notice should mean trace_printk() was
used at least once?
