Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbbAWFIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:08:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:33821 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbAWFIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:08:07 -0500
Date: Thu, 22 Jan 2015 21:08:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: mmotm 2015-01-22-15-04: qemu failure due to 'mm: memcontrol: remove
 unnecessary soft limit tree node test'
Message-ID: <20150123050802.GB22751@roeck-us.net>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020205.54C1D737.0082,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 2
X-CTCH-SenderID-TotalMessages: 12
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:05:17PM -0800, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2015-01-22-15-04 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
qemu test for ppc64 fails with

Unable to handle kernel paging request for data at address 0x0000af50
Faulting instruction address: 0xc00000000089d5d4
Oops: Kernel access of bad area, sig: 11 [#1]

with the following call stack:

Call Trace:
[c00000003d32f920] [c00000000089d588] .__slab_alloc.isra.44+0x7c/0x6f4
(unreliable)
[c00000003d32fa90] [c00000000020cf8c] .kmem_cache_alloc_node_trace+0x12c/0x3b0
[c00000003d32fb60] [c000000000bceeb4] .mem_cgroup_init+0x128/0x1b0
[c00000003d32fbf0] [c00000000000a2b4] .do_one_initcall+0xd4/0x260
[c00000003d32fce0] [c000000000ba26a8] .kernel_init_freeable+0x244/0x32c
[c00000003d32fdb0] [c00000000000ac24] .kernel_init+0x24/0x140
[c00000003d32fe30] [c000000000009564] .ret_from_kernel_thread+0x58/0x74

bisect log:

# bad: [03586ad04b2170ee816e6936981cc7cd2aeba129] pci: test for unexpectedly disabled bridges
# good: [ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc] Linux 3.19-rc5
git bisect start 'HEAD' 'v3.19-rc5'
# bad: [d113ba21d15c7d3615fd88490d1197615bb39fc0] mm: remove lock validation check for MADV_FREE
git bisect bad d113ba21d15c7d3615fd88490d1197615bb39fc0
# good: [17351d1625a5030fa16f1346b77064c03b51f107] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
git bisect good 17351d1625a5030fa16f1346b77064c03b51f107
# good: [ad18ad1fce6f241a9cbd4adfd6b16c9283181e39] memcg: add BUILD_BUG_ON() for string tables
git bisect good ad18ad1fce6f241a9cbd4adfd6b16c9283181e39
# bad: [aa7e7cbfa43b74f6faef04ff730b5098544a4f77] mm/compaction: enhance tracepoint output for compaction begin/end
git bisect bad aa7e7cbfa43b74f6faef04ff730b5098544a4f77
# bad: [a40d0d2cf21e2714e9a6c842085148c938bf36ab] mm: memcontrol: remove unnecessary soft limit tree node test
git bisect bad a40d0d2cf21e2714e9a6c842085148c938bf36ab
# good: [e987aa804213c2d0c7f583639d868c7629ae479e] oom: add helpers for setting and clearing TIF_MEMDIE
git bisect good e987aa804213c2d0c7f583639d868c7629ae479e
# good: [af52cb6dc98bd833d4d15fe8eafc4a3e1f17951d] sysrq: convert printk to pr_* equivalent
git bisect good af52cb6dc98bd833d4d15fe8eafc4a3e1f17951d
# good: [61e257724ea22eb85488e7209f594106ca57258a] mm: cma: fix totalcma_pages to include DT defined CMA regions
git bisect good 61e257724ea22eb85488e7209f594106ca57258a
# first bad commit: [a40d0d2cf21e2714e9a6c842085148c938bf36ab] mm: memcontrol: remove unnecessary soft limit tree node test

If there is anything I can do to help debugging, please let me know.

Guenter
