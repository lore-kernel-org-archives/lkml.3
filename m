Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3DLPMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:12:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33927 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3DLPMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:12:13 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-b5-5168244b9454
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Piotr Bereza <p.bereza@samsung.com>
Subject: Re: [RFC] security: smack: add hash table for smack for quick label
 searching
Message-id: <871uag812q.fsf@samsung.com>
References: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com>
 <5166F9FA.20003@schaufler-ca.com>
From: l.stelmach@samsung.com (=?utf-8?Q?=C5=81ukasz?= Stelmach)
Date: Fri, 12 Apr 2013 17:12:09 +0200
In-reply-to: <5166F9FA.20003@schaufler-ca.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7reKhmBBnuP8Fvc2/aLzaLx01xm
	i7NNb9gtLu+aw2bxoecRm8XaI3fZLeb2X2O0eDtpBbPFvPaXrA6cHn1bVjF6HN2/iM3j8ya5
	AOYoLpuU1JzMstQifbsErozHFwoKZoRVvFg/nbWB8YlFFyMnh4SAicSXJ32MELaYxIV769m6
	GLk4hASWMkos2rOLCcJpYpJoXTeDDaRKREBHYt+e5+wgCWaBOUwSK3sfs4IkhAUiJDou7WUH
	sXkFNCT2vtgGZgsJ5EisnPYJzGYTsJeY++85C4jNIqAqcWP2PbDVnAJ6Eue+TAGbIypgKdH4
	5goLxBxBiR+T7wHZHEDL1CWmTMkFCTMLaEs8eXeBdQKjwCwkVbMQqmYhqVrAyLyKUTS1NLmg
	OCk910ivODG3uDQvXS85P3cTIyTEv+5gXHrM6hCjAAejEg/vAZmMQCHWxLLiytxDjBIczEoi
	vDF70wKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MLoX6jLuusC43DTIqzSRJXbrvYbiLXfnlbgo
	bFfQ2+X48L5afhvPm08hNbnb9v1bc/F6TSzfuXkJBlE1q9yOX5tRtFxgT2VFluR/CUmJhZNm
	6iZeWS1zrmSeeb6iX/PtktI3ydKh9/cocH/bVrdrSsxuJ5Mw54UiKpZ2ew3uHWo7Gdo7M//Z
	KiWW4oxEQy3mouJEAAZsm3JPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was <2013-04-11 czw 19:59>, when Casey Schaufler wrote:
> On 4/11/2013 1:46 AM, Tomasz Stanislawski wrote:
>> Hi everyone,
>> I am a developer working on optimization of the TIZEN system.
>> Recently, I've discovered a performance issue in SMACK subsystem.
>> I used the PERF tool to find performance bottlenecks.
>>
>> The test scenario was simple. Run multiple applications and
>> see what the system does using the following command:
>>
>>  perf record -a -g
>>
>> Next, see the results with the command:
>>
>>  perf report -s symbol -g graph,0.5
>>
>> Among the many lines, the following ones are especially interesting:
>>
>>      5.96%  [k] smk_find_entry                                                                         
>>             |          
>>             |--5.06%-- smk_access
>>             |          |          
>>             |           --4.99%-- smk_curacc
>>             |                     |          
>>             |                     |--3.79%-- smack_ptrace_access_check

[...]

>>
>> To sum up, the result indicates that the CPU spents circa 8% (2.16% + 5.96%)
>> of cycles searching for a SMACK label in the smk_find_entry function.
>> The function iterates through smack_known_list to find an entry.
>> The further analysis showed that the size of the list can reach even 600.
>> I measured that it takes circa 200 tries to find an entry on average.
>> The value was computed as a total number iterations in the smk_find_entry's
>> loop divided by the times smk_find_entry was called in a time-window of
>> the length of 10 seconds.
>>
>> IMO, this is a serious performance issue which scales badly with
>> a complexity of the system.
>>
>> I implemented a patch that makes a use of a hash table to quicken searching
>> for SMACK's labels.  The patch is rebased onto the latest v3.9-rc6 kernel.
>> The code is thread-safe (I hope) because it shares the RCU mechanism
>> and locks with smack_known_list.

[...]

>>
>> I hope you find the measurement and the patch useful.
>> All comments are welcome.
>
> NAK
>
> There will be no hash tables in Smack.
>
> The correct solution is simple.
>
> In the task_smack structure there are two Smack label pointers,
> smk_task and smk_forked. Replace these fields with pointers to
> the smack_known structures that contain the Smack label pointers
> used today. This will require trivial changes throughout the
> Smack code to accommodate the type change and a few logical twists
> around smk_import. It will eliminate the need for smk_lookup_entry.

Allow me to join the conversation with an interesting observation.
I don't know whether hash table is a good solution to the problem Tomasz
has mentioned it definitely improves performance during loading rules.

Conditions:

--8<---------------cut here---------------start------------->8---
# number of subjects
sh-4.1# cat /etc/smack/accesses.d/* | cut -d\  -f1 | sort -u | wc -l
379
# number of rules
sh-4.1# cat /etc/smack/accesses.d/* | wc -l   
23895
--8<---------------cut here---------------end--------------->8---

Without the patch

--8<---------------cut here---------------start------------->8---
sh-4.1# time smackctl apply

