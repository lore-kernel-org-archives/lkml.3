Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaFRPc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:32:27 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58157 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFRPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:32:26 -0400
Date: Wed, 18 Jun 2014 11:32:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: cl@linux-foundation.org, kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
Message-ID: <20140618153222.GA11042@htj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <53A1097F.3060400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1097F.3060400@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:37:35AM +0800, Lai Jiangshan wrote:
> > @@ -97,7 +98,10 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
> >  static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
> >  				    unsigned __percpu **pcpu_countp)
> >  {
> > -	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
> > +	unsigned long pcpu_ptr;
> > +
> > +	/* paired with smp_store_release() in percpu_ref_reinit() */
> > +	pcpu_ptr = smp_load_acquire(&ref->pcpu_count_ptr);
> 
> 
> Does "smp_load_acquire()" hurts the performance of percpu_ref_get/put()
> in non-x86 system?

It's equivalent to data dependency barrier.  The only arch which needs
something more than barrier() is alpha.  It isn't an issue.

Thanks.

-- 
tejun
