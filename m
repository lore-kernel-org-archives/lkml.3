Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3AQXKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:10:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3AQXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:10:47 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1dK1Tq4abSwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=daFlbPKOXuoA:10 a=8fWfWLdYwF3g9vYamwQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358464245.23211.62.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] slub: Check for page NULL before doing the
 node_match check
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Thu, 17 Jan 2013 18:10:45 -0500
In-Reply-To: <1358462763.23211.57.camel@gandalf.local.home>
References: <1358446258.23211.32.camel@gandalf.local.home>
	 <1358447864.23211.34.camel@gandalf.local.home>
	 <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com>
	 <1358458996.23211.46.camel@gandalf.local.home>
	 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com>
	 <1358462763.23211.57.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 17:46 -0500, Steven Rostedt wrote:
> On Thu, 2013-01-17 at 21:51 +0000, Christoph Lameter wrote:
> 
> > This is dealing with the same cpu being interrupted. Some of these
> > segments are in interrupt disable sections so they are not affected.
> 
> Except that we are not always on the same CPU. Now I'm looking at
> mainline (non modified by -rt):

Because there's also nothing to keep page related to object either, we
may just need to do:


> 
> From slab_alloc_node():
> 
> 	/*
> 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
> 	 * enabled. We may switch back and forth between cpus while
> 	 * reading from one cpu area. That does not matter as long
> 	 * as we end up on the original cpu again when doing the cmpxchg.
> 	 */

	local_irq_save(flags);

> 	c = __this_cpu_ptr(s->cpu_slab);
> 
> 	/*
> 	 * The transaction ids are globally unique per cpu and per operation on
> 	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
> 	 * occurs on the right processor and that there was no operation on the
> 	 * linked list in between.
> 	 */
> 	tid = c->tid;
> 	barrier();
> 
> 	object = c->freelist;
> 	page = c->page;

	r = !object || !node_match(page, node);
	local_irq_restore(flags);

	if (unlikely(r)) {

> 		object = __slab_alloc(s, gfpflags, node, addr, c);
> 

I was thinking at first we could use preempt_disable(), but if an
interrupt comes in after we set object = c->freelist, and changes
c->page, then we disassociate the freelist and page again.

-- Steve


