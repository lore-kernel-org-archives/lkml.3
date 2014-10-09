Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaJIXkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:40:51 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:44327 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJIXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:40:48 -0400
Date: Fri, 10 Oct 2014 00:40:44 +0100
From: James Hogan <james.hogan@imgtec.com>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <david.daney@cavium.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <richard@nod.at>, <zajec5@gmail.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <akpm@linux-foundation.org>, <lars.persson@axis.com>
Subject: Re: [PATCH v2 2/3] MIPS: Setup an instruction emulation in VDSO
 protected page instead of user stack
Message-ID: <20141009234044.GB4818@jhogan-linux.le.imgtec.org>
References: <20141009195030.31230.58695.stgit@linux-yegoshin>
 <20141009200017.31230.69698.stgit@linux-yegoshin>
 <20141009224304.GA4818@jhogan-linux.le.imgtec.org>
 <543715D7.1020505@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <543715D7.1020505@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leonid,

On Thu, Oct 09, 2014 at 04:10:15PM -0700, Leonid Yegoshin wrote:
> >> Small stack of emulation blocks is supported because nested traps are possible
> >> in MIPS32/64 R6 emulation mix with FPU emulation.
> > Could you please clarify how this nesting of emulation blocks could
> > happen now that signals are handled more cleanly.
> >
> > I.e. isn't the emuframe stuff only required for instructions in branch
> > delay slots, and branches shouldn't be in branch delay slots anyway, so
> > I don't get how they could nest.
> >
> It may be a case for mix of FPU and MIPS R6 emulations. I just keep both 
> emulators separate as much as possible but I assume that without prove 
> it may be stackable - some rollback is needed to join both and it may 
> (probably) cause a double emulation setup - dsemul may be called twice 
> for the same pair of instructions. I didn't see that yet, honestly and 
> you may be right.

If the only time they're used is for emulation of a branch delay slot
instruction which should never be another branch, and signals always
undo the emuframe before being handled (btw, should the BD bit in cause
get set if rewinding for signal handlers/gdb?), then it stands to reason
it should never nest.

You could then avoid the whole stack and per-thread thing and just have
a maximum of one emuframe dedicated to each thread or allocated on
demand, and if there genuinely is a use case for nesting later on, worry
about it then.

So long as the kernel handles a long sequence of sequential emulated
branches gracefully (not necessarily correctly).

Cheers
James
