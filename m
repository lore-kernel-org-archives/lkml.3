Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaA1PZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:25:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbaA1PZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:25:16 -0500
Date: Tue, 28 Jan 2014 10:24:57 -0500
From: Dave Jones <davej@redhat.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] numa, mem-hotplug: Fix array index overflow when
 synchronizing nid to memblock.reserved.
Message-ID: <20140128152457.GB16534@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
 <1390899916-23566-3-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390899916-23566-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 05:05:16PM +0800, Tang Chen wrote:
 > The following path will cause array out of bound.
 > 
 > memblock_add_region() will always set nid in memblock.reserved to MAX_NUMNODES.
 > In numa_register_memblks(), after we set all nid to correct valus in memblock.reserved,
 > we called setup_node_data(), and used memblock_alloc_nid() to allocate memory, with
 > nid set to MAX_NUMNODES.
 > 
 > The nodemask_t type can be seen as a bit array. And the index is 0 ~ MAX_NUMNODES-1.
 > 
 > After that, when we call node_set() in numa_clear_kernel_node_hotplug(), the nodemask_t
 > got an index of value MAX_NUMNODES, which is out of [0 ~ MAX_NUMNODES-1].
 > 
 > See below:
 > 
 > numa_init()
 >  |---> numa_register_memblks()
 >  |      |---> memblock_set_node(memory)		set correct nid in memblock.memory
 >  |      |---> memblock_set_node(reserved)	set correct nid in memblock.reserved
 >  |      |......
 >  |      |---> setup_node_data()
 >  |             |---> memblock_alloc_nid()	here, nid is set to MAX_NUMNODES (1024)
 >  |......
 >  |---> numa_clear_kernel_node_hotplug()
 >         |---> node_set()			here, we have an index 1024, and overflowed
 > 
 > This patch moves nid setting to numa_clear_kernel_node_hotplug() to fix this problem.
 > 
 > Reported-by: Dave Jones <davej@redhat.com>
 > Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
 > Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
 > ---
 >  arch/x86/mm/numa.c | 19 +++++++++++--------
 >  1 file changed, 11 insertions(+), 8 deletions(-)

This does seem to solve the problem (In conjunction with David's variant of the other patch).

	Dave

