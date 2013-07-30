Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3G3D7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:59:24 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:14876 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757195Ab3G3D7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:59:20 -0400
Message-ID: <51F73A17.2090208@akamai.com>
Date: Mon, 29 Jul 2013 23:59:19 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Du, Changbin" <changbin.du@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: add wildcard support to filter files/functions/modules
References: <1374757321-5988-1-git-send-email-changbin.du@gmail.com> <1374770840.1957.4.camel@joe-AO722>
In-Reply-To: <1374770840.1957.4.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 12:47 PM, Joe Perches wrote:
> On Thu, 2013-07-25 at 21:02 +0800, Du, Changbin wrote:
>> From: "Du, Changbin" <changbin.du@gmail.com>
>>
>> This patch add wildcard '*'(matches zero or more characters) and '?'
>> (matches one character) support when qurying debug flags.
> Seems very useful.  Caveat below.
>
>> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> []
>> @@ -127,6 +127,21 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
>>   		 query->first_lineno, query->last_lineno);
>>   }
>>   
>> +static int match_pattern(char *pat, char *str)
>> +{
>> +	switch (*pat) {
>> +	case '\0':
>> +		return !*str;
>> +	case '*':
>> +		return  match_pattern(pat+1, str) ||
>> +			(*str && match_pattern(pat, str+1));
>> +	case '?':
>> +		return *str && match_pattern(pat+1, str+1);
>> +	default:
>> +		return *pat == *str && match_pattern(pat+1, str 1);
>> +	}
>> +}
> What's the maximum length string used today?
> On a very long pattern, can this recursion cause stack overflow?
>
> Other than that, I like it.

The recursion here is a concern - especially since the 'pat' pointer is 
controlled from userspace. Maybe not at pretty, but this can easily be 
done in userspace. For example, to set all driver/usb* one could do 
something like:

grep "drivers/usb" control | awk -F ":| "  '{ print "file " $1 " line " 
$2 }' | xargs -i -n1 echo {} +p > control

Thanks,

-Jason



