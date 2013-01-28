Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3A1S4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:56:03 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:40212 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3A1S4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:56:01 -0500
Date: Mon, 28 Jan 2013 10:55:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128185552.GD22465@mtj.dyndns.org>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
 <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128184933.GC26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Mon, Jan 28, 2013 at 10:49:33AM -0800, Kent Overstreet wrote:
> Yeah. It'd be really nice if it was doable without synchronize_rcu(),
> but it'd definitely make get/put heavier.
> 
> Though, re. close() - considering we only need a synchronize_rcu() if
> the ref was in percpu mode, I wonder if that would be a dealbreaker. I
> have no clue myself.

The problem is that the performance drop (or latency increase) in
patheological cases would be catastrophic.  We're talking about
possibly quite a few millisecs of delay between each close().  When
done sequentially for large number of files, it gets ugly.  It becomes
a dangerous optimization to make.

> Getting rid of synchronize_rcu would basically require turning get and
> put into cmpxchg() loops - even in the percpu fastpath. However, percpu
> mode would still be getting rid of the shared cacheline contention, we'd
> just be adding another branch that can be safely marked unlikely() - and
> my current version has one of those already, so two branches instead of
> one in the fast path.

Or offer an asynchrnous interface so that high-frequency users don't
end up inserting synchronize_sched() between each call.  It makes the
interface more complex and further away from simple atomic_t
replacement tho.

Thanks.

-- 
tejun
