Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaGBLt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:49:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13385 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaGBLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:49:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Jul 2014 04:42:53 -0700
Date: Wed, 2 Jul 2014 14:49:24 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Tomasz Figa <t.figa@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz =?utf-8?Q?Stanis=C5=82awski?= <t.stanislaws@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Andrzej Hajda <a.hajda@samsung.com>,
        Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ABBA deadlock in Common Clock Framework
Message-ID: <20140702114924.GC3679@tbergstrom-lnx.Nvidia.com>
References: <53B3E5F8.80501@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53B3E5F8.80501@samsung.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 12:59:04PM +0200, Tomasz Figa wrote:
> Hi All,
> 
> While testing linux-next (next-20140625) on Exynos4412-based TRATS2
> board, from time to time I hit a deadlock between clk_disable_unused()
> of Common Clock Framework and parallel clk_prepare() from s3c24xx-i2c
> driver.
> 
> I believe the following is happening (in processes 1 and 2):
>  1: clk_disable_unused()
>  1: clk_prepare_lock()
>  1: mutex_lock(clk prepare mutex) // lock A
>  1: max77686_clk_is_prepared()
>  1: regmap_read()
>  2: regulator_set_voltage()
>  2: regmap_read()
>  2: mutex_lock(max77686 regmap mutex) // lock B
>  2: i2c_transfer()
>  2: s3c24xx_i2c_xfer()
>  2: clk_unprepare()
>  2: clk_prepare_lock()
>  2: mutex_lock(clk prepare mutex) // lock A
>  1: mutex_lock(max77686 regmap mutex) // lock B
>  1,2: BOOM!
> 
> I suppose this is a general problem affecting any MFD device that is
> also a clock provider, but I clearly don't have a good idea what to do
> about it.
> 

Or if you use notifiers which use i2c... See also
http://comments.gmane.org/gmane.linux.kernel/1553699. One workaround is to
always leave the clock of the i2c controller in a prepared state.

Cheers,

Peter.
