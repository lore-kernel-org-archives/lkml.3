Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaAQJhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:37:19 -0500
Received: from mail1.windriver.com ([147.11.146.13]:38163 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAQJhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:37:15 -0500
Message-ID: <52D8F960.6030107@windriver.com>
Date: Fri, 17 Jan 2014 17:35:28 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: Alexey Lugovskoy <lugovskoy@dev.rtsoft.ru>
Subject: Re: powerpc/hugetlb: BUG: using smp_processor_id() in preemptible
References: <201401171323.52657@blacky.localdomain>
In-Reply-To: <201401171323.52657@blacky.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.163.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 05:23 PM, Nikita Yushchenko wrote:
> Hi
>
> While running LTP hugeltb tests on freescale powerpc board, I'm getting
>
> [ 7253.637591] BUG: using smp_processor_id() in preemptible [00000000 00000000]
> code: hugemmap01/9048
> [ 7253.637601] caller is free_hugepd_range.constprop.25+0x88/0x1a8
> [ 7253.637605] CPU: 1 PID: 9048 Comm: hugemmap01 Not tainted 3.10.20-rt14+ #114
> [ 7253.637606] Call Trace:
> [ 7253.637617] [cb049d80] [c0007ea4] show_stack+0x4c/0x168 (unreliable)
> [ 7253.637624] [cb049dc0] [c031c674] debug_smp_processor_id+0x114/0x134
> [ 7253.637628] [cb049de0] [c0016d28] free_hugepd_range.constprop.25+0x88/0x1a8
> [ 7253.637632] [cb049e00] [c001711c] hugetlb_free_pgd_range+0x6c/0x168
> [ 7253.637639] [cb049e40] [c0117408] free_pgtables+0x12c/0x150
> [ 7253.637646] [cb049e70] [c011ce38] unmap_region+0xa0/0x11c
> [ 7253.637671] [cb049ef0] [c011f03c] do_munmap+0x224/0x3bc
> [ 7253.637676] [cb049f20] [c011f2e0] vm_munmap+0x38/0x5c
> [ 7253.637682] [cb049f40] [c000ef88] ret_from_syscall+0x0/0x3c
> [ 7253.637686] --- Exception: c01 at 0xff16004
>
> This is on 3.10 based kernel but looks like code in question did not change
> since then.
>
> Immediate reason of this dump is usage of smp_processor_id() in hugepd_free(),
> which is executed in preemptible context on this path.
>
> Perhaps need to add preempt_disable() / preempt_enable() somewhere.
> But what is the proper location for these?
>

Could you try this?

powerpc/hugetlb: replace __get_cpu_var with get_cpu_var

Replace __get_cpu_var safely with get_cpu_var to avoid
the following call trace:

[ 7253.637591] BUG: using smp_processor_id() in preemptible [00000000 00000000]
code: hugemmap01/9048
[ 7253.637601] caller is free_hugepd_range.constprop.25+0x88/0x1a8
[ 7253.637605] CPU: 1 PID: 9048 Comm: hugemmap01 Not tainted 3.10.20-rt14+ #114
[ 7253.637606] Call Trace:
[ 7253.637617] [cb049d80] [c0007ea4] show_stack+0x4c/0x168 (unreliable)
[ 7253.637624] [cb049dc0] [c031c674] debug_smp_processor_id+0x114/0x134
[ 7253.637628] [cb049de0] [c0016d28] free_hugepd_range.constprop.25+0x88/0x1a8
[ 7253.637632] [cb049e00] [c001711c] hugetlb_free_pgd_range+0x6c/0x168
[ 7253.637639] [cb049e40] [c0117408] free_pgtables+0x12c/0x150
[ 7253.637646] [cb049e70] [c011ce38] unmap_region+0xa0/0x11c
[ 7253.637671] [cb049ef0] [c011f03c] do_munmap+0x224/0x3bc
[ 7253.637676] [cb049f20] [c011f2e0] vm_munmap+0x38/0x5c
[ 7253.637682] [cb049f40] [c000ef88] ret_from_syscall+0x0/0x3c
[ 7253.637686] --- Exception: c01 at 0xff16004

Signed-off-by: Tiejun Chen<tiejun.chen@windriver.com>
---
  arch/powerpc/mm/hugetlbpage.c |    4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index fb05b12..42779c0 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -400,12 +400,13 @@ static void hugepd_free(struct mmu_gather *tlb, void *hugepte)
  {
  	struct hugepd_freelist **batchp;

-	batchp = &__get_cpu_var(hugepd_freelist_cur);
+	batchp = &get_cpu_var(hugepd_freelist_cur);

  	if (atomic_read(&tlb->mm->mm_users) < 2 ||
  	    cpumask_equal(mm_cpumask(tlb->mm),
  			  cpumask_of(smp_processor_id()))) {
  		kmem_cache_free(hugepte_cache, hugepte);
+        put_cpu_var(hugepd_freelist_cur);
  		return;
  	}

@@ -419,6 +420,7 @@ static void hugepd_free(struct mmu_gather *tlb, void *hugepte)
  		call_rcu_sched(&(*batchp)->rcu, hugepd_free_rcu_callback);
  		*batchp = NULL;
  	}
+    put_cpu_var(hugepd_freelist_cur);
  }
  #endif

-- 
1.7.9.5

Tiejun

>
> Nikita
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>
>

