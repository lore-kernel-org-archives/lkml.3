Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3KNKcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:32:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54290 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3KNKch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:32:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5284A689.70903@jp.fujitsu.com>
Date: Thu, 14 Nov 2013 19:31:37 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Baoquan He <bhe@redhat.com>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: /proc/vmcore mmap() failure issue
References: <20131113204130.GD7613@redhat.com>
In-Reply-To: <20131113204130.GD7613@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/14 5:41), Vivek Goyal wrote:
> Hi Hatayama,
>
> We are facing some /proc/vmcore mmap() failure issues and then makdumpfile
> exits without saving dump and system reboots.
>
> I tried latest makedumpfile (devel branch) with 3.12 kernel.
>
> I think this issue happens only on some machines. And it looks like it
> happens when end of system RAM chunk in first kernel is not page aligned. For
> example, I have one machine where I noticed it and this is how system
> RAM looks like.
>
> 00100000-dafa57ff : System RAM
>    01000000-015892fa : Kernel code
>    015892fb-0195c9ff : Kernel data
>    01ae6000-01d31fff : Kernel bss
>    24000000-33ffffff : Crash kernel
> dafa5800-dbffffff : reserved
>
> Notice that dafa57ff does not end at page boundary and next reserved
> range does not start at page boundary. I think that next reserved
> range is referenced through some ACPI data. More on this later.
>
> So we put some printk() messages to get more info. In a nut shell,
> remap_pfn_range() fails when we try to map the last section of system
> RAM not ending on page boundary.
>
> remap_pfn_range()
>     track_pfn_remap() {
>          /*
>           * For anything smaller than the vma size we set prot based on the
>           * lookup.
>           */
>          flags = lookup_memtype(paddr);
>
>          /* Check memtype for the remaining pages */
>          while (size > PAGE_SIZE) {
>                  size -= PAGE_SIZE;
>                  paddr += PAGE_SIZE;
>                  if (flags != lookup_memtype(paddr))
>                          return -EINVAL; <---------------- Failure.
>          }
> 	
>     }
>
>
> So we pass in a range to track_pfn_remap. Say pfn=0xdad62 size=0x244000.
> Now we call lookup_memtype() on every page in the range and make sure
> they all are same, otherwise we fail. Guess what, all all same except
> last page (which does not end at page boundary).
>
> I dived deeper in to lookup_memtype() and noticed that all regular
> ranges are not registered anywhere and their flags are _PAGE_CACHE_UC_MINUS.
> But last unaligned page/range, is registered in memtype rb tree and
> has attribute, _PAGE_CACHE_WB.
>
> Then I hooked into reserve_memtype() to figure out who is registering
> page 0xdafa5000 and it is acpi_init() which does it.
>
> [    0.721655] Hardware name: <edited>
> [    0.730590]  ffff8800340f3830 ffff8800340f37c0 ffffffff81575509
> 00000000dafa5000
> [    0.738010]  ffff8800340f3800 ffffffff810566cc 00000000000dafa5
> 00000000dafa5000
> [    0.745428]  00000000dafa6000 00000000dafa5000 0000000000000000
> 0000000000001000
> [    0.752845] Call Trace:
> [    0.755288]  [<ffffffff81575509>] dump_stack+0x45/0x56
> [    0.760414]  [<ffffffff810566cc>] reserve_memtype+0x31c/0x3f0
> [    0.766144]  [<ffffffff810537ef>] __ioremap_caller+0x12f/0x360
> [    0.771963]  [<ffffffff8130ad56>] ? acpi_os_release_object+0xe/0x12
> [    0.778217]  [<ffffffff815686ba>] ? acpi_os_map_memory+0xf6/0x14e
> [    0.784295]  [<ffffffff81053a54>] ioremap_cache+0x14/0x20
> [    0.789679]  [<ffffffff815686ba>] acpi_os_map_memory+0xf6/0x14e
> [    0.795582]  [<ffffffff81322ac9>]
> acpi_ex_system_memory_space_handler+0xdd/0x1ca
> [    0.802961]  [<ffffffff8131ca48>]
> acpi_ev_address_space_dispatch+0x1b0/0x208
> [    0.809993]  [<ffffffff8131fd49>] acpi_ex_access_region+0x20e/0x2a2
> [    0.816244]  [<ffffffff81149464>] ? __alloc_pages_nodemask+0x134/0x300
> [    0.822754]  [<ffffffff813200e4>] acpi_ex_field_datum_io+0xf6/0x171
> [    0.829004]  [<ffffffff81320301>] acpi_ex_extract_from_field+0xd7/0x20a
> [    0.835602]  [<ffffffff81331d80>] ?
> acpi_ut_create_internal_object_dbg+0x23/0x8a
> [    0.842981]  [<ffffffff8131f8e7>]
> acpi_ex_read_data_from_field+0x10f/0x14b
> [    0.849838]  [<ffffffff81322e16>]
> acpi_ex_resolve_node_to_value+0x18e/0x21c
> [    0.856780]  [<ffffffff813230a6>] acpi_ex_resolve_to_value+0x202/0x209
> [    0.863291]  [<ffffffff81319486>] acpi_ds_evaluate_name_path+0x7b/0xf5
> [    0.869803]  [<ffffffff81319834>] acpi_ds_exec_end_op+0x98/0x3e8
> [    0.875793]  [<ffffffff8132aca4>] acpi_ps_parse_loop+0x514/0x560
> [    0.881784]  [<ffffffff8132b738>] acpi_ps_parse_aml+0x98/0x28c
> [    0.887601]  [<ffffffff8132bf8d>] acpi_ps_execute_method+0x1c1/0x26c
> [    0.893939]  [<ffffffff813269c5>] acpi_ns_evaluate+0x1c1/0x258
> [    0.899755]  [<ffffffff8131cb98>] acpi_ev_execute_reg_method+0xca/0x112
> [    0.906353]  [<ffffffff8131cd6e>] acpi_ev_reg_run+0x48/0x52
> [    0.911910]  [<ffffffff81328fad>] acpi_ns_walk_namespace+0xc8/0x17f
> [    0.918160]  [<ffffffff8131cd26>] ? acpi_ev_detach_region+0x146/0x146
> [    0.924585]  [<ffffffff8131cdbc>] acpi_ev_execute_reg_methods+0x44/0xf7
> [    0.931184]  [<ffffffff819b2324>] ? acpi_sleep_proc_init+0x2a/0x2a
> [    0.937349]  [<ffffffff8130ac66>] ? acpi_os_wait_semaphore+0x43/0x57
> [    0.943686]  [<ffffffff81331a3f>] ? acpi_ut_acquire_mutex+0x48/0x88
> [    0.949938]  [<ffffffff8131ceb8>]
> acpi_ev_initialize_op_regions+0x49/0x71
> [    0.956709]  [<ffffffff819b2324>] ? acpi_sleep_proc_init+0x2a/0x2a
> [    0.962873]  [<ffffffff81333310>] acpi_initialize_objects+0x23/0x4f
> [    0.969125]  [<ffffffff819b23b4>] acpi_init+0x90/0x268
>
> So basically, this split page seems to be a problem. Some other code
> thinks that it has access to full page and goes ahead and registers
> that with PAT rb tree and this causes problems in mmap() code.
>
> I suspect we might have to go back to idea of copying first and last
> non page aligned ranges in new kernel's memory and read it from there
> to solve this issue. Do you have other ideas?
>

