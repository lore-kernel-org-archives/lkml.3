Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbbAESTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:19:17 -0500
Received: from gw1.transmode.se ([195.58.98.146]:60551 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbbAESTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:19:15 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 13:19:15 EST
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 04/11] powerpc/8xx: Take benefit of aligned PGDIR
Thread-Topic: [PATCH 04/11] powerpc/8xx: Take benefit of aligned PGDIR
Thread-Index: AQHQGUGAyrNzLqXuPUqDkis6GV95WZyx5PCA
Date: Mon, 5 Jan 2015 18:19:13 +0000
Message-ID: <1420481953.25047.19.camel@transmode.se>
References: <20141216150338.978F71A5E04@localhost.localdomain>
In-Reply-To: <20141216150338.978F71A5E04@localhost.localdomain>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.200.4]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DC3A87DB9E497D4D87BA431D98C13C38@transmode.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-12-16 at 16:03 +0100, Christophe Leroy wrote:
> L1 base address is now aligned so we can insert L1 index into r11 directly and
> then preserve r10
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>

> 
> ---
>  arch/powerpc/kernel/head_8xx.S | 34 +++++++++++++++-------------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
> index 2c329f1..ae05f28 100644
> --- a/arch/powerpc/kernel/head_8xx.S
> +++ b/arch/powerpc/kernel/head_8xx.S
> @@ -326,16 +326,15 @@ InstructionTLBMiss:
>         ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
>  3:
>  #endif
> -       /* Extract level 1 index */
> -       rlwinm  r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> -       lwzx    r11, r10, r11/* Get the level 1 entry */
> -       rlwinm  r10, r11,0,0,19/* Extract page descriptor page address */
> +       /* Insert level 1 index */
> +       rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> +       lwz     r11, 0(r11)/* Get the level 1 entry */
>  
>         /* Load the MI_TWC with the attributes for this "segment." */
>         MTSPR_CPU6(SPRN_MI_TWC, r11, r3)/* Set segment attributes */
> -       mfspr   r11, SPRN_SRR0/* Get effective address of fault */
> +       rlwinm  r11, r11,0,0,19/* Extract page descriptor page address */
>         /* Extract level 2 index */
> -       rlwinm  r11, r11, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
> +       rlwinm  r10, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
>         lwzx    r10, r10, r11/* Get the pte */
>  
>  #ifdef CONFIG_SWAP
> @@ -380,13 +379,12 @@ DataStoreTLBMiss:
>         lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
>         ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
>  3:
> -       /* Extract level 1 index */
> -       rlwinm  r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> -       lwzx    r11, r10, r11/* Get the level 1 entry */
> +       /* Insert level 1 index */
> +       rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> +       lwz     r11, 0(r11)/* Get the level 1 entry */
>  
>         /* We have a pte table, so load fetch the pte from the table.
>                 */
> -       mfspr   r10, SPRN_MD_EPN/* Get address of fault */
>         /* Extract level 2 index */
>         rlwinm  r10, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
>         rlwimi  r10, r11, 0, 0, 32 - PAGE_SHIFT - 1/* Add level 2 base */
> @@ -515,16 +513,14 @@ FixupDAR:/* Entry point for dcbx workaround. */
>         beq-    3f      /* Branch if user space */
>         lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
>         ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
> -       /* Extract level 1 index */
> -3:     rlwinm  r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> -       lwzx    r11, r10, r11/* Get the level 1 entry */
> -       rlwinm  r10, r11,0,0,19/* Extract page descriptor page address */
> -       mfspr   r11, SPRN_SRR0/* Get effective address of fault */
> -       /* Extract level 2 index */
> -       rlwinm  r11, r11, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
> -       lwzx    r11, r10, r11/* Get the pte */
> +       /* Insert level 1 index */
> +3:     rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> +       lwz     r11, 0(r11)/* Get the level 1 entry */
> +       rlwinm  r11, r11,0,0,19/* Extract page descriptor page address */
> +       /* Insert level 2 index */
> +       rlwimi  r11, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
> +       lwz     r11, 0(r11)/* Get the pte */
>         /* concat physical page address(r11) and page offset(r10) */
> -       mfspr   r10, SPRN_SRR0
>         rlwimi  r11, r10, 0, 32 - PAGE_SHIFT, 31
>         lwz     r11,0(r11)
>  /* Check if it really is a dcbx instruction. */