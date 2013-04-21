Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3DUIwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 04:52:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8229 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3DUIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 04:52:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 21 Apr 2013 01:50:33 -0700
Message-ID: <5173A7D9.8030300@nvidia.com>
Date: Sun, 21 Apr 2013 14:18:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT][PATCH] regulator: palmas: Convert to use regulator_set_voltage_time_sel()
References: <1366459972.3833.2.camel@phoenix>
In-Reply-To: <1366459972.3833.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 April 2013 05:42 PM, Axel Lin wrote:
> Use regulator_set_voltage_time_sel() instead of open coded.
>
> If rdev->constraints->ramp_delay is specified, the setting will be used in
> regulator_set_voltage_time_sel(). And then pmic->ramp_delay[] is not used and
> can be removed.
>
> There is a different behavior change here:
> regulator_set_voltage_time_sel() always returns
> 	DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);
>
> palma_smps_set_voltage_smps_time_sel() actually returns
> 	DIV_ROUND_UP(abs(new_volt - old_volt), modified_ramp_delay);
> where the modified_ramp_delay is not exactly specified by
> rdev->constraints->ramp_delay but a value from pmic->ramp_delay[id].
>
> So palma_smps_set_voltage_smps_time_sel() may return a smaller delay than
> regulator_set_voltage_time_sel() depend on rdev->constraints->ramp_delay value.
>
> I think the delay in both version are *safe* for the operation.
>
Nack,
This approach does not look good and the reason for which I did not use 
this core api here was:
- The palma device support ramp of 10mV/us, 5mV/us and 2.5mV/us. So if 
client pass the other than this value then register is programmed to 
nearest high value.
In this case, the constraint->ramp_delay is not much accurate with 
register level programming and need to update with actual register 
programmed. Hence we need to have local equivalent to the register 
programmed and use this new value instead of constraints->ramp_delay.

- Second reason is that TPS65913 ES1.0/ES2.0 has the hw errata on which 
the output voltage become slow ramp near to final value. TI suggested to 
use 1.5x as SWAR. So we need to use the local implementation to adjust this.
The changes for this errata is not there because we will need to read 
the version register and Ian has posted the series which is not merged 
yet. So waiting for his series to be merged for this errata implementation.

