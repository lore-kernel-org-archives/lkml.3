Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbaAIVL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:11:26 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:48008 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaAIVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:11:19 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 16:11:19 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/lkml
Cc: Sergio Durigan Junior <sergiodj@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
In-Reply-To: Oleg Nesterov's message of  Tuesday, 7 January 2014 16:30:36 +0100 <20140107153036.GA4749@redhat.com>
References: <m3wqic205t.fsf@redhat.com>
	<20140107153036.GA4749@redhat.com>
X-Shopping-List: (1) Optimistic whips
   (2) Joyous food splits
   (3) Imported Baltic ghost-melts
Message-Id: <20140109210456.A3B0574425@topped-with-meat.com>
Date: Thu,  9 Jan 2014 13:04:56 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.1 cv=Zsx+dbLG c=1 sm=1 tr=0
		a=WkljmVdYkabdwxfqvArNOQ==:117 a=14OXPxybAAAA:8 a=Pmu-sk8uLEkA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=gZUHmhi39p4A:10
		a=2CnBpj5XRpv_2wmykV8A:9 a=4Fsy7JEMdGvxXIwj:21 a=lU2lcuMxN2n-zh5c:21
		a=CjuIK1q_8ugA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I won't argue, but it is not clear to me if this is really useful,
> given that the debugger can read the regs.

I do see the utility of having a consistent machine-independent way to get
the syscall number from userspace.  But note that this could be probably
accomplished with just a uapi header change, providing an inline or macro
to extract the syscall number from the regset data.  (It was once the case
that there were some machines where the syscall number is not in any
register and has to be extracted by decoding the instruction.  I'm not sure
if that is still an issue anywhere.)

Also note that adding a separate copy of the syscall number introduces a
new wrinkle into the interface.  This might be considered to be good, bad,
or indifferent, but I think it should at least be considered explicitly.
That is, at the entry stop the syscall number (when it's in a register) can
be changed via ptrace.  So if the number is delivered via ptrace_message,
that's a separate copy of the original number that does not reflect any
changes made via ptrace--so it reflects what userland asked for, as opposed
to what the kernel actually acted on.

I don't have a particular opinion about which way to go with that.
I just wanted all the issues (I'm aware of) to be considered.

I absolutely concur that all new tracing features should work in the
existing style of PTRACE_EVENT_* that a PTRACE_O_* flag enables it and
then it applies for all kinds of running under ptrace.  Things like
PTRACE_SYSCALL that combine what-to-report with how-to-run are terrible
and should never be done again.


Thanks,
Roland
