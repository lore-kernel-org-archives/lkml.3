Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3JaE4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:56:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50305 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3JaE4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:56:35 -0400
Date: Wed, 30 Oct 2013 21:56:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        gleb@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131031045629.GT4126@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131030190929.GA7153@redhat.com>
 <20131030201552.GP4126@linux.vnet.ibm.com>
 <20131030232605.GA28823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030232605.GA28823@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103104-1344-0000-0000-000002E276FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 01:26:05AM +0200, Michael S. Tsirkin wrote:
> > > Paul, could you review this patch please?
> > > Documentation/memory-barriers.txt says that unlock has a weaker
> > > uni-directional barrier, but in practice srcu_read_unlock calls
> > > smp_mb().
> > > 
> > > Is it OK to rely on this? If not, can I add
> > > smp_mb__after_srcu_read_unlock (making it an empty macro for now)
> > > so we can avoid an actual extra smp_mb()?
> > 
> > Please use smp_mb__after_srcu_read_unlock().  After all, it was not
> > that long ago that srcu_read_unlock() contained no memory barriers,
> > and perhaps some day it won't need to once again.
> > 
> > 							Thanx, Paul
> >
> 
> Thanks!
> Something like this will be enough?
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index c114614..9b058ee 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -237,4 +237,18 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
>  	__srcu_read_unlock(sp, idx);
>  }
> 
> +/**
> + * smp_mb__after_srcu_read_unlock - ensure full ordering after srcu_read_unlock
> + *
> + * Converts the preceding srcu_read_unlock into a two-way memory barrier.
> + *
> + * Call this after srcu_read_unlock, to guarantee that all memory operations
> + * that occur after smp_mb__after_srcu_read_unlock will appear to happen after
> + * the preceding srcu_read_unlock.
> + */
> +static inline void smp_mb__after_srcu_read_unlock(void)
> +{
> +	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
> +}
> +
>  #endif

Yep, that should do it!

							Thanx, Paul

