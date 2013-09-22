Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3IVElO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 00:41:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:56259 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab3IVElM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 00:41:12 -0400
Message-ID: <1379824754.24090.11.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 22 Sep 2013 14:39:14 +1000
In-Reply-To: <523E4F8A.7020708@zytor.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-21 at 19:01 -0700, H. Peter Anvin wrote:
> On 09/21/2013 02:45 PM, Benjamin Herrenschmidt wrote:
> > 
> > I really don't like the "larger" irq stack ... probably because I can't
> > make it work easily :-) See my previous comment about how we get to
> > thread_info on ppc.
> > 
> 
> For the record, I intend to remove thread_info from the stack on x86 and
> instead merge it with task_struct as a single structure pointed to with
> a percpu variable.

Last I looked, our per-cpu codegen was pretty poor... but then we have
this "PACA" (somewhat arch specific per-cpu blob that is separate from
the rest of per-cpu because of a mix of historical reasons and the fact
that it has to be allocated in a specific part of memory at boot time)
which we point to directly via a GPR, so we could point to it via PACA.

How do you do your per-cpu on x86 ? On powerpc we struggle because we
try to dedicate a register (r13) to this PACA (the per-cpu offset hangs
off it), but we constantly run into issues where gcc copies r13 to
another register and then indexes off that, even accross
preempt_enable/disable sections, or worst such as saving/restoring from
the stack. We can't seem to get the compiler to treat it appropriately
as volatile.

Ben.


