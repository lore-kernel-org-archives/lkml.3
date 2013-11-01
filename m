Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3KASrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:47:21 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:47413 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3KASrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:47:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzzdLn1xqyGobtP2yo7es+XOgt10Kr-9FRHvg-9eE3cyg@mail.gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	<20131101080135.GB25547@gmail.com>
	<1383328187.2653.5.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzzdLn1xqyGobtP2yo7es+XOgt10Kr-9FRHvg-9eE3cyg@mail.gmail.com>
Date: Fri, 1 Nov 2013 11:47:19 -0700
Message-ID: <CANN689EQ9d1BubEZ9txfWfKJEZQ5_zWvV5V_CyPCP5cRUw-oAw@mail.gmail.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to rwlock_t
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 11:09 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 1, 2013 at 10:49 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>>
>> Andrea's last input from this kind of conversion is that it cannot be
>> done (at least yet): https://lkml.org/lkml/2013/9/30/53
>
> No, none of the invalidate_page users really need to sleep. If doing
> this makes some people not do stupid sh*t, then that's all good. So at
> least _that_ worry was a false alarm. We definitely don't want to
> support crap in the VM, and sleeping during teardown is crap.

Should copy Andrea on this. I talked with him during KS, and there are
no current in-tree users who are doing such sleeping; however there
are prospective users for networking (RDMA) or GPU stuff who want to
use this to let hardware directly copy data into user mappings. I'm
not too aware of the details, but my understanding is that we then
need to send the NIC and/or GPU some commands to tear down the
mapping, and that command is currently acknowledged with an interrupt,
which is where the lseepability requirement comes from. Andrea was
thinking about cooking up some scheme to dynamically change between
sleepable and non-sleepable locks at runtime depending on when such
drivers are used; this seems quite complicated to me but I haven't
heard of alternative plans for RDMA usage either.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
