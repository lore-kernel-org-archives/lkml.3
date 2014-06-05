Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFEWZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:25:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:25:01 -0400
Date: Thu, 05 Jun 2014 15:24:59 -0700 (PDT)
Message-Id: <20140605.152459.1082790961637060914.davem@davemloft.net>
To: Alexey.Brodkin@synopsys.com
Cc: netdev@vger.kernel.org, hdegoede@redhat.com, peppe.cavallaro@st.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH] stmmac: extend DMA initialization delay to 2.5 seconds
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401973080-10085-1-git-send-email-abrodkin@synopsys.com>
References: <1401973080-10085-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Jun 2014 15:25:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Date: Thu,  5 Jun 2014 16:58:00 +0400

> On some platforms existing 100 msecond delay is not enough for DMA block to
> recover after reset. This is because MAC DMA waits for all PHY input clocks
> to present and depending on the board reset bit deassertion may take much
> longer than previously used 100 milliseconds
> 
> I have a board that requires more than 2 seconds for DMA to zero "reset" bit.
> If for other boards it's still not long enough this value should be extended
> once again.
> 
> In the same change I convert "mdelay" to "msleep" to make CPU available for
> other processes during DMA init delay which is especially useful in case of
> delay for a few seconds.
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

This will not work, you cannot sleep with spinlocks held, and this code is
absolutely called in such a context.

For example stmmac_resume() --> stmmac_hw_setup() -> stmmac_init_dma_engine().

stmmac_resume() holds priv->lock over all of these operations, and even has
interrupts disabled.
