Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbbAVC3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:29:08 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:4006 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbbAVC3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:29:01 -0500
Message-ID: <54C06059.2040207@huawei.com>
Date: Thu, 22 Jan 2015 10:28:41 +0800
From: "long.wanglong" <long.wanglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <phillip@squashfs.org.uk>, <rientjes@google.com>, <minchan@kernel.org>
CC: <squashfs-devel@lists.sourceforge.net>, <peifeiyue@huawei.com>,
        <long.wanglong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] Using squashfs, kernel will hung task with no free memory?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.88.174]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi，

I have encountered kernel hung task when running stability and stress test.

test scenarios:
	1)the kernel hungtask settings are following:
		hung_task_panic = 1
		hung_task_timeout_secs = 120
	2)the rootfs type is squashfs(read-only)
	
what the test does is to fork many child process and each process will alloc memory.
when there is no free memory in the system, OOM killer is triggerred. and then the kernel triggers hung task(after about five  minutes) .
the reason for hung task is that some process keep D states for 120 seconds.

if there is no free memory in the system, many process state is D, they enter into D state by kernel path  `squashfs_cache_get()--->wait_event()`.
the backtrace is:

[  313.950118] [<c02d2014>] (__schedule+0x448/0x5cc) from [<c014e510>] (squashfs_cache_get+0x120/0x3ec)
[  314.059660] [<c014e510>] (squashfs_cache_get+0x120/0x3ec) from [<c014fd1c>] (squashfs_readpage+0x748/0xa2c)
[  314.176497] [<c014fd1c>] (squashfs_readpage+0x748/0xa2c) from [<c00b7be0>] (__do_page_cache_readahead+0x1ac/0x200)
[  314.300621] [<c00b7be0>] (__do_page_cache_readahead+0x1ac/0x200) from [<c00b7e98>] (ra_submit+0x24/0x28)
[  314.414325] [<c00b7e98>] (ra_submit+0x24/0x28) from [<c00b043c>] (filemap_fault+0x16c/0x3f0)
[  314.515521] [<c00b043c>] (filemap_fault+0x16c/0x3f0) from [<c00c94e0>] (__do_fault+0xc0/0x570)
[  314.618802] [<c00c94e0>] (__do_fault+0xc0/0x570) from [<c00cbdc4>] (handle_pte_fault+0x47c/0x1048)
[  314.726250] [<c00cbdc4>] (handle_pte_fault+0x47c/0x1048) from [<c00cd928>] (handle_mm_fault+0x164/0x218)
[  314.839959] [<c00cd928>] (handle_mm_fault+0x164/0x218) from [<c02d4878>] (do_page_fault.part.7+0x108/0x360)
[  314.956788] [<c02d4878>] (do_page_fault.part.7+0x108/0x360) from [<c02d4afc>] (do_page_fault+0x2c/0x70)
[  315.069442] [<c02d4afc>] (do_page_fault+0x2c/0x70) from [<c00084cc>] (do_PrefetchAbort+0x2c/0x90)
[  315.175850] [<c00084cc>] (do_PrefetchAbort+0x2c/0x90) from [<c02d3674>] (ret_from_exception+0x0/0x10)

when a task is already exiting because of OOM killer,the next time OOM killer will kill the same task.
so, if the first time of OOM killer select a task(A) that in D state (the task ingore exit signal beacuse of D state).
then the next time of OOM killer will also kill task A. In this scenario, oom killer will not free memory.

with no free memory, many process sleep in function squashfs_cache_get. about 2 minutes, the system hung task and panic.
because of OOM feature and squashfs, on heavy system, This problem is easily reproduce.

Is this a problem about squashfs or about the OOM killer. Can anyone give me some good ideas about this?

Best Regards
Wang Long









