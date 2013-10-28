Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3J1FIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:08:22 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:33757 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J1FIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <20131022210232.GB2884@redhat.com>
References: <20131018155532.GD2277@redhat.com>
	<1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
	<1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
	<20131022210232.GB2884@redhat.com>
Date: Mon, 28 Oct 2013 13:08:18 +0800
Message-ID: <CAA7+ByUH7BeEOcuZF-cs8BMZMBOG+S9MF7ZryTRymy7ZPUxOKA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] blk-throttle: trim tokens generated for an idle tree
From: Hong zhi guo <honkiko@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek,

I tested the PATCH v4 for some basic hierarchical setup as I did
before. And I get the similar result.

Preparation
============
1) mount subsys blkio with "__DEVEL__sane_behavior"
2) Create 3 levels of directories under the blkio mount point:
    mkdir 1
    mkdir 1/2
    mkdir 1/2/3
    mkdir 4
3) start 4 bash sessions, write their PIDs into:
    1/cgroup.procs
    1/2/cgroup.procs
    1/2/3/cgroup.procs
    4/cgroup.procs
4) prepare 4 10MB files on sdb(ext4 fs)

Note: in below hierarchy graph:
    "[50k]" means configured value for read_bps_device is 50kB/s
    "(50k)" means bandwidth reported by dd is 50kB/s

Test A: 1 process throttled by ancestor group
=============================================
Hierarchy set-up:
    (echo "8:16 204800" > 1/blkio.throttle.read_bps_device)
    |-- 1 [200k]
    |    `-- 2 [-]
    |         `-- 3 [-]
    `-- 4 [-]

dd within group 3:
    (drop cache then: dd if=10M-file-3 of=/dev/null)
Result:
    206kB/s (I did same test without the token-bucket patch, The
result is 205kB/s)

dd within group 2:
    (drop cache then: dd if=10M-file-2 of=/dev/null)
Result:
    206kB/s


Test B: 4 processes in 3 levels of hierarchy
=============================================
Hierarchy set-up:
    echo "8:16 204800" > 1/blkio.throttle.read_bps_device
    echo "8:16 102400" > 1/2/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 1/2/3/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 4/blkio.throttle.read_bps_device
    |-- 1 [200k]
    |    `-- 2 [100k]
    |         `-- 3 [50k]
    `-- 4 [50k]

start 4 dd processes from 4 bash sessions
    (dd if=10M-file-x of=/dev/null)
Result:
    |-- 1 (104k)
    |    `-- 2 (52.1k)
    |         `-- 3 (51.3k)
    `-- 4 (51.4k)


On Wed, Oct 23, 2013 at 5:02 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Hong,
>
> This approach looks good in general. Only downside I can think of
> updation of nr_requests throughout the hierarchy. So deeper the
> hierarchy, higher the overhead.
>
> I am not sure if that's a concern or not. I will have a closer look
> a the patches tomorrow and do some testing too.
>
> Thanks
> Vivek


-- 
best regards
Hong Zhiguo
