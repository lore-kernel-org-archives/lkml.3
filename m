Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3JPFph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:45:37 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54432 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3JPFp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:45:26 -0400
Message-ID: <525E27ED.4000005@c-s.fr>
Date: Wed, 16 Oct 2013 07:45:17 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc 8xx: Fixing memory init issue with CONFIG_PIN_TLB
References: <201310111256.r9BCuepM006243@localhost.localdomain>	 <OFF3401910.4A8AA6D0-ONC1257C01.0052FC82-C1257C01.00539C55@transmode.se>	 <525D6CD4.5090403@c-s.fr> <1381869216.7979.718.camel@snotra.buserror.net>
In-Reply-To: <1381869216.7979.718.camel@snotra.buserror.net>
Content-Type: multipart/mixed;
 boundary="------------030308070004050808080304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030308070004050808080304
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Le 15/10/2013 22:33, Scott Wood a écrit :
> On Tue, 2013-10-15 at 18:27 +0200, leroy christophe wrote:
>> Le 11/10/2013 17:13, Joakim Tjernlund a écrit :
>>> "Linuxppc-dev"
>>> <linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org>
>>> wrote on 2013/10/11 14:56:40:
>>>> Activating CONFIG_PIN_TLB allows access to the 24 first Mbytes of memory
>>> at
>>>> bootup instead of 8. It is needed for "big" kernels for instance when
>>> activating
>>>> CONFIG_LOCKDEP_SUPPORT. This needs to be taken into account in init_32
>>> too,
>>>> otherwise memory allocation soon fails after startup.
>>>>
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>>
>>>> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S
>>> linux-3.11/arch/powerpc/kernel/head_8xx.S
>>>> --- linux-3.11.org/arch/powerpc/mm/init_32.c   2013-09-02
>>> 22:46:10.000000000 +0200
>>>> +++ linux-3.11/arch/powerpc/mm/init_32.c   2013-09-09 11:28:54.000000000
>>> +0200
>>>> @@ -213,7 +213,12 @@
>>>>        */
>>>>       BUG_ON(first_memblock_base != 0);
>>>>
>>>> +#ifdef CONFIG_PIN_TLB
>>>> +   /* 8xx can only access 24MB at the moment */
>>>> +   memblock_set_current_limit(min_t(u64, first_memblock_size,
>>> 0x01800000));
>>>> +#else
>>>>       /* 8xx can only access 8MB at the moment */
>>>>       memblock_set_current_limit(min_t(u64, first_memblock_size,
>>> 0x00800000));
>>>> +#endif
>>>>    }
>>>>    #endif /* CONFIG_8xx */
>>> hmm, I think you should always map 24 MB (or less if RAM < 24 MB) and do
>>> the same
>>> in head_8xx.S.
>>>
>>> Or to keep it simple, just always map at least 16 MB here and in
>>> head_8xx.S, assuming
>>> that 16 MB is min RAM for any 8xx system running 3.x kernels.
>> Yes we could do a more elaborated modification in the future. However it
>> also has an impact on the boot loader, so I'm not sure we should make it
>> the default without thinking twice.
>>
>> In the meantime, my patch does take into account the existing situation
>> where you have 8Mb by default and 24Mb when you activate CONFIG_PIN_TLB.
>> I see it as a bug fix and I believe we should include it at least in
>> order to allow including in the stable releases.
>>
>> Do you see any issue with this approach ?
> The patch is fine, but I don't think it's stable material (BTW, if it
> were, you should have marked it as such when submitting).  If I
> understand the situation correctly, there's no regression, and nothing
> fails to work with CONFIG_PIN_TLB that would have worked without it.
> It's just making CONFIG_PIN_TLB more useful.
>
>
Yes the patch is definitly stable. How should I have mark it ?

The situation is that in 2010, I discovered that I was not able to start 
a big Kernel because of the 8Mb limit.
You told me (see attached mail) that in order to get rid of that limit I 
shall use CONFIG_PIN_TLB: it was the first step, it helped pass the 
memory zeroize at init, but it was not enough as I then got problems 
with the Device Tree being erased because being put inside the first 8Mb 
area too. Then I temporarely gave up at that time.

Recently I started again. After fixing my bootloader to get the device 
tree somewhere else, I discovered this 8Mb limit hardcoded in 
mm/init_32.c for the 8xx
With the patch I submitted I can now boot a kernel which is bigger than 8Mb.

So, I'm a bit lost here on what to do.

--------------030308070004050808080304
Content-Type: message/rfc822;
 name="Message joint"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Message joint"

Return-Path: <B07421@freescale.com>
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 73531C7392
	for <christophe.leroy@c-s.fr>; Tue, 15 Oct 2013 22:33:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id t-uOp0jzNl3a for <christophe.leroy@c-s.fr>;
	Tue, 15 Oct 2013 22:33:56 +0200 (CEST)
Received: from mailhub1.si.c-s.fr (mailhub1.si.c-s.fr [192.168.12.233])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3E19CC7391
	for <chleroy@messagerie.si.c-s.fr>; Tue, 15 Oct 2013 22:33:56 +0200 (CEST)
Received: from mailhub1.si.c-s.fr (mailhub1 [192.168.12.233])
	by localhost (Postfix) with ESMTP id CE4BB3C006
	for <chleroy@messagerie.si.c-s.fr>; Tue, 15 Oct 2013 22:33:50 +0200 (CEST)
