Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaKRPmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:42:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbaKRPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:42:53 -0500
Date: Tue, 18 Nov 2014 15:42:46 +0000
From: Mel Gorman <mgorman@suse.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
Message-ID: <20141118154246.GB2725@suse.de>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de>
 <5466C8A5.3000402@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5466C8A5.3000402@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 10:29:41PM -0500, Sasha Levin wrote:
> On 11/14/2014 08:32 AM, Mel Gorman wrote:> This is follow up from the "pipe/page fault oddness" thread.
> 
> Hi Mel,
> 
> Applying this patch series I've started seeing the following straight away:
> 
> [  367.547848] page:ffffea0003fb7db0 count:1007 mapcount:1005 mapping:ffff8800691f2f58 index:0x37
> [  367.551481] flags: 0x5001aa8030202d(locked|referenced|uptodate|lru|writeback|unevictable|mlocked)
> [  367.555382] page dumped because: VM_BUG_ON_PAGE(!v9inode->writeback_fid)
> [  367.558262] page->mem_cgroup:ffff88006d8a1bd8
> [  367.560403] ------------[ cut here ]------------
> [  367.562343] kernel BUG at fs/9p/vfs_addr.c:190!
> [  367.564239] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
> [  367.566991] Dumping ftrace buffer:
> [  367.568481]    (ftrace buffer empty)
> [  367.569914] Modules linked in:
> [  367.570254] CPU: 3 PID: 8234 Comm: kworker/u52:1 Not tainted 3.18.0-rc4-next-20141114-sasha-00054-ga9ff95e-dirty #1459

Thanks Sasha. I don't see a next-20141114 so I looked at next-20141113 and
assuming they are similar. It does not appear that writeback_fid is a struct
page so it's not clear what VM_BUG_ON_PAGE means in this context. Certainly
the fields look screwy but I think it's just accessing garbage.

I tried reproducing this but my KVM setup appears to be broken after an
update and not even able to boot 3.17 properly let alone with the patches. I
still have a few questions though.

1. I'm assuming this is a KVM setup but can you confirm?
2. Are you using numa=fake=N?
3. If you are using fake NUMA, what happens if you boot without it as
   that should make the patches a no-op?
4. Similarly, does the kernel boot properly without without patches?
5. Are any other patches applied because the line numbers are not lining
   up exactly?
6. As my own KVM setup appears broken, can you tell me if the host
   kernel has changed recently? If so, does using an older host kernel
   make a difference?

At the moment I'm scratching my head trying to figure out how the
patches could break 9p like this as I don't believe KVM is doing any
tricks with the same bits that could result in loss.

-- 
Mel Gorman
SUSE Labs
