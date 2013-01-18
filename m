Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3ARSkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:40:20 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:31394 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab3ARSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:40:17 -0500
Date: Fri, 18 Jan 2013 18:40:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RFC][PATCH v3] slub: Keep page and object in sync in
 slab_alloc_node()
In-Reply-To: <1358521791.7383.11.camel@gandalf.local.home>
Message-ID: <0000013c4ef61783-2778b0f1-fdc1-421b-9d3e-ccd68d528115-000000@email.amazonses.com>
References: <1358446258.23211.32.camel@gandalf.local.home> <1358447864.23211.34.camel@gandalf.local.home> <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com> <1358458996.23211.46.camel@gandalf.local.home>
 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com> <1358462763.23211.57.camel@gandalf.local.home> <1358464245.23211.62.camel@gandalf.local.home> <1358464837.23211.66.camel@gandalf.local.home> <1358468598.23211.67.camel@gandalf.local.home>
 <1358468924.23211.69.camel@gandalf.local.home> <1358521791.7383.11.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013, Steven Rostedt wrote:

> @@ -2337,7 +2337,10 @@ redo:
>  	 * enabled. We may switch back and forth between cpus while
>  	 * reading from one cpu area. That does not matter as long
>  	 * as we end up on the original cpu again when doing the cmpxchg.
> +	 *
> +	 * But we need to sync the setting of page and object.
>  	 */
> +	preempt_disable();
>  	c = __this_cpu_ptr(s->cpu_slab);
>
>  	/*
> @@ -2347,10 +2350,14 @@ redo:
>  	 * linked list in between.
>  	 */
>  	tid = c->tid;

The fetching of the tid is the only critical thing here. If the tid is
retrieved from the right cpu then the cmpxchg will fail if any changes
occured to freelist or the page variable.

The tid can be retrieved without disabling preemption through
this_cpu_read().
