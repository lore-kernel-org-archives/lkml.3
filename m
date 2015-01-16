Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbbAPSLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:11:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45905 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAPSLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:11:04 -0500
Message-ID: <54B95426.5020509@oracle.com>
Date: Fri, 16 Jan 2015 13:10:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
References: <54B4A909.9060206@oracle.com>	<20150113164441.5b210f48@tlielax.poochiereds.net>	<54B5A145.6060108@oracle.com>	<20150114092705.39bd4881@tlielax.poochiereds.net>	<54B6FF69.3080705@oracle.com>	<20150115152247.5e660000@tlielax.poochiereds.net>	<54B920BB.3010205@oracle.com> <20150116094028.4ffd675f@tlielax.poochiereds.net>
In-Reply-To: <20150116094028.4ffd675f@tlielax.poochiereds.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 09:40 AM, Jeff Layton wrote:
> On Fri, 16 Jan 2015 09:31:23 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> On 01/15/2015 03:22 PM, Jeff Layton wrote:
>>> Ok, I tried to reproduce it with that and several variations but it
>>> still doesn't seem to do it for me. Can you try the latest linux-next
>>> tree and see if it's still reproducible there?
>>
>> It's still not in in today's -next, could you send me a patch for testing
>> instead?
>>
> 
> Seems to be there for me:
> 
> ----------------------[snip]-----------------------
> /*
>  * This function is called on the last close of an open file.
>  */
> void locks_remove_file(struct file *filp)
> {
>         /* ensure that we see any assignment of i_flctx */
>         smp_rmb();
> 
>         /* remove any OFD locks */
>         locks_remove_posix(filp, filp);
> ----------------------[snip]-----------------------
> 
> That's actually the right place to put the barrier, I think. We just
> need to ensure that this function sees any assignment to i_flctx that
> occurred before this point. By the time we're here, we shouldn't be
> getting any new locks that matter to this close since the fcheck call
> should fail on any new requests.
> 
> If that works, then I'll probably make some other changes to the set
> and re-post it next week.
> 
> Many thanks for helping me test this!

You're right, I somehow missed that.

But it doesn't fix the issue, I still see it happening, but it seems
to be less frequent(?).


Thanks,
Sasha

