Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab3JPAxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:53:48 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50507 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab3JPAxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:53:47 -0400
Message-ID: <525DE395.7040408@gmail.com>
Date: Wed, 16 Oct 2013 09:53:41 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mpatocka@redhat.com
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org
Subject: Re: A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com> <52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com> <alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

> I/Os shouldn't be returned with -ENOMEM. If they are, you can treat it as 
> a hard error.
It seems to be blkdev_issue_discard returns -ENOMEM
when bio_alloc fails, for example.
Waiting for a second and we can alloc the memory is my idea
for handling -ENOMEM returned.

> Blocking I/O until the admin turns a specific variable isn't too 
> reliable.
> 
> Think of this case - your driver detects I/O error and blocks all I/Os. 
> The admin tries to log in. The login process needs memory. To fulfill this 
> memory need, the login process writes out some dirty pages. Those writes 
> are blocked by your driver - in the result, the admin is not able to log 
> in and flip the switch to unblock I/Os.
> 
> Blocking I/O indefinitely isn't good because any system activity 
> (including typing commands into shell) may wait on this I/O.
I understand the problem. But, what should I do then?
Since writeboost is a cache software,
it loses consistency if we ignore the cache at all
in its returning I/O error.
Go panic in that case is also inappropriate (But, inaccessibility to
the storage will eventually halt the whole system. If so, go panic might
be an acceptable solution).

I am afraid my idea is based on your past comment
> If you can't handle a specific I/O request failure gracefully, you should 
> mark the driver as dead, don't do any more I/Os to the disk or cache 
> device and return -EIO on all incoming requests.
> 
> Always think that I/O failures can happen because of connection problems, 
> not data corruption problems - for example, a disk cable can go loose, a 
> network may lose connectivity, etc. In these cases, it is best to stop 
> doing any I/O at all and let the user resolve the situation.
1) In failure, mark the driver dead - set `blockup` to 1 in my case -
   and returning -EIO on all incoming requests. Yes.
2) And wait for the user resolve the situation - returning -EIO until
   admin turns `blockup` to 0 after checkup in my case - . Yes.

Did you mean we should not provide any way to recover the system
because admin may not be able to reach the switch?
writeboost module autonomously checking the device in problem
recovered should be implemented?
Retry submitting I/O to the device and find the device is recovered
on I/O success is a solution and I have implemented it.
I/O retry doesn't destroy any consistency in writeboost;
sooner or later it can not be able to accept writes any more because of
lack of RAM buffer which can be reused after I/O success to cache device.

Akira

