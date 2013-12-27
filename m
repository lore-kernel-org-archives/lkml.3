Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3L0Hee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 02:34:34 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48813 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3L0Hed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 02:34:33 -0500
Message-ID: <52BD2D81.7090506@hitachi.com>
Date: Fri, 27 Dec 2013 16:34:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: Re: [PATCH] perf probe: Improve error message when function
 not found
References: <1387562649-25929-1-git-send-email-dsahern@gmail.com> <52BC3295.3020007@gmail.com>
In-Reply-To: <52BC3295.3020007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/26 22:43), David Ahern wrote:
> Masami:
> 
> If you do not have any problems with this version please Ack so Arnaldo 
> will pick it up.

David, as we talked about that before;

(2013/12/04 10:23), Masami Hiramatsu wrote:> (2013/12/04 0:15), David Ahern wrote:
>> On 12/2/13, 10:12 PM, Masami Hiramatsu wrote:
>>>> That needs to be explicitly stated in the error message -- only global
>>>> symbols may be given.
>>>
>>> Ah, I see. In that case, I think the "variable" is not a correct word,
>>> the "symbol" is better, because perf probe can take tracing variable
>>> arguments after the trace point definition. :)
>>
>> Right, variable is not the correct word. So how about this:
>>
>> "Failed to find requested symbol in %s. Is it a global symbol?"
>
> Yeah, that's good for me now :)

But your patch, still using the "variable"....

>> +		pr_err("Failed to find requested symbol in %s. Is it a global variable?\n",
>> +		       name);

Thus, I can't give Ack for this.

Anyway, I'd like to rewrite this part since it is too limited,
after my 2 weeks off.

Thank you,

> On 12/20/13, 1:04 PM, David Ahern wrote:
>> When requesting a function from a userspace library the error message to
>> the user is less than helpful. e.g.,
>>
>>      perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
>>      no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
>>      Failed to load map.
>>         Error: Failed to add events. (-22)
>>
>> yet the symbol really does exist but is a local symbol which is filtered:
>>
>> nm /lib64/libpthread-2.14.90.so | grep __pthread_mutex_lock_full
>> 0000000000005700 t __pthread_mutex_lock_full
>>
>> With this patch:
>>      perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
>>
>>      no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
>>      Failed to find function in /lib64/libpthread-2.14.90.so. Perhaps it is a local variable?
>>        Error: Failed to add events. (-22)
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 9c6989ca2bea..2eac49096840 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -2309,7 +2309,8 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>>   	}
>>   	available_func_filter = strfilter__new(function, NULL);
>>   	if (map__load(map, filter_available_functions)) {
>> -		pr_err("Failed to load map.\n");
>> +		pr_err("Failed to find requested symbol in %s. Is it a global variable?\n",
>> +		       name);
>>   		goto out;
>>   	}

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


