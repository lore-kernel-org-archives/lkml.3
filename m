Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaFSNbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:31:10 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:56272 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaFSNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:31:08 -0400
Date: Thu, 19 Jun 2014 09:31:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: cl@linux-foundation.org, kmo@daterainc.com, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 6/6] percpu-refcount: implement percpu_ref_reinit()
 and percpu_ref_is_zero()
Message-ID: <20140619133104.GH11042@htj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <20140619022055.GD20100@mtj.dyndns.org>
 <53A25286.1030003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A25286.1030003@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 11:01:26AM +0800, Lai Jiangshan wrote:
> > +	/*
> > +	 * Restore per-cpu operation.  smp_store_release() is paired with
> > +	 * smp_load_acquire() in __pcpu_ref_alive() and guarantees that the
> 
> s/smp_load_acquire()/smp_read_barrier_depends()/

Will update.

> s/smp_store_release()/smp_mb()/  if you accept my next comment.
>
> > +	 * zeroing is visible to all percpu accesses which can see the
> > +	 * following PCPU_REF_DEAD clearing.
> > +	 */
> > +	for_each_possible_cpu(cpu)
> > +		*per_cpu_ptr(pcpu_count, cpu) = 0;
> > +
> > +	smp_store_release(&ref->pcpu_count_ptr,
> > +			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
> 
> I think it would be better if smp_mb() is used.

smp_wmb() would be better here.  We don't need the reader side.

> it is documented that smp_read_barrier_depends() and smp_mb() are paired.
> Not smp_read_barrier_depends() and smp_store_release().

I don't know.  I thought about doing that but the RCU accessors are
pairing store_release with read_barrier_depends, so I don't think the
particular paring is problematic and store_release is better at
documenting what's being barriered.

Thanks.

-- 
tejun
