Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab3GSIYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:24:32 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56522 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3GSIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:24:26 -0400
Date: Fri, 19 Jul 2013 10:24:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Hunter <ahh@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] [PATCH] x86: avoid per_cpu for APIC id tables
Message-ID: <20130719082422.GA25787@gmail.com>
References: <1374090073-1957-1-git-send-email-ahh@google.com>
 <20130718065249.GA17622@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718065249.GA17622@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> [...]
> 
> Also, if the goal is to pack better then we could do even better than 
> that: we could create a 'struct x86_apic_ids':
> 
>   struct x86_apic_ids {
> 	u16 bios_apicid;
> 	u16 apicid;
> 	u32 logical_apicid;	/* NOTE: does this really have to be 32-bit? */
>   };
> 
> and put that into an explicit, [NR_CPUS] array. This preserves the tight 
> coupling between fields that PER_CPU offered, requiring only a single 
> cacheline fetch in the cache-cold case, while also giving efficient, 
> packed caching for cache-hot remote wakeups.
> 
> [ Assuming remote wakeups access all of these fields in the hot path to 
>   generate an IPI. Do they? ]
> 
> Also, this NR_CPUS array should be cache-aligned and read-mostly, to avoid 
> false sharing artifacts. Your current patch does not do either.

Btw., if you implement the changes I suggested and the patch still 
provides a robust 10% improvement in the cross-wakeup benchmark over the 
vanilla kernel then that will be a pretty good indication that it's the 
cache-hot layout and decreased indirection cost that makes the difference 
- and then we'd of course want to merge your patch upstream.

Also, a comment should be added to the new [NR_CPUS] array explaining that 
it's a special data structure that is almost always accessed from remote 
CPUs, and that for that reason PER_CPU accesses are sub-optimal: to 
prevent someone else from naively PER_CPU-ifying the [NR_CPUS] array later 
on ;-)

Thanks,

	Ingo
