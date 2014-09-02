Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaIBR7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:59:11 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37269 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbaIBR7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:59:08 -0400
Date: Tue, 2 Sep 2014 10:59:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Aug 23
Message-ID: <20140902175902.GA8829@roeck-us.net>
References: <20140823080422.7895575c@canb.auug.org.au>
 <20140825045741.GA29723@roeck-us.net>
 <20140901155804.GT27892@worktop.ger.corp.intel.com>
 <5404A2F2.3090908@roeck-us.net>
 <20140901190438.GB5806@worktop.ger.corp.intel.com>
 <20140902094016.GD31157@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902094016.GD31157@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:40:16AM +0200, Peter Zijlstra wrote:
> On Mon, Sep 01, 2014 at 09:04:38PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 01, 2014 at 09:46:42AM -0700, Guenter Roeck wrote:
> > > Yes, the problem is still seen in next-140829. See qemu test results at
> > > http://server.roeck-us.net:8010/builders.
> > > 
> > > I provided sparc64 images at http://server.roeck-us.net/qemu/sparc64/.
> > > The README file includes instructions on how to run the image in qemu
> > > and how to build a kernel.
> > > 
> > > I can do the same for mips and mips64 if needed; let me know.
> > 
> > Thanks, that's enough to get started.
> 
> This makes sparc64 go again, silly oversight indeed.
> 
> ---
> Subject: sparc64: Fix atomics
> 
> The patch folding the atomic ops had a silly fail in the _return primitives.
> 
> Fixes: 4f3316c2b5fe ("locking,arch,sparc: Fold atomic_ops")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Confirmed working.

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
> diff --git a/arch/sparc/lib/atomic_64.S b/arch/sparc/lib/atomic_64.S
> index 96d70b4..05dac43 100644
> --- a/arch/sparc/lib/atomic_64.S
> +++ b/arch/sparc/lib/atomic_64.S
> @@ -37,7 +37,7 @@ ENTRY(atomic_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
>  	cas	[%o1], %g1, %g7;					\
>  	cmp	%g1, %g7;						\
>  	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
> -	 add	%g1, %o0, %g1;						\
> +	 op	%g1, %o0, %g1;						\
>  	retl;								\
>  	 sra	%g1, 0, %o0;						\
>  2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
> @@ -76,7 +76,7 @@ ENTRY(atomic64_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
>  	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
>  	 nop;								\
>  	retl;								\
> -	 add	%g1, %o0, %o0;						\
> +	 op	%g1, %o0, %o0;						\
>  2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
>  ENDPROC(atomic64_##op##_return);
>  
> 
> 
