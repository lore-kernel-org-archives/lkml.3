Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3GSEIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 00:08:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42966 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3GSEID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 00:08:03 -0400
X-Spam-Score: -100.8
Message-ID: <51E8BB66.6020002@asianux.com>
Date: Fri, 19 Jul 2013 12:07:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: George Spelvin <linux@horizon.com>, reiserfs-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: check/extend buffer length for printing functions
References: <51E65A68.8070009@asianux.com> <51E76ED7.303@asianux.com> <51E7994D.1060300@asianux.com> <20130718074316.GY4165@ZenIV.linux.org.uk> <51E79F24.2050504@asianux.com> <51E7A4C1.4020309@asianux.com>
In-Reply-To: <51E7A4C1.4020309@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:18 PM, Chen Gang wrote:
> On 07/18/2013 03:54 PM, Chen Gang wrote:
>> On 07/18/2013 03:43 PM, Al Viro wrote:
>>> On Thu, Jul 18, 2013 at 03:29:17PM +0800, Chen Gang wrote:
>>>>> On 07/18/2013 12:28 PM, Chen Gang wrote:
>>>>>>>  
>>>>>>>>>  	strcpy(fmt1, fmt);
>>>>>>>>> @@ -199,46 +214,51 @@ static void prepare_error_buf(const char *fmt, va_list args)
>>>>>>>>>  	while ((k = is_there_reiserfs_struct(fmt1, &what)) != NULL) {
>>>>>>>>>  		*k = 0;
>>>>>>>>>  
>>>>>>>>> -		p += vsprintf(p, fmt1, args);
>>>>>>>>> +		p += vsnprintf(p, left, fmt1, args);
>>>>>
>>>>> At least, need use vscnprintf() instead of vsnprintf(), since we need
>>>>> the real written length return.
>>> 		n = vsnprintf(p, left, ....);
>>> 		left -= n;
>>> 		if (left <= 0) /* overflow */
>>> 			break;	/* or whatever's suitable here */
>>> 		p += n;
>>>
>>>
>>
>> Yeah, it is really a better fix. :-)
>>
>>
>> And now I am just testing, and find another issue about it, I am just
>> analyzing it it.
> 
> 
> even only change vsprintf() to vsnprintf(), it will report '<7' !!
> 

I finish analyzing it, it is not an issue.

'<7>' or '<5>' ... is the level, '<7>' is 'KERN_DEBUG', '<5>' is
'KERN_NOTICE' ...

For system log, the kernel always print level before time stamp, but
when we type command 'dmesg', it will skip them at the head of a line
(also skip the empty line).

It is implemented in "kernel/printk.c", below.

 887 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 888 {
 889         size_t len = 0;
 890         unsigned int prefix = (msg->facility << 3) | msg->level;
 891 
 892         if (syslog) {
 893                 if (buf) {
 894                         len += sprintf(buf, "<%u>", prefix);
 895                 } else {
 896                         len += 3;
 897                         if (prefix > 999)
 898                                 len += 3;
 899                         else if (prefix > 99)
 900                                 len += 2;
 901                         else if (prefix > 9)
 902                                 len++;
 903                 }
 904         }
 905 
 906         len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
 907         return len;
 908 }
 909 


When a string truncated by force (may without '\n'). It may print level
and time stamp not at the head of the line, which can not be skipped by
dmesg.

That is the reason why we can not see it.


We can try to modify the print_prefix() in "kernel/printk.c" to test
the result which I provide above.

  e.g. append addition information after the time stamp to be sure that this function is really affect to all lines which command 'dmesg' displays.
  e.g. use "\n<%u>" instead of "<%u>" and dummy 'syslog', to know dmesg will skip the level at the head of the line, and also skip the empty line.


And next, I will send patch v2 for this patch.

Welcome any additional suggestions, checking, or completions.

:-)

Thanks.

> ----------------------------diff begin---------------------------------
> 
> diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
> index c0b1112..9dd79be 100644
> --- a/fs/reiserfs/prints.c
> +++ b/fs/reiserfs/prints.c
> @@ -238,7 +238,8 @@ static void prepare_error_buf(const char *fmt, va_list args)
>  		p += strlen(p);
>  		fmt1 = k + 2;
>  	}
> -	vsprintf(p, fmt1, args);
> +
> +	vsnprintf(p, 13, fmt1, args);
>  	spin_unlock(&error_lock);
>  
>  }
> 
> ----------------------------diff end-----------------------------------
> 
> This patch seems related with this new issue.  So After I finish
> analyzing it (get root cause), then send the patch v2 for this patch.
> 
> 
> Thanks.
> 
>>
>> For next-20130717, let reiserfs build-in, when "mount /dev/sda11
>> /mnt/sda11" (assume sda11 is reiserfs filesystem).
>>
>> I modify the code like this (just only use vsnprintf instead of vsprintf):
>>
>> --------------------------diff begin------------------------------
>>
>> diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
>> index c0b1112..3a38a62 100644
>> --- a/fs/reiserfs/prints.c
>> +++ b/fs/reiserfs/prints.c
>> @@ -10,7 +10,7 @@
>>  
>>  #include <stdarg.h>
>>  
>> -static char error_buf[1024];
>> +static char error_buf[13];
>>  static char fmt_buf[1024];
>>  static char off_buf[80];
>>  
>> @@ -195,7 +195,7 @@ static void prepare_error_buf(const char *fmt, va_list args)
>>  	spin_lock(&error_lock);
>>  
>>  	strcpy(fmt1, fmt);
>> -
>> +#if 0
>>  	while ((k = is_there_reiserfs_struct(fmt1, &what)) != NULL) {
>>  		*k = 0;
>>  
>> @@ -238,7 +238,8 @@ static void prepare_error_buf(const char *fmt, va_list args)
>>  		p += strlen(p);
>>  		fmt1 = k + 2;
>>  	}
>> -	vsprintf(p, fmt1, args);
>> +#endif
>> +	vsnprintf(p, 13, fmt1, args);
>>  	spin_unlock(&error_lock);
>>  
>>  }
>>
>> --------------------------diff end--------------------------------
>>
>>
>> The output has '<7>':
>>
>> [root@dhcp122 ~]# dmesg
>> [   38.797073] REISERFS (device sda11): found reiser
>> [   38.797089] REISERFS warning (device sda11):  reiserfs_fill_super: CONFIG_REISE
>> [   38.797095] REISERFS warning (device sda11):  reiserfs_fill_super: - it is slow
>> [   38.797098] REISERFS (device sda11): using orderereiserfs: using flush barriers
>> [   38.800507] REISERFS (device sda11): journal para
>> [   38.801158] REISERFS (device sda11): checking tra<7>[   38.801165] REISERFS debug (device sda11): journal-1153
>> [   38.801405] REISERFS debug (device sda11): journal-1206
>> [   38.801410] REISERFS debug (device sda11): journal-1299
>> [   38.817621] REISERFS (device sda11): Using r5 has
>> [   38.817906] SELinux: initialized (dev sda11, type reiserfs), uses genfs_contexts
>>
>>
>>
>> Welcome any suggestions or completions.
>>
>> Thanks.
>>
> 
> 


-- 
Chen Gang
