Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbAUNZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:25:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42396 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbAUNZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:25:08 -0500
Message-ID: <54BFA8AE.2070902@oracle.com>
Date: Wed, 21 Jan 2015 08:25:02 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
References: <54B4A909.9060206@oracle.com>	<20150113164441.5b210f48@tlielax.poochiereds.net>	<54B5A145.6060108@oracle.com>	<20150114092705.39bd4881@tlielax.poochiereds.net>	<54B6FF69.3080705@oracle.com>	<20150115152247.5e660000@tlielax.poochiereds.net>	<54B920BB.3010205@oracle.com>	<20150116094028.4ffd675f@tlielax.poochiereds.net>	<54B95426.5020509@oracle.com>	<20150116135304.0feeaf15@tlielax.poochiereds.net> <20150116161635.3678ad23@tlielax.poochiereds.net>
In-Reply-To: <20150116161635.3678ad23@tlielax.poochiereds.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 04:16 PM, Jeff Layton wrote:
> On Fri, 16 Jan 2015 13:53:04 -0500
> Jeff Layton <jlayton@primarydata.com> wrote:
> 
>> > On Fri, 16 Jan 2015 13:10:46 -0500
>> > Sasha Levin <sasha.levin@oracle.com> wrote:
>> > 
>>> > > On 01/16/2015 09:40 AM, Jeff Layton wrote:
>>>> > > > On Fri, 16 Jan 2015 09:31:23 -0500
>>>> > > > Sasha Levin <sasha.levin@oracle.com> wrote:
>>>> > > > 
>>>>> > > >> On 01/15/2015 03:22 PM, Jeff Layton wrote:
>>>>>> > > >>> Ok, I tried to reproduce it with that and several variations but it
>>>>>> > > >>> still doesn't seem to do it for me. Can you try the latest linux-next
>>>>>> > > >>> tree and see if it's still reproducible there?
>>>>> > > >>
>>>>> > > >> It's still not in in today's -next, could you send me a patch for testing
>>>>> > > >> instead?
>>>>> > > >>
>>>> > > > 
>>>> > > > Seems to be there for me:
>>>> > > > 
>>>> > > > ----------------------[snip]-----------------------
>>>> > > > /*
>>>> > > >  * This function is called on the last close of an open file.
>>>> > > >  */
>>>> > > > void locks_remove_file(struct file *filp)
>>>> > > > {
>>>> > > >         /* ensure that we see any assignment of i_flctx */
>>>> > > >         smp_rmb();
>>>> > > > 
>>>> > > >         /* remove any OFD locks */
>>>> > > >         locks_remove_posix(filp, filp);
>>>> > > > ----------------------[snip]-----------------------
>>>> > > > 
>>>> > > > That's actually the right place to put the barrier, I think. We just
>>>> > > > need to ensure that this function sees any assignment to i_flctx that
>>>> > > > occurred before this point. By the time we're here, we shouldn't be
>>>> > > > getting any new locks that matter to this close since the fcheck call
>>>> > > > should fail on any new requests.
>>>> > > > 
>>>> > > > If that works, then I'll probably make some other changes to the set
>>>> > > > and re-post it next week.
>>>> > > > 
>>>> > > > Many thanks for helping me test this!
>>> > > 
>>> > > You're right, I somehow missed that.
>>> > > 
>>> > > But it doesn't fix the issue, I still see it happening, but it seems
>>> > > to be less frequent(?).
>>> > > 
>> > 
>> > Ok, that was my worry (and one of the reasons I really would like to
>> > find some way to reproduce this on my own). I think what I'll do at
>> > this point is pull the patchset from linux-next until I can consult
>> > with someone who understands this sort of cache-coherency problem
>> > better than I do.
>> > 
>> > Once I get it resolved, I'll push it back to my linux-next branch and
>> > let you know and we can give it another go.
>> > 
>> > Thanks for the testing so far!
> Actually, I take it back. One more try...
> 
> I dragooned David Howells into helping me look at this and he talked me
> into just going back to using the i_lock to protect the i_flctx
> assignment.
> 
> My hope is that will work around whatever strange effect is causing
> this. Can you test tomorrow's -next tree (once it's been merged) and see
> whether this is still reproducible?

I've updated and re-tested with the latest -next, and it seems that the
issue is gone.

I'll update if I end up seeing it again.


Thanks,
Sasha
