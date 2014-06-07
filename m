Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaFGV6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:58:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59445 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaFGV6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:58:19 -0400
Message-ID: <53938AD8.80109@cogentembedded.com>
Date: Sun, 08 Jun 2014 01:57:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>
CC: David Rientjes <rientjes@google.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dns_resolver: assure that dns_query() result is null-terminated
References: <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com> <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de> <alpine.DEB.2.02.1406071441050.24927@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406071441050.24927@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 01:42 AM, David Rientjes wrote:

>> dns_query() credulously assumes that keys are null-terminated and
>> returns a copy of a memory block that is off by one.

> No sign-off?  Please read Documentation/SubmittingPatches.

>> ---
>>   net/dns_resolver/dns_query.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
>> index e7b6d53..84871a2 100644
>> --- a/net/dns_resolver/dns_query.c
>> +++ b/net/dns_resolver/dns_query.c
>> @@ -145,11 +145,11 @@ int dns_query(const char *type, const char *name, size_t namelen,
>>   	len = upayload->datalen;
>>
>>   	ret = -ENOMEM;
>> -	*_result = kmalloc(len + 1, GFP_KERNEL);
>> +	*_result = kzalloc(len + 1, GFP_KERNEL);
>>   	if (!*_result)
>>   		goto put;
>>
>> -	memcpy(*_result, upayload->data, len + 1);
>> +	memcpy(*_result, upayload->data, len);
>>   	if (_expiry)
>>   		*_expiry = rkey->expiry;

> kzalloc() would be unnecessary overhead (zeroing definitely comes with a
> cost) if you're going to copy to the memory immediately afterwards.  Just
> leave the kmalloc(), do the memcpy() and explicitly zero terminate it
> _result.

    You can also replace kmalloc()/memcpy() with kmemdup().

WBR, Sergei

