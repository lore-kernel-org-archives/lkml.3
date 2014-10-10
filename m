Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaJJKDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:03:42 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:51966 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaJJKDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:03:38 -0400
Date: Fri, 10 Oct 2014 11:03:34 +0100
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
Message-ID: <20141010100334.GD4818@jhogan-linux.le.imgtec.org>
References: <20141009195030.31230.58695.stgit@linux-yegoshin>
 <20141009200017.31230.69698.stgit@linux-yegoshin>
 <20141009224304.GA4818@jhogan-linux.le.imgtec.org>
 <543715D7.1020505@imgtec.com>
 <20141009234044.GB4818@jhogan-linux.le.imgtec.org>
 <5437232F.60800@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5437232F.60800@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leonid,

On Thu, Oct 09, 2014 at 05:07:11PM -0700, Leonid Yegoshin wrote:
> On 10/09/2014 04:40 PM, James Hogan wrote:
> > You could then avoid the whole stack and per-thread thing and just have
> > a maximum of one emuframe dedicated to each thread or allocated on
> > demand, and if there genuinely is a use case for nesting later on, worry
> > about it then.
> 
> As I understand, you propose to allocate some space in mmap.

No, sorry if I wasn't very clear. I just mean that you can get away with
a single kernel managed page per mm, with an emuframe allocated
per-thread which that thread always uses, since they never nest, which I
think simplifies the whole thing significantly.

The allocation could be smarter than that of course in case you have
thousands of threads and only a subset doing lots of FP branches, but a
single thread should never need more than one at a time since the new
signal behaviour effectively makes the delay slot emulation sort of
atomic from the point of view of usermode, and the kernel knows for sure
whether BD emulation is in progress from the PC.

(If there is some other way than signals that I haven't taken into
account that the emulation could be pre-empted then please let me know!)

> > So long as the kernel handles a long sequence of sequential emulated
> > branches gracefully (not necessarily correctly).
> >
> I don't understand a question. Each pair/single instruction is emulated 
> separately but there is some pipeline of that, even in FPU emulator, it 
> is just not this patch issue.

I just mean an (illegal/undefined) sequence of FPU branch instructions
in one anothers delay slots shouldn't be able to crash the kernel.

Actually 2 of them would be enough to verify the kernel didn't get too
confused. Maybe the second will be detected & ignored, or maybe it
doesn't matter if the first emuframe gets overwritten by the second one
from the kernels point of view.

Cheers
James
