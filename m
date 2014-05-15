Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaEOToE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:44:04 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:39696 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752025AbaEOToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:44:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2693:2828:3138:3139:3140:3141:
X-HE-Tag: river85_46eaaa781940
X-Filterd-Recvd-Size: 2782
Message-ID: <1400183029.5058.21.camel@joe-AO725>
Subject: Re: [PATCH v5 1/3] smp: Print more useful debug info upon receiving
 IPI on an offline CPU
From: Joe Perches <joe@perches.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 12:43:49 -0700
In-Reply-To: <537516DA.9010407@linux.vnet.ibm.com>
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
	 <20140515191259.19811.81032.stgit@srivatsabhat.in.ibm.com>
	 <1400181576.5058.19.camel@joe-AO725> <537516DA.9010407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 01:04 +0530, Srivatsa S. Bhat wrote:
> On 05/16/2014 12:49 AM, Joe Perches wrote:
> > On Fri, 2014-05-16 at 00:43 +0530, Srivatsa S. Bhat wrote:
> >> Today the smp-call-function code just prints a warning if we get an IPI on
> >> an offline CPU. This info is sufficient to let us know that something went
> >> wrong, but often it is very hard to debug exactly who sent the IPI and why,
> >> from this info alone.
> > []
> >> diff --git a/kernel/smp.c b/kernel/smp.c
> > []
> >> @@ -185,14 +185,26 @@ void generic_smp_call_function_single_interrupt(void)
> > []
> >> -	entry = llist_del_all(&__get_cpu_var(call_single_queue));
> >> -	entry = llist_reverse_order(entry);
> >> +		/*
> >> +		 * We don't have to use the _safe() variant here
> >> +		 * because we are not invoking the IPI handlers yet.
> >> +		 */
> >> +		llist_for_each_entry(csd, entry, llist)
> >> +			pr_warn("IPI callback %pS sent to offline CPU\n",
> >> +				csd->func);
> > 
> > Perhaps add ratelimited?
> > 
> 
> This entire scenario is expected to be _very_ infrequent, and even if
> it happens, these prints will appear only once during the entire run
> (note the use of the 'warned' variable to control that). So I don't think
> ratelimiting is called for in this case.

Ah, good.

I was misled a bit by the WARN_ONCE that is in the
same block.  Perhaps because there is a guard flag
above the block, maybe the WARN_ONCE should just be
WARN.


