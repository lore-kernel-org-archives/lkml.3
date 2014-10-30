Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793AbaJ3VAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:00:33 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:40478 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbaJ3VAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:00:32 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <5452A6ED.8090007@mev.co.uk>
Date: Thu, 30 Oct 2014 21:00:29 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] staging: comedi: don't allow read() on async command
 set up for "write"
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk> <1414672952-1587-5-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D882600D340@P3PWEX4MB008.ex4.secureserver.net> <54529F35.1060108@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D8826017050@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8826017050@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/14 20:45, Hartley Sweeten wrote:
> On Thursday, October 30, 2014 1:28 PM, Ian Abbott wrote:
>> On 30/10/14 18:05, Hartley Sweeten wrote:
>>> On Thursday, October 30, 2014 5:42 AM, Ian Abbott wrote:
>>   [snip]
>>>>    	add_wait_queue(&async->wait_head, &wait);
>>>>    	while (nbytes > 0 && !retval) {
>>>> @@ -2249,6 +2253,10 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
>>>>    				retval = -EACCES;
>>>>    				break;
>>>>    			}
>>>> +			if (async->cmd.flags & CMDF_WRITE) {
>>>> +				retval = -EINVAL;
>>>> +				break;
>>>> +			}
>>>
>>> Is this second test really needed in the while() loop?
>>>
>>> For that matter, are the s->busy tests needed in the while() loop?
>>
>> To answer your second question, some other thread using the same file
>> object might have cancelled the asynchronous command, causing the
>> current thread to see that the command is no longer active when it wakes up.
>>
>> To answer your first question, that other thread might have managed to
>> set up another asynchronous command in before we wake up, and it might
>> have been set up as a "write" command (if the subdevice supports
>> commands in both directions).  This doesn't detect the case when the
>> other thread has managed to set up another "read" command, but since the
>> current read() call hasn't read any data yet, we can just pretend we
>> didn't know about the original command and read data from the new
>> command instead.  (After all, the calling thread can't prove the read()
>> started before the first command was cancelled, so we can just pretend
>> it didn't.)
>
> But when the command is first started by do_cmd_ioctl() we have this sequence:
>
> 	if (s->busy)
> 		return -EBUSY;
> 	...
> 	s->busy = file;
> 	ret = s->do_cmd(dev, s);
>
>  From then on the s->busy pointer can only be cleared in do_become_nonbusy()
> (by way of a (*cancel)). So another command cannot be started until the current
> command is completed.

The other thread could do its own read() after it cancelled the command, 
which would clear the busy condition (once it returns 0 to indicate 
end-of-file), so the current thread's read() still needs to check it.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
