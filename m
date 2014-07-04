Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbaGDSyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:54:32 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34037 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaGDSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140704171824.GC11787@mtj.dyndns.org>
References: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
	<20140624210930.GD14909@htj.dyndns.org>
	<CADT32eJPAty_yGA5UGZV9h7XHN_8Sn70v1vhRRn7+URvU+URGA@mail.gmail.com>
	<20140624214340.GE14909@htj.dyndns.org>
	<20140704171824.GC11787@mtj.dyndns.org>
Date: Fri, 4 Jul 2014 13:54:29 -0500
Message-ID: <CADT32eJ6_3EwEEtvcBwmrp4Te4cLfYJc9hoU0kQTtyweUFF1Og@mail.gmail.com>
Subject: Re: [PATCH] blkio: Release blkg infrastructure only after last policy
 is deactivated.
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        Shirish Pargaonkar <spargaonkar@suse.com>, axboe@kernel.dk,
        ssant@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, I do not have another iteration of the patch yet.

we have two customers who reported this problem.  One of them has not
responded to requests to test a/any patch and other one is not able to
recreate this
with the latest release.  And I am not able to recreate this problem
on my own but
working on a setup.  So if you have any patch, I would be happy to
test/deploy it on a
first setup I can get hold of.

I was also trying to figure out whether this is some refcounting issue
or not since
I was thinking that put by anybody other than blk_cleanup_queue() should
not result on freeing/blk_release_queue() i.e. put by blk_cleanup_queue() should
always be the last put.

Regards,

Shirish


On Fri, Jul 4, 2014 at 12:18 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jun 24, 2014 at 05:43:40PM -0400, Tejun Heo wrote:
>> Hello,
>>
>> On Tue, Jun 24, 2014 at 04:37:58PM -0500, Shirish Pargaonkar wrote:
>> > When we start from blk_cleanup_queue(), we put request queue in bypass mode,
>> > drain it (and service queues), and then destroy blkcgs (explicitly)
>> >
>> > When we start from blk_release_queue(), we do not drain first and then
>> > destroy blkcgs.  So if we destroy blkcg and then call (implicitly) and
>> > bail out of
>> > blk_drain_queue, we would not have drained the service queues which
>> > is not what we want.
>>
>> I'm not really following you.  What do you mean "when we start from
>> blk_release_queue()"?  blk_release_queue() is called after the last
>> put which can only follow blk_cleanup_queue() if the queue is fully
>> initialized.  The queue is already in bypass mode and fully drained by
>> the time control reaches blk_release_queue().  Module [un]load
>> re-invoking the path doesn't change anything.
>>
>> > I do not see any harm in waiting till end to release blkcgs (as I understand).
>>
>> Well, the harm there is not freeing those blkgs unless all the blkcg
>> policies are unloaded which is usually never on most systems.
>
> Ping.  We have a patch which makes this problem more visible.  Are you
> still planning to re-spin the patch?
>
> Thanks.
>
> --
> tejun
