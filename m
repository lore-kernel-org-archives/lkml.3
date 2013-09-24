Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3IXAL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:11:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:43529 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3IXAL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:11:57 -0400
Message-ID: <1379981427.5443.8.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>
Date: Tue, 24 Sep 2013 10:10:27 +1000
In-Reply-To: <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 15:22 -0700, Linus Torvalds wrote:
>  - use %r13 for the per-thread thread-info pointer instead. A
> per-thread pointer is *not* volatile like the per-cpu base is.

 .../...

> Alternatively, make %r13 point to the percpu side, but make sure that
> you always use an asm accessor to fetch the value. In particular, I
> think you need to make __my_cpu_offset be an inline asm that fetches
> %r13 into some other register. Otherwise you can never get it right.

BTW, that boils down to a choice between using r13 as either a TLS for
current or current_thread_info, or as a per-cpu pointer, which one is
the most performance critical ?

Now in the first case, it seems to me that using it as "current" rather
than "current_thread_info()" is a better idea since we access current a
LOT more overall in the kernel, from there we can find a way to put
thread_info into task struct (via thread struct maybe) to make it a
simple offset from current.

The big pro of that approach is of course that r13 becomes the TLS as
intended, and we can feel a lot more comfortable that we are "safe" vs.
whatever crazyness gcc will come up with next.

The flip side is that per-cpu will remain a load away, so getting the
address of a per-cpu variable would typically be a 3 instruction deal
involving a load and a pair of adds to get to the address, then the
actual per-cpu access proper. This is equivalent to what we have today
(we put the per-cpu offset in the PACA). Using r13 as per-cpu allows to
avoid that first load.

So what's the most worthwhile thing to do here ? I'm leaning toward 1,
ie, stick current in r13 and feel a lot safer about it (I won't have to
scrutinize generated code all over the place to convince myself things
aren't crossing the barriers), and if the thread_info is in the task
struct, that makes accessing it really trivial & fast as well.

Cheers,
Ben.


