Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaIRNbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:31:47 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51859 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbaIRNbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:31:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140917174647.GC19308@redhat.com>
References: <CACZ9PQXJzoczS7gN5UCFygTHrLW5Rtjew5BF-txfL=cryE331w@mail.gmail.com>
	<1410960495-9198-1-git-send-email-r.peniaev@gmail.com>
	<20140917174647.GC19308@redhat.com>
Date: Thu, 18 Sep 2014 22:31:45 +0900
Message-ID: <CACZ9PQV0uQ+0Nzn10tCxyVo0_8qRFexh0iQLQErAkFc1T2WGHA@mail.gmail.com>
Subject: Re: [v2 PATCH 1/1] init: fix race between rootfs mount and firmware loading
From: Roman Peniaev <r.peniaev@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 2:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/17, Roman Pen wrote:
>>
>> +void wait_for_rootfs(void)
>> +{
>> +     /* Avoid waiting for ourselves */
>> +     if (is_global_init(current))
>> +             pr_warn("init: it is not a good idea to wait for the rootfs mount from the init task\n");
>> +     else
>> +             wait_event(rootfs_waitq, rootfs_mounted);
>> +}
>
> Well, this pr_warn() doesn't look very useful, how about
>
>         if (WARN_ON((is_global_init(current))))
>                 return;
>
> ? this will show the caller.

Ok, I will change.

>
>> +static inline void wake_up_rootfs_waiters(void)
>> +{
>> +     rootfs_mounted = true;
>> +     /* wake_up guarantees write memory barrier if and only if
>> +        there is a task to be woken up, it is not always true
>> +        for our case. */
>
> Yes, but this doesn't matter. wait_event() takes care,
>
>> +     smp_wmb();
>
> so please remove this wmb() and the comment.


I was confused by these lines in memory-barriers.txt document:

 (5) LOCK operations.

     This acts as a one-way permeable barrier.  It guarantees that all memory
     operations after the LOCK operation will appear to happen after the LOCK
     operation with respect to the other components of the system.

So it turns out to be, that without explicit barrier the order can be changed
and CONDITION set can be done _after_ list check.

But, it still can't cross UNLOCK border and will be between LOCK-UNLOCK.
And this is the key.

If my final understanding is right (please, correct me if I am still wrong),
following reordering can happen, but we are fine with it:

wake_up_rootfs                 wait_event

LOCK
check the list, but empty
set CONDITION <<< reordered
UNLOCK

                                          LOCK
                                          add to the list
                                          rmb            <<< now we
see CONDITION
                                          UNLOCK

                                          check CONDITION <<< it is
set, we are woken up


--
Roman
