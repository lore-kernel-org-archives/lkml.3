Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaKJUcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:32:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48125 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaKJUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:32:32 -0500
Date: Mon, 10 Nov 2014 15:32:28 -0500 (EST)
Message-Id: <20141110.153228.2187951801277440496.davem@davemloft.net>
To: tinajohnson.1234@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] drivers: atm: eni: Add pci_dma_mapping_error() call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415463482-8013-1-git-send-email-tinajohnson.1234@gmail.com>
References: <1415463482-8013-1-git-send-email-tinajohnson.1234@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 12:32:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tina Johnson <tinajohnson.1234@gmail.com>
Date: Sat,  8 Nov 2014 21:48:02 +0530

> Added a pci_dma_mapping_error() call to check for mapping errors before
> further using the dma handle. Unchecked dma handles were found using
> Coccinelle:
> 
> @rule1@
> expression e1;
> identifier x;
> @@
> 
> *x = pci_map_single(...);
>  ... when != pci_dma_mapping_error(e1,x)
> 
> Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

I really don't like quick fixes like this, exactly because of the
kind of new bug this change is introducing.

The 'trouble' label assumes that it is recovering and unwinding state
when an error occurs after the DMA buffer is successfully mapped.

It unconditionally does pci_unmap_single() if 'paddr' is non-zero
which it might be in the error case depending upon how DMA errors
are represented on a given platform.
