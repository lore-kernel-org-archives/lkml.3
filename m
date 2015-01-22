Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbbAVFMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:12:30 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52779 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbbAVFMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:12:23 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 22 Jan 2015 14:13:21 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, cl@linux.com, brouer@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm/slub: use unchecked percpu access within preemptible
 sections
Message-ID: <20150122051321.GG21444@js1304-P5Q-DELUXE>
References: <1421814703-1869-1-git-send-email-sasha.levin@oracle.com>
 <20150122015904.GF21444@js1304-P5Q-DELUXE>
 <54C0601D.5050006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C0601D.5050006@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:27:41PM -0500, Sasha Levin wrote:
> On 01/21/2015 08:59 PM, Joonsoo Kim wrote:
> > On Tue, Jan 20, 2015 at 11:31:43PM -0500, Sasha Levin wrote:
> >> > Commit "mm/slub: optimize alloc/free fastpath by removing preemption on/off"
> >> > has added access to percpu memory while the code is preemptible.
> >> > 
> >> > While those accesses are okay, this creates a huge amount of warnings from
> >> > the code that checks for that.
> >> > 
> >> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > Hello,
> > 
> > I already sent the patch to fix this issue and it is in mmotm, but,
> > not be released yet.
> > 
> > https://lkml.org/lkml/2015/1/19/17
> 
> The patch you sent out still has the issue. The one I sent goes on top of
> it.
> 
> +	do {
> +		tid = this_cpu_read(s->cpu_slab->tid); <=== checked percpu access
> +		c = raw_cpu_ptr(s->cpu_slab);
> +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> 

Hello,

this_cpu_xxx() is designed to be called regardless of interrupts and
preemption.

In Documentation/this_cpu_ops.txt,

The following this_cpu() operations with implied preemption protection
are defined. These operations can be used without worrying about
preemption and interrupts.

        this_cpu_read(pcp)
        ...

And, for correctness of algorithm, tid should be fetched through
this_cpu_read() rather than raw_cpu_read(). Generic implementation of
raw_cpu_read() has a race window to fetch different cpu's tid instead
of the cpu where we are at now and this will cause algorithm broken.

Thanks.
