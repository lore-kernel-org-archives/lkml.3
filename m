Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaFKQHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:07:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54334 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaFKQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:07:42 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4d-53987ecbedb4
Message-id: <53987EBC.70307@samsung.com>
Date: Wed, 11 Jun 2014 18:07:24 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jon Loeliger <loeliger@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robin Holt <holt@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: mm: cache-l2x0: Add base address argument to
 write_sec callback
References: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
 <1402500612-4778-2-git-send-email-t.figa@samsung.com>
 <CAJgR-BhgZ7k_Uk_Md79pkZKQXTZUjspqq0u9sa9D69Kixy7DhA@mail.gmail.com>
In-reply-to: <CAJgR-BhgZ7k_Uk_Md79pkZKQXTZUjspqq0u9sa9D69Kixy7DhA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t/xa7qn62YEG3yar2LRP62D1aJ3wVU2
	i+2dM9gtpvxZzmSx6fE1VovLu+awWcxe0s9iMeP8PiaL25d5Lc5t38Ji8bpvDbPFql1/GC32
	X/Fy4PVoae5h8/j2dRKLx+W+XiaPnbPusnvcubaHzWPzknqPvi2rGD3uXn/J5HH8xnYmj8+b
	5AK4orhsUlJzMstSi/TtErgyvjf3MhXMEKw4uPwSewPjDJ4uRg4OCQETiYUNjl2MnECmmMSF
	e+vZuhi5OIQEljJKXJzUwwjhfGaUOPOylxWkildAQ2Jzzx4wm0VAVWLFvNdsIDabgJrE54ZH
	YDa/gJbEmqbrLCALRAUiJB5fEIJoFZT4MfkeC4gtAtQ66+wiJpD5zAJ7mCXuPrkFNlNYIF7i
	U+MjdojFBxglWlZsBBvEKRAscf22PkgNs4C6xKR5i5ghbHmJzWveMk9gFJyFZMcsJGWzkJQt
	YGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESZV92MC4+ZnWIUYCDUYmHl0NnWrAQa2JZ
	cWXuIUYJDmYlEV6NshnBQrwpiZVVqUX58UWlOanFhxiZODilGhg5wtJ9O94+bmPdm/ThA5v5
	lyWLVe4qbA7umKF51fnS1+Jdn7pzTt/6qT+BzyjZ1nPZi8xanoU8a66Eni4/E/L1AJupEt+s
	z1tvV0hM1tLImixj0bzR/PDh/S1nJLS4biwIejZF5auUe7XLGa/1qs+URIzawu4V7F1WXKGb
	tD1jlnuSzaaPi5qUWIozEg21mIuKEwFxDNd3kAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.06.2014 18:00, Jon Loeliger wrote:
>> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
>> index 060a75e..ddaebcd 100644
>> --- a/arch/arm/include/asm/mach/arch.h
>> +++ b/arch/arm/include/asm/mach/arch.h
>> @@ -46,7 +46,8 @@ struct machine_desc {
>>         enum reboot_mode        reboot_mode;    /* default restart mode */
>>         unsigned                l2c_aux_val;    /* L2 cache aux value   */
>>         unsigned                l2c_aux_mask;   /* L2 cache aux mask    */
>> -       void                    (*l2c_write_sec)(unsigned long, unsigned);
>> +       void                    (*l2c_write_sec)(void __iomem *,
>> +                                                unsigned long, unsigned);
>>         struct smp_operations   *smp;           /* SMP operations       */
>>         bool                    (*smp_init)(void);
>>         void                    (*fixup)(struct tag *, char **);
> 
>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>> index efc5cab..1695eab 100644
>> --- a/arch/arm/mm/cache-l2x0.c
>> +++ b/arch/arm/mm/cache-l2x0.c
>> @@ -72,7 +72,7 @@ static void l2c_write_sec(unsigned long val, void __iomem *base, unsigned reg)
>>         if (val == readl_relaxed(base + reg))
>>                 return;
>>         if (outer_cache.write_sec)
>> -               outer_cache.write_sec(val, reg);
>> +               outer_cache.write_sec(base, val, reg);
>>         else
>>                 writel_relaxed(val, base + reg);
>>  }
> 
> The parameter order (base, val, reg) seems very non-intuitive.
> Are you matching some existing prototype or adhering to some
> backwards compatibility issue?  If not wouldn't, say, (base, reg, val)
> or (val, base, reg) be more intuitive?

Hmm, I didn't think too much about this, so this order is just whatever
first came to my mind, probably because I'm used to xxx_write(ctx, val,
reg) accessors found in many drivers.

Anyway, l2c_write_sec() in arm/mm/cache-l2x0.c, which calls
outer_cache.write_sec(), already uses (val, base, reg) convention, so
probably this one would be most suitable. I'll change in v2.

Best regards,
Tomasz
