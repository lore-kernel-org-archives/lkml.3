Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaETNga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:36:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55154 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaETNg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:36:28 -0400
Message-ID: <537B5A4F.2040209@ti.com>
Date: Tue, 20 May 2014 08:36:15 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>	<537A0247.1030503@ti.com>	<CAKohpoknoFuz8qnDpunA7oxr5E_18=+EQsFEy0P39fcU=4Ps9w@mail.gmail.com>	<CAGo_u6o+Vysq0LkdFTrP82WOpS1TT-=MD+zgP+Q_L=3RV8x5hA@mail.gmail.com>	<CAKohponAx=Hi_Ywgg4hXxrpmmaqy5=pYnb3nSBNUP3KtADTEeA@mail.gmail.com>	<CAKohpomKvPcioNmfzvx7vqJHqs_TrhnHH6yYb5w_0f+YvA5hvA@mail.gmail.com> <CAKohponRwcd8C-OyhrY2ExgMUP-WcrYo641j6osXekmRTc4m6A@mail.gmail.com>
In-Reply-To: <CAKohponRwcd8C-OyhrY2ExgMUP-WcrYo641j6osXekmRTc4m6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 08:31 AM, Viresh Kumar wrote:
> On 20 May 2014 17:35, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Though after more thought into this I feel this must also be done:
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index bdf09f5..3f540d8 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -453,9 +453,13 @@ int dev_pm_opp_add(struct device *dev, unsigned
>> long freq, unsigned long u_volt)
>>         }
>>
>>         if (new_opp->rate == opp->rate) {
>> +               int ret = 0;
>> +
>> +               if (new_opp->u_volt == opp->u_volt)
>> +                       ret = -EEXIST;
>>                 mutex_unlock(&dev_opp_list_lock);
>>                 kfree(new_opp);
>> -               return 0;
>> +               return ret;
> 
> Ahh, sorry gentlemen. I have screwed up yet again.
> 
> I meant this instead:
> 
>> +               if (new_opp->u_volt != opp->u_volt)
>> +                       ret = -EEXIST;
> 
> Otherwise we are trying to add same OPP again and we can
> return zero.
> 
if it was added and disabled? I suggest:
new_opp->u_volt != opp->u_volt || !opp->available

I still dont like the idea that we are allowing folks to do:
{
	{1GHz 1.1V}
	{1GHz 1.1V}
	{1.2GHz 1.2V}
}

if you already had an OPP added and are trying to add it again, you
might want some debug ability. but anyways, with the mentioned check
above, my opposition is lower.

-- 
Regards,
Nishanth Menon
