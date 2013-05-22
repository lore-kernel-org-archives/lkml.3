Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3EVJxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:53:07 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:19035 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447Ab3EVJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:53:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0NADWUnFF5LBBG/2dsb2JhbABbgwiDAmm5DYUeBAGBARd0giMBAQQBIwQLASMjBQsIAQIYAgIFIQICDwUlAyETiAcFjWubJJFQFoEQjEgPgR0HgkGBEwOXN5FBgyEqgS0
Date: Wed, 22 May 2013 19:53:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: CAI Qian <caiqian@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: 3.9.2: xfstests triggered panic
Message-ID: <20130522095300.GK29466@dastard>
References: <40971621.4497871.1369211701112.JavaMail.root@redhat.com>
 <1805266998.4499261.1369211998387.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1805266998.4499261.1369211998387.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 04:39:58AM -0400, CAI Qian wrote:
> Reproduced on almost all s390x guests by running xfstests.
> 
> 14634.396658¨ XFS (dm-1): Mounting Filesystem 
> 14634.525522¨ XFS (dm-1): Ending clean mount 
> 14640.413007¨  <000000000017c6d4>¨ idle_balance+0x1a0/0x340 
> 14640.413010¨  <000000000063303e>¨ __schedule+0xa22/0xaf0 
> 14640.428279¨  <0000000000630da6>¨ schedule_timeout+0x186/0x2c0 
> 14640.428289¨  <00000000001cf864>¨ rcu_gp_kthread+0x1bc/0x298 
> 14640.428300¨  <0000000000158c5a>¨ kthread+0xe6/0xec 
> 14640.428304¨  <0000000000634de6>¨ kernel_thread_starter+0x6/0xc 
> 14640.428308¨  <0000000000634de0>¨ kernel_thread_starter+0x0/0xc 
> 14640.428311¨ Last Breaking-Event-Address: 
> 14640.428314¨  <000000000016bd76>¨ walk_tg_tree_from+0x3a/0xf4 
> 14640.428319¨  list_add corruption. next->prev should be prev (0000000000000918 
> ), but was           (null). (next=          (null)). 

Where's XFS in this? walk_tg_tree_from() is part of the scheduler
code. This kind of implies a stack corruption....

> Sometimes, this pops up,
> [16907.275002] WARNING: at kernel/rcutree.c:1960 
> 
> or this,
> 15316.154171¨ XFS (dm-1): Mounting Filesystem 
> 15316.255796¨ XFS (dm-1): Ending clean mount 
> 15320.364246¨            00000000006367a2: e310b0080004        lg      %r1,8(%r 
> 11) 
> 15320.364249¨            00000000006367a8: 41101010            la      %r1,16(% 
> r1) 
> 15320.364251¨            00000000006367ac: e33010000004        lg      %r3,0(%r 
> 1) 
> 15320.364252¨ Call Trace: 
> 15320.364252¨ Last Breaking-Event-Address: 
> 15320.364253¨  � <0000000000000000>¨ Kernel stack overflow. 
> 15320.364308¨ CPU: 0 Tainted: GF       W    3.9.2 #1 
> 15320.364309¨ Process rhts-test-runne (pid: 625, task: 000000003dccc890, ksp: 0 

.... and there you go - a stack overflow. Your kernel stack size is
too small.

I'd suggest that you need 16k stacks on s390 - IIRC every function
call has 128 byte stack frame, and there are call chains 70-80
functions deep in the storage stack...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
