Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaF3MV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:21:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53987 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753086AbaF3MV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:21:28 -0400
Message-ID: <53B15645.9000200@free-electrons.com>
Date: Mon, 30 Jun 2014 14:21:25 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] ARM: smp_scu: Add the enable speculative linefills
 operation
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>	<1403822608-31158-3-git-send-email-gregory.clement@free-electrons.com> <20140628170216.0c1965cf@free-electrons.com>
In-Reply-To: <20140628170216.0c1965cf@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,>> + */
>> +void scu_spec_linefills_enable(void __iomem *scu_base, bool enable)
>> +{
>> +	u32 scu_ctrl;
>> +
>> +	scu_ctrl = readl_relaxed(scu_base + SCU_CTRL);
>> +	/* already enabled? */
> 
> Comment not needed, since SCU_CTRL_ENABLE already documents what's
> happening. Or a more useful comment would be: "We cannot change the SCU
> configuration while it is enabled".

Right, however I need to figure out if it is really the case. Because in
ARM documentation about the SCU control register, I didn't find any mention
of this restriction.

> 
>> +	if (scu_ctrl & SCU_CTRL_ENABLE)
>> +		return;
> 
> Return an error in this case maybe?

If it failed we just don't benefit of an optimization, it won't prevent the
system working. And also, we can't do anything more if it failed. However
it could be nice to let the calling function know that it failed.

> 
>> +	if (enable)
>> +		scu_ctrl |= SCU_CTRL_SPEC_LINEFILLS;
>> +	else
>> +		scu_ctrl &= ~SCU_CTRL_SPEC_LINEFILLS;
>> +
>> +	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
>> +}
> 
> Instead of having a separate function to do this (and the standby
> operation), what about doing that directly in scu_enable() ? Either
> unconditionally if that is fine for all SCU users, or through a flags
> argument?

OK using a flag argument makes sens indeed. About setting it unconditionally,
I would prefer not taking the risk to break the other platforms.

Thanks,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