real    0m1.255s
user    0m0.115s
sys     0m0.895s
--8<---------------cut here---------------end--------------->8---

perfs output is:

--8<---------------cut here---------------start------------->8---
# ========
# captured on: Tue Jan  1 09:52:14 2013
# os release : 3.4.5
# arch : armv7l
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : ARMv7 Processor rev 0 (v7l)
# total memory : 1025456 kB
# cmdline : /perf record -a -g -- /usr/bin/smackctl apply 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 45, 46, 47, 48 }
# ========
#
# Events: 1K cycles
#
# Overhead                              Symbol
# ........  ..................................
#
    47.49%  [k] strcmp                        
            |          
            |--41.27%-- smk_find_entry
            |          |          
            |          |--28.87%-- smk_import_entry
            |          |          smk_import
            |          |          smk_fill_rule
            |          |          smk_parse_long_rule
            |          |          smk_write_rules_list.clone.3
            |          |          smk_write_load2
            |          |          vfs_write
            |          |          sys_write
            |          |          ret_fast_syscall
            |          |          
            |           --12.41%-- smk_write_rules_list.clone.3
            |                     smk_write_load2
            |                     vfs_write
            |                     sys_write
            |                     ret_fast_syscall
            |          
            |--4.41%-- smk_import_entry
            |          smk_import
            |          smk_fill_rule
            |          smk_parse_long_rule
            |          smk_write_rules_list.clone.3
            |          smk_write_load2
            |          vfs_write
            |          sys_write
            |          ret_fast_syscall
            |          
             --1.80%-- smk_write_rules_list.clone.3
                       smk_write_load2
                       vfs_write
                       sys_write
                       ret_fast_syscall
    19.21%  [k] smk_find_entry                
            |          
            |--12.44%-- smk_import_entry
            |          smk_import
            |          smk_fill_rule
            |          smk_parse_long_rule
            |          smk_write_rules_list.clone.3
            |          smk_write_load2
            |          vfs_write
            |          sys_write
            |          ret_fast_syscall
            |          
             --6.78%-- smk_write_rules_list.clone.3
                       smk_write_load2
                       vfs_write
                       sys_write
                       ret_fast_syscall

[ less than 10% per entry ]

--8<---------------cut here---------------end--------------->8---

With the patch

--8<---------------cut here---------------start------------->8---
sh-4.1# time smackctl apply                                  

real    0m0.349s
user    0m0.095s
sys     0m0.250s
--8<---------------cut here---------------end--------------->8---

still quite long but 3.59598853868 times better.

--8<---------------cut here---------------start------------->8---
# ========
# captured on: Tue Jan  1 10:40:45 2013
# os release : 3.4.5
# arch : armv7l
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : ARMv7 Processor rev 0 (v7l)
# total memory : 1025544 kB
# cmdline : /perf record -a -g -- smackctl apply 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 1, 2, 3, 4 }
# ========
#
# Events: 606  cycles
#
# Overhead                                 Symbol
# ........  .....................................
#
    12.90%  [k] smk_write_rules_list.isra.9      
            |
            --- smk_write_load2
                vfs_write
                sys_write
                ret_fast_syscall
     7.86%  [k] exynos_enter_idle                
            |
            --- cpuidle_enter
                cpuidle_enter_state
                cpuidle_idle_call
                cpu_idle
               |          
                --7.69%-- secondary_start_kernel
                          0x4066df54
     6.95%  [k] v7_dma_inv_range                 
            |          
            |--3.70%-- __dma_page_cpu_to_dev
            |          arm_dma_map_page
            |          arm_dma_map_sg
            |          dw_mci_pre_dma_transfer
            |          dw_mci_pre_req
            |          mmc_pre_req
            |          mmc_start_req
            |          mmc_blk_issue_rw_rq
            |          mmc_blk_issue_rq
            |          mmc_queue_thread
            |          kthread
            |          do_exit
            |          
             --3.25%-- __dma_page_dev_to_cpu
                       arm_dma_unmap_page
                       arm_dma_unmap_sg
                       dw_mci_post_req
                       mmc_post_req
                       mmc_start_req
                       mmc_blk_issue_rw_rq
                       mmc_blk_issue_rq
                       mmc_queue_thread
                       kthread
                       do_exit
     3.56%  [k] _raw_spin_unlock_irq             
            |          
            |--1.40%-- mmc_blk_issue_rw_rq
            |          mmc_blk_issue_rq
            |          mmc_queue_thread
            |          kthread
            |          do_exit
            |          
             --1.09%-- finish_task_switch
                       __schedule
                       |          
                        --0.75%-- schedule


     3.45%  [.] 0x0000118c                       
     2.94%  [.] strncpy                          
     2.67%  [.] vfprintf                         
     2.44%  [k] strcmp                           
            |
            --- smk_find_entry
                smk_import_entry
                smk_import
                smk_fill_rule
                smk_parse_long_rule
                smk_write_rules_list.isra.9
                smk_write_load2
                vfs_write
                sys_write
                ret_fast_syscall

[ less than 2.5%  per entry ]
--8<---------------cut here---------------end--------------->8---

-- 
Łukasz Stelmach
Software wizzard
Samsung Poland R&D Center

Al. Armii Ludowej 26, 00-609 Warszawa
http://www.rd.samsung.pl
