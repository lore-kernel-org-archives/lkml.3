Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaJPJ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:26:17 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:53912 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaJPJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:26:15 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <2364c55f44b2dc9518b7f3908b103143>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <543F8F2A.9040904@rock-chips.com>
Date: Thu, 16 Oct 2014 17:26:02 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: broonie@kernel.org
CC: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, amstan@google.com, sonnyrao@google.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Subject: Re: [PATCH 2/2] spi/rockchip: fix bug that cause spi transfer timed
 out in DMA duplex mode
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com> <1413372378-4309-1-git-send-email-addy.ke@rock-chips.com> <20141015130547.GE27755@sirena.org.uk>
In-Reply-To: <20141015130547.GE27755@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

The following changes is nessarry:(if tx complete, spi must be disabled too)
diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 153269b..87bc16f 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -418,8 +418,10 @@ static void rockchip_spi_dma_txcb(void *data)
        spin_lock_irqsave(&rs->lock, flags);

        rs->state &= ~TXBUSY;
-       if (!(rs->state & RXBUSY))
+       if (!(rs->state & RXBUSY)) {
+               spi_enable_chip(rs, 0);
                spi_finalize_current_transfer(rs->master);
+       }

        spin_unlock_irqrestore(&rs->lock, flags);
 }

Sorry for my mistake, I have not put these changes to this patch.

Do I need send patch v2 or a new patch to fix this issure?

On 2014/10/15 21:05, Mark Brown wrote:
> On Wed, Oct 15, 2014 at 07:26:18PM +0800, Addy Ke wrote:
>> In rx mode, dma must be prepared before spi is enabled.
>> But in tx and tr mode, spi must be enabled first.
> 
> Applied, thanks.
> 

