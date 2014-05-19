Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbaESQT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:19:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbaESQTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:19:53 -0400
Date: Mon, 19 May 2014 18:18:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 UPDATEDv2 3/3] CPU hotplug, smp: Flush any pending
	IPI callbacks before CPU offline
Message-ID: <20140519161836.GA30387@redhat.com>
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com> <20140515191938.GB21306@htj.dyndns.org> <537514D3.4060308@linux.vnet.ibm.com> <20140515193656.GM4570@linux.vnet.ibm.com> <537518D6.6030006@linux.vnet.ibm.com> <5379F6BD.1090809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5379F6BD.1090809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Srivatsa S. Bhat wrote:
>
> However, an IPI sent much earlier might arrive late on the target CPU
> (possibly _after_ the CPU has gone offline) due to hardware latencies,
> and due to this, the smp-call-function callbacks queued on the outgoing
> CPU might not get noticed (and hence not executed) at all.

OK, but

> +void flush_smp_call_function_queue(void)
> +{
> +	struct llist_head *head;
> +	struct llist_node *entry;
> +	struct call_single_data *csd, *csd_next;
> +
> +	WARN_ON(!irqs_disabled());
> +
> +	head = &__get_cpu_var(call_single_queue);
> +
> +	if (likely(llist_empty(head)))
> +		return;
> +
> +	entry = llist_del_all(head);
> +	entry = llist_reverse_order(entry);
> +
> +	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
> +		csd->func(csd->info);
> +		csd_unlock(csd);
> +	}
> +}

why do we need it? Can't multi_cpu_stop() just call
generic_smp_call_function_single_interrupt() ? This cpu is still online,
we should not worry about WARN_ON(!cpu_online()) ?

Oleg.

