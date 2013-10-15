Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab3JOUfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:35:03 -0400
Received: from [213.199.154.249] ([213.199.154.249]:28445 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933368Ab3JOUfB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:35:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zzbb2dI98dIc89bh936eI15bfK1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381869216.7979.718.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc 8xx: Fixing memory init issue with
 CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>
Date: Tue, 15 Oct 2013 15:33:36 -0500
In-Reply-To: <525D6CD4.5090403@c-s.fr>
References: <201310111256.r9BCuepM006243@localhost.localdomain>
	 <OFF3401910.4A8AA6D0-ONC1257C01.0052FC82-C1257C01.00539C55@transmode.se>
	 <525D6CD4.5090403@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 18:27 +0200, leroy christophe wrote:
> Le 11/10/2013 17:13, Joakim Tjernlund a écrit :
> > "Linuxppc-dev"
> > <linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org>
> > wrote on 2013/10/11 14:56:40:
> >> Activating CONFIG_PIN_TLB allows access to the 24 first Mbytes of memory
> > at
> >> bootup instead of 8. It is needed for "big" kernels for instance when
> > activating
> >> CONFIG_LOCKDEP_SUPPORT. This needs to be taken into account in init_32
> > too,
> >> otherwise memory allocation soon fails after startup.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S
> > linux-3.11/arch/powerpc/kernel/head_8xx.S
> >> --- linux-3.11.org/arch/powerpc/mm/init_32.c   2013-09-02
> > 22:46:10.000000000 +0200
> >> +++ linux-3.11/arch/powerpc/mm/init_32.c   2013-09-09 11:28:54.000000000
> > +0200
> >> @@ -213,7 +213,12 @@
> >>       */
> >>      BUG_ON(first_memblock_base != 0);
> >>
> >> +#ifdef CONFIG_PIN_TLB
> >> +   /* 8xx can only access 24MB at the moment */
> >> +   memblock_set_current_limit(min_t(u64, first_memblock_size,
> > 0x01800000));
> >> +#else
> >>      /* 8xx can only access 8MB at the moment */
> >>      memblock_set_current_limit(min_t(u64, first_memblock_size,
> > 0x00800000));
> >> +#endif
> >>   }
> >>   #endif /* CONFIG_8xx */
> > hmm, I think you should always map 24 MB (or less if RAM < 24 MB) and do
> > the same
> > in head_8xx.S.
> >
> > Or to keep it simple, just always map at least 16 MB here and in
> > head_8xx.S, assuming
> > that 16 MB is min RAM for any 8xx system running 3.x kernels.
> Yes we could do a more elaborated modification in the future. However it 
> also has an impact on the boot loader, so I'm not sure we should make it 
> the default without thinking twice.
> 
> In the meantime, my patch does take into account the existing situation 
> where you have 8Mb by default and 24Mb when you activate CONFIG_PIN_TLB.
> I see it as a bug fix and I believe we should include it at least in 
> order to allow including in the stable releases.
> 
> Do you see any issue with this approach ?

The patch is fine, but I don't think it's stable material (BTW, if it
were, you should have marked it as such when submitting).  If I
understand the situation correctly, there's no regression, and nothing
fails to work with CONFIG_PIN_TLB that would have worked without it.
It's just making CONFIG_PIN_TLB more useful.

-Scott



