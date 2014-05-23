Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaEWPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:19:24 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54265 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaEWPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:19:23 -0400
Message-ID: <537F66AF.30303@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 20:48:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@kernel.org, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com> <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com> <20140523132250.GA1768@localhost.localdomain> <537F5F0F.5050802@linux.vnet.ibm.com> <20140523151252.GE30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140523151252.GE30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052315-5816-0000-0000-00000E30E0AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 08:42 PM, Peter Zijlstra wrote:
> On Fri, May 23, 2014 at 08:15:35PM +0530, Srivatsa S. Bhat wrote:
>>>> +		 * During CPU offline, we don't want the other CPUs to send
>>>> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
>>>> +		 * disabled interrupts (because, then it will notice the IPIs
>>>> +		 * only after it has gone offline). We can prevent this by
>>>> +		 * making the other CPUs disable their interrupts first - that
>>>> +		 * way, they will run the stop-machine code with interrupts
>>>> +		 * disabled, and hence won't send IPIs after that point.
> 
> That's complete nonsense, you can send IPIs all you want with interrupts
> disabled.
> 

True, but that's not what the comment says. It says "you can't send IPIs
because you are running the *stop-machine* loop, because the stop-machine loop
doesn't send IPIs itself! The only possibility of sending IPIs from within
stop-machine is if that CPU can takes an interrupt and the *interrupt handler*
sends the IPI (like what the block layer used to do) - and we precisely avoid
that possibility by disabling interrupts. So no IPIs will be sent beyond
this point.

Regards,
Srivatsa S. Bhat

