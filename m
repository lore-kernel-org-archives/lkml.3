Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaJUIMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:12:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaJUIMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:12:10 -0400
Date: Tue, 21 Oct 2014 10:11:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
Message-ID: <20141021081159.GK23531@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <5445A3A6.2@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5445A3A6.2@amacapital.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 05:07:02PM -0700, Andy Lutomirski wrote:
> On 10/20/2014 02:56 PM, Peter Zijlstra wrote:
> > Hi,
> > 
> > I figured I'd give my 2010 speculative fault series another spin:
> > 
> >   https://lkml.org/lkml/2010/1/4/257
> > 
> > Since then I think many of the outstanding issues have changed sufficiently to
> > warrant another go. In particular Al Viro's delayed fput seems to have made it
> > entirely 'normal' to delay fput(). Lai Jiangshan's SRCU rewrite provided us
> > with call_srcu() and my preemptible mmu_gather removed the TLB flushes from
> > under the PTL.
> > 
> > The code needs way more attention but builds a kernel and runs the
> > micro-benchmark so I figured I'd post it before sinking more time into it.
> > 
> > I realize the micro-bench is about as good as it gets for this series and not
> > very realistic otherwise, but I think it does show the potential benefit the
> > approach has.
> 
> Does this mean that an entire fault can complete without ever taking
> mmap_sem at all?  If so, that's a *huge* win.

Yep.

> I'm a bit concerned about drivers that assume that the vma is unchanged
> during .fault processing.  In particular, is there a race between .close
> and .fault?  Would it make sense to add a per-vma rw lock and hold it
> during vma modification and .fault calls?

VMA granularity contention would be about as bad as mmap_sem for many
workloads. But yes, that is one of the things we need to look at, I was
_hoping_ that holding the file open would sort most these problems, but
I'm sure there plenty 'interesting' cruft left.
