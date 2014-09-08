Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaIHNb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:31:59 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45152 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaIHNb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:31:58 -0400
Message-ID: <540DAFBC.1010502@roeck-us.net>
Date: Mon, 08 Sep 2014 06:31:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC Watchdog
References: <1409841592-18890-1-git-send-email-lee.jones@linaro.org> <1409841592-18890-6-git-send-email-lee.jones@linaro.org> <20140905155811.GA12374@roeck-us.net> <20140908123246.GB26284@lee--X1>
In-Reply-To: <20140908123246.GB26284@lee--X1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.540DAFCD.0281,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 05:32 AM, Lee Jones wrote:
> On Fri, 05 Sep 2014, Guenter Roeck wrote:
...
>>> +
>>> +static struct st_wdog_syscfg stid127_syscfg = {
>>> +	.type_mask	= BIT(2),
>>> +	.enable_mask	= BIT(2),
>>> +};
>>> +
>>> +static struct st_wdog_syscfg stih415_syscfg = {
>>> +	.type_mask	= BIT(6),
>>> +	.enable_mask	= BIT(7),
>>> +};
>>> +
>>> +static struct st_wdog_syscfg stih416_syscfg = {
>>> +	.type_mask	= BIT(6),
>>> +	.enable_mask	= BIT(7),
>>> +};
>>> +
>>> +static struct st_wdog_syscfg stih407_syscfg = {
>>> +	.enable_mask	= BIT(19),
>>> +};
>>> +
...

>>> +	/* Mask/unmask watchdog reset */
>>> +	regmap_update_bits(st_wdog->syscfg->regmap,
>>> +			   st_wdog->syscfg->enable_reg,
>>> +			   st_wdog->syscfg->enable_mask,
>>> +			   !enable);
>>
>> enable is a bool, but is supposed to provide the value to be put into the
>> register, masked with enable_mask. Unless I am missing something, the value
>> is not shifted in regmap_update_bits. So I don't think this can work, but
>> effectively always writes zero into the mask unless the mask happens to be
>> at bit position 0 - which never happens.
>>
>> Same is true for warm_reset above, which also has values 0 or 1.
>>
>> I know it does not really matter in C (at least when it comes to handling
>> 0 and 1), but I would suggest to avoid mixing booleans with bit masks.
>
> You're right of course, great spot.
>
> How about?
>
>    !enable << ffs(st_wdog->syscfg->enable_mask).
>
Seems to add a lot of complexity (as in 'makes it difficult to understand')
to avoid a conditional, and assumes that enable_mask will never have more
than one bit set. I would go with
	enable ? st_wdog->syscfg->enable_mask : 0
to avoid confusion, but your call.

Guenter

