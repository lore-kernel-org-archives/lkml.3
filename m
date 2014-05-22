Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaEVBBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:01:47 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44593 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEVBBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:01:45 -0400
Message-ID: <537D4C73.40901@gmail.com>
Date: Thu, 22 May 2014 09:01:39 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: gerrit@erg.abdn.ac.uk, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSCBsaW51eC1uZXh0XSBuZXQvZGNjcC8=?=
 =?UTF-8?B?dGltZXIuYzogdXNlICd1NjQnIGluc3RlYWQgb2YgJ3M2NCcgdG8gYXZvaWQgY28=?=
 =?UTF-8?B?bXBpbGVyJ3Mgd2FybmluZw==?=
References: <1546102096.46113.1400718399706.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1546102096.46113.1400718399706.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 08:26 AM, 管雪涛 wrote:
> 
> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> 'dccp_timestamp_seed' is initialized once by ktime_get_real() in
>> dccp_timestamping_init(). It is always less than ktime_get_real()
>> in dccp_timestamp().
>>
>> Then, ktime_us_delta() in dccp_timestamp() will always return positive
>> number. So can use manual type cast to let compiler and do_div() know
>> about it to avoid warning.
>>
>> The related warning (with allmodconfig under unicore32):
>>
>>     CC [M]  net/dccp/timer.o
>>   net/dccp/timer.c: In function ‘dccp_timestamp’:
>>   net/dccp/timer.c:285: warning: comparison of distinct pointer types lacks a cast
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  net/dccp/timer.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/dccp/timer.c b/net/dccp/timer.c
>> index 16f0b22..1cd46a3 100644
>> --- a/net/dccp/timer.c
>> +++ b/net/dccp/timer.c
>> @@ -280,7 +280,7 @@ static ktime_t dccp_timestamp_seed;
>>   */
>>  u32 dccp_timestamp(void)
>>  {
>> -	s64 delta = ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
>> +	u64 delta = (u64)ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
> 
> Do you assume that delta should be very small?
> Otherwise, return value will be different if data type is changed.
> 

'u64' is a very very large number. after calculation, if it is based on
nano second (although I am not quite sure whether it is based on it).

        a hour,            3,600,000,000,000ns
        a day,            90,000,000,000,000ns
        a year,       50,000,000,000,000,000ns
        10 years,    500,000,000,000,000,000ns
        100 years, 5,000,000,000,000,000,000ns
        4G * 4G = 16,000,000,000,000,000,000ns

So we can assume it will never overflow for 'u64'.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
