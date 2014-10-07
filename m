Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaJGMdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:33:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaJGMdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:33:35 -0400
Date: Tue, 7 Oct 2014 14:33:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Please backport commit 3812c8c8f39 to stable
Message-ID: <20141007123334.GC14243@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
 <20140930081637.GA4456@dhcp22.suse.cz>
 <CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
 <CAM_iQpVC0Q0G9s-02nSqrmpGWL3G0bHLK41NoRfySAenoJc+uA@mail.gmail.com>
 <20141003153748.GF4816@dhcp22.suse.cz>
 <CAM_iQpVMGiE+gxbnr1x6QrSbDQGHAJGCEGMi9XAQCPbptA8j2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVMGiE+gxbnr1x6QrSbDQGHAJGCEGMi9XAQCPbptA8j2A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 03-10-14 11:16:31, Cong Wang wrote:
> On Fri, Oct 3, 2014 at 8:37 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Thu 02-10-14 14:04:08, Cong Wang wrote:
> >> Hello again,
> >>
> >> I realized it is a series of patch actually:
> >>
> >> 3812c8c8f3953921ef18544110dafc3505c1ac62 mm: memcg: do not trap
> >> chargers with full callstack on OOM
> >> fb2a6fc56be66c169f8b80e07ed999ba453a2db2 mm: memcg: rework and
> >> document OOM waiting and wakeup
> >> 519e52473ebe9db5cdef44670d5a97f1fd53d721 mm: memcg: enable memcg OOM
> >> killer only for user faults
> >> 3a13c4d761b4b979ba8767f42345fed3274991b0 x86: finish user fault error
> >> path with fatal signal
> >> 759496ba6407c6994d6a5ce3a5e74937d7816208 arch: mm: pass userspace
> >> fault flag to generic fault handler
> >> 871341023c771ad233620b7a1fb3d9c7031c4e5c arch: mm: do not invoke OOM
> >> killer on kernel fault OOM
> >> 94bce453c78996cc4373d5da6cfabe07fcc6d9f9 arch: mm: remove obsolete
> >> init OOM protection
> >
> > Yes, that looks like the full series.
> >
> >> I am not sure if they have more dependencies.
> >>
> >> However, this bug is *fairly* easy to reproduce on 3.10, just using the
> >> following script:
> >>
> >> #!/bin/bash
> >>
> >> TEST_DIR=/tmp/cgroup_test
> >> [ -d $TEST_DIR ] || mkdir -p $TEST_DIR
> >> mount -t cgroup none $TEST_DIR -o memory
> >> mkdir $TEST_DIR/test
> >> echo 512k > $TEST_DIR/test/memory.limit_in_bytes
> >
> > This is just insane. You allow only 128 pages to be charged and the
> > reclaim will have to constantly wait for each page to finish the
> > writeback.
> 
> This is a test case ONLY used to reproduce this bug, why it has to be
> sane? :)
>
> On the other hand, no matter how insane a test case is, as long as it
> triggers some hung tasks in kernel, it is a kernel bug needs to fix.

Well, my point was that an insane setting might produce a lot of
problems. And as said this problem has been inherent since the day 1.
So a real world example would be much more preferable. Especially when
we have this state for years and nobody triggered it.

[...]
> >> So please consider this seriously. :)
> >
> > The bug is there since the memory controller has been introduced. Yet we
> > only had a single report happening in the real life. So I do not think
> > this is that urgent. It was definitely not a good design decision that
> > OOM killer was handled on top of unknown locks which might prevent from
> > forward progress. No question about that. Do you see the problem in the
> > real life somewhere because to be honest the test case is pretty much
> > insane.
> 
> I am sorry to confuse you that it is my the above test case which caused
> this bug. No, we saw this bug in *production* in our data center, it happened
> on 30+ machines!! :) The above insane test case is ONLY to draw your
> attention on how serious the bug is, nothing else.

Sure then the issue definitely needs to be fixed.

You have written in other email, that you have a backport. I will help
you with the review if you post it publicly.

-- 
Michal Hocko
SUSE Labs
