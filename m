Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJUIn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:43:56 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:43079 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbaJUInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:43:53 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54461CC3.2020103@mev.co.uk>
Date: Tue, 21 Oct 2014 09:43:47 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: fix memory leak / bad pointer freeing
 for chanlist
References: <1413814240-3094-1-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D8825FF1FC4@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825FF1FC4@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/14 22:38, Hartley Sweeten wrote:
> On Monday, October 20, 2014 7:11 AM, Ian Abbott wrote:
>> As a follow-up to commit 6cab7a37f5c04 ("staging: comedi: (regression)
>> channel list must be set for COMEDI_CMD ioctl"), Hartley Sweeten pointed
>> out another couple of bugs stemming from commit 6cab7a37f5c04 ("staging:
>> comedi: comedi_fops: introduce __comedi_get_user_chanlist()").
>>
>> Firstly, `do_cmdtest_ioctl()` never frees the kernel copy of the user
>> chanlist allocated by `__comedi_get_user_chanlist()`, so that memory is
>> leaked.  Fix it by freeing the allocated kernel memory pointed to by
>> `cmd.chanlist` before that pointer is overwritten with its original
>> pointer to user memory before `cmd` is copied back to user-space.
>>
>> Secondly, if `__comedi_get_user_chanlist()` returns an error,
>> `cmd->chanlist` is left unchanged and in fact will be a pointer to user
>> memory.  This causes `do_cmd_ioctl()` to `goto cleanup` and call
>> `do_become_nonbusy()` which would attempt to free the memory pointed to
>> by the user-space pointer.  Fix it by setting `cmd->chanlist` to NULL at
>> the start of `__comedi_get_user_chanlist()`.
>>
>> Fixes: c6cd0eefb27b ("staging: comedi: comedi_fops: introduce __comedi_get_user_chanlist()")
>> Reported-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: <stable@vger.kernel.org> # 3.15.y 3.16.y 3.17.y: 6cab7a37f5c04
>> Cc: <stable@vger.kernel.org> # 3.15.y 3.16.y 3.17.y
>> ---
>> Greg, this patch applies to your "staging-linus" branch.
>> ---
>>   drivers/staging/comedi/comedi_fops.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
>> index a9b7fe5..a1788e8 100644
>> --- a/drivers/staging/comedi/comedi_fops.c
>> +++ b/drivers/staging/comedi/comedi_fops.c
>> @@ -1462,6 +1462,7 @@ static int __comedi_get_user_chanlist(struct comedi_device *dev,
>>   	unsigned int *chanlist;
>>   	int ret;
>>
>> +	cmd->chanlist = NULL;
>>   	chanlist = memdup_user(user_chanlist,
>>   			       cmd->chanlist_len * sizeof(unsigned int));
>>   	if (IS_ERR(chanlist))
>
> I don't think this covers all the problems in your second issue above.
>
> It does fix the attempt to free the memory pointed to by the user-space pointer
> if the memdub_user() fails.
>
> But in do_cmd_ioctl() we still have an issue if the s->do_cmdtest() fails or
> the CMDF_BOGUS flag is set. There we restore the users cmd.chanlist
> pointer to allow copy_to_user() to return the cmd/ But the kernel allocated
> chanlist is not freed. The goto cleanup will again try to free the user-space
> pointer.

No, 'async->cmd' is copied (via struct assignment) to local variable 
'cmd' and it is the local 'cmd.chanlist' pointer that is set to the 
original user-space pointer and the local 'cmd' that is copied back to 
user-space.  'async->cmd.chanlist' still points to the kernel copy of 
the chanlist that gets cleaned up by 'goto cleanup' / 'do_become_nonbusy().

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
