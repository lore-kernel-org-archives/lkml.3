Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3FZVMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:12:55 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:50693 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3FZVMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:12:53 -0400
X-AuditID: cbfec37d-b7f036d000004805-31-51cb59548c3e
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] power: Add warning message about incorrect system date
 and time after resume when pm_trace is enabled
Thread-topic: [PATCH v2] power: Add warning message about incorrect system date
 and time after resume when pm_trace is enabled
Thread-index: AQHOcTIp4yU9PBfFeEaBODaFSkxwag==
Date: Wed, 26 Jun 2013 21:12:51 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61731812@sisaex02sj>
References: <1372116318-10824-1-git-send-email-shuah.kh@samsung.com>
 <2689226.oQ0T3XLPmT@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+wn25I5OlAg5XvhSxmTdnLZHF51xw2
	i8+9Rxgt7p46ymbRv7CXyeLrTwcHNo+ds+6yeyze85LJ49HiFkaPFau/s3t83iQXwBrFZZOS
	mpNZllqkb5fAldHdvp+l4JdIxZWXpxkbGP8KdDFycEgImEicfaLWxcgJZIpJXLi3nq2LkYtD
	SGAZo8SvsyeZIZxeJomtj/cwQTjzGSU6fr5kBmlhE1CX+Px6BzuILSKgKrHlyX92kCJmgVlM
	Eqs3PWYCSQgL1EvMfAeREBFoYJSYunwlO8huEQE9iRNTDEBqWICa3+45wQJi8wrYS5xcdAHM
	FhLIkvhwpwlsASPQfd9PrQGbySwgLtHcepMF4m4BiSV7zjND2KISLx//Y4V4TVFi+2oriHIt
	ifU7j0O1aks8eXeBFWKVoMSPyfdYJjCKzUIydRaSlllIWmYhaVnAyLKKUay0OLmgOCk9tcJE
	rzgxt7g0L10vOT93EyMkCmt3MN7/anOIUYCDUYmH9wPj6UAh1sSy4srcQ4wSHMxKIrzWnkAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjNZTYpqC+zmKc1Pelih1cJWHiBxasPnXll5xqf1skqkb
	rNJKtxwUPs7u2CdofZf301VZp4+r1JQqMgyevxA6OJk5L0tT5pNP6IRt8gZb72SbSE38KjXh
	+BH/tL7C6+ecfVyPf/F1W7DTahW/sc33Z4JcxUvZi3QOT/G8JPm8zrOr5crWV8wblViKMxIN
	tZiLihMBHt92UKACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 05:01 PM, Rafael J. Wysocki wrote:
> On Monday, June 24, 2013 05:25:18 PM Shuah Khan wrote:
>> pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
>> Reason for this is that the RTC is the only reliably available piece of
>> hardware during resume operations where a value can be set that will
>> survive a reboot.
>>
>> Consequence is that after a resume (even if it is successful) your system
>> clock will have a value corresponding to the magic number instead of the
>> correct date/time! It is therefore advisable to use a program like ntp-date
>> or rdate to reset the correct date/time from an external time source when
>> using this trace option.
>>
>> There is no run-time message to warn users of the consequences of enabling
>> pm_trace. Adding a warning message to pm_trace_store() will serve as a
>> reminder to users to set the system date and time after resume.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   kernel/power/main.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/power/main.c b/kernel/power/main.c
>> index d77663b..fd744d1 100644
>> --- a/kernel/power/main.c
>> +++ b/kernel/power/main.c
>> @@ -528,6 +528,8 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
>>
>>   	if (sscanf(buf, "%d", &val) == 1) {
>>   		pm_trace_enabled = !!val;
>> +		pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n");
>> +		pr_cont("PM: Remember to set correct time after resume\n");
>
> You can do it like this:
>
> +	pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n"
> +		  "PM: Remember to set correct time after resume\n");
>
> No need to use pr_cont(). :-)

:) Yeah.

>
> And I'd say "during" instead of "after" in the first sentence.
>
> I'd also say something like "Correct system time has to be restored manually after resume."
> instead of the second one.
>

Will do. I think I should add a check and print this warning when 
pm_trace is enabled and not when it is disabled. The way this patch is 
done, it prints this warning for enable and disable. For both:

echo 1 > pm_trace and echo 0 > pm_trace.

Any thoughts?

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
