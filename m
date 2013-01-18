Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3ARTUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:20:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3ARTUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:20:37 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cyUn3qz5vA4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RPfT3mj6-UMA:10 a=N8q07LOnDHBArjjbhnUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358536835.7383.31.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v3] slub: Keep page and object in sync in
 slab_alloc_node()
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Fri, 18 Jan 2013 14:20:35 -0500
In-Reply-To: <1358536190.11051.573.camel@edumazet-glaptop>
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
	 <1358521791.7383.11.camel@gandalf.local.home>
	 <0000013c4ef61783-2778b0f1-fdc1-421b-9d3e-ccd68d528115-000000@email.amazonses.com>
	 <1358536190.11051.573.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 11:09 -0800, Eric Dumazet wrote:
> On Fri, 2013-01-18 at 18:40 +0000, Christoph Lameter wrote:
> 
> > The fetching of the tid is the only critical thing here. If the tid is
> > retrieved from the right cpu then the cmpxchg will fail if any changes
> > occured to freelist or the page variable.
> > 
> > The tid can be retrieved without disabling preemption through
> > this_cpu_read().
> 
> Strictly speaking, this_cpu_read() _does_ disable preemption.

I was thinking the same thing.

> 
> Of course, on x86, this_cpu_read() uses __this_cpu_read()


Looking at using this_cpu_read() on tid, I can't see what would break.
We still need the check for page being NULL in node_match(). I'm still
uneasy about it. Just because we can't see how it might break doesn't
mean that it wont. As we have already found a bit of bugs in the current
code. I'd feel more comfortable with the explicit preempt_disable(). And
this is coming from an -rt guy that tries to avoid preempt_disable().
But you're (Christoph) the maintainer.

I guess if you use this_cpu_read() you don't need that barrier anymore.

-- Steve


