Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaJCPhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:37:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaJCPhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:37:50 -0400
Date: Fri, 3 Oct 2014 17:37:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Please backport commit 3812c8c8f39 to stable
Message-ID: <20141003153748.GF4816@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
 <20140930081637.GA4456@dhcp22.suse.cz>
 <CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
 <CAM_iQpVC0Q0G9s-02nSqrmpGWL3G0bHLK41NoRfySAenoJc+uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVC0Q0G9s-02nSqrmpGWL3G0bHLK41NoRfySAenoJc+uA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-10-14 14:04:08, Cong Wang wrote:
> Hello again,
> 
> I realized it is a series of patch actually:
> 
> 3812c8c8f3953921ef18544110dafc3505c1ac62 mm: memcg: do not trap
> chargers with full callstack on OOM
> fb2a6fc56be66c169f8b80e07ed999ba453a2db2 mm: memcg: rework and
> document OOM waiting and wakeup
> 519e52473ebe9db5cdef44670d5a97f1fd53d721 mm: memcg: enable memcg OOM
> killer only for user faults
> 3a13c4d761b4b979ba8767f42345fed3274991b0 x86: finish user fault error
> path with fatal signal
> 759496ba6407c6994d6a5ce3a5e74937d7816208 arch: mm: pass userspace
> fault flag to generic fault handler
> 871341023c771ad233620b7a1fb3d9c7031c4e5c arch: mm: do not invoke OOM
> killer on kernel fault OOM
> 94bce453c78996cc4373d5da6cfabe07fcc6d9f9 arch: mm: remove obsolete
> init OOM protection

Yes, that looks like the full series.

> I am not sure if they have more dependencies.
> 
> However, this bug is *fairly* easy to reproduce on 3.10, just using the
> following script:
> 
> #!/bin/bash
> 
> TEST_DIR=/tmp/cgroup_test
> [ -d $TEST_DIR ] || mkdir -p $TEST_DIR
> mount -t cgroup none $TEST_DIR -o memory
> mkdir $TEST_DIR/test
> echo 512k > $TEST_DIR/test/memory.limit_in_bytes

This is just insane. You allow only 128 pages to be charged and the
reclaim will have to constantly wait for each page to finish the
writeback.

> dd if=/dev/zero of=/tmp/oom_test_big_file bs=512 count=20000000 &
> echo $! > $TEST_DIR/test/tasks
> rm -f /tmp/oom_test_big_file
> umount $TEST_DIR
> 
> 
> Run it like this:
> 
> for i in `seq 1 1000`; do ./oom_hung.sh ; done

OK, so you will eventually deplete the limit by anon charges if the pid
makes it into the group sooner than dd allocates its 512B buffer (which
will end up consuming the full page anyway). So the OOM is pretty much
unavoidable. All the task will have minimum rss so then it is just a
matter of luck which one gets killed. But this alone shouldn't cause a
dead lock. Are you really sure this is the same issue discussed in the
mentioned patch?

> So please consider this seriously. :)

The bug is there since the memory controller has been introduced. Yet we
only had a single report happening in the real life. So I do not think
this is that urgent. It was definitely not a good design decision that
OOM killer was handled on top of unknown locks which might prevent from
forward progress. No question about that. Do you see the problem in the
real life somewhere because to be honest the test case is pretty much
insane.
-- 
Michal Hocko
SUSE Labs
