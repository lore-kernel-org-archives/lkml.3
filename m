Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab3FROIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab3FROIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:08:01 -0400
Date: Tue, 18 Jun 2013 10:07:30 -0400
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [x86] only print out DR registers if they are not power-on
 defaults.
Message-ID: <20130618140730.GA1313@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20130618041132.GA23492@redhat.com>
 <20130618084356.GA13123@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618084356.GA13123@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:43:56AM +0200, Borislav Petkov wrote:
 > On Tue, Jun 18, 2013 at 12:11:32AM -0400, Dave Jones wrote:
 > > The DR registers are rarely useful when decoding oopses.
 > > With screen real estate during oopses at a premium, we can save two lines
 > > by only printing out these registers when they are set to something other
 > > than they power-on state.
 > 
 > Makes sense, except...
 > 
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > > diff -durpN '--exclude-from=/home/davej/.exclude' /home/davej/src/kernel/git-trees/linux/arch/x86/kernel/process_64.c linux-dj/arch/x86/kernel/process_64.c
 > > --- /home/davej/src/kernel/git-trees/linux/arch/x86/kernel/process_64.c	2013-05-01 10:02:52.064151923 -0400
 > > +++ linux-dj/arch/x86/kernel/process_64.c	2013-05-06 20:35:09.219868881 -0400
 > > @@ -105,11 +105,18 @@ void __show_regs(struct pt_regs *regs, i
 > >  	get_debugreg(d0, 0);
 > >  	get_debugreg(d1, 1);
 > >  	get_debugreg(d2, 2);
 > > -	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 > >  	get_debugreg(d3, 3);
 > >  	get_debugreg(d6, 6);
 > >  	get_debugreg(d7, 7);
 > > +
 > > +	/* Only print out debug registers if they are in their non-default state. */
 > > +	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
 > > +	    (d6 & ~DR6_RESERVED) && (d7 == 0x400))
 > 
 > ... I'm not sure about %dr6. So we're not dumping %dr6 when, a.o.
 > any of the bits in the bit slices [3:0], [15:13] are set (bit 12
 > is Read-As-Zero). Now those mean stuff like Breakpoint-Condition
 > Detected or Debug-Register-Access Detected and so on and I think this is
 > meaningful information.
 > 
 > So actually, we wouldn't want to dump %dr6 when its contents are its
 > default contents, i.e, 0xffff0ff0, i.e. the test should be:
 > 
 > 	(d6 == DR6_RESERVED)
 > 
 > no?

My intent here was to ignore cases where the reserved bits haven't been set.
I occasionally see DR6: 00000000fffe0ff0 for eg.

But maybe you're right, and that is a clue and is worth printing ?
I can't personally recall ever diagnosing a bug using those register dumps
in the last 15 years.

	Dave

