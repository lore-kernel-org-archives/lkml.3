Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKKB2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:28:06 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:33752 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193AbaKKB2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:28:04 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43170832"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.co>, <fabf@skynet.be>, <nzimmer@sgi.com>,
        <wangnan0@huawei.com>, <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <miaox@cn.fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 0/2] Fix node meminfo and zoneinfo corruption.
Date: Tue, 11 Nov 2014 09:27:05 +0800
Message-ID: <1415669227-10996-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two problems in memory hot-add progress:

1. When hot-adding a node without onlining any page, node meminfo corrupted:

# hot-add node2 (memory not onlined)
# cat /sys/device/system/node/node2/meminfo
Node 2 MemTotal:       33554432 kB			/* corrupted */
Node 2 MemFree:               0 kB
Node 2 MemUsed:        33554432 kB
Node 2 Active:                0 kB
......


2. When onlining memory on node2, node2 zoneinfo and node3 meminfo corrupted:

# for ((i = 2048; i < 2064; i++)); do echo online_movable > /sys/devices/system/node/node2/memory$i/state; done
# cat /sys/devices/system/node/node2/meminfo
Node 2 MemTotal:       33554432 kB
Node 2 MemFree:        33549092 kB
Node 2 MemUsed:            5340 kB
......
# cat /sys/devices/system/node/node3/meminfo
Node 3 MemTotal:              0 kB
Node 3 MemFree:               248 kB      /* corrupted, should be 0 */
Node 3 MemUsed:               0 kB
......

# cat /proc/zoneinfo
......
Node 2, zone   Movable
......
        spanned  8388608
        present  16777216		/* corrupted, should be 8388608 */
        managed  8388608



Change log v1 -> v2:
1. Replace patch 2/2 with a new one. It provides the simplest way to
   fix problem 2. 

Tang Chen (2):
  mem-hotplug: Reset node managed pages when hot-adding a new pgdat.
  mem-hotplug: Reset node present pages when hot-adding a new pgdat.

 include/linux/bootmem.h |  1 +
 mm/bootmem.c            |  9 +++++----
 mm/memory_hotplug.c     | 24 ++++++++++++++++++++++++
 mm/nobootmem.c          |  8 +++++---
 4 files changed, 35 insertions(+), 7 deletions(-)

-- 
1.8.3.1

