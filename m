Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab3IBLSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:18:54 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7320 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3IBLSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:18:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Sep 2013 04:16:09 -0700
Date: Mon, 2 Sep 2013 14:18:50 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: Clock framework deadlock with external SPI clockchip
Message-ID: <20130902111850.GN9594@tbergstrom-lnx.Nvidia.com>
References: <52209D1D.3080102@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52209D1D.3080102@metafoo.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 03:24:45PM +0200, Lars-Peter Clausen wrote:
> Hi,
> 
> I'm currently facing a deadlock in the common clock framework that
> unfortunately is not addressed by the reentrancy patches. I have a external
> clock chip that is controlled via SPI. So for example to configure the rate
> of the clock chip you need to send a SPI message. Naturally the clock
> framework will hold the prepare lock while configuring the rate.
> Communication in the SPI framework happens asynchronously, spi_sync() will
> enqueue a message in the SPI masters queue and then wait using
> wait_for_completion(). The master will call complete() once the transfer has
> been finished. The SPI master runs in it's own thread in which it processes
> the messages. In this thread it also calls clk_set_rate() to configure the
> SPI transfer clock rate based on what the message says. Now the deadlock
> happens as we try to take the prepare_lock again and since the clock chip
> and the SPI master run in different threads the reentrancy code does not
> kick in.
> 
> The basic sequence is like this:
> 
> === Clock chip driver ===        === SPI master driver ===
>  clk_prepare_lock()
>  spi_sync()
>    wait_for_completion(X)
>                                  clk_get_rate()
> 			           clk_prepare_lock() <--- DEADLOCK
> 				   clk_prepare_unlock()
> 				 ...
> 				 complete(X)
>  ...
>  clk_prepare_unlock()
> 
> I'm wondering if you have any idea how this can be fixed. In my opinion we'd
> need a per clock mutex to address this properly.

One workaround is to leave the SPI masters clock always prepared. A similar
problem can occur with I2C and DVFS using notifiers.

Cheers,

Peter.
