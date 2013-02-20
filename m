Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935712Ab3BTNx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:53:59 -0500
Received: from clients.imail.ciril.fr ([193.54.6.108]:59986 "EHLO
	clients.imail.ciril.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935405Ab3BTNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:53:58 -0500
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2013 08:53:58 EST
Message-ID: <5124D2ED.1090703@univ-lorraine.fr>
Date: Wed, 20 Feb 2013 14:43:09 +0100
From: Alexandre SIMON <Alexandre.Simon@univ-lorraine.fr>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandre SIMON <Alexandre.Simon@univ-lorraine.fr>
Subject: Re: [ 1/1] printk: fix buffer overflow when calling log_prefix function
 from call_console_drivers
References: <20130218181454.615592566@linuxfoundation.org> <20130218181454.976143076@linuxfoundation.org> <87ip5njfze.wl%satoru.takeuchi@gmail.com>
In-Reply-To: <87ip5njfze.wl%satoru.takeuchi@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AS-Test: me
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Satoru Takeuchi] wrote the following on [20/02/2013 14:02]:
[...]
> 
> I reviewed this patch and it seems to be good for me. Since I'm not good at
> printk code, I want to confirm whether what I think is correct or not.
> Is the following my understanding correct?

  No problem, it's nice to talk about this patch !


>> -			cur_index += log_prefix(&LOG_BUF(cur_index), &msg_level, NULL);
> 
> Here is one example of the problematic case.
> 
>   +---- start of log_buf
>   |
>   |                           +--- end of log_buf
>   |                           |
>   v                           v
>   <-------- log_buf ----------><------- * outside of log_buf. Don't access here !!! * --- ~~~
>                               ^
>                               |
>                               cur_index
> 
> In this case, only LOG_BUF(cur_index) is safe to access and
> 
>  - "LOG_BUF(cur_index) + 1" as p[1],
>  - "LOG_BUF(cur_index) + 2" as p[2], and
>  - "LOG_BUF(cur_index) + 1 or more" as simple_strtoul(&p[1], &endp, 10)
> 
> in log_prefix() are not to do so. Hence touching them would cause the system hang as you
> said as follows.

  Yes, your analyze is totally right. Your figure is clear and shows exactly when the problem occurs in the "borderline case".
  The initial code does not check that the "cur_index" can be at the end of "log_buf" whereas "log_prefix" function may access to one, two or more indexes after.


[...]
>> +			/*
>> +			 * prepare buf_prefix, as a contiguous array,
>> +			 * to be processed by log_prefix function
>> +			 */
>> +			char buf_prefix[SYSLOG_PRI_MAX_LENGTH+1];
>> +			unsigned i;
>> +			for (i = 0; i < ((end - cur_index)) && (i < SYSLOG_PRI_MAX_LENGTH); i++) {
> 
> The condition, "i < ((end - cur_index)) && (i < SYSLOG_PRI_MAX_LENGTH)", is to prevent
> access over
> 
>  - the region to write out, and

  Yes, because buf_prefix has a fixed length.


>  - the max length of log_prefix.

  In another term : to do not exceed the end boundary of "log_buf".


> In addition, "min(end - cur_index, SYSLOG_PRI_MAX_LENGTH)" has the same meaning here.

  Yes, that may also work.


>> +				buf_prefix[i] = LOG_BUF(cur_index + i);
> 
> You ensure that all characters (not only first character) in the candidate of log_prefix
> are inside of log_buf here by copying each character of them one by one.

  Yes, I also take care of the index that must be masked to wrap around the log_buf : we restart at index=0 when cur_index > length(log_buf).
  At this point, we are sure that the buffer passed to log_prefix is consistent and all the access (through p[1], p[2], simple_strtoul(...)) may not cause a buffer overflow.


> Thanks,
> Satoru

  Bye, Alex.

