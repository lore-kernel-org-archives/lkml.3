Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaJJKYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:24:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaJJKYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:24:35 -0400
Date: Fri, 10 Oct 2014 12:24:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, linux-mips@linux-mips.org,
        Zubair.Kakakhel@imgtec.com, geert+renesas@glider.be,
        david.daney@cavium.com, paul.gortmaker@windriver.com, davidlohr@hp.com,
        macro@linux-mips.org, chenhc@lemote.com, richard@nod.at,
        zajec5@gmail.com, keescook@chromium.org, alex@alex-smith.me.uk,
        tglx@linutronix.de, blogic@openwrt.org, jchandra@broadcom.com,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        markos.chandras@imgtec.com, dengcheng.zhu@imgtec.com,
        manuel.lauss@gmail.com, akpm@linux-foundation.org,
        lars.persson@axis.com
Subject: Re: [PATCH v2 2/3] MIPS: Setup an instruction emulation in VDSO
 protected page instead of user stack
Message-ID: <20141010102406.GK10832@worktop.programming.kicks-ass.net>
References: <20141009195030.31230.58695.stgit@linux-yegoshin>
 <20141009200017.31230.69698.stgit@linux-yegoshin>
 <20141009224304.GA4818@jhogan-linux.le.imgtec.org>
 <543715D7.1020505@imgtec.com>
 <20141009234044.GB4818@jhogan-linux.le.imgtec.org>
 <5437232F.60800@imgtec.com>
 <20141010100334.GD4818@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010100334.GD4818@jhogan-linux.le.imgtec.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:03:34AM +0100, James Hogan wrote:
> Hi Leonid,
> 
> On Thu, Oct 09, 2014 at 05:07:11PM -0700, Leonid Yegoshin wrote:
> > On 10/09/2014 04:40 PM, James Hogan wrote:
> > > You could then avoid the whole stack and per-thread thing and just have
> > > a maximum of one emuframe dedicated to each thread or allocated on
> > > demand, and if there genuinely is a use case for nesting later on, worry
> > > about it then.
> > 
> > As I understand, you propose to allocate some space in mmap.
> 
> No, sorry if I wasn't very clear. I just mean that you can get away with
> a single kernel managed page per mm, with an emuframe allocated
> per-thread which that thread always uses, since they never nest, which I
> think simplifies the whole thing significantly.
> 
> The allocation could be smarter than that of course in case you have
> thousands of threads and only a subset doing lots of FP branches, but a
> single thread should never need more than one at a time since the new
> signal behaviour effectively makes the delay slot emulation sort of
> atomic from the point of view of usermode, and the kernel knows for sure
> whether BD emulation is in progress from the PC.
> 
> (If there is some other way than signals that I haven't taken into
> account that the emulation could be pre-empted then please let me know!)

Right, look at uprobes, it does exactly all this with a single page.
Slot allocation will block waiting for a free slot when all are in use.

If you need to support nesting, you need to do greedy slot allocation,
which is possible with limited nesting.
