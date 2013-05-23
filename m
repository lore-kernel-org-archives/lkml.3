Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3EWELf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 00:11:35 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34493 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3EWELd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 00:11:33 -0400
Date: Thu, 23 May 2013 00:11:30 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        xfs@oss.sgi.com
Message-ID: <915421596.5010452.1369282290151.JavaMail.root@redhat.com>
In-Reply-To: <20130523034611.GX24543@dastard>
References: <40971621.4497871.1369211701112.JavaMail.root@redhat.com> <1805266998.4499261.1369211998387.JavaMail.root@redhat.com> <20130522095300.GK29466@dastard> <1483868349.4996990.1369279016162.JavaMail.root@redhat.com> <20130523034611.GX24543@dastard>
Subject: Re: 3.9.2: xfstests triggered panic
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.2: xfstests triggered panic
Thread-Index: nw1i+XDAeRDiEuz7zqXGB08vIYjsQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com
> Sent: Thursday, May 23, 2013 11:46:11 AM
> Subject: Re: 3.9.2: xfstests triggered panic
> 
> On Wed, May 22, 2013 at 11:16:56PM -0400, CAI Qian wrote:
> > ----- Original Message -----
> > > From: "Dave Chinner" <david@fromorbit.com>
> > > To: "CAI Qian" <caiqian@redhat.com>
> > > Cc: "LKML" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
> > > xfs@oss.sgi.com
> > > Sent: Wednesday, May 22, 2013 5:53:00 PM
> > > Subject: Re: 3.9.2: xfstests triggered panic
> > > 
> > > On Wed, May 22, 2013 at 04:39:58AM -0400, CAI Qian wrote:
> > > > Reproduced on almost all s390x guests by running xfstests.
> > > > 
> > > > 14634.396658¨ XFS (dm-1): Mounting Filesystem
> > > > 14634.525522¨ XFS (dm-1): Ending clean mount
> > > > 14640.413007¨  <000000000017c6d4>¨ idle_balance+0x1a0/0x340
> > > > 14640.413010¨  <000000000063303e>¨ __schedule+0xa22/0xaf0
> > > > 14640.428279¨  <0000000000630da6>¨ schedule_timeout+0x186/0x2c0
> > > > 14640.428289¨  <00000000001cf864>¨ rcu_gp_kthread+0x1bc/0x298
> > > > 14640.428300¨  <0000000000158c5a>¨ kthread+0xe6/0xec
> > > > 14640.428304¨  <0000000000634de6>¨ kernel_thread_starter+0x6/0xc
> > > > 14640.428308¨  <0000000000634de0>¨ kernel_thread_starter+0x0/0xc
> > > > 14640.428311¨ Last Breaking-Event-Address:
> > > > 14640.428314¨  <000000000016bd76>¨ walk_tg_tree_from+0x3a/0xf4
> > > > 14640.428319¨  list_add corruption. next->prev should be prev
> > > > (0000000000000918
> > > > ), but was           (null). (next=          (null)).
> > > 
> > > Where's XFS in this? walk_tg_tree_from() is part of the scheduler
> > > code. This kind of implies a stack corruption....
> > > 
> > > > Sometimes, this pops up,
> > > > [16907.275002] WARNING: at kernel/rcutree.c:1960
> > > > 
> > > > or this,
> > > > 15316.154171¨ XFS (dm-1): Mounting Filesystem
> > > > 15316.255796¨ XFS (dm-1): Ending clean mount
> > > > 15320.364246¨            00000000006367a2: e310b0080004        lg
> > > > %r1,8(%r
> > > > 11)
> > > > 15320.364249¨            00000000006367a8: 41101010            la
> > > > %r1,16(%
> > > > r1)
> > > > 15320.364251¨            00000000006367ac: e33010000004        lg
> > > > %r3,0(%r
> > > > 1)
> > > > 15320.364252¨ Call Trace:
> > > > 15320.364252¨ Last Breaking-Event-Address:
> > > > 15320.364253¨  � <0000000000000000>¨ Kernel stack overflow.
> > > > 15320.364308¨ CPU: 0 Tainted: GF       W    3.9.2 #1
> > > > 15320.364309¨ Process rhts-test-runne (pid: 625, task:
> > > > 000000003dccc890,
> > > > ksp: 0
> > > 
> > > .... and there you go - a stack overflow. Your kernel stack size is
> > > too small.
> > > 
> > > I'd suggest that you need 16k stacks on s390 - IIRC every function
> > > call has 128 byte stack frame, and there are call chains 70-80
> > > functions deep in the storage stack...
> > Hmm, I am unsure how to set to 16k stack there
> 
> Are you build a 64 bit s390 kernel or a 32 bit kernel? 32 bit
> kernels only have an 8k stack size, 64 bit kernels are 16k (see
> arch/s390/Makefile).
It is 64-bit.
> 
> $ git grep STACK_SIZE arch/s390 |head -2
> arch/s390/Makefile:STACK_SIZE   := 8192
> arch/s390/Makefile:STACK_SIZE   := 16384
> 
> As it is, the stack frame usage is worse than I thought:
> 
> $ git grep STACK_FRAME_OVERHEAD arch/s390 |head -2
> arch/s390/include/uapi/asm/ptrace.h:#define STACK_FRAME_OVERHEAD 96      /*
> size of minimum stack frame */
> arch/s390/include/uapi/asm/ptrace.h:#define STACK_FRAME_OVERHEAD 160      /*
> size of minimum stack frame */
> 
> Overhead is 96 bytes for 32 bit and 160 bytes for 64 bit. So 16k
> stack size is going to have big troubles with a 70-80 function deep
> call chain.
> 
> As for powerpc:
> 
> arch/powerpc/include/asm/ppc_asm.h:#define STACKFRAMESIZE 256
> 
> Yeah, same issue.
> 
> But, seriously, these stack traces are meaningless to anyone not
> familiar with s390 or power7 - they indicate a problem detected
> in the idle loop, not where ever the stack overran.
> 
> Can you please work with the s390/power7 people to obtain whatever
> stack it was that overflowed, and we can go from there.
OK, I'll do.
CAI Qian
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
