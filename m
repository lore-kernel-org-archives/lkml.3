Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaENLsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:48:20 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:63236 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaENLsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:48:19 -0400
Message-ID: <537357FE.2050803@gmail.com>
Date: Wed, 14 May 2014 13:48:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/8] clk: berlin: add core clock driver for BG2/BG2CD
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com> <1399839881-29895-7-git-send-email-sebastian.hesselbarth@gmail.com> <20140514114315.GJ29318@piout.net>
In-Reply-To: <20140514114315.GJ29318@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 01:43 PM, Alexandre Belloni wrote:
> On 11/05/2014 at 22:24:39 +0200, Sebastian Hesselbarth wrote :
>> This driver deals with the core clocks found on Marvell Berlin
>> BG2 and BG2CD. For the shared register dividers, make use of the
>> corresponding driver and add some single clock muxes and gates for
>> the rest.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
[...]
>> diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
>> new file mode 100644
>> index 000000000000..7fe04e11861b
>> --- /dev/null
>> +++ b/drivers/clk/berlin/bg2.c
>> @@ -0,0 +1,509 @@
>> +/*
>> + * Copyright (c) 2014 Marvell Technology Group Ltd.
>> + *
>> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> + * Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/slab.h>
>> +
>> +#include "berlin2-div.h"
>> +
>> +/*
>> + * BG2/BG2CD SoCs have the following audio/video I/O units:
>> + *
>> + * audiohd: HDMI TX audio
>> + * audio0:  7.1ch TX
>> + * audio1:  2ch TX
>> + * audio2:  2ch RX
>> + * audio3:  SPDIF TX
>> + * video0:  HDMI video
>> + * video1:  Secondary video
>> + * video2:  SD auxiliary video
>> + *
>> + * There are no external audio clocks (ACLKI0, ACLKI1) and
>> + * only one external video clock (VCLKI0).
>> + *
>> + * Currently missing bits and pieces:
>> + * - audio_fast_pll is unknown
>> + * - audiohd_pll is unknown
>> + * - video0_pll is unknown
>> + * - audio[023], audiohd parent pll is assumed to be audio_fast_pll
>> + *
>> + */
>> +
>> +struct bg2_gate_data {
>> +	const char *name;
>> +	const char *parent_name;
>> +	u8 bit_idx;
>> +	unsigned long flags;
>> +};
>> +
>> +#define REG_CLKENABLE		0x00
>> +#define REG_CLKSELECT0		0x04
>> +#define REG_CLKSELECT1		0x08
>> +#define REG_CLKSELECT2		0x0c
>> +#define REG_CLKSELECT3		0x10
>> +#define REG_CLKSWITCH0		0x14
>> +#define REG_CLKSWITCH1		0x18
>> +
>> +enum {
>> +	/* clock divider cells */
>> +	SYS, CPU, DRMFIGO, CFG, GFX, ZSP, PERIF, PCUBE, VSCOPE, NFC_ECC,
>> +	VPP, APP, AUDIO0, AUDIO2, AUDIO3, AUDIO1,
>> +	/* clock gates */
>> +	GETH0, GETH1, SATA, AHBAPB, USB0, USB1, PBRIDGE, SDIO0, SDIO1,
>> +	NFC, SMEMC, AUDIOHD, VIDEO0, VIDEO1, VIDEO2,
>> +	MAX_CLKS
>> +};
>> +
>
> Shouldn't you reuse the CLKID_* that you are introducing in
> dt-bindings/clock/berlin2.h in a following patch there ?
> That would prevent inconsistencies.

I didn't follow the discussion of whether it is reasonable to
include dt-bindings/foo.h into driver code. But a quick git grep
reveals at least some drivers do it.

So, yes, if that is still valid, I fix it up to reuse the dt-binding
include here.

Sebastian

