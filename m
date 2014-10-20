Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaJTEAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 00:00:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaJTEAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 00:00:17 -0400
Date: Mon, 20 Oct 2014 05:58:30 +0200
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, herbert@gondor.apana.org.au,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com
Subject: Re: [PATCH v2 3/6] hw_random: use reference counts on each struct
 hwrng.
Message-ID: <20141020035830.GA3982@air.redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
 <1411043867-21109-4-git-send-email-akong@redhat.com>
 <20140918170813.GA30440@air.redhat.com>
 <871tq3a9b8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tq3a9b8.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:42:11AM +1030, Rusty Russell wrote:
> Amos Kong <akong@redhat.com> writes:
> > We got a warning in boot stage when above set_current_rng() is executed,
> > it can be fixed by init rng->ref in hwrng_init().
> >
> >
> > @@ -166,6 +169,8 @@ static inline int hwrng_init(struct hwrng *rng)
> >         if (current_quality > 0 && !hwrng_fill)
> >                 start_khwrngd();
> >  
> > +       kref_init(&rng->ref);
> > +
> >         return 0;
> >  }
> 
> OK, I folded this fix on.

Thanks.

Reviewed-by: Amos Kong <akong@redhat.com>
 
> Thanks,
> Rusty.
> 
> hw_random: use reference counts on each struct hwrng.
> 
> current_rng holds one reference, and we bump it every time we want
> to do a read from it.
> 
> This means we only hold the rng_mutex to grab or drop a reference,
> so accessing /sys/devices/virtual/misc/hw_random/rng_current doesn't
> block on read of /dev/hwrng.
> 
> Using a kref is overkill (we're always under the rng_mutex), but
> a standard pattern.
> 
> This also solves the problem that the hwrng_fillfn thread was
> accessing current_rng without a lock, which could change (eg. to NULL)
> underneath it.
> 
> v3: initialize kref (thanks Amos Kong)
> v2: fix missing put_rng() on exit path (thanks Amos Kong)
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index a0905c818e13..0ecac38da954 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
....
