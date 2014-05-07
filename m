Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaEGPzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:55:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101AbaEGPzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:55:25 -0400
Message-ID: <536A572C.8080809@oracle.com>
Date: Wed, 07 May 2014 11:54:20 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulus@samba.org, Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf: memory corruption in perf_event_mmap
References: <5361758D.3090005@oracle.com> <20140501065105.GJ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140501065105.GJ11096@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 02:51 AM, Peter Zijlstra wrote:
> On Wed, Apr 30, 2014 at 06:13:33PM -0400, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following:
> 
> We are currently chasing memory corruption. Hard to say if its the same
> or not :/
> 

I've reproduced it again today. I can test out any debug patch you'd like?

[ 5526.045911] =============================================================================
[ 5526.046890] BUG kmalloc-4096 (Tainted: G    B   W    ): Poison overwritten
[ 5526.048170] -----------------------------------------------------------------------------
[ 5526.048170]
[ 5526.050048] INFO: 0xffff880078063490-0xffff880078063497. First byte 0x0 instead of 0x6b
[ 5526.050048] INFO: Allocated in perf_event_mmap+0xae/0x280 age=35 cpu=34 pid=38653
[ 5526.050048] 	__slab_alloc+0x59b/0x637
[ 5526.050048] 	kmem_cache_alloc_trace+0x137/0x3b0
[ 5526.050048] 	perf_event_mmap+0xae/0x280
[ 5526.050048] 	mmap_region+0x445/0x610
[ 5526.050048] 	do_mmap_pgoff+0x344/0x400
[ 5526.050048] 	vm_mmap_pgoff+0x88/0xe0
[ 5526.050048] 	SyS_mmap_pgoff+0x26b/0x2b0
[ 5526.050048] 	SyS_mmap+0x22/0x30
[ 5526.050048] 	tracesys+0xe1/0xe6
[ 5526.050048] INFO: Freed in perf_event_mmap+0x249/0x280 age=35 cpu=34 pid=38653
[ 5526.050048] 	__slab_free+0x3d/0x2f0
[ 5526.050048] 	kfree+0x2e8/0x360
[ 5526.050048] 	perf_event_mmap+0x249/0x280
[ 5526.050048] 	mmap_region+0x445/0x610
[ 5526.050048] 	do_mmap_pgoff+0x344/0x400
[ 5526.050048] 	vm_mmap_pgoff+0x88/0xe0
[ 5526.050048] 	SyS_mmap_pgoff+0x26b/0x2b0
[ 5526.050048] 	SyS_mmap+0x22/0x30
[ 5526.050048] 	tracesys+0xe1/0xe6
[ 5526.050048] INFO: Slab 0xffffea0001e01800 objects=7 used=7 fp=0x          (null) flags=0x9fffff80004080
[ 5526.050048] INFO: Object 0xffff8800780633d8 @offset=13272 fp=0xffff880078064520
[ 5526.050048]
[ 5526.050048] Bytes b4 ffff8800780633c8: 59 02 07 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  Y.......ZZZZZZZZ
[ 5526.050048] Object ffff8800780633d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780633e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780633f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063408: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063418: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063428: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063438: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063448: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063458: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063468: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063478: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063488: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 00 00 00 00  kkkkkkkk........
[ 5526.050048] Object ffff880078063498: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780634a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780634b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780634c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780634d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780634e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780634f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063508: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063518: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063528: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063538: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063548: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063558: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063568: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063578: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063588: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063598: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780635a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780635b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780635c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780635d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780635e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780635f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063608: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063618: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063628: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063638: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063648: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063658: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063668: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063678: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063688: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063698: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780636a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780636b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780636c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780636d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780636e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780636f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063708: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063718: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063728: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063738: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063748: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063758: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063768: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063778: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063788: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063798: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780637a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780637b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780637c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780637d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780637e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780637f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063808: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063818: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063828: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063838: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063848: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063858: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063868: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063878: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063888: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063898: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780638a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780638b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780638c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780638d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780638e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780638f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063908: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063918: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063928: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063938: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063948: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063958: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063968: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063978: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063988: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063998: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780639a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780639b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780639c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780639d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780639e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780639f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063a98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063aa8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ab8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ac8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ad8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ae8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063af8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063b98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ba8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063bb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063bc8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063bd8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063be8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063bf8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063c98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ca8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063cb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063cc8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063cd8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ce8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063cf8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063d98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063da8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063db8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063dc8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063dd8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063de8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063df8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063e98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ea8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063eb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ec8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ed8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ee8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ef8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063f98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063fa8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063fb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063fc8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063fd8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063fe8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078063ff8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064008: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064018: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064028: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064038: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064048: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064058: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064068: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064078: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064088: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064098: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780640a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780640b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780640c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780640d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780640e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780640f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064108: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064118: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064128: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064138: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064148: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064158: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064168: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064178: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064188: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064198: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780641a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780641b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780641c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780641d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780641e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780641f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064208: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064218: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064228: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064238: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064248: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064258: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064268: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064278: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064288: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064298: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780642a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780642b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780642c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780642d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780642e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780642f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064308: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064318: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064328: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064338: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064348: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064358: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064368: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064378: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064388: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff880078064398: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780643a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780643b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 5526.050048] Object ffff8800780643c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[ 5526.050048] Redzone ffff8800780643d8: bb bb bb bb bb bb bb bb                          ........
[ 5526.050048] Padding ffff880078064518: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[ 5526.050048] CPU: 2 PID: 9786 Comm: runtrin.sh Tainted: G    B   W     3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
[ 5526.050048]  ffff8800780633d8 ffff88002fded918 ffffffffa4536f8a 0000000000000001
[ 5526.050048]  ffff88003680e1c0 ffff88002fded948 ffffffffa12e83a1 ffff880078063498
[ 5526.050048]  ffff88003680e1c0 000000000000006b ffff8800780633d8 ffff88002fded998
[ 5526.050048] Call Trace:
[ 5526.050048] dump_stack (lib/dump_stack.c:52)
[ 5526.050048] print_trailer (mm/slub.c:641)
[ 5526.050048] check_bytes_and_report (mm/slub.c:680 mm/slub.c:704)
[ 5526.050048] check_object (mm/slub.c:816 (discriminator 1))
[ 5526.050048] ? sd_alloc_ctl_entry (kernel/sched/core.c:4819)
[ 5526.050048] alloc_debug_processing (mm/slub.c:1082)
[ 5526.050048] __slab_alloc (mm/slub.c:2379 (discriminator 1))
[ 5526.050048] ? cmpxchg_double_slab.isra.41 (mm/slub.c:436)
[ 5526.050048] ? sd_alloc_ctl_entry (kernel/sched/core.c:4819)
[ 5526.050048] ? cmpxchg_double_slab.isra.41 (mm/slub.c:437)
[ 5526.050048] ? get_parent_ip (kernel/sched/core.c:2485)
[ 5526.050048] __kmalloc (mm/slub.c:2470 mm/slub.c:2481 mm/slub.c:3295)
[ 5526.050048] ? sd_alloc_ctl_entry (kernel/sched/core.c:4819)
[ 5526.050048] ? __slab_free (mm/slub.c:2599)
[ 5526.050048] sd_alloc_ctl_entry (kernel/sched/core.c:4819)
[ 5526.050048] register_sched_domain_sysctl (kernel/sched/core.c:4936)
[ 5526.050048] ? get_parent_ip (kernel/sched/core.c:2485)
[ 5526.050048] ? kfree (mm/slub.c:2699 mm/slub.c:3382)
[ 5526.050048] partition_sched_domains (kernel/sched/core.c:6646)
[ 5526.050048] ? partition_sched_domains (kernel/sched/core.c:6610)
[ 5526.050048] ? preempt_count_sub (kernel/sched/core.c:2541)
[ 5526.050048] cpuset_update_active_cpus (include/linux/workqueue.h:492 include/linux/workqueue.h:550 kernel/cpuset.c:2186)
[ 5526.050048] cpuset_cpu_inactive (kernel/sched/core.c:6708)
[ 5526.050048] notifier_call_chain (kernel/notifier.c:95)
[ 5526.050048] __raw_notifier_call_chain (kernel/notifier.c:395)
[ 5526.050048] __cpu_notify (kernel/cpu.c:201)
[ 5526.050048] _cpu_down (kernel/cpu.c:335)
[ 5526.050048] ? cpu_maps_update_begin (kernel/cpu.c:40)
[ 5526.050048] ? mutex_lock_nested (arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:570 kernel/locking/mutex.c:587)
[ 5526.050048] ? device_offline (drivers/base/core.c:2128 drivers/base/core.c:1423)
[ 5526.050048] ? klist_next (lib/klist.c:361)
[ 5526.050048] cpu_down (kernel/cpu.c:409)
[ 5526.050048] cpu_subsys_offline (drivers/base/cpu.c:69)
[ 5526.050048] device_offline (drivers/base/core.c:1429)
[ 5526.050048] online_store (drivers/base/core.c:451 (discriminator 2))
[ 5526.050048] ? kernfs_fop_write (fs/kernfs/file.c:283)
[ 5526.050048] dev_attr_store (drivers/base/core.c:138)
[ 5526.050048] sysfs_kf_write (fs/sysfs/file.c:114)
[ 5526.050048] ? kernfs_fop_write (fs/kernfs/file.c:283)
[ 5526.050048] kernfs_fop_write (fs/kernfs/file.c:295)
[ 5526.050048] vfs_write (fs/read_write.c:532)
[ 5526.050048] SyS_write (fs/read_write.c:584 fs/read_write.c:576)
[ 5526.050048] tracesys (arch/x86/kernel/entry_64.S:747)

Thanks,
Sasha
