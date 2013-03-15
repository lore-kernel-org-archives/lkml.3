Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3COCIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:08:17 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48005 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752574Ab3COCIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:08:16 -0400
Date: Thu, 14 Mar 2013 22:08:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Eric Wong <normalperson@yhbt.net>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
	Implementation
Message-ID: <20130315020812.GA25419@Krystal>
References: <20130311213602.GB9829@Krystal> <1363308584.3194.124.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363308584.3194.124.camel@thor.lan>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley (peter@hurleysoftware.com) wrote:
> On Mon, 2013-03-11 at 17:36 -0400, Mathieu Desnoyers wrote:
> > +/*
> > + * Do not put head and tail on the same cache-line if concurrent
> > + * enqueue/dequeue are expected from many CPUs. This eliminates
> > + * false-sharing between enqueue and dequeue.
> > + */
> > +struct wfcq_head {
> > +	struct wfcq_node node;
> > +	struct mutex lock;
> > +};
> > +
> > +struct wfcq_tail {
> > +	struct wfcq_node *p;
> > +};
> 
> 
> If you want to force separate cachelines for SMP, this would be
> 
> struct wfcq_head {
> 	struct wfcq_node node;
> 	struct mutex lock;
> } ____cacheline_aligned_in_smp;
> 
> struct wfcq_tail {
> 	struct wfcq_node *p;
> } ____cacheline_aligned_in_smp;

Well, the thing is: I don't want to force it. The queue head and tail
can be used in a few ways:

1) tail used by frequent enqueue on one CPU, head used for frequent
   dequeues on another CPU. In this case, we want head/tail on different
   cache lines.
2) same scenario as 1), but head and tail are placed in per-cpu data
   of the two CPUs. We don't need to align each structure explicitly.
3) tail and head used locally, e.g. on the stack, as splice destination
   followed by iteration or dequeue from the same CPU. We don't want to
   waste precious memory space in this case, so no alignment.

So as you see, only (1) actually requires explicit alignment of head and
tail.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
