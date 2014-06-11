Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaFKVP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:15:26 -0400
Received: from cmta4.telus.net ([209.171.16.77]:39837 "EHLO cmta4.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbaFKVPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:15:24 -0400
X-Authority-Analysis: v=2.0 cv=CvthhAED c=1 sm=2
 a=zJWegnE7BH9C0Gl4FFgQyA==:17 a=1chCufcSjPwA:10 a=LGgl8L9ij00A:10
 a=IkcTkHD0fZMA:10 a=aatUQebYAAAA:8 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19
 a=VwQbUJbxAAAA:8 a=p-nOP-kxAAAA:8 a=KKAkSRfTAAAA:8 a=QyXUC8HyAAAA:8
 a=MthGaeBqYI1wDCWjPbMA:9 a=QEXdDO2ut3YA:10 a=Nr7RNssggs8A:10
 a=WwgC8nHKvroA:10 a=dGJ0OcVc7YAA:10 a=zJWegnE7BH9C0Gl4FFgQyA==:117
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Stratos Karafotis'" <stratosk@semaphore.gr>
Cc: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>,
        <dirk.j.brandewie@intel.com>
References: <1402490012-19969-1-git-send-email-stratosk@semaphore.gr> <009b01cf857a$d5032090$7f0961b0$@net> <539862DB.9060905@semaphore.gr> <00a001cf8586$24eb5c70$6ec21550$@net> <5398BA0B.7070903@semaphore.gr>
In-Reply-To: <5398BA0B.7070903@semaphore.gr>
Subject: RE: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
Date: Wed, 11 Jun 2014 14:15:19 -0700
Message-ID: <00b301cf85ba$40fe4290$c2fac7b0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+FspZX483AU5ztS0aNwt9CCYX3NAAA0OPA
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Stratos Karafotis [mailto:stratosk@semaphore.gr] 
Sent: June-11-2014 13:20
To: Doug Smythies
Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; rjw@rjwysocki.net; viresh.kumar@linaro.org; dirk.j.brandewie@intel.com
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct

On 2014.06.11 13:20 Stratos Karafotis wrote:
> On 11/06/2014 06:02 μμ, Doug Smythies wrote:
>> 
>> On 2104.06.11 07:08 Stratos Karafotis wrote:
>>> On 11/06/2014 04:41 μμ, Doug Smythies wrote:
>>>
>>> No.
>>
>>> The intent was only ever to round properly the pseudo floating point result of the divide.
>>> It was much more important (ugh, well 4 times more) when FRACBITS was still 6, which also got changed to 8 in a recent patch.
>>>
>> 
>> Are you sure?
>> 
>> Yes.
>> 
>>> This rounding was very recently added.
>>> As far as I can understand, I don't see the meaning of this rounding, as is.
>>> Even if FRAC_BITS was 6, I think it would have almost no improvement in
>>> calculations.
>> 
>> Note: I had not seen this e-mail when I wrote a few minutes ago:
>> 
>> You may be correct.
>> If Dirk agrees, I will re-analyse the entire driver for rounding effects soon.
>> When FRACBITS was 6 there were subtle cases where the driver would get stuck, and not make a final pstate change, with the default PID gains.
>> Other things have changed, and the analysis needs to be re-done.
>> 

> Could you please elaborate a little bit more what we need these 2 lines below?
>
>        if ((rem << 1) >= int_tofp(sample->mperf))
>                core_pct += 1;
>
> Because nothing is mentioned for them in commit's changelog.
> Do we need to round core_pct or not?
> Because if we try to round it, I think this patch should work.

As mentioned originally, they are there just to round the pseudo floating number, not the integer portion only.
Let us bring back the very numbers you originally gave and work through it.

aperf = 5024
mperf = 10619

core_pct = 47.31142292%
or 47 and 79.724267 256ths
or to the closest kept fractional part 47 and 80 256ths
or 12112 as a pseudo float.
The maximum error with this rounding will be 1 part in 512 and symmetric instead of the 1 part in 256 always in one direction without.

Now if FRACBITS was still 6:
core_pct = 47.31142292%
or 47 and 19.931 64ths
or to the closest kept fractional part 47 and 20 64ths
or 3028 as a pseudo float.
The maximum error with this rounding will be 1 part in 128 and symmetric instead of the 1 part in 64 (1.6% !!!) always in one direction without.

Hope this helps.

... Doug