X-Spam-Status: No, score=-1.8 required=6.0 tests=AWL,BAYES_00,URIBL_BLOCKED
	autolearn=ham version=3.3.2
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on mailhub1.si.c-s.fr
Received: from localhost (mailhub1 [192.168.12.233])
	by pegase1.c-s.fr (Postfix) with ESMTP id CBCB83C005
	for <chleroy@messagerie.si.c-s.fr>; Tue, 15 Oct 2013 22:33:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from mailhub1.si.c-s.fr ([192.168.12.233])
	by localhost (mailhub1.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id TEKUaA562H7I for <chleroy@messagerie.si.c-s.fr>;
	Tue, 15 Oct 2013 22:33:50 +0200 (CEST)
Received: from db9outboundpool.messaging.microsoft.com (mail-db9lp0250.outbound.messaging.microsoft.com [213.199.154.250])
	by pegase1.c-s.fr (Postfix) with ESMTP id 9A3173C004
	for <christophe.leroy@c-s.fr>; Tue, 15 Oct 2013 22:33:50 +0200 (CEST)
Received: from mail51-db9-R.bigfish.com (10.174.16.242) by
 DB9EHSOBE014.bigfish.com (10.174.14.77) with Microsoft SMTP Server id
 14.1.225.22; Tue, 15 Oct 2013 20:33:50 +0000
Received: from mail51-db9 (localhost [127.0.0.1])	by mail51-db9-R.bigfish.com
 (Postfix) with ESMTP id 3F155120188;	Tue, 15 Oct 2013 20:33:50 +0000 (UTC)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zzbb2dI98dIc89bh936eI15bfK1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Received: from mail51-db9 (localhost.localdomain [127.0.0.1]) by mail51-db9
 (MessageSwitch) id 1381869228487453_32172; Tue, 15 Oct 2013 20:33:48 +0000
 (UTC)
Received: from DB9EHSMHS026.bigfish.com (unknown [10.174.16.236])	by
 mail51-db9.bigfish.com (Postfix) with ESMTP id 62E714E00E9;	Tue, 15 Oct 2013
 20:33:48 +0000 (UTC)
Received: from mail.freescale.net (70.37.183.190) by DB9EHSMHS026.bigfish.com
 (10.174.14.36) with Microsoft SMTP Server (TLS) id 14.16.227.3; Tue, 15 Oct
 2013 20:33:48 +0000
Received: from tx30smr01.am.freescale.net (10.81.153.31) by
 039-SN1MMR1-003.039d.mgd.msft.net (10.84.1.16) with Microsoft SMTP Server
 (TLS) id 14.3.158.2; Tue, 15 Oct 2013 20:33:46 +0000
Received: from [10.214.83.72] ([10.214.83.72])	by tx30smr01.am.freescale.net
 (8.14.3/8.14.0) with ESMTP id r9FKXaOB017060;	Tue, 15 Oct 2013 13:33:43 -0700
Message-ID: <1381869216.7979.718.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc 8xx: Fixing memory init issue with
 CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>, Paul
 Mackerras <paulus@samba.org>
Date: Tue, 15 Oct 2013 15:33:36 -0500
In-Reply-To: <525D6CD4.5090403@c-s.fr>
References: <201310111256.r9BCuepM006243@localhost.localdomain>
	 <OFF3401910.4A8AA6D0-ONC1257C01.0052FC82-C1257C01.00539C55@transmode.se>
	 <525D6CD4.5090403@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%

On Tue, 2013-10-15 at 18:27 +0200, leroy christophe wrote:
> Le 11/10/2013 17:13, Joakim Tjernlund a =C3=A9crit :
> > "Linuxppc-dev"
> > <linuxppc-dev-bounces+joakim.tjernlund=3Dtransmode.se@lists.ozlabs.or=
g>
> > wrote on 2013/10/11 14:56:40:
> >> Activating CONFIG_PIN_TLB allows access to the 24 first Mbytes of me=
mory
> > at
> >> bootup instead of 8. It is needed for "big" kernels for instance whe=
n
> > activating
> >> CONFIG_LOCKDEP_SUPPORT. This needs to be taken into account in init_=
32
> > too,
> >> otherwise memory allocation soon fails after startup.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S
> > linux-3.11/arch/powerpc/kernel/head_8xx.S
> >> --- linux-3.11.org/arch/powerpc/mm/init_32.c   2013-09-02
> > 22:46:10.000000000 +0200
> >> +++ linux-3.11/arch/powerpc/mm/init_32.c   2013-09-09 11:28:54.00000=
0000
> > +0200
> >> @@ -213,7 +213,12 @@
> >>       */
> >>      BUG_ON(first_memblock_base !=3D 0);
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
> > hmm, I think you should always map 24 MB (or less if RAM < 24 MB) and=
 do
> > the same
> > in head_8xx.S.
> >
> > Or to keep it simple, just always map at least 16 MB here and in
> > head_8xx.S, assuming
> > that 16 MB is min RAM for any 8xx system running 3.x kernels.
> Yes we could do a more elaborated modification in the future. However i=
t=20
> also has an impact on the boot loader, so I'm not sure we should make i=
t=20
> the default without thinking twice.
>=20
> In the meantime, my patch does take into account the existing situation=
=20
> where you have 8Mb by default and 24Mb when you activate CONFIG_PIN_TLB=
.
> I see it as a bug fix and I believe we should include it at least in=20
> order to allow including in the stable releases.
>=20
> Do you see any issue with this approach ?

The patch is fine, but I don't think it's stable material (BTW, if it
were, you should have marked it as such when submitting).  If I
understand the situation correctly, there's no regression, and nothing
fails to work with CONFIG_PIN_TLB that would have worked without it.
It's just making CONFIG_PIN_TLB more useful.

-Scott


--------------030308070004050808080304--
