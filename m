Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbbAESVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:21:05 -0500
Received: from gw1.transmode.se ([195.58.98.146]:61178 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbbAESVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:21:03 -0500
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v3 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
Thread-Topic: [PATCH v3 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
Thread-Index: AQHQHdAiSuXq6pRq+0uuRJgVzjygvZyx2c4A
Date: Mon, 5 Jan 2015 18:12:00 +0000
Message-ID: <1420481520.25047.15.camel@transmode.se>
References: <20141222101450.D7DD11A5E15@localhost.localdomain>
In-Reply-To: <20141222101450.D7DD11A5E15@localhost.localdomain>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.200.4]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <3AB9AB1CAFE0674D92E7BDEDDC39CFCC@transmode.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2014-12-22 at 11:14 +0100, Christophe Leroy wrote:
> On powerpc 8xx, in TLB entries, 0x400 bit is set to 1 for read-only pages
> and is set to 0 for RW pages. So we should use _PAGE_RO instead of _PAGE_RW
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Hi Christophe, been meaning to look over all you recent 8xx MMU/TLB patches
but got so little time :(

This is very cool (not sure if there will be a performance gain)  but ..
> 
> 
> 
> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
> index caf094a..b4e0c3b 100644
> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
> @@ -178,9 +178,10 @@ static inline unsigned long pte_update(pte_t *p,
>         andc    %1,%0,%5\n\
>         or      %1,%1,%6\n\
>         /* 0x200 == Extended encoding, bit 22 */ \
> -       /* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
> +       /* Bit 22 has to be 1 when _PAGE_USER is unset and _PAGE_RO is set */ \
>         rlwimi  %1,%1,32-2,0x200\n /* get _PAGE_USER */ \
> -       rlwinm  %3,%1,32-1,0x200\n /* get _PAGE_RW */ \
> +       rlwinm  %3,%1,32-1,0x200\n /* get _PAGE_RO */ \
> +       xori    %3,%3,0x200\n \
>         or      %1,%3,%1\n\
>         xori    %1,%1,0x200\n"
>  "      stwcx.  %1,0,%4\n\

... here I expected to loose the existing xori insn instead of adding one?

 Jocke