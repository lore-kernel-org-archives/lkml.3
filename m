Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbbAWFEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:04:55 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:33279 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbbAWFEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:04:53 -0500
Date: Thu, 22 Jan 2015 21:04:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mmotm 2015-01-22-15-04: qemu failures due to 'mm: account pmd page
 tables to the process'
Message-ID: <20150123050445.GA22751@roeck-us.net>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C1D674.0181,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
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
qemu:sh fails to shut down.

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
# good: [a40d0d2cf21e2714e9a6c842085148c938bf36ab] mm: memcontrol: remove unnecessary soft limit tree node test
git bisect good a40d0d2cf21e2714e9a6c842085148c938bf36ab
# good: [4ec4aa2e07c1d6eee61f6cace29401c6febcb6c5] mm: make FIRST_USER_ADDRESS unsigned long on all archs
git bisect good 4ec4aa2e07c1d6eee61f6cace29401c6febcb6c5
# bad: [22310c209483224a64436a6e815a86feda681659] mm: account pmd page tables to the process
git bisect bad 22310c209483224a64436a6e815a86feda681659
# good: [19a41261b1dcd8d12372d9c57c2035144608a599] arm: define __PAGETABLE_PMD_FOLDED for !LPAE
git bisect good 19a41261b1dcd8d12372d9c57c2035144608a599
# first bad commit: [22310c209483224a64436a6e815a86feda681659] mm: account pmd page tables to the process

---

qemu:microblaze generates warnings to the console.

WARNING: CPU: 0 PID: 32 at mm/mmap.c:2858 exit_mmap+0x184/0x1a4()

with various call stacks. See
http://server.roeck-us.net:8010/builders/qemu-microblaze-mmotm/builds/15/steps/qemubuildcommand/logs/stdio
for details.

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
# good: [a40d0d2cf21e2714e9a6c842085148c938bf36ab] mm: memcontrol: remove unnecessary soft limit tree node test
git bisect good a40d0d2cf21e2714e9a6c842085148c938bf36ab
# good: [4ec4aa2e07c1d6eee61f6cace29401c6febcb6c5] mm: make FIRST_USER_ADDRESS unsigned long on all archs
git bisect good 4ec4aa2e07c1d6eee61f6cace29401c6febcb6c5
# bad: [22310c209483224a64436a6e815a86feda681659] mm: account pmd page tables to the process
git bisect bad 22310c209483224a64436a6e815a86feda681659
# good: [19a41261b1dcd8d12372d9c57c2035144608a599] arm: define __PAGETABLE_PMD_FOLDED for !LPAE
git bisect good 19a41261b1dcd8d12372d9c57c2035144608a599
# first bad commit: [22310c209483224a64436a6e815a86feda681659] mm: account pmd page tables to the process

If there is anything I can do to help debugging, please let me know.

Guenter
