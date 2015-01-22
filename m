Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbbAVSXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:23:12 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:58816 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbbAVSXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:23:10 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 13:23:09 EST
Message-ID: <54C13F29.9070309@lougher.demon.co.uk>
Date: Thu, 22 Jan 2015 18:19:21 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "long.wanglong" <long.wanglong@huawei.com>, phillip@squashfs.org.uk,
        rientjes@google.com, minchan@kernel.org
CC: squashfs-devel@lists.sourceforge.net, peifeiyue@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Using squashfs, kernel will hung task with no free memory?
References: <54C06059.2040207@huawei.com>
In-Reply-To: <54C06059.2040207@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 02:28, long.wanglong wrote:
> hi，
>
> I have encountered kernel hung task when running stability and stress test.
>
> test scenarios:
> 	1)the kernel hungtask settings are following:
> 		hung_task_panic = 1
> 		hung_task_timeout_secs = 120
> 	2)the rootfs type is squashfs(read-only)
> 	
> what the test does is to fork many child process and each process will alloc memory.
> when there is no free memory in the system, OOM killer is triggerred. and then the kernel triggers hung task(after about five  minutes) .
> the reason for hung task is that some process keep D states for 120 seconds.
>
> if there is no free memory in the system, many process state is D, they enter into D state by kernel path  `squashfs_cache_get()--->wait_event()`.
> the backtrace is:
>
> [  313.950118] [<c02d2014>] (__schedule+0x448/0x5cc) from [<c014e510>] (squashfs_cache_get+0x120/0x3ec)
> [  314.059660] [<c014e510>] (squashfs_cache_get+0x120/0x3ec) from [<c014fd1c>] (squashfs_readpage+0x748/0xa2c)
> [  314.176497] [<c014fd1c>] (squashfs_readpage+0x748/0xa2c) from [<c00b7be0>] (__do_page_cache_readahead+0x1ac/0x200)
> [  314.300621] [<c00b7be0>] (__do_page_cache_readahead+0x1ac/0x200) from [<c00b7e98>] (ra_submit+0x24/0x28)
> [  314.414325] [<c00b7e98>] (ra_submit+0x24/0x28) from [<c00b043c>] (filemap_fault+0x16c/0x3f0)
> [  314.515521] [<c00b043c>] (filemap_fault+0x16c/0x3f0) from [<c00c94e0>] (__do_fault+0xc0/0x570)
> [  314.618802] [<c00c94e0>] (__do_fault+0xc0/0x570) from [<c00cbdc4>] (handle_pte_fault+0x47c/0x1048)
> [  314.726250] [<c00cbdc4>] (handle_pte_fault+0x47c/0x1048) from [<c00cd928>] (handle_mm_fault+0x164/0x218)
> [  314.839959] [<c00cd928>] (handle_mm_fault+0x164/0x218) from [<c02d4878>] (do_page_fault.part.7+0x108/0x360)
> [  314.956788] [<c02d4878>] (do_page_fault.part.7+0x108/0x360) from [<c02d4afc>] (do_page_fault+0x2c/0x70)
> [  315.069442] [<c02d4afc>] (do_page_fault+0x2c/0x70) from [<c00084cc>] (do_PrefetchAbort+0x2c/0x90)
> [  315.175850] [<c00084cc>] (do_PrefetchAbort+0x2c/0x90) from [<c02d3674>] (ret_from_exception+0x0/0x10)
>
> when a task is already exiting because of OOM killer,the next time OOM killer will kill the same task.
> so, if the first time of OOM killer select a task(A) that in D state (the task ingore exit signal beacuse of D state).
> then the next time of OOM killer will also kill task A. In this scenario, oom killer will not free memory.
>
> with no free memory, many process sleep in function squashfs_cache_get. about 2 minutes, the system hung task and panic.
> because of OOM feature and squashfs, on heavy system, This problem is easily reproduce.
>
> Is this a problem about squashfs or about the OOM killer. Can anyone give me some good ideas about this?

This is not a Squashfs issue, it is a well known problem with
the OOM killer trying to kill tasks which are slow to exit (being
in D state).  Just google "OOM hung task" to see how long this
issue has been around.

The OOM killer is worse than useless in embedded systems because
its behaviour is unpredictable and can leave a system in a
zombified or half zombified state. Due to this reason many
embedded systems disable the OOM killer entirely, and ensure
there is adequate memory backed up by a watchdog which reboots
a hung system.

Phillip

>
> Best Regards
> Wang Long
>
>
>
>
>
>
>
>
>
> .
>

