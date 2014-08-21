Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaHUSyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:54:49 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61047 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaHUSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:54:47 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Addy Ke <addy.ke@rock-chips.com>, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, huangtao@rock-chips.com, hl@rock-chips.com,
        yzq@rock-chips.com, zyw@rock-chips.com, linux-kernel@vger.kernel.org,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, linux-i2c@vger.kernel.org,
        caesar.wang@rock-chips.com, cf@rock-chips.com, hj@rock-chips.com,
        zhengsq@rock-chips.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: rk3x: fix bug that cause transfer fails in master receive mode
Date: Thu, 21 Aug 2014 20:54:06 +0200
Message-ID: <5150326.5TB64kCfF4@typ>
User-Agent: KMail/4.13.2 (Linux/3.15.7-031507-generic; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140821181738.GA1443@katana>
References: <1408643457-7126-1-git-send-email-addy.ke@rock-chips.com> <53F634AF.1010303@cogentembedded.com> <20140821181738.GA1443@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8jh68E9bvlo6t8qxldcRy1x1duRwEP013lnfo+mlgtX
 nLTug68P2mSVRimFlBEpeqHAMXrH/CwObI/j9kSx/WVgqPy3Hx
 3LkQ8zdBYvWSie7wlSSssCkc753cI3jEzunFtVLjewvoqnK/0p
 j3+HUfHsMWhYWRR5UdyqDJVfZk4V6GgmT8ujfASl4nG0XHM83E
 Hl2ri3+w3C7fpJa1HJ2cZjFWawjuI78LnvHgDgg2Pa8ec5/EmN
 jTagabYBfdlfySmG8h8YpfMRAYDXpgjIhkxgAG5MtxlIxBmoc9
 mrzqsnSIZifDsHqAVqu8qWIngvlWx5iyuKFrohCaymg+r0FpA=
 =
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 21 August 2014 at 13:17:38, Wolfram Sang wrote:
> On Thu, Aug 21, 2014 at 10:04:31PM +0400, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 08/21/2014 09:50 PM, Addy Ke wrote:
> > >In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
> > >in one transaction, so the size of data to be write/read to/from
> > >TXDATAx/RXDATAx must be less than or equal 32 bytes at a time.
> > >
> > >Test on pinky board, elan receive 158 bytes data.
> > >
> > >Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> > >---
> > >
> > >  drivers/i2c/busses/i2c-rk3x.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > >diff --git a/drivers/i2c/busses/i2c-rk3x.c
> > >b/drivers/i2c/busses/i2c-rk3x.c
> > >index 69e1185..dc0aa64 100644
> > >--- a/drivers/i2c/busses/i2c-rk3x.c
> > >+++ b/drivers/i2c/busses/i2c-rk3x.c
> > >@@ -323,6 +323,9 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c
> > >*i2c, unsigned int ipd)> >
> > >  	/* ack interrupt */
> > >  	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
> > >
> > >+	/* Can only handle a maximum of 32 bytes at a time */
> > >+	len = (len > 32) ? 32 : len;
> > >
> >    Why not min(len, 32)? Or even:
> > 	if (len > 32)
> > 	
> > 		len = 32;
> 
> No silent trimming, please. The message should be rejected when the transfer
> is set up. We could assign -EOVERFLOW to that type of failures, so users
> will know. Sadly, I have seen other controllers having such limits :(

Actually, reads with >32 bytes of data are possible with the controller. The 
hw returns the data in 32 byte chunks. Our chunk handling code is just buggy. 
We always read the number of missing bytes from the current chunk, instead of 
truncating that to 32.
The fix is correct. The following lines in the rk3x_i2c_handle_read() function 
already check if we got everything and trigger an additional chunk read if 
necessary:

	/* are we finished? */
	if (i2c->processed == i2c->msg->len)
		rk3x_i2c_stop(i2c, i2c->error);
	else
		rk3x_i2c_prepare_read(i2c);

I'd like a clearer syntax as suggested by Sergei, though.

Apart from that,
Acked-By: Max Schwarz <max.schwarz@online.de>

Cheers,
  Max
