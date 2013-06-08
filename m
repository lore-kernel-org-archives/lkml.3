Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3FHVIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 17:08:04 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31832 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab3FHVIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 17:08:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,828,1363129200"; 
   d="scan'208";a="20981670"
Date: Sat, 8 Jun 2013 23:07:59 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Rusty Russell <rusty@rustcorp.com.au>, Thomas Meyer <thomas@m3y3r.de>,
        mst@redhat.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
In-Reply-To: <20130603071526.GA5483@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1306082305220.1968@localhost6.localdomain6>
References: <1370080565.29224.29.camel@localhost.localdomain> <87mwr8sz9g.fsf@rustcorp.com.au> <20130603071526.GA5483@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-686122369-1370725680=:1968"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-686122369-1370725680=:1968
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 3 Jun 2013, Uwe Kleine-König wrote:

> Hello Rusty,
> 
> [added akpm to Cc: who took the patch back then and Julia for the
> coccinelle part below]
> 
> On Mon, Jun 03, 2013 at 11:59:15AM +0930, Rusty Russell wrote:
> > 
> > Back in 2011, Uwe Kleine-König added the nonsensically-named
> > PTR_RET(), providing a means to avoid if() statements in code (commit 
> > fa9ee9c4b9).
> > 
> > Instead, just make PTR_ERR() return 0 if the pointer isn't an error
> > value.  This is harmless, since PTR_ERR() should have never been
> > passed a non-error value.  And GCC is usually smart enough to remove
> > the extra test if IS_ERR() has already been called.
> I wonder in which situations gcc fails to be smart enough. Did you check
> this?
> 
> > My vmlinux text increased by 300 bytes:
> > 
> > 	   text	   data	    bss	    dec	    hex	filename
> > 	6029452	 491628	2576384	9097464	 8ad0f8	vmlinux
> > 	6029721	 491628	2576384	9097733	 8ad205	vmlinux.PTR_ERR
> > 
> > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Thomas Meyer <thomas@m3y3r.de>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > diff --git a/include/linux/err.h b/include/linux/err.h
> > index f2edce2..621d859 100644
> > --- a/include/linux/err.h
> > +++ b/include/linux/err.h
> > @@ -24,14 +24,16 @@ static inline void * __must_check ERR_PTR(long error)
> >  	return (void *) error;
> >  }
> >  
> > -static inline long __must_check PTR_ERR(const void *ptr)
> > +static inline long __must_check IS_ERR(const void *ptr)
> >  {
> > -	return (long) ptr;
> > +	return IS_ERR_VALUE((unsigned long)ptr);
> >  }
> >  
> > -static inline long __must_check IS_ERR(const void *ptr)
> > +static inline long __must_check PTR_ERR(const void *ptr)
> >  {
> > -	return IS_ERR_VALUE((unsigned long)ptr);
> > +	if (IS_ERR(ptr))
> > +		return (long) ptr;
> > +	return 0;
> >  }
> >  
> >  static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
> > @@ -52,14 +54,7 @@ static inline void * __must_check ERR_CAST(const void *ptr)
> >  	return (void *) ptr;
> >  }
> >  
> > -static inline int __must_check PTR_RET(const void *ptr)
> > -{
> > -	if (IS_ERR(ptr))
> > -		return PTR_ERR(ptr);
> > -	else
> > -		return 0;
> > -}
> > -
> > +#define PTR_RET	PTR_ERR
> I'd add a comment here that PTR_RET shouldn't be used anymore.
> 
> >  #endif
> >  
> >  #endif /* _LINUX_ERR_H */
> > 
> 
> Is it worth to apply the same change to tools/virtio/linux/err.h to
> minimize the chance for later surprises?
> Also scripts/coccinelle/api/ptr_ret.cocci starts giving false warnings.
> 
> Other than that I think the change is fine.

For a random example, here is a function that currently uses PTR_RET:

static int __net_init iptable_raw_net_init(struct net *net)
{
        struct ipt_replace *repl;

        repl = ipt_alloc_initial_table(&packet_raw);
	if (repl == NULL)
                return -ENOMEM;
        net->ipv4.iptable_raw =
                ipt_register_table(net, &packet_raw, repl);
	kfree(repl);
        return PTR_RET(net->ipv4.iptable_raw);
}

If it becomes return PTR_ERR(...); at the end, won't it look like the 
function always fails?

julia
--8323328-686122369-1370725680=:1968--
