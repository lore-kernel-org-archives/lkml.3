Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaEOTgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:36:05 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49280 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaEOTgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:36:03 -0400
Message-ID: <537516DA.9010407@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 01:04:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] smp: Print more useful debug info upon receiving
 IPI on an offline CPU
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191259.19811.81032.stgit@srivatsabhat.in.ibm.com> <1400181576.5058.19.camel@joe-AO725>
In-Reply-To: <1400181576.5058.19.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051519-8878-0000-0000-00000C727CD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:49 AM, Joe Perches wrote:
> On Fri, 2014-05-16 at 00:43 +0530, Srivatsa S. Bhat wrote:
>> Today the smp-call-function code just prints a warning if we get an IPI on
>> an offline CPU. This info is sufficient to let us know that something went
>> wrong, but often it is very hard to debug exactly who sent the IPI and why,
>> from this info alone.
> []
>> diff --git a/kernel/smp.c b/kernel/smp.c
> []
>> @@ -185,14 +185,26 @@ void generic_smp_call_function_single_interrupt(void)
> []
>> -	entry = llist_del_all(&__get_cpu_var(call_single_queue));
>> -	entry = llist_reverse_order(entry);
>> +		/*
>> +		 * We don't have to use the _safe() variant here
>> +		 * because we are not invoking the IPI handlers yet.
>> +		 */
>> +		llist_for_each_entry(csd, entry, llist)
>> +			pr_warn("IPI callback %pS sent to offline CPU\n",
>> +				csd->func);
> 
> Perhaps add ratelimited?
> 

This entire scenario is expected to be _very_ infrequent, and even if
it happens, these prints will appear only once during the entire run
(note the use of the 'warned' variable to control that). So I don't think
ratelimiting is called for in this case.

Regards,
Srivatsa S. Bhat

