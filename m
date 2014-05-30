Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaE3HJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:09:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4564 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaE3HJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:09:28 -0400
Message-ID: <53882E60.5070602@huawei.com>
Date: Fri, 30 May 2014 15:08:16 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>, Li Zefan <lizefan@huawei.com>
CC: Yong Zhang <yong.zhang@windriver.com>, <ralf@linux-mips.org>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com> <5384119E.7010606@huawei.com> <20140528200929.GA30528@drone.musicnaut.iki.fi>
In-Reply-To: <20140528200929.GA30528@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/29 4:09, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, May 27, 2014 at 12:16:30PM +0800, Li Zefan wrote:
>> On 2014/5/21 13:36, Yong Zhang wrote:
>>> asid_cache must be unsigned long otherwise on 64bit system
>>> it will become 0 if the value in get_new_mmu_context()
>>> reaches 0xffffffff and in the end the assumption of
>>> ASID_FIRST_VERSION is not true anymore thus leads to
>>> more dangerous things.
>>
>> We should describe what problem this bug can lead to, which
>> will help people who encounter the same problem and google it.
> 
> Please describe it, then. Even if the patch is already committed,
> googling would probably still find this e-mail thread.
> 
> Thanks,
> 
> A.
> 
> 

Problem description:
On our MIPS architecture product, after a long time running our business
service, a random cpu trigger the problem, that if running test cases
include the following code on this cpu will trigger bus error or
segment fault:
    ...
    pid = fork();
    if (pid < 0)
        return 1;
    if (0 == pid)
        exit(0);
    else
            exit(0);
    ...

Root cause:
After doing a lot of fork/mmap/munmap operations, it will make the asid value
exceeds 0xffffffff in get_new_mmu_context function, which is truncated to 0:
|-get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
    unsigned long asid = asid_cache(cpu); //if asid_cache(cpu) is 0xffffffff now
    if (! ((asid += ASID_INC) & ASID_MASK) ) {  //asid reaches 0x1 0000 0000
        ...
        local_flush_tlb_all();         /* start new asid cycle */
        if (!asid)             /* fix version if needed */  //but here condition does not meet...
            asid = ASID_FIRST_VERSION;
         }
         cpu_context(cpu, mm) = asid_cache(cpu) = asid; //and here cpu_context and asid_cache is truncated to 0

In do_fork()->dup_mmap(), adding write-protect flag for writable page but the
following tlb flush does not take effect, and breaks the normal COW:
do_fork()
|-copy_process()
    |-copy_mm()
        ...
        |-dup_mmap()
            |-copy_page_range()
                ...
                |-copy_one_pte()
                ...
                    if (is_cow_mapping(vm_flags)) {
                        ptep_set_wrprotect(src_mm, addr, src_pte);
                        pte = pte_wrprotect(pte);
                    }
                ...
        |-flush_tlb_mm(oldmm)
            |-local_flush_tlb_mm（）
                if (cpu_context(cpu, mm) != 0) {//cpu_context is 0, no tlb flush
                drop_mmu_context(mm, cpu);
            }

In addition, the condition ((cpu_context(cpu, next) ^ asid_cache(cpu))
& ASID_VERSION_MASK) can not be met in switch_mm(), and the tlb flush operation
can not be completed during the process switch.
|-switch_mm()
    ...
    /* Check if our ASID is of an older version and thus invalid */
    if ((cpu_context(cpu, next) ^ asid_cache(cpu)) & ASID_VERSION_MASK)
        get_new_mmu_context(next, cpu);
        write_c0_entryhi(cpu_asid(cpu, next));
    ...

In short, due to the truncation operation caused by inappropriate type conversion,
making tlb flush failure, causing problems of COW, triggering bus error or segment fault.

Thanks,
Libin

