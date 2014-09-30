Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaI3Ktb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:49:31 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:50666 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaI3Kta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:49:30 -0400
Message-ID: <542A8AB1.5000009@gmail.com>
Date: Tue, 30 Sep 2014 12:49:21 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: mtk.manpages@gmail.com, Doug Ledford <dledford@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
References: <542921EA.4050709@gmail.com> <1412022198.23497.23.camel@linux-t7sj.site>
In-Reply-To: <1412022198.23497.23.camel@linux-t7sj.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 09/29/2014 10:23 PM, Davidlohr Bueso wrote:
> Hi Michael,
> 
> Cc'ing Manfred.

(Thanks, I should have thought of that.)

> On Mon, 2014-09-29 at 11:10 +0200, Michael Kerrisk (man-pages) wrote:
>> Hello Doug, David,
>>
>> I think you two were the last ones to make significant 
>> changes to the semantics of the files in /proc/sys/fs/mqueue,
>> so I wonder if you (or anyone else who is willing) might
>> take a look at the man page text below that I've written
>> (for the mq_overview(7) page) to describe past and current
>> reality, and let me know of improvements of corrections.
> 
> Over the years posix mqueues have increasingly become a mess *sigh* :-/
> Thanks for doing this and untangling some of the historic changes.
> 
>> From mq_overview(7) draft:
>>
>>    /proc interfaces
>>        The following interfaces can be used to limit the amount of  ker‐
>>        nel  memory  consumed  by  POSIX  message  queues  and to set the
>>        default attributes for new message queues:
>>
>>        /proc/sys/fs/mqueue/msg_default (since Linux 3.5)
>>               This file  defines  the  value  used  for  a  new  queue's
>>               mq_maxmsg setting when the queue is created with a call to
>>               mq_open(3) where attr is specified as NULL.   The  default
>>               value for this file is 10.  The minimum and maximum are as
>>               for /proc/sys/fs/mqueue/msg_max.  If  msg_default  exceeds
>>               msg_max,  a  new queue's default mq_maxmsg value is capped
>>               to the msg_max limit. 
> 
> I think rephrasing this would read easier. Basically the behavior is
> this:
> 
> 		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
> 					   ipc_ns->mq_msg_default);
> 
> Something like:
> "a new queue's default mq_maxmsg value will be the smallest of msg_default and msg_max"

Yes, better. Changed. Thanks.
> 
>>  Up until Linux 2.6.28, the  default
>>               mq_maxmsg  was  10;  from  Linux  2.6.28 to Linux 3.4, the
>>               default was the value defined for the msg_max limit.
>>
>>        /proc/sys/fs/mqueue/msg_max
>>               This file can be used to view and change the ceiling value
>>               for the maximum number of messages in a queue.  This value
>>               acts as a ceiling on the attr->mq_maxmsg argument given to
>>               mq_open(3).   The  default  value  for msg_max is 10.  The
>>               minimum value is 1 (10 in  kernels  before  2.6.28).   The
>>               upper  limit is HARD_MSGMAX.  The msg_max limit is ignored
>>               for  privileged  processes  (CAP_SYS_RESOURCE),  but   the
>>               HARD_MSGMAX ceiling is nevertheless imposed.
> 
> Note that the HARD_MSGMAX check is done *only* for privileged processes,
> regular processes only check against namespace values. This is a pretty
> fundamental difference. The same goes of course for msgsize:

Yes, I understand. But, the existing text still seems okay to me. The
thing is that HARD_MSGMAX is still in effect a limit for unprivileged 
processes also, since it is a ceiling on 'msg_max'. See what I mean?

> 	if (capable(CAP_SYS_RESOURCE)) {
> 		if (attr->mq_maxmsg > HARD_MSGMAX ||
> 		    attr->mq_msgsize > HARD_MSGSIZEMAX)
> 			return -EINVAL;
> 	} else {
> 		if (attr->mq_maxmsg > ipc_ns->mq_msg_max ||
> 		    attr->mq_msgsize > ipc_ns->mq_msgsize_max)
> 			return -EINVAL;
> 	}
> 
> 
>>               The  definition  of  HARD_MSGMAX has changed across kernel
>>               versions:
>>
>>               *  Up to Linux 2.6.32: 131072 / sizeof(void *)
>>
>>               *  Linux 2.6.33 to 3.4: (32768 * sizeof(void *) / 4)
>>
>>               *  Since Linux 3.5: 65,536
>>
>>        /proc/sys/fs/mqueue/msgsize_default (since Linux 3.5)
> 
> You might want to mention the units (bytes) when refering to limits.

