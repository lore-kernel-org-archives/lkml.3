Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaI2T5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:57:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:53882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaI2T5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:57:02 -0400
Date: Mon, 29 Sep 2014 21:57:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andy Lutomirski <luto@amacapital.net>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
In-Reply-To: <5429B664.4060003@zytor.com>
Message-ID: <alpine.DEB.2.02.1409292152270.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de> <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com>
 <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de> <5429B664.4060003@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, H. Peter Anvin wrote:
> On 09/29/2014 12:41 PM, Thomas Gleixner wrote:
> >>
> >> If it weren't the case, then we'd be totally screwed.  Fortunately, it
> >> is.  I found it: SDM Volume 3 6.12.1.2 says:
> >>
> >> (On calls to exception and interrupt
> >> handlers, the processor also clears the VM, RF, and NT flags in the
> >> EFLAGS register,
> >> after they are saved on the stack.)
> > 
> > Sorry, I misunderstood your question.
> > 
> > And yes on exception and interrupt entry it is cleared. Otherwise the
> > whole feature would not work at all ...
> > 
> > But that's why I'm really not worried about it. While we can mask out
> > the stupid bit easily, it does not provide any value except protecting
> > silly userspace from rightfully raised exceptions.
> > 
> > When I first saw that patch, I was worried about the security impact,
> > but after staring long enough at the SDM and the code, the only way it
> > can explode is when returning to user space. It cannot explode in the
> > kernel.
> > 
> > So in IA-32e it creates a #GP otherwise it falls over the return to
> > NULL (TSS.back_link). So what?
> > 
> 
> How about "it's a bug, but it's not (necessarily) a security issue?"

It's a bug in user space, but as I explained it is NOT a security
issue because the only place it can explode is the return to the buggy
user space code via IRET.

If we start to use IRET in the kernel for random crap where we should
not, then its better we trap over the stupid NT bit as well.
 
> I think we should mask the bit anyway.

I tend to disagree. If we clear it there we need to consequentely
audit ALL other possibilites and if there are any we need to clear the
bit there as well. Just to make buggy user space happy?

Thanks,

	tglx
