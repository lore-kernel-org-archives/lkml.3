Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbbASGTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:19:09 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:36564 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbASGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:19:07 -0500
Message-ID: <54BCA187.6070601@huawei.com>
Date: Mon, 19 Jan 2015 14:17:43 +0800
From: "long.wanglong" <long.wanglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <hannes@cmpxchg.org>, <shijie8@gmail.com>, <torvalds@linux-foundation.org>,
        <mhocko@suse.cz>, <azurit@pobox.sk>, <hugh.dickins@tiscali.co.uk>,
        <rientjes@google.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <long.wanglong@huawei.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>
Subject: does the semantics of MAP_LOCKED is equal to mlock() function?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.88.174]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54BCA197.012E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: c1e34c65e234c7713651f751674d5ff4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

In the latest kernel, i set the memory limit (4096) in a test cgroup. and add the test task.
the test code code is:

testcase 1: mmap with MAP_LOCKED flag(memsize = 8192)

185                 p = mmap(NULL, memsize, PROT_WRITE | PROT_READ,
186                          MAP_PRIVATE | MAP_ANONYMOUS | MAP_LOCKED, 0, 0);
187                 if (p == MAP_FAILED)
188                         err(1, "mmap(lock) failed");
					
expect: invoke OOM killer.
result: not invoke OOM killer.


testcase 2: mmap without MAP_LOCKED flag and the call mlock (memsize = 8192)

185                 p = mmap(NULL, memsize, PROT_WRITE | PROT_READ,
186                          MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
187                 if (p == MAP_FAILED)
188                         err(1, "mmap(lock) failed");
189
190                 if (mlock(p, memsize) == -1)
191                         err(1, "mlock failed")

expect: invoke OOM killer.
result: invoke OOM killer.

in the Linux Programmer's Manual:

MAP_LOCKED (since Linux 2.5.37)
		Lock the pages of the mapped region into memory in the manner
		of mlock(2).  This flag is ignored in older kernels.
	
and
       mlock() locks pages in the address range starting at addr and
       continuing for len bytes.  All pages that contain a part of the
       specified address range are guaranteed to be resident in RAM when the
       call returns successfully; the pages are guaranteed to stay in RAM
       until later unlocked.
	
According to the description in the manual, the two testcases are equivalent.

why the first testcase does not invoke OOM killer?
does the mmap with MAP_LOCKED flag will not immediately allocate physical memory?


Best Regards
Wang Long

