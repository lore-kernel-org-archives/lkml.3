Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaJAIT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:19:58 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34171 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJAITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:19:54 -0400
Message-ID: <542BB925.1090409@gmail.com>
Date: Wed, 01 Oct 2014 10:19:49 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Doug Ledford <dledford@redhat.com>
CC: mtk.manpages@gmail.com, Davidlohr Bueso <dave@stgolabs.net>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
References: <542921EA.4050709@gmail.com>	 <1412011687.15492.39.camel@firewall.xsintricity.com>	 <CAKgNAkj9+Z1yO-zrQ_qWFut7BqOkzNtNCruSSRyTKMpXZOcBaw@mail.gmail.com> <1412107074.4930.9.camel@firewall.xsintricity.com>
In-Reply-To: <1412107074.4930.9.camel@firewall.xsintricity.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 09/30/2014 09:57 PM, Doug Ledford wrote:
> On Tue, 2014-09-30 at 12:12 +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Doug,
>>
>> On Mon, Sep 29, 2014 at 7:28 PM, Doug Ledford <dledford@redhat.com> wrote:
>>> On Mon, 2014-09-29 at 11:10 +0200, Michael Kerrisk (man-pages) wrote:
>>>> Hello Doug, David,
>>>>
>>>> I think you two were the last ones to make significant
>>>> changes to the semantics of the files in /proc/sys/fs/mqueue,
>>>> so I wonder if you (or anyone else who is willing) might
>>>> take a look at the man page text below that I've written
>>>> (for the mq_overview(7) page) to describe past and current
>>>> reality, and let me know of improvements of corrections.
>>>>
>>>> By the way, Doug, your commit ce2d52cc1364 appears to have
>>>> changed/broken the semantics of the files in the /dev/mqueue
>>>> filesystem. Formerly, the QSIZE field in these files showed
>>>> the number of bytes of real user data in all of the queued
>>>> messages. After that commit, QSIZE now includes kernel
>>>> overhead bytes, which does not seem very useful for user
>>>> space. Was that change intentional? I see no mention of the
>>>> change in the commit message, so it sounds like it was not
>>>> intended.
>>>
>>> That change didn't come in that commit.  That commit modified it, but
>>> didn't introduce it.
>>
>> (Which commit was it then? d6629859b36 ?)
> 
> Yes, that's the one.
> 
>>> Now, was it intentional? Yes.  Is it valuable, useful?  That depends on
>>> your perspective.
>>
>> Thanks for the detailed explanation below. However, I don't understand
>> why the (useful) work that you describe below necessitated a change in
>> the QSIZE value that was exposed to user space.
> 
> Given how long ago this was, I can't say for sure, old age and memory
> being what it is ;-)  Most likely, when I rewrote the msg_insert
> routine, I saw we were updating info->qsize and said to myself "Crap,
> I've added a new structure, we have to account for it too" and made the
> change.
> 
>>  Surely the necessary
>> changes could have been done internally while still leaving QSIZE to
>> expose the same value it ever did?
> 
> Yes, it could have.
> 
>>  As things stand now (and unless I
>> am missing something), QSIZE exposes an implementation-specific
>> internal value that has little meaning or value to user space.
> 
> This part is not necessarily true.  I'm pretty sure at the time I
> thought the struct msg_msg was also included in qsize (even though it
> isn't).  And although we've not had any reports of bugs on this, I have
> a Red Hat bug against the accounting change (namely that it caught one
> user off guard that they needed to increase their RLIMIT_MSGQUEUE to
> create the same number/size of queues they used to be able to create)
> and so it does have some value in that it's the only way a user has of
> knowing just how much the overhead of their queue is biting them in the
> ass in terms of that RLIMIT_MSGQUEUE test.  But, since it doesn't
> include the size of each struct msg_msg, it's incomplete even for that
> purpose.  Like I said in my previous email, I'm not so sure it wouldn't
> be wise to include some extra data in this file (but that again would be
> an ABI break).  Maybe a second line that includes something like this:
> 
> CUR_OVERHEAD: # RLIM_OVERHEAD: # RLIM_PAYLOAD: #
> 
> where CUR_OVERHEAD is how much we currently have allocated in internal
> kernel structures for the current DATA on the line above, and the other
> two are the amount of size we charged against the RLIMIT_MSGQUEUE
> available to the user based upon their queue parameters and the
> potential worst case scenario of queue usage.
> 
>>  And,
>> it's unfortunate that the commit message made no mention of the fact
>> that there was an ABI change here.
> 
> I don't think I realized it was an ABI change at the time.

So, to summarize:

* QSIZE returning a count of the user data bytes in the queue was
  the actual (and intended and documented) behavior from Linux 
  2.6.6 to 3.4.
* Linux 3.5 changed the value exposed by QSIZE to something
  that more closely matches the amount of memory
  consumed by the kernel implementation. However:

     -- That change broke the ABI.
     -- The newly exposed value still doesn't match the
        consumed memory as accounted against RLIMIT_MSGQUEUE,
        so it's still not really useful.

* No-one complained about the QSIZE ABI change yet (well, except 
  me), but that doesn't mean no-one has been bitten. After
  all, it took a while before reports about the HARD_QUEUESMAX
  breakage to filter through.

I think QSIZE really should be fixed to expose the same value
it used to expose, which is the real number of user data bytes
in the queue. I'm agnostic on whether or not further fields
along the lines you suggest should be added to the /dev/mqueue 
files. In my opinion, that's an ABI extension, but not a breakage:
those files have been designed for easy parsing with fields of
the form "name:value", and properly designed applications
won't be tripped up by extensions to the format.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
