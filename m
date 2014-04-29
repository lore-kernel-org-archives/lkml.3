Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaD2VtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:49:24 -0400
Received: from mail.siteground.com ([67.19.240.234]:57609 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419AbaD2VtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:49:23 -0400
Message-ID: <53601E5B.5050004@1h.com>
Date: Wed, 30 Apr 2014 00:49:15 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>, "Theodore Ts'o" <tytso@mit.edu>,
        containers@lists.linux-foundation.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
References: <535FADDA.2070803@1h.com> <20140429183534.GB19325@thunk.org> <20140429185251.GA27969@ubuntumail>
In-Reply-To: <20140429185251.GA27969@ubuntumail>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 09:52 PM, Serge Hallyn wrote:
> Quoting Theodore Ts'o (tytso@mit.edu):
>> On Tue, Apr 29, 2014 at 04:49:14PM +0300, Marian Marinov wrote:
>>>
>>> I'm proposing a fix to this, by replacing the capable(CAP_LINUX_IMMUTABLE)
>>> check with ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE).
>>
>> Um, wouldn't it be better to simply fix the capable() function?
>>
>> /**
>>   * capable - Determine if the current task has a superior capability in effect
>>   * @cap: The capability to be tested for
>>   *
>>   * Return true if the current task has the given superior capability currently
>>   * available for use, false if not.
>>   *
>>   * This sets PF_SUPERPRIV on the task if the capability is available on the
>>   * assumption that it's about to be used.
>>   */
>> bool capable(int cap)
>> {
>> 	return ns_capable(&init_user_ns, cap);
>> }
>> EXPORT_SYMBOL(capable);
>>
>> The documentation states that it is for "the current task", and I
>> can't imagine any use case, where user namespaces are in effect, where
>> using init_user_ns would ever make sense.
>
> the init_user_ns represents the user_ns owning the object, not the
> subject.
>
> The patch by Marian is wrong.  Anyone can do 'clone(CLONE_NEWUSER)',
> setuid(0), execve, and end up satisfying 'ns_capable(current_cred()->userns,
> CAP_SYS_IMMUTABLE)' by definition.
>
> So NACK to that particular patch.  I'm not sure, but IIUC it should be
> safe to check against the userns owning the inode?
>

So what you are proposing is to replace 'ns_capable(current_cred()->userns, CAP_SYS_IMMUTABLE)' with
'inode_capable(inode, CAP_SYS_IMMUTABLE)' ?

I agree that this is more sane.

Marian

>> No?  Otherwise, pretty much every single use of capable() would be
>> broken, not just this once instances in ext4/ioctl.c.
>>
>> 					- Ted
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers
>


-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
