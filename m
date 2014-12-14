Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaLNKGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 05:06:24 -0500
Received: from ozlabs.org ([103.22.144.67]:57742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLNKGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 05:06:01 -0500
In-Reply-To: <1418151413-6141-5-git-send-email-shreyas@linux.vnet.ibm.com>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [v4,4/4] powernv: powerpc: Add winkle support for offline cpus
Message-Id: <20141214100600.3446B140119@ozlabs.org>
Date: Sun, 14 Dec 2014 21:05:59 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-12 at 18:56:53 UTC, "Shreyas B. Prabhu" wrote:
> Winkle is a deep idle state supported in power8 chips. A core enters
> winkle when all the threads of the core enter winkle. In this state
> power supply to the entire chiplet i.e core, private L2 and private L3
> is turned off. As a result it gives higher powersavings compared to
> sleep.
...

> diff --git a/arch/powerpc/platforms/powernv/subcore.h b/arch/powerpc/platforms/powernv/subcore.h
> index 148abc9..604eb40 100644
> --- a/arch/powerpc/platforms/powernv/subcore.h
> +++ b/arch/powerpc/platforms/powernv/subcore.h
> @@ -15,4 +15,5 @@
>  
>  #ifndef __ASSEMBLY__
>  void split_core_secondary_loop(u8 *state);
> +extern void update_subcore_sibling_mask(void);
>  #endif

subcore.c isn't built for CONFIG_SMP=n, resulting in:

  setup.c:(.init.text+0x34b0): undefined reference to `.update_subcore_sibling_mask'

I needed to add:

+#else
+static inline void update_subcore_sibling_mask(void) { };
+#endif /* CONFIG_SMP */


I also got quite a few conflicts, with this and the previous patch, mainly in
the paca and asm-offsets. Please check I resolved them correctly:

  https://github.com/mpe/powerpc-merge/commits/test

cheers
