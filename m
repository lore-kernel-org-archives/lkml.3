Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaL3TDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:03:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaL3TDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:03:36 -0500
Date: Tue, 30 Dec 2014 20:03:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        root <chenggang.qin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>, jolsa@redhat.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: =?utf-8?B?562U5aSN77yaW1BBVENIXSBwZXJm?= =?utf-8?Q?_core=3A_Us?=
 =?utf-8?Q?e?= KSTK_ESP() instead of pt_regs->sp while output user regs
Message-ID: <20141230190327.GB23965@worktop.programming.kicks-ass.net>
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
 <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 07:48:28AM -0800, Andy Lutomirski wrote:
> On a quick look, there are plenty of other bugs in there besides just
> the stack pointer issue.  The ABI check that uses TIF_IA32 in the perf
> core is completely wrong.  TIF_IA32 may be equal to the actual
> userspace bitness by luck, but, if so, that's more or less just luck.
> And there's a user_mode test that should be user_mode_vm.
> 
> Also, it's not just sp that's wrong.  There are various places that
> you can interrupt in which many of the registers have confusing
> locations.  You could try using the cfi unwind data, but that's
> unlikely to work for regs like cs and ss, and, during context switch,
> this has very little chance of working.
> 
> What's the point of this feature?  Honestly, my suggestion would be to
> delete it instead of trying to fix it.  It's also not clear to me that
> there aren't serious security problems here -- it's entirely possible
> for sensitive *kernel* values to and up in task_pt_regs at certain
> times, and if you run during context switch and there's no code to
> suppress this dump during context switch, then you could be showing
> regs that belong to the wrong task.

Of course the people who actually wrote the code are not on CC :/

There's two users of this iirc;

 1) the dwarf stack unwinder thingy, which basically dumps the userspace
 regs and the top of userspace stack on 'event'.

 2) the recent sample_regs_intr, which dumps the register set at
 'event', be it kernel or userspace.


The first is somewhat usable when lacking framepointers while still
desiring some unwind information, the second is useful to things like
call argument profiling and the like.
