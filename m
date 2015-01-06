Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbbAFOmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:42:16 -0500
Received: from smtp-out4.electric.net ([192.162.216.181]:59865 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbAFOmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:42:15 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'leroy christophe'" <christophe.leroy@c-s.fr>,
        "'Joakim Tjernlund'" <Joakim.Tjernlund@transmode.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Thread-Topic: [PATCH 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Thread-Index: AQHQGUF+EnF0bbuoVUWd2Dp/RmzK9Zyx6QEAgAE2+WCAABaXAIAAEpVA
Date: Tue, 6 Jan 2015 14:41:12 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAC18C9@AcuExch.aculab.com>
References: <20141216150338.D4F0A1A5E0A@localhost.localdomain>
 <1420482826.25047.26.camel@transmode.se>
 <063D6719AE5E284EB5DD2968C1650D6D1CAC1765@AcuExch.aculab.com>
 <54ABE2CA.8030608@c-s.fr>
In-Reply-To: <54ABE2CA.8030608@c-s.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: leroy christophe
> Le 06/01/2015 13:08, David Laight a écrit :
> >> On Tue, 2014-12-16 at 16:03 +0100, Christophe Leroy wrote:
> >>> All accessed to PGD entries are done via 0(r11).
> >>> By using lower part of swapper_pg_dir as load index to r11, we can remove the
> >>> ori instruction.
> >>>
> >>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >> Nice :)
> >> Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>
> >>
> >>> ---
> >>>   arch/powerpc/kernel/head_8xx.S | 22 ++++++++++------------
> >>>   1 file changed, 10 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
> >>> index ae05f28..aa45225 100644
> >>> --- a/arch/powerpc/kernel/head_8xx.S
> >>> +++ b/arch/powerpc/kernel/head_8xx.S
> >>> @@ -322,13 +322,12 @@ InstructionTLBMiss:
> >>>          mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
> >>>   #ifdef CONFIG_MODULES
> >>>          beq     3f
> >>> -       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
> >>> -       ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
> >>> +       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
> >>>   3:
> >>>   #endif
> >>>          /* Insert level 1 index */
> >>>          rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> >>> -       lwz     r11, 0(r11)/* Get the level 1 entry */
> >>> +       lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
> >>>
> > On the face of it that fragment doesn't look right when CONFIG_MODULES is undefined.
> >
> > 	David
> >
> I'm not sure I understand what you mean.
> 
> The other part of the patch adds the following:
> +    li    r5, (swapper_pg_dir-PAGE_OFFSET)@l
> +    sub    r4, r4, r5
> 
> r4 is the value put into SPRN_M_TW, so I don't see what may be wrong.

Ok, but it is completely non-obvious.
You probably need to change some comments somewhere about what is held
in SPRN_M_TW - since it is no longer the L1 base address, but that value
offset by some 'random' amount.

	David

