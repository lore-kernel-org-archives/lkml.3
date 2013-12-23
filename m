Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab3LWUF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:05:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37672 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab3LWUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:05:55 -0500
Message-ID: <52B897A1.8030205@codeaurora.org>
Date: Mon, 23 Dec 2013 12:05:53 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] regmap: Allow regmap_bulk_write() to work for "no-bus"
 regmaps
References: <20131210235000.GK11468@sirena.org.uk> <52A7AE1B.3040201@codeaurora.org> <20131211005106.GL11468@sirena.org.uk> <52A7C0C3.2070805@codeaurora.org> <20131211132729.GT11468@sirena.org.uk> <52AA42FD.4040503@codeaurora.org> <20131213104128.GT11044@sirena.org.uk> <20131213213707.GO21983@codeaurora.org> <20131216210153.GA3185@sirena.org.uk> <20131217023047.GC31766@codeaurora.org> <20131218184541.GH31886@sirena.org.uk>
In-Reply-To: <20131218184541.GH31886@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/13 10:45, Mark Brown wrote:
> On Mon, Dec 16, 2013 at 06:30:47PM -0800, Stephen Boyd wrote:
>
>> -	/* No formatting is require if val_byte is 1 */
>> -	if (val_bytes == 1) {
>> -		wval = (void *)val;
>> +			ival = *(unsigned int *)(val + (i * val_bytes));
>> +			ret = _regmap_write(map, reg + (i * map->reg_stride),
>> +					ival);
>> +			if (ret != 0)
>> +				goto out;
> This doesn't quite work - val is an array of objects of the size of the
> size of a register not of unsigned integers so you're parsing extra data
> out there.  That possibly wasn't the best choice of API but we have
> quite a few users now so ick.

Are you concerned that we'll read past the end of the val buffer? Do we
need to cast the pointer to be the appropriate size according to
val_bytes? Something like this?

                for (i = 0; i < val_count; i++) {
                        unsigned int ival;

                        switch (val_bytes) {
                        case 1: 
                                ival = *(u8 *)(val + (i * val_bytes));
                                break;
                        case 2: 
                                ival = *(u16 *)(val + (i * val_bytes));
                                break;
                        case 4: 
                                ival = *(u32 *)(val + (i * val_bytes));
                                break;
#ifdef CONFIG_64BIT
                        case 8: 
                                ival = *(u64 *)(val + (i * val_bytes));
                                break;
#endif
                        default:
                                ret = -EINVAL;
                                goto out;
                        }

                        ret = _regmap_write(map, reg + (i * map->reg_stride),
                                        ival);
                        if (ret != 0)
                                goto out;
                }

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

