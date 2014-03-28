Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaC1DDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:03:05 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9065
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757030AbaC1DDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:03:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
Date: Fri, 28 Mar 2014 10:41:00 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <Li.Xiubo@freescale.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <timur@tabi.org>, <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v2] ASoC: fsl_sai: Add isr to deal with error flag
Message-ID: <20140328024059.GA18417@MrMyself>
References: <1395918419-20739-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140327132626.GN30768@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140327132626.GN30768@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 01:26:27PM +0000, Mark Brown wrote:
> On Thu, Mar 27, 2014 at 07:06:59PM +0800, Nicolin Chen wrote:
> > It's quite cricial to clear error flags because SAI might hang if getting
> > FIFO underrun during playback (I haven't confirmed the same issue on Rx
> > overflow though).
> > 
> > So this patch enables those irq and adds isr() to clear the flags so as to
> > keep playback entirely safe.
> 
> So, I've applied this since we're (hopefully!) very near the merge
> window opening and it seems like it should be an improvement overall.
> However a few things below:
> 
> > +	/* Only handle those what we enabled */
> > +	mask = (FSL_SAI_FLAGS >> FSL_SAI_CSR_xIE_SHIFT) << FSL_SAI_CSR_xF_SHIFT;
> 
> The shifting here could use a comment.

Will send an extra patch to cover it.

> > +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
> > +			   FSL_SAI_CSR_xF_W_MASK | FSL_SAI_CSR_FR, xcsr);
> 
> Using update_bits() is going to do an extra read, better to do this as:
> 
> 	if (xcsr)
> 		regmap_write(sai->regmap, FSL_SAI_RCSR, xcsr);

T/RCSR register stands for T/Rx Control (Status -- I guess) Register.
It actually contains control bits, IRQ mask bits and IRQ status bits.
Thus we can't regard it as a entire status register. That's why I try
to update it partially for status bits only at this point.

But if it's just for saving this extra read instance, I may save those
non-status bits from upper regmap_read() and then merge them into this
regmap_write() over here.

> otherwise we might be ignoring any of the bits that are actually clear
> on read (it seems like there are some?).

For all status flags bits, actually five for each, three of them are
write-1-clear and the other two are self-clearance by SAI self -- so
none of them are clear-on-read type.

> > +	return IRQ_HANDLED;
> 
> I'd expect to see IRQ_NONE if we didn't actually see an interrupt
> source.

Will add this.

Thank you,
Nicolin


