Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3DQGsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:48:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5987 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3DQGs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:48:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 16 Apr 2013 23:48:27 -0700
Message-ID: <516E44CD.3010203@nvidia.com>
Date: Wed, 17 Apr 2013 12:14:29 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulator: tps80031: question about LDO2 TRACK_MODE_ENABLE of
 TPS80031 or TPS80032-ES1.0
References: <1366169084.10398.4.camel@phoenix>
In-Reply-To: <1366169084.10398.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013 08:54 AM, Axel Lin wrote:
> hi Laxman,
>
> Currently we have below code in tps80031_ldo_set_voltage_sel():
>
>          /* Check for valid setting for TPS80031 or TPS80032-ES1.0 */
>          if ((ri->rinfo->desc.id == TPS80031_REGULATOR_LDO2) &&
>                          (ri->device_flags & TRACK_MODE_ENABLE)) {
>                  unsigned nvsel = (sel) & 0x1F;
>                  if (((tps80031_get_chip_info(parent) == TPS80031) ||
>                          ((tps80031_get_chip_info(parent) == TPS80032) &&
>                          (tps80031_get_pmu_version(parent) == 0x0))) &&
>                          ((nvsel == 0x0) || (nvsel >= 0x19 && nvsel <= 0x1F))) {
>                                  dev_err(ri->dev,
>                                          "Invalid sel %d in track mode LDO2\n",
>                                          nvsel);
>                                  return -EINVAL;
>                  }
>          }
>
> However, list_voltage() still show these invalid selectors have supported voltage.
> Besides, having the code "nvsel = (sel) & 0x1F" looks a bit odd, because currently
> n_voltages is set to 57 when TRACK_MODE_ENABLE is set.
>
> I'm wondering if below comment is still true for LDO2 TRACK_MODE_ENABLE of
> "TPS80031/TPS80032-ES1.0"?
>
> /* TRACK mode the ldo2 varies from 600mV to 1300mV */
>
> What is the register value && voltage mapping for LDO2 TRACK_MODE_ENABLE of
> TPS80031 or TPS80032-ES1.0?

Hi Axel,

Following the excerpt of the mail got from TI on this issue:

There is a bug on LDO2 tracking on TPS80031 and TPS80032 ES1.0 but you 
should be able to have the functionality working.

Issue description:
- LDO2 traking mode is enabled
- LDO2 tracks SMPS2 voltage.
- LDO2 automatically switch-off when LDO2_CFG_VOLTAGE is changed to some 
discrete values (non exhaustive list):
             00011001, 00011010, 00011011, 00011100, .
- LDO2 switch-on again when LDO2_CFG_VOLTAGE is changed to other values 
(non exhaustive list):
         00011000, 00010111, .

LDOs have reserved codes. For these codes, LDO is switch-off.

In tracking, LDO2 ref comes from SMPS2.
However LDO2 enable is still gated by LDO2 VSEL decoding.
As a result, in tracking mode LDO2 will be disabled for following code 
(SMPS VSEL format):
000000 & 100000 (MSB not decoded)
011001 & 111001 (MSB not decoded)
011010 & 111010 (MSB not decoded)
011100 & 111100 (MSB not decoded)
011101 & 111101 (MSB not decoded)
011110 & 111110 (MSB not decoded)





Therefore, we made this voltage to be invalid on above case.
