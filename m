Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaEWPcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:32:20 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47235 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaEWPcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:32:19 -0400
Message-ID: <537F69B7.20002@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 21:01:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@kernel.org, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, fweisbec@gmail.com, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v6 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com> <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com> <20140523152145.GF30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140523152145.GF30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052315-5564-0000-0000-00000DDC83AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 08:51 PM, Peter Zijlstra wrote:
> On Fri, May 23, 2014 at 03:42:20PM +0530, Srivatsa S. Bhat wrote:
>>        Re-enable interrupts                          Re-enable interrupts
>>
>>                                                      The pending IPI is noted
>>                                                      immediately, but alas,
>>                                                      the CPU is offline at
>>                                                      this point.
>>
> 
> So wasn't clear_local_APIC() (and the arch function __cpu_disable() in
> general) wipe all pending interrup state?
> 

Apparently not. Atleast powerpc explicitly re-enables only the IPIs.. 

A snippet from xics_migrate_irqs_away() in powerpc, which is called
in the cpu-disable phase:


/* Interrupts are disabled. */
void xics_migrate_irqs_away(void)
{
	[...]
	/* Reject any interrupt that was queued to us... */
	icp_ops->set_priority(0);

	[...]
	/* Allow IPIs again... */
	icp_ops->set_priority(DEFAULT_PRIORITY);

	for_each_irq_desc(virq, desc) {
		[...]
		/* We only need to migrate enabled IRQS */
		if (!desc->action)
			continue;

		[...]

		/* We need to get IPIs still. */
		if (irq == XICS_IPI || irq == XICS_IRQ_SPURIOUS)
			continue;
		[...]

}

But that said, it should have cleared any pending IPIs and allowed
only *new* IPIs (for whatever reason). Atleast the warning I hit
indicates that that didn't happen, and the old IPI really was taken
later.

Ben, Paul, any thoughts on this?

Regards,
Srivatsa S. Bhat

