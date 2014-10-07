Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaJGRQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:16:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46570 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbaJGRQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:16:48 -0400
Date: Tue, 07 Oct 2014 13:16:46 -0400 (EDT)
Message-Id: <20141007.131646.1417551297088545264.davem@davemloft.net>
To: sylvain.hitier@gmail.com
Cc: linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, mroos@linux.ee,
        netdev@vger.kernel.org, klassert@mathematik.tu-chemnitz.de
Subject: Re: [PATCH RESEND v3] 3c59x: fix bad split of
 cpu_to_le32(pci_map_single())
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141007134034.GA8838@erable>
References: <20141007134034.GA8838@erable>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Oct 2014 10:16:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
Date: Tue, 7 Oct 2014 13:40:34 +0000

> From: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
> 
> In commit 6f2b6a3005b2c34c39f207a87667564f64f2f91a,
>   # 3c59x: Add dma error checking and recovery
> the intent is to split out the mapping from the byte-swapping in order to
> insert a dma_mapping_error() check.
> 
> Kinda this semantic patch:
> 
>     // See http://coccinelle.lip6.fr/
>     //
>     // Beware, grouik-and-dirty!
>     @@
>     expression DEV, X, Y, Z;
>     @@
>     -   cpu_to_le32(pci_map_single(DEV, X, Y, Z))
>     +   dma_addr_t addr = pci_map_single(DEV, X, Y, Z);
>     +   if (dma_mapping_error(&DEV->dev, addr))
>     +       /* snip */;
>     +   cpu_to_le32(addr)
> 
> However, the #else part (of the #if DO_ZEROCOPY test) is changed this way:
> 
>     -   cpu_to_le32(pci_map_single(DEV, X, Y, Z))
>     +   dma_addr_t addr = cpu_to_le32(pci_map_single(DEV, X, Y, Z));
>     //                    ^^^^^^^^^^^
>     //                    That mismatches the 3 other changes!
>     +   if (dma_mapping_error(&DEV->dev, addr))
>     +       /* snip */;
>     +   cpu_to_le32(addr)
> 
> Let's remove the leftover cpu_to_le32() for coherency.
> 
> v2: Better changelog.
> v3: Add Acked-by
> 
> Fixes: 6f2b6a3005b2c34c39f207a87667564f64f2f91a
>   # 3c59x: Add dma error checking and recovery
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>

Applied and queued up for -stable, thanks!
