Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaJBVEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:04:11 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36414 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaJBVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
	<20140930081637.GA4456@dhcp22.suse.cz>
	<CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
Date: Thu, 2 Oct 2014 14:04:08 -0700
Message-ID: <CAM_iQpVC0Q0G9s-02nSqrmpGWL3G0bHLK41NoRfySAenoJc+uA@mail.gmail.com>
Subject: Re: Please backport commit 3812c8c8f39 to stable
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

I realized it is a series of patch actually:

3812c8c8f3953921ef18544110dafc3505c1ac62 mm: memcg: do not trap
chargers with full callstack on OOM
fb2a6fc56be66c169f8b80e07ed999ba453a2db2 mm: memcg: rework and
document OOM waiting and wakeup
519e52473ebe9db5cdef44670d5a97f1fd53d721 mm: memcg: enable memcg OOM
killer only for user faults
3a13c4d761b4b979ba8767f42345fed3274991b0 x86: finish user fault error
path with fatal signal
759496ba6407c6994d6a5ce3a5e74937d7816208 arch: mm: pass userspace
fault flag to generic fault handler
871341023c771ad233620b7a1fb3d9c7031c4e5c arch: mm: do not invoke OOM
killer on kernel fault OOM
94bce453c78996cc4373d5da6cfabe07fcc6d9f9 arch: mm: remove obsolete
init OOM protection

I am not sure if they have more dependencies.

However, this bug is *fairly* easy to reproduce on 3.10, just using the
following script:

#!/bin/bash

TEST_DIR=/tmp/cgroup_test
[ -d $TEST_DIR ] || mkdir -p $TEST_DIR
mount -t cgroup none $TEST_DIR -o memory
mkdir $TEST_DIR/test
echo 512k > $TEST_DIR/test/memory.limit_in_bytes
dd if=/dev/zero of=/tmp/oom_test_big_file bs=512 count=20000000 &
echo $! > $TEST_DIR/test/tasks
rm -f /tmp/oom_test_big_file
umount $TEST_DIR


Run it like this:

for i in `seq 1 1000`; do ./oom_hung.sh ; done


So please consider this seriously. :)

Thanks!
