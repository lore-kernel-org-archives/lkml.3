Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbaIST1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:27:15 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41826 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaIST1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:27:14 -0400
Message-ID: <541C838B.7070207@collabora.co.uk>
Date: Fri, 19 Sep 2014 21:27:07 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 5/6] rtc: max77686: Use ffs() to calculate tm_wday
References: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>	 <1411122377-10426-6-git-send-email-javier.martinez@collabora.co.uk> <1411137561.24444.5.camel@joe-AO725>
In-Reply-To: <1411137561.24444.5.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On 09/19/2014 04:39 PM, Joe Perches wrote:
> On Fri, 2014-09-19 at 12:26 +0200, Javier Martinez Canillas wrote:
>> The function max77686_rtc_calculate_wday() is used to
>> calculate the day of the week to be filled in struct
>> rtc_time but that function only calculates the number
>> of bits shifted. So the ffs() function can be used to
>> find the first bit set instead of a special function.
> 
> This isn't the same logic.  Perhaps you want fls.
>

Right, the removed function has the same logic than fls() - 1 but the value
stored in data[RTC_WEEKDAY] is:

data[RTC_WEEKDAY] = 1 << tm->tm_wday;

so for this particular case, it doesn't matter since ffs() == fls() always.

>> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> []
>> -static inline int max77686_rtc_calculate_wday(u8 shifted)
>> -{
>> -	int counter = -1;
>> -	while (shifted) {
>> -		shifted >>= 1;
>> -		counter++;
>> -	}
>> -	return counter;
>> -}
>> -
>>  static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
>>  				   int rtc_24hr_mode)
>>  {
>> @@ -93,7 +83,7 @@ static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
>>  			tm->tm_hour += 12;
>>  	}
>>  
>> -	tm->tm_wday = max77686_rtc_calculate_wday(data[RTC_WEEKDAY] & 0x7f);
>> +	tm->tm_wday = ffs(data[RTC_WEEKDAY] & 0x7f) - 1;

I did wonder which function to use and the question is when you want to know
the number of shifted bits, do you look for the first or the last bit set?

Of course is the same for powers of two but I did a naive search to have an
usage count:

$ git grep "shift = ffs(" | wc -l
39
$ git grep "shift = fls(" | wc -l
17

so it seems that ffs() is twice more popular than fls() for this case so I
decided to use ffs() but I don't have a strong opinion tbh.

Best regards,
Javier
