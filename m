Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaCSToo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:44:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:41846 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaCSTon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,688,1389772800"; 
   d="scan'208";a="502243475"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Peng Tao <bergwolf@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Thread-Topic: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Thread-Index: AQHPQqvhmGRT/iVq/UyFTbqnXI+TbZrnTU6AgAAE6ACAAAPpAIAACxSAgAAbjICAAKeMgIAA/mUA///AHQA=
Date: Wed, 19 Mar 2014 19:44:29 +0000
Message-ID: <CF4F4C6F.9A880%andreas.dilger@intel.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
 <20140318133331.GA23193@laptop.programming.kicks-ass.net>
 <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com>
 <20140318140504.GD23193@laptop.programming.kicks-ass.net>
 <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com>
 <20140318162319.GB5669@redhat.com>
 <CA+a=Yy51Ex=UdsCRn8Ty_s4XR4xbOZ_YAf3tejb=JyTgQ_QzRA@mail.gmail.com>
 <20140319173330.GA11923@redhat.com>
In-Reply-To: <20140319173330.GA11923@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.132.228]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF870A57D2A3D745A39868EBC4358B54@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/03/19, 11:33 AM, "Oleg Nesterov" <oleg@redhat.com> wrote:
>On 03/19, Peng Tao wrote:
>>
>> On Wed, Mar 19, 2014 at 12:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > Firtsly, cfs_block_sigs/cfs_block_sigsinv/etc are not exactly right,
>> > they need set_current_blocked(). And you can read "old" lockless.
>> >
>> It seems that set_current_blocked() is not exported. Can we ask to
>>export it?
>
>Why not. If you are going to change this code to use
>set_current_blocked(), I'd suggest you to send the "export
>set_current_blocked" patch in series. Otherwise, if it is sent
> separately, your change will depend on another tree.
>
>Or you can use sigprocmask(). Actually it should die, but this won't
>happen soon and it is already exported.
>
>> And looking at other similar places like coda_block_signals(),
>
>Yes, it can have much more users.
>
>But note that set_current_blocked() can't help you to really block
>SIGKILL anyway.
>
>Could you explain why __l_wait_event() can't use TASK_UNINTERRUPTIBLE
>instead of cfs_block_sigsinv(0) ?

The original reason for l_wait_event() not using TASK_UNINTERRUPTIBLE
is to avoid the load on the server continually being "num_service_threads"
regardless of whether they are actually doing something or not.  We
added various cases for periodic wakeups and such afterward.

l_wait_event() was originally developed for 2.4 kernels, so there may
well be better primitives to use today.

I'd be happy to move toward replacing l_wait_event() with kernel
primitives if possible, but we need to ensure that this is tested
sufficiently since it can otherwise be a source of hard-to-find bugs.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


