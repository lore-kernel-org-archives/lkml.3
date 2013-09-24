Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3IXT1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:27:33 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:35011 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3IXT1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:27:31 -0400
Message-ID: <5241E7A1.3010800@tilera.com>
Date: Tue, 24 Sep 2013 15:27:29 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>  <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>  <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>  <20130920162603.GA30381@localhost.localdomain>  <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>  <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>  <1379799901.24090.6.camel@pasglop>	<523E4F8A.7020708@zytor.com>  <1379824754.24090.11.camel@pasglop>	<1379824861.24090.12.camel@pasglop>  <20130922162410.GA10649@laptop.programming.kicks-ass.net>  <1379887000.24090.19.camel@pasglop>  <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>  <5240819F.4050903@tilera.com> <1379969837.11249.24.camel@pasglop>
In-Reply-To: <1379969837.11249.24.camel@pasglop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2013 4:57 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-09-23 at 13:59 -0400, Chris Metcalf wrote:
>> We just came up against this on tilegx with a customer bug report in a
>> PREEMPT environment.  On tile, %tp is a GPR that points to the percpu area.
>> The following seems to be the right abstraction -- though I'd also argue
>> that letting barrier() clobber not just memory, but %tp, might be a better
>> solution, but it's not clear what the best way is to do per-architecture
>> overrides of per-compiler definitions like barrier().  See also the ARM v7
>> code, which has to do something similar, though their percpu pointer is
>> not a GPR, which changes the tradeoffs somewhat.
> Hrm, if I read correctly what you did is that you read "tp" into another
> register *and* also mark that action as clobbering the top int on the stack ?
>
> I don't quite get what the stack clobber brings you here and how it works
> around the fact that gcc might still cache that copy of tp into another
> register accross preempt_enable/disable...

Correct.  The idea is that since gcc knows that the outputs of the asm are
dependent on memory, when it sees a memory clobber it knows it has to
instantiate the asm again to get a new value of the asm outputs.  gcc will know
that any copies of tp in other registers are also dependent on memory and
will drop all of them across the barrier() as well.


> It's hard to tell with gcc ... the best I've had so far as an option was
> something that would mark my per-cpu register (r13) *itself* as clobbered...

Well, as I said above, that would be better, but it requires providing an
alternate definition of barrier() that is per-architecture, not just
per-compiler.  If there's interest in pursuing a solution like that, it
would be technically somewhat better; in particular, with PREEMPT_NONE,
you could treat the "tp" register int as locally scoped in an inline, and
the compiler wouldn't have to reload it after function calls.  Presumably
we'd need to pick an asm header that could provide an arch_barrier_clobbers
string that would be added to barrier() for gcc if it were defined.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

