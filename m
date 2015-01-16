Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbbAPBaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:30:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:62770 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753405AbbAPBaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:30:24 -0500
Date: Thu, 15 Jan 2015 20:30:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by
 removing preemption on/off
Message-ID: <20150115203045.00e9fb73@grimm.local.home>
In-Reply-To: <20150115171634.685237a4.akpm@linux-foundation.org>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20150115171634.685237a4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 17:16:34 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > I saw roughly 5% win in a fast-path loop over kmem_cache_alloc/free
> > in CONFIG_PREEMPT. (14.821 ns -> 14.049 ns)
> 
> I'm surprised.  preempt_disable/enable are pretty fast.  I wonder why
> this makes a measurable difference.  Perhaps preempt_enable()'s call
> to preempt_schedule() added pain?

profiling function tracing I discovered that accessing preempt_count
was actually quite expensive, even just to read. But it may not be as
bad since Peter Zijlstra converted preempt_count to a per_cpu variable.
Although, IIRC, the perf profiling showed the access to the %gs
register was where the time consuming was happening, which is what
I believe per_cpu variables still use.

-- Steve
