Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab3BNMQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:16:51 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12451 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3BNMQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:16:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 04:12:53 -0800
Message-ID: <511CD59A.7080504@nvidia.com>
Date: Thu, 14 Feb 2013 17:46:26 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap: irq: do not write mask register if it is
 not supported
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com> <1360761290-15976-2-git-send-email-ldewangan@nvidia.com> <20130213142036.GJ5062@opensource.wolfsonmicro.com> <511CC520.8050104@nvidia.com> <20130214113531.GC13249@opensource.wolfsonmicro.com> <511CD0A1.70606@nvidia.com> <20130214115746.GF13249@opensource.wolfsonmicro.com>
In-Reply-To: <20130214115746.GF13249@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013 05:27 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Feb 14, 2013 at 05:25:13PM +0530, Laxman Dewangan wrote:
>> On Thursday 14 February 2013 05:05 PM, Mark Brown wrote:
>>> This doesn't sound like something that should be open coded in
>>> individual interrupt controller drivers, obviously it's a bit rubbish
>>> that there's no way to enable or disable the interrupt but presumably
>>> other hardware has the same "feature" and the IRQ subsystem ought to
>>> understand it.
>> To support such case, can we assume that mask is always enabled
>> (interrupt enabled) so that it can be use in irq_thread to mask the
>> interrupt status. So during initialization, if there is no mask_base
>> register then all mask_buf is such that it enabled interrupt.
> ...and have any attempt to mask the interrupt return an error?
>

Yes, we can return error as -EINVAL.

I just looked kernel/irq/chip.c, enable_irq()/disable_irq()  do not 
check for return value but it does not matter as per regmap-irq 
implementation.

void irq_enable(struct irq_desc *desc)
{
         irq_state_clr_disabled(desc);
         if (desc->irq_data.chip->irq_enable)
desc->irq_data.chip->irq_enable(&desc->irq_data);
         else
desc->irq_data.chip->irq_unmask(&desc->irq_data);
         irq_state_clr_masked(desc);
}