I added the words "bytes" in the text near here.
 
>>               This file defines the value used for a new queue's mq_msg‐
>>               size  setting  when  the  queue  is created with a call to
>>               mq_open(3) where attr is specified as NULL.   The  default
>>               value  for this file is 8192.  The minimum and maximum are
>>               as   for   /proc/sys/fs/mqueue/msgsize_max.     If    msg‐
>>               size_default  exceeds  msgsize_max,  a new queue's default
>>               mq_msgsize value is capped to the msgsize_max  limit.   Up
>>               until  Linux 2.6.28, the default mq_msgsize was 8192; from
>>               Linux 2.6.28 to Linux  3.4,  the  default  was  the  value
>>               defined for the msgsize_max limit.
>>
>>        /proc/sys/fs/mqueue/msgsize_max
> 
> Ditto here.

("bytes" does already get mentioned below.)

>>               This  file  can  be used to view and change the ceiling on
>>               the maximum message size.  This value acts as a ceiling on
>>               the  attr->mq_msgsize  argument  given to mq_open(3).  The
>>               default value for msgsize_max is 8192 bytes.  The  minimum
>>               value  is  128 (8192 in kernels before 2.6.28).  The upper
>>               limit for msgsize_max has varied across kernel versions:
>>
>>               *  Before Linux 2.6.28, the upper limit is INT_MAX.
>>
>>               *  From Linux 2.6.28 to 3.4, the limit is 1,048,576.
>>
>>               *  Since Linux 3.5, the limit is 16,777,216 (HARD_MSGSIZE‐
>>                  MAX).
>>               The  msgsize_max  limit  is ignored for privileged process
>>               (CAP_SYS_RESOURCE), but, since Linux  3.5,  the  HARD_MSG‐
>>               SIZEMAX ceiling is enforced for privileged processes.
>>
>>        /proc/sys/fs/mqueue/queues_max
>>               This  file  can be used to view and change the system-wide
>>               limit on the number of message queues that can be created.
>>               The default value for queues_max is 256.  The semantics of
>>               this limit have changed across kernel versions as follows:
>>
>>               *  Before Linux 3.5, this limit could be  changed  to  any
>>                  value  in  the  range 0 to INT_MAX, but privileged pro‐
>>                  cesses (CAP_SYS_RESOURCE) can exceed the limit.
>>
>>               *  Since Linux 3.5, there is a ceiling for this  limit  of
>>                  1024     (HARD_QUEUESMAX).      Privileged    processes
>>                  (CAP_SYS_RESOURCE) can exceed the queues_max limit, but
>>                  the  HARD_QUEUESMAX  limit  is enforced even for privi‐
>>                  leged processes.
>>
>>               *  Starting with Linux 3.14, the HARD_QUEUESMAX ceiling is
>>                  removed: no ceiling is imposed on the queues_max limit,
>>                  and privileged processes (CAP_SYS_RESOURCE) can  exceed
>>                  the limit.
> 
> Given that this was treated as a bug that breaks user-space, I don't
> think we really want to document the behavior between 3.5 and 3.14 (all
> three bullets). Stable kernels back to 3.5 now have the default
> behavior, so its as nothing ever changed(?). Now, if you explicitly want
> to document such bug, I would agree, but just not mentioning it as
> intentional differences in behavior. Does that make sense?

Yes. I've simplified that piece to just:

       /proc/sys/fs/mqueue/queues_max
              This file can be used to view and change  the  system-wide
              limit on the number of message queues that can be created.
              The default value for queues_max is 256.   No  ceiling  is
              imposed  on  the  queues_max  limit;  privileged processes
              (CAP_SYS_RESOURCE) can exceed the limit (but see BUGS).

plus:

    BUGS
       In  Linux  versions  3.5 to 3.14, the kernel imposed a ceiling of
       1024 (HARD_QUEUESMAX) on the value to which the queues_max  limit
       could be raised, and the ceiling was enforced even for privileged
       processes.  This ceiling value was removed  in  Linux  3.14,  and
       patches  to stable kernels 3.5.x to 3.13.x also removed the ceil‐
       ing.

Okay?

Thanks for the careful review, David.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
