Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbbAVEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:25:28 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:38330 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbbAVEZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:25:22 -0500
MIME-Version: 1.0
In-Reply-To: <54C07AD7.9020102@rock-chips.com>
References: <1421861370-19422-1-git-send-email-wxt@rock-chips.com>
 <1421861370-19422-2-git-send-email-wxt@rock-chips.com> <CAGS+omAi+F1_1-8wmDMf9oUq6GCjXu8N4kyeNmKRWv8m3eaCrA@mail.gmail.com>
 <54C07AD7.9020102@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 22 Jan 2015 12:25:00 +0800
X-Google-Sender-Auth: ppW9qW2gffsCPkluE71Gm_OftUw
Message-ID: <CAGS+omDdbUBn5swOZ23K3MpjzV3UMk3xABLWxj1SFE+s=FcHQA@mail.gmail.com>
Subject: Re: [PATCH v3] thermal: rockchip: make temperature reporting much
 more accurate
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: Caesar Wang <wxt@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:21 PM, Caesar Wang
<caesar.wang@rock-chips.com> wrote:
>
> 在 2015年01月22日 12:01, Daniel Kurtz 写道:
>
>> On Thu, Jan 22, 2015 at 1:29 AM, Caesar Wang <wxt@rock-chips.com> wrote:
>>>
>>> In general, the kernel should report temperature readings exactly as
>>> reported by the hardware. The cpu / gpu thermal driver works in 5 degree
>>> increments,but we ought to do more accurate. The temperature will do
>>> linear interpolation between the entries in the table.
>>>
>>> Test= $md5sum /dev/zero &
>>> $while true; do grep "" /sys/class/thermal/thermal_zone[1-2]/temp;
>>> sleep .5; done
>>>
>>> e.g. We can get the result as follows:
>>>      /sys/class/thermal/thermal_zone1/temp:39994
>>>      /sys/class/thermal/thermal_zone2/temp:39086
>>>      /sys/class/thermal/thermal_zone1/temp:39994
>>>      /sys/class/thermal/thermal_zone2/temp:39540
>>>      /sys/class/thermal/thermal_zone1/temp:39540
>>>      /sys/class/thermal/thermal_zone2/temp:39540
>>>      /sys/class/thermal/thermal_zone1/temp:39540
>>>      /sys/class/thermal/thermal_zone2/temp:39994
>>>
>>> Signed-off-by: Caesar Wang <wxt@rock-chips.com>
>>> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>>
>>> ---
>>>
>>> Changes in v3:
>>> Suggested-by Daniel Kurtz,
>>> the check doesn't reject "code == 0xfff"
>>> Fixed in rk_tsadcv2_code_to_temp(u32 code)
>>>
>>> Changes in v2:
>>> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>>
>>>   drivers/thermal/rockchip_thermal.c | 32
>>> ++++++++++++++++++++++----------
>>>   1 file changed, 22 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/thermal/rockchip_thermal.c
>>> b/drivers/thermal/rockchip_thermal.c
>>> index 1bcddfc..ce18007 100644
>>> --- a/drivers/thermal/rockchip_thermal.c
>>> +++ b/drivers/thermal/rockchip_thermal.c
>>> @@ -193,19 +193,22 @@ static u32 rk_tsadcv2_temp_to_code(long temp)
>>>
>>>   static long rk_tsadcv2_code_to_temp(u32 code)
>>>   {
>>> -       int high, low, mid;
>>> -
>>> -       low = 0;
>>> -       high = ARRAY_SIZE(v2_code_table) - 1;
>>> -       mid = (high + low) / 2;
>>> +       unsigned int low = 0;
>>> +       unsigned int high = ARRAY_SIZE(v2_code_table) - 1;
>>> +       unsigned int mid = (low + high) / 2;
>>> +       unsigned int num;
>>> +       unsigned long denom;
>>>
>>> +       /* No code available, return callback */
>>>          if (code > v2_code_table[low].code || code <
>>> v2_code_table[high].code)
>>> -               return 125000; /* No code available, return max
>>> temperature */
>>> +               return rk_tsadcv2_code_to_temp(code);
>>
>> Isn't this an infinite recursion?
>
>
> No, I think we can try check if it  is happened.
> Maybe we can return a warning/error for it.

I mean, if the 'if' condition is true, then this will just call the
same function again with the same code, and again, and again...
Just return an error code here, -ENOENT maybe?
I am not sure what error code is appropriate.


>
>>>          while (low <= high) {
>>> -               if (code >= v2_code_table[mid].code && code <
>>> -                   v2_code_table[mid - 1].code)
>>> -                       return v2_code_table[mid].temp;
>>> +               if (code >= v2_code_table[mid].code &&
>>> +                   code < v2_code_table[mid - 1].code)
>>> +                       break;
>>> +               else if (code == TSADCV2_DATA_MASK)
>>> +                       break;
>>>                  else if (code < v2_code_table[mid].code)
>>>                          low = mid + 1;
>>>                  else
>>> @@ -213,7 +216,16 @@ static long rk_tsadcv2_code_to_temp(u32 code)
>>>                  mid = (low + high) / 2;
>>>          }
>>>
>>> -       return 125000;
>>> +       /*
>>> +        * The 5C granularity provided by the table is too much. Let's
>>> +        * assume that the relationship between sensor readings and
>>> +        * temperature between 2 table entries is linear and interpolate
>>> +        * to produce less granular result.
>>> +        */
>>> +       num = v2_code_table[mid].temp - v2_code_table[mid - 1].temp;
>>> +       num *= v2_code_table[mid - 1].code - code;
>>> +       denom = v2_code_table[mid - 1].code - v2_code_table[mid].code;
>>> +       return v2_code_table[mid - 1].temp + (num / denom);
>>>   }
>>>
>>>   /**
>>> --
>>> 1.9.1
>>>
>>>
>>
>>
>
> --
> Best regards
> Caesar Wang (王晓腾)
> 福州瑞芯微电子有限公司
> Fuzhou Rockchip Electronics Co.Ltd
> 福建省福州市铜盘路软件大道89号软件园A区18号楼(350003)
> Addr:No.18 Building, A District, No.89, software Boulevard Fuzhou,
> Fujian,PRC
> Email:wxt@rock-chips.com
> Tel:+86-591-83991906/07->8221
>
>
