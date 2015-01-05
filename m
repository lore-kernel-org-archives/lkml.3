Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbbAESdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:33:49 -0500
Received: from gw1.transmode.se ([195.58.98.146]:51836 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbbAESds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:33:48 -0500
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Thread-Topic: [PATCH 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Thread-Index: AQHQGUF+EnF0bbuoVUWd2Dp/RmzK9Zyx6QEA
Date: Mon, 5 Jan 2015 18:33:46 +0000
Message-ID: <1420482826.25047.26.camel@transmode.se>
References: <20141216150338.D4F0A1A5E0A@localhost.localdomain>
In-Reply-To: <20141216150338.D4F0A1A5E0A@localhost.localdomain>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.200.4]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <A2559D0F37477146BD143AC84D098C04@transmode.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-12-16 at 16:03 +0100, Christophe Leroy wrote:
> All accessed to PGD entries are done via 0(r11).
> By using lower part of swapper_pg_dir as load index to r11, we can remove the
> ori instruction.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Nice :)
Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>

> 
> ---
>  arch/powerpc/kernel/head_8xx.S | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
> index ae05f28..aa45225 100644
> --- a/arch/powerpc/kernel/head_8xx.S
> +++ b/arch/powerpc/kernel/head_8xx.S
> @@ -322,13 +322,12 @@ InstructionTLBMiss:
>         mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
>  #ifdef CONFIG_MODULES
>         beq     3f
> -       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
> -       ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
> +       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
>  3:
>  #endif
>         /* Insert level 1 index */
>         rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> -       lwz     r11, 0(r11)/* Get the level 1 entry */
> +       lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
>  
>         /* Load the MI_TWC with the attributes for this "segment." */
>         MTSPR_CPU6(SPRN_MI_TWC, r11, r3)/* Set segment attributes */
> @@ -376,12 +375,11 @@ DataStoreTLBMiss:
>         andis.  r11, r10, 0x8000
>         mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
>         beq     3f
> -       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
> -       ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
> +       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
>  3:
>         /* Insert level 1 index */
>         rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> -       lwz     r11, 0(r11)/* Get the level 1 entry */
> +       lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
>  
>         /* We have a pte table, so load fetch the pte from the table.
>                 */
> @@ -510,12 +508,11 @@ FixupDAR:/* Entry point for dcbx workaround. */
>         mfspr   r10, SPRN_SRR0
>         andis.  r11, r10, 0x8000/* Address >= 0x80000000 */
>         mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
> -       beq-    3f      /* Branch if user space */
> -       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
> -       ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
> +       beq     3f
> +       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
>         /* Insert level 1 index */
>  3:     rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> -       lwz     r11, 0(r11)/* Get the level 1 entry */
> +       lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
>         rlwinm  r11, r11,0,0,19/* Extract page descriptor page address */
>         /* Insert level 2 index */
>         rlwimi  r11, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
> @@ -670,8 +667,7 @@ start_here:
>                 * init's THREAD like the context switch code does, but this is
>                 * easier......until someone changes init's static structures.
>                 */
> -       lis     r6, swapper_pg_dir@h
> -       ori     r6, r6, swapper_pg_dir@l
> +       lis     r6, swapper_pg_dir@ha
>         tophys(r6,r6)
>  #ifdef CONFIG_8xx_CPU6
>         lis     r4, cpu6_errata_word@h
> @@ -850,6 +846,8 @@ _GLOBAL(set_context)
>         stw     r4, 0x4(r5)
>  #endif
>  
> +       li      r5, (swapper_pg_dir-PAGE_OFFSET)@l
> +       sub     r4, r4, r5
>  #ifdef CONFIG_8xx_CPU6
>         lis     r6, cpu6_errata_word@h
>         ori     r6, r6, cpu6_errata_word@l