Sorry for delayed response, although it looks like you have already found
a way to fix this issue.

BTW, I previously found a part of makedumpfile that truncates the first and
last pages if they are not aligned in page size. Discussing with Kumagai-san,
the truncation is performed on some ia64 system and he found a valid data in
the truncated area, and the latest makedumpfile no longer does such
truncation.

The commit is:

commit f854b37adba223d5b4801accbedd17b447266d51
Author: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Date:   Fri Jun 21 15:25:31 2013 +0900

     [PATCH 2/2] Fix the handling of the pages correspond to border of PT_LOAD.

     The pages correspond to border of PT_LOAD were removed as holes.
     For example, pfn:N showed below was removed but we know even
     odd region like [0x40ffda7000 - 0x40ffda8000] can include valid
     dates, so we shouldn't remove it as holes.

                                phys_start
                                = 0x40ffda7000
              |<-- frac_head -->|------------- PT_LOAD -------------
          ----+-----------------------+---------------------+----
              |         pfn:N         |       pfn:N+1       | ...
          ----+-----------------------+---------------------+----
              |
          pfn_to_paddr(pfn:N)               # page size = 16k
          = 0x40ffda4000

     This patch handles such odd regions correctly. Then read pfn:N
     and write it to disk, the ranges not covered by any PT_LOAD
     entries will be filled with 0.

     Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>

The log on the web is:

http://lists.infradead.org/pipermail/kexec/2013-May/008875.html

So, without this change, you would not have seen this issue. The original
reason why the code was implemented so might be the issues similar to here.

Next, I think it necessary to consider whether or not to revert the above
commit or not since makedumpfile fails on some kind of system as you reported.

-- 
Thanks.
HATAYAMA, Daisuke

