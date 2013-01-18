Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3ARSwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:52:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3ARSwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:52:13 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HJMuRcDKq34A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RPfT3mj6-UMA:10 a=bJxBL_JUdif7w-WkzrQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358535129.7383.25.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v2] slub: Keep page and object in sync in
 slab_alloc_node()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Fri, 18 Jan 2013 13:52:09 -0500
In-Reply-To: <0000013c4eec1cbd-fb392b9f-b39e-4bcf-a043-2fa76fb8d35a-000000@email.amazonses.com>
References: <1358446258.23211.32.camel@gandalf.local.home>
	 <1358447864.23211.34.camel@gandalf.local.home>
	 <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com>
	 <1358458996.23211.46.camel@gandalf.local.home>
	 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com>
	 <1358462763.23211.57.camel@gandalf.local.home>
	 <1358464245.23211.62.camel@gandalf.local.home>
	 <1358464837.23211.66.camel@gandalf.local.home>
	 <1358468598.23211.67.camel@gandalf.local.home>
	 <1358468924.23211.69.camel@gandalf.local.home>
	 <0000013c4e1ea131-b8ab56b9-bfca-44fe-b5da-f030551194c9-000000@email.amazonses.com>
	 <1358521484.7383.8.camel@gandalf.local.home>
	 <1358524501.7383.17.camel@gandalf.local.home>
	 <0000013c4eec1cbd-fb392b9f-b39e-4bcf-a043-2fa76fb8d35a-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 18:29 +0000, Christoph Lameter wrote:
> On Fri, 18 Jan 2013, Steven Rostedt wrote:
> 
> > On Fri, 2013-01-18 at 10:04 -0500, Steven Rostedt wrote:
> >
> > Just to be more complete:
> >
> > > 	CPU0			CPU1
> > > 	----			----
> > 			c = __this_cpu_ptr(s->cpu_slab);
> > 			<migrates to CPU0>
> >
> > > <cpu fetches c->page>
> > 			<another task>
> >
> > > 			updates c->tid
> 
> We can avoid the above scenario by doing a cpu local fetch.
> 
> i.e.
> `	tid = this_cpu_read(s->cpu_slab->tid);

I'm curious to why not just add the preempt disable? It's rather quick
and avoids all this complex trickery, which is just prone to bugs. It
would make it much easier for others to review as well, and also keeps
the setting of page, objects and cpu_slab consistent with everything
else (which is assigned under preempt(irq)_disable).


> 
> 
> > > 			updates c->page
> > > 			updates c->freelist
> > > <cpu fetches c->tid>
> > > <cpu fetches c->freelist>
> > >
> > >   node_match() succeeds even though
> > >     current c->page wont
> > >
> >
> >  <migrates back to CPU 1>
> >
> > >  this_cpu_cmpxchg_double() only tests
> > >    the object (freelist) and tid, both which
> > >    will match, but the page that was tested
> > >    isn't the right one.
> > >
> >
> > Yes, it's very unlikely, but we are in the business of dealing with the
> > very unlikely. That's because in our business, the very unlikely is very
> > likely. Damn, I need to buy a lotto ticket!
> 
> Well, the consequence would be that an object from another node than
> desired will be allocated. Not that severe of an issue.

Yes, it's not that severe of an issue, but it is still incorrect code.
Why not just allocate on whatever node you want then? Why bother with
the check at all?

-- Steve


