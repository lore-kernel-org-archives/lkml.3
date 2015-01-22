Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbbAVTea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:34:30 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34152 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbbAVTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:34:25 -0500
Message-ID: <54C150BB.6050000@roeck-us.net>
Date: Thu, 22 Jan 2015 11:34:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>, davem@davemloft.net
CC: Mel Gorman <mgorman@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: linux-next: Tree for Jan 20 -- sparc32: fix broken set_pte()
References: <20150120185308.53f4af4e@canb.auug.org.au> <20150120202642.GA6178@roeck-us.net> <20150120225443.GA19629@node.dhcp.inet.fi> <54BF1785.7040300@roeck-us.net> <20150121104325.GA22449@node.dhcp.inet.fi> <54C06B19.8060305@roeck-us.net> <20150122171338.GA1039@node.dhcp.inet.fi>
In-Reply-To: <20150122171338.GA1039@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C150C1.01E3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 13
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

On 01/22/2015 09:13 AM, Kirill A. Shutemov wrote:
...
> vm_normal_page() is never called in this case, since prot_numa is always
> zero.
>
> I tracked the bug down. It's a sparc bug. The commit only triggers it,
> because affect how GCC optimize the code around faulty point.
>
> Please, test.
>
>>From 5b9232753217412116a4cdc2897be0db818371ca Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Thu, 22 Jan 2015 18:42:13 +0200
> Subject: [PATCH] sparc32: fix broken set_pte()
>
> 32-bit sparc uses swap instruction to implement set_pte(). It called
> using GCC inline assembler. But it misses the "memory" clobber to
> indicate that pte value will be updated in memory.
>
> As result GCC doesn't know that it cannot postpone pte pointer
> dereference which occurs before set_pte() to post-set_pte() time.
>
> It leads to real-world bugs -- [1]. In this situation we have code:
>
> 	ptent = ptep_modify_prot_start(mm, addr, pte);
> 	ptent = pte_modify(ptent, newprot);
> 	...
> 	ptep_modify_prot_commit(mm, addr, pte, ptent);
>
> ptep_modify_prot_start() in sparc case is just 'pte' dereference plus
> pte_clear(). pte_clear() calls broken set_pte(). GCC thinks it's valid
> to dereference 'pte' again on pte_modify() and gets cleared pte.
> ptep_modify_prot_commit() puts 'pteent' with pfn==0 back to page table,
> which eventually leads to the crash.
>
> [1] http://lkml.kernel.org/r/54C06B19.8060305@roeck-us.net
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>

Excellent catch. Yes, the fix works.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

