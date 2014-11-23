Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaKWQpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:45:24 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:59019
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbaKWQpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:45:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="90113207"
Date: Sun, 23 Nov 2014 17:45:18 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Konstantin Khlebnikov <koct9i@gmail.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        kexec@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>, Michal Marek <mmarek@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2 v2] scripts/coccinelle: catch freeing cryptographic
 structures via kfree
In-Reply-To: <CALYGNiOiErex4-WfqfCKHuZAMoA6SPvQVHjAx0imeeB6bzcbNQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1411231743320.2037@localhost6.localdomain6>
References: <20141117151420.10739.16342.stgit@buzz> <20141118114920.13498.73584.stgit@buzz> <alpine.DEB.2.10.1411191040020.2363@hadrien> <CALYGNiOiErex4-WfqfCKHuZAMoA6SPvQVHjAx0imeeB6bzcbNQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Nov 2014, Konstantin Khlebnikov wrote:

> On Wed, Nov 19, 2014 at 12:41 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> >> +// Comments: There are false positives in crypto/ where they are
> >> actually freed.
> >
> > I didn't really understand this comment.  I ran the semantic patch and got
> > around 10 results, but it wasn't clear to me how to see which were false
> > positives.
> 
> I mean false positives in code inside directory crypto/ where this
> subsystem lives.
> 
> ./arch/x86/crypto/fpu.c:143:1-6: WARNING: invalid free of
> crypto_alloc_* allocated data
> ./crypto/algapi.c:846:1-6: WARNING: invalid free of crypto_alloc_*
> allocated data
> ./crypto/lrw.c:378:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/ecb.c:163:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/ctr.c:242:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/ctr.c:419:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/ctr.c:428:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/pcbc.c:273:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/cts.c:329:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/cbc.c:267:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> ./crypto/xts.c:340:1-6: WARNING: invalid free of crypto_alloc_* allocated data
> 
> This is kfree calls on error paths in constructors or in destructors
> which actually frees memory when crypto_free_* is called.

Sorry, but I am not sure to fully understand the issue.  Is it actually 
just the case that crypto_alloc_instance and crypto_alloc_instance2 should 
not be in the list of allocation functions, because their results should 
be freed with kfree?

julia


> 
> >
> > I would suggest to extend the rule a little bit to include information
> > about where the allocation call is:
> 
> Not sure if this is necessary. This part of crypto-api is simple.
> 
> >
> > ///
> > /// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
> > /// This finds freeing them by kfree.
> > ///
> > // Confidence: Moderate
> > // Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
> > // Comments: There are false positives in crypto/ where they are actually freed.
> > // Keywords: crypto, kfree
> > // Options: --no-includes --include-headers
> >
> > virtual org
> > virtual report
> > virtual context
> >
> > @r depends on context || org || report@
> > expression x;
> > position p1;
> > @@
> >
> > (
> >  x = crypto_alloc_base@p1(...)
> > |
> >  x = crypto_alloc_cipher@p1(...)
> > |
> >  x = crypto_alloc_ablkcipher@p1(...)
> > |
> >  x = crypto_alloc_aead@p1(...)
> > |
> >  x = crypto_alloc_instance@p1(...)
> > |
> >  x = crypto_alloc_instance2@p1(...)
> > |
> >  x = crypto_alloc_comp@p1(...)
> > |
> >  x = crypto_alloc_pcomp@p1(...)
> > |
> >  x = crypto_alloc_hash@p1(...)
> > |
> >  x = crypto_alloc_ahash@p1(...)
> > |
> >  x = crypto_alloc_shash@p1(...)
> > |
> >  x = crypto_alloc_rng@p1(...)
> > )
> >
> > @pb@
> > expression r.x;
> > position p;
> > @@
> >
> > * kfree@p(x)
> >
> > @script:python depends on org@
> > p << pb.p;
> > p1 << r.p1;
> > @@
> >
> > msg="WARNING: invalid free of crypto_alloc_* allocated data"
> > coccilib.org.print_todo(p[0], msg)
> > coccilib.org.print_link(p1[0], "allocation")
> >
> > @script:python depends on report@
> > p << pb.p;
> > p1 << r.p1;
> > @@
> >
> > msg="WARNING: invalid free of crypto_alloc_* allocated data, allocated on line %s" % (p1[0].line)
> > coccilib.report.print_report(p[0], msg)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
