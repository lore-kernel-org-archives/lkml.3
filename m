Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaBDAzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:55:47 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49519 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBDAzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:55:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140128152457.GB16534@redhat.com>
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
	<1390899916-23566-3-git-send-email-tangchen@cn.fujitsu.com>
	<20140128152457.GB16534@redhat.com>
Date: Mon, 3 Feb 2014 19:55:38 -0500
X-Google-Sender-Auth: nIY0rQOGCFTNtuYLqC0OxvfGUjA
Message-ID: <CA+5PVA5M=NK2VrCL+FaVruCeT7BDzx-+gXGXERpFeonPLKOaHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] numa, mem-hotplug: Fix array index overflow when
 synchronizing nid to memblock.reserved.
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Dave Jones <davej@redhat.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86 <x86@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:24 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Jan 28, 2014 at 05:05:16PM +0800, Tang Chen wrote:
>  > The following path will cause array out of bound.
>  >
>  > memblock_add_region() will always set nid in memblock.reserved to MAX_NUMNODES.
>  > In numa_register_memblks(), after we set all nid to correct valus in memblock.reserved,
>  > we called setup_node_data(), and used memblock_alloc_nid() to allocate memory, with
>  > nid set to MAX_NUMNODES.
>  >
>  > The nodemask_t type can be seen as a bit array. And the index is 0 ~ MAX_NUMNODES-1.
>  >
>  > After that, when we call node_set() in numa_clear_kernel_node_hotplug(), the nodemask_t
>  > got an index of value MAX_NUMNODES, which is out of [0 ~ MAX_NUMNODES-1].
>  >
>  > See below:
>  >
>  > numa_init()
>  >  |---> numa_register_memblks()
>  >  |      |---> memblock_set_node(memory)              set correct nid in memblock.memory
>  >  |      |---> memblock_set_node(reserved)    set correct nid in memblock.reserved
>  >  |      |......
>  >  |      |---> setup_node_data()
>  >  |             |---> memblock_alloc_nid()    here, nid is set to MAX_NUMNODES (1024)
>  >  |......
>  >  |---> numa_clear_kernel_node_hotplug()
>  >         |---> node_set()                     here, we have an index 1024, and overflowed
>  >
>  > This patch moves nid setting to numa_clear_kernel_node_hotplug() to fix this problem.
>  >
>  > Reported-by: Dave Jones <davej@redhat.com>
>  > Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>  > Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>  > ---
>  >  arch/x86/mm/numa.c | 19 +++++++++++--------
>  >  1 file changed, 11 insertions(+), 8 deletions(-)
>
> This does seem to solve the problem (In conjunction with David's variant of the other patch).

Is this (and the first in the series) going to land in Linus' tree
soon?  I don't see them in -rc1 and people are still hitting the early
oops Dave did without this.

josh
