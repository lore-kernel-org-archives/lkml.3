Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab3GQT1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:27:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45755 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3GQT11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:27:27 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes) causes hang
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130717190029.GA362@x4>
Date: Thu, 18 Jul 2013 03:27:13 +0800
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A162C863-8D7A-4346-AECA-4509AC9BC7C0@gmail.com>
References: <20130717163215.GA359@x4> <20130717164232.GI13732@redhat.com> <20130717165743.GA357@x4> <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com> <20130717184226.GA358@x4> <20130717185539.GK13732@redhat.com> <20130717190029.GA362@x4>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you please try this:

index 460b9c6..16d1578 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2952,6 +2952,9 @@ static bool page_fault_can_be_fast(u32 error_code)
              !(error_code & PFERR_WRITE_MASK))
                return false;
 
+       if (error_code & PFERR_RSVD_MASK)
+               return false;
+
        return true;
 }

On Jul 18, 2013, at 3:00 AM, Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2013.07.17 at 21:55 +0300, Gleb Natapov wrote:
>> On Wed, Jul 17, 2013 at 08:42:26PM +0200, Markus Trippelsdorf wrote:
>>> On 2013.07.18 at 01:25 +0800, Xiao Guangrong wrote:
>>>> Hi Markus,
>>>> 
>>>> Thanks for your report! I am downloading the ubuntu iso and will try to reproducible it.
>>>> 
>>>> Could you please enable these tracepoints:
>>>> kvmmmu/check_mmio_spte
>>>> kvmmmu/handle_mmio_page_fault
>>>> kvmmmu/kvm_mmu_invalidate_zap_all_pages
>>>> kvmmmu/mark_mmio_spte
>>>> kvm/kvm_mmio
>>>> kvm/vcpu_match_mmio
>>>> 
>>>> and post the output?
>>>> 
>>> First line repeated ad nauseam.
>>> ...
>>> 10346367  qemu-system-x86-1403  [001]  1451.422225: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346368  qemu-system-x86-1403  [001]  1451.422226: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346369  qemu-system-x86-1403  [001]  1451.422227: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346370  qemu-system-x86-1403  [001]  1451.422228: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346371  qemu-system-x86-1403  [001]  1451.422229: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346372  qemu-system-x86-1404  [002]  1451.422229: kvm_mmio:             mmio write len 4 gpa 0xfee000b0 val 0x0
>>> 10346373  qemu-system-x86-1403  [001]  1451.422230: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346374  qemu-system-x86-1403  [001]  1451.422231: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346375  qemu-system-x86-1403  [001]  1451.422232: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346376  qemu-system-x86-1403  [001]  1451.422233: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346377  qemu-system-x86-1403  [001]  1451.422234: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346378  qemu-system-x86-1403  [001]  1451.422235: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346379  qemu-system-x86-1404  [002]  1451.422236: kvm_mmio:             mmio write len 4 gpa 0xfee00380 val 0x3c7b0
>>> 10346380  qemu-system-x86-1403  [001]  1451.422237: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346381  qemu-system-x86-1403  [001]  1451.422238: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346382  qemu-system-x86-1403  [001]  1451.422239: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346383  qemu-system-x86-1403  [001]  1451.422240: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346384  qemu-system-x86-1403  [001]  1451.422241: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346385  qemu-system-x86-1403  [001]  1451.422242: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346386  qemu-system-x86-1403  [001]  1451.422243: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346387  qemu-system-x86-1403  [001]  1451.422244: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
>>> 10346403  qemu-system-x86-1403  [001]  1451.422260: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0  
>>> ...
>>> Last line repeated ad nauseam.
>>> 
>> While this happens can you run "echo t > /proc/sysrq-trigger" and attach
>> dmesg here.
> 
> [  236.309484] SysRq : Show State
> [  236.309492]   task                        PC stack   pid father
> [  236.309496] minit           S ffff8802168882c0     0     1      0 0x00000000
> [  236.309504]  ffff880216888000 0000000000000086 0000000000011a80 ffff880216885fd8
> [  236.309510]  0000000000011a80 ffff880216885fd8 ffff880216885ba8 00000000004c4b3f
> [  236.309515]  0000000000000000 0000000000000000 0000000000000000 ffff880216885bc4
> [  236.309521] Call Trace:
> [  236.309532]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.309541]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.309548]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.309554]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.309560]  [<ffffffff810d8d25>] ? handle_pte_fault+0x405/0x7c0
> [  236.309567]  [<ffffffff81233510>] ? number.isra.1+0x2f0/0x320
> [  236.309572]  [<ffffffff8107e900>] ? autoremove_wake_function+0x40/0x40
> [  236.309579]  [<ffffffff8112e7e2>] ? fsnotify_clear_marks_by_inode+0x22/0x100
> [  236.309585]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.309590]  [<ffffffff81234d99>] ? snprintf+0x39/0x40
> [  236.309597]  [<ffffffff81093c8f>] ? __getnstimeofday+0x2f/0xc0
> [  236.309603]  [<ffffffff81093d25>] ? getnstimeofday+0x5/0x20
> [  236.309610]  [<ffffffff81093ff0>] ? do_gettimeofday+0x10/0x60
> [  236.309617]  [<ffffffff810666a9>] ? SyS_gettimeofday+0x29/0x80
> [  236.309624]  [<ffffffff81038825>] ? emulate_vsyscall+0x285/0x340
> [  236.309630]  [<ffffffff81579d81>] ? __bad_area_nosemaphore+0xb2/0x1c9
> [  236.309637]  [<ffffffff810586f6>] ? __do_page_fault+0x296/0x440
> [  236.309643]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.309648]  [<ffffffff81064e7e>] ? do_wait+0x13e/0x240
> [  236.309654]  [<ffffffff81065d2f>] ? SyS_wait4+0x6f/0xe0
> [  236.309660]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.309665]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.309672]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.309675] kthreadd        S ffff8802168888b0     0     2      0 0x00000000
> [  236.309681]  ffff8802168885f0 0000000000000046 0000000000011a80 ffff880216887fd8
> [  236.309686]  0000000000011a80 ffff880216887fd8 ffffffff81a19550 ffff8801dff77ce8
> [  236.309691]  ffff8802168885f0 ffff8802168885f0 0000000000000000 0000000000000000
> [  236.309696] Call Trace:
> [  236.309701]  [<ffffffff8107e219>] ? kthreadd+0xf9/0x120
> [  236.309706]  [<ffffffff8107e120>] ? kthread_stop+0x60/0x60
> [  236.309711]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.309716]  [<ffffffff8107e120>] ? kthread_stop+0x60/0x60
> [  236.309719] ksoftirqd/0     S ffff880216888ea0     0     3      2 0x00000000
> [  236.309723]  ffff880216888be0 0000000000000046 0000000000011a80 ffff8802168a1fd8
> [  236.309728]  0000000000011a80 ffff8802168a1fd8 ffff880216888be0 ffff8802168023e0
> [  236.309733]  ffffffff81a168e0 ffff880216888be0 ffff880216888be0 0000000000000000
> [  236.309737] Call Trace:
> [  236.309744]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.309749]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.309753]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.309758]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309763]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.309768]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309770] kworker/0:0     S ffff880216889490     0     4      2 0x00000000
> [  236.309782]  ffff8802168891d0 0000000000000046 0000000000011a80 ffff8802168a3fd8
> [  236.309787]  0000000000011a80 ffff8802168a3fd8 ffff88021fc11318 ffff88021687b130
> [  236.309791]  ffff8802168891d0 ffff8802168891d0 ffff88021fc11300 ffff88021687b100
> [  236.309796] Call Trace:
> [  236.309802]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.309808]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.309812]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.309817]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309822]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.309827]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309829] kworker/0:0H    S ffff880216889a80     0     5      2 0x00000000
> [  236.309838]  ffff8802168897c0 0000000000000046 0000000000011a80 ffff8802168a5fd8
> [  236.309842]  0000000000011a80 ffff8802168a5fd8 ffff88021fc116d8 ffff88021687b2b0
> [  236.309847]  ffff8802168897c0 ffff8802168897c0 ffff88021fc116c0 ffff88021687b280
> [  236.309851] Call Trace:
> [  236.309857]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.309863]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.309867]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.309872]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309877]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.309882]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309884] kworker/u8:0    S ffff88021688a070     0     6      2 0x00000000
> [  236.309892]  ffff880216889db0 0000000000000046 0000000000011a80 ffff8802168a7fd8
> [  236.309897]  0000000000011a80 ffff8802168a7fd8 ffff88021680d818 ffff88021687b430
> [  236.309901]  ffff880216889db0 ffff880216889db0 ffff88021680d800 ffff88021687b400
> [  236.309906] Call Trace:
> [  236.309911]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.309917]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.309921]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.309926]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309931]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.309936]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309938] migration/0     S ffff88021688a660     0     7      2 0x00000000
> [  236.309943]  ffff88021688a3a0 0000000000000046 0000000000011a80 ffff8802168a9fd8
> [  236.309947]  0000000000011a80 ffff8802168a9fd8 ffff88021688a3a0 ffff8802168023f0
> [  236.309952]  ffffffff81a1ad40 ffff88021688a3a0 ffff88021688a3a0 0000000000000000
> [  236.309956] Call Trace:
> [  236.309962]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.309967]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.309972]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.309976]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309982]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.309986]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.309989] rcu_bh          S ffff88021688ac50     0     8      2 0x00000000
> [  236.309993]  ffff88021688a990 0000000000000046 0000000000011a80 ffff8802168abfd8
> [  236.309998]  0000000000011a80 ffff8802168abfd8 ffffffff81a1b140 ffffffff81a1b260
> [  236.310002]  ffff88021688a990 0000000000000000 0000000000000000 0000000000000000
> [  236.310006] Call Trace:
> [  236.310014]  [<ffffffff810ac0d2>] ? rcu_gp_kthread+0x92/0x5a0
> [  236.310019]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.310025]  [<ffffffff810ac040>] ? rcu_gp_fqs+0x60/0x60
> [  236.310029]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310034]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310039]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310044]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310046] rcu_sched       S ffff88021688b240     0     9      2 0x00000000
> [  236.310050]  ffff88021688af80 0000000000000046 0000000000011a80 ffff8802168adfd8
> [  236.310055]  0000000000011a80 ffff8802168adfd8 ffffffff81a1b400 ffffffff81a1b520
> [  236.310059]  ffff88021688af80 ffff88021fd0d760 ffffffff81a1b4c0 ffff8802168ade98
> [  236.310064] Call Trace:
> [  236.310070]  [<ffffffff810ac0d2>] ? rcu_gp_kthread+0x92/0x5a0
> [  236.310075]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.310082]  [<ffffffff810ac040>] ? rcu_gp_fqs+0x60/0x60
> [  236.310086]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310091]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310096]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310101]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310103] migration/1     S ffff88021688ca00     0    10      2 0x00000000
> [  236.310108]  ffff88021688c740 0000000000000046 0000000000011a80 ffff8802168b5fd8
> [  236.310112]  0000000000011a80 ffff8802168b5fd8 ffff88021688c740 ffff880216802400
> [  236.310117]  ffffffff81a1ad40 ffff88021688c740 ffff88021688c740 0000000000000000
> [  236.310121] Call Trace:
> [  236.310127]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.310133]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.310137]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310142]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310147]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310152]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310154] ksoftirqd/1     S ffff88021688cff0     0    11      2 0x00000000
> [  236.310159]  ffff88021688cd30 0000000000000046 0000000000011a80 ffff8802168b7fd8
> [  236.310163]  0000000000011a80 ffff8802168b7fd8 ffff88021688cd30 ffff880216802410
> [  236.310168]  ffffffff81a168e0 ffff88021688cd30 ffff88021688cd30 0000000000000000
> [  236.310172] Call Trace:
> [  236.310178]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.310183]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.310188]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310192]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310198]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310202]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310205] kworker/1:0     S ffff88021688d5e0     0    12      2 0x00000000
> [  236.310213]  ffff88021688d320 0000000000000046 0000000000011a80 ffff8802168b9fd8
> [  236.310217]  0000000000011a80 ffff8802168b9fd8 ffff88021fc91318 ffff88021687bc30
> [  236.310222]  ffff88021688d320 ffff88021688d320 ffff88021fc91300 ffff88021687bc00
> [  236.310226] Call Trace:
> [  236.310232]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.310238]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.310242]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310247]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310252]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310257]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310259] kworker/1:0H    S ffff88021688dbd0     0    13      2 0x00000000
> [  236.310267]  ffff88021688d910 0000000000000046 0000000000011a80 ffff8802168bbfd8
> [  236.310272]  0000000000011a80 ffff8802168bbfd8 ffff88021fc916d8 ffff88021687bdb0
> [  236.310276]  ffff88021688d910 ffff88021688d910 ffff88021fc916c0 ffff88021687bd80
> [  236.310281] Call Trace:
> [  236.310286]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.310292]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.310296]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310301]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310306]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310311]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310313] migration/2     S ffff88021688e1c0     0    14      2 0x00000000
> [  236.310317]  ffff88021688df00 0000000000000046 0000000000011a80 ffff8802168c1fd8
> [  236.310322]  0000000000011a80 ffff8802168c1fd8 ffff88021688df00 ffff880216802420
> [  236.310326]  ffffffff81a1ad40 ffff88021688df00 ffff88021688df00 0000000000000000
> [  236.310331] Call Trace:
> [  236.310337]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.310342]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.310346]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310352]  [<ffffffff81020303>] ? decode_operand+0x6a3/0x780
> [  236.310356]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310361]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310366]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310368] ksoftirqd/2     S ffff88021688e7b0     0    15      2 0x00000000
> [  236.310372]  ffff88021688e4f0 0000000000000046 0000000000011a80 ffff8802168c3fd8
> [  236.310377]  0000000000011a80 ffff8802168c3fd8 ffff88021688e4f0 ffff880216802430
> [  236.310381]  ffffffff81a168e0 ffff88021688e4f0 ffff88021688e4f0 0000000000000000
> [  236.310386] Call Trace:
> [  236.310392]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.310397]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.310401]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310407]  [<ffffffff81040303>] ? get_cpu_vendor+0xa3/0xc0
> [  236.310411]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310417]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310421]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310424] kworker/2:0     S ffff88021688eda0     0    16      2 0x00000000
> [  236.310431]  ffff88021688eae0 0000000000000046 0000000000011a80 ffff8802168d9fd8
> [  236.310436]  0000000000011a80 ffff8802168d9fd8 ffff88021fd11318 ffff88021687c130
> [  236.310440]  ffff88021688eae0 ffff88021688eae0 ffff88021fd11300 ffff88021687c100
> [  236.310445] Call Trace:
> [  236.310450]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.310456]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.310460]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310466]  [<ffffffff811b0000>] ? xfs_quota_calc_throttle+0x40/0xa0
> [  236.310471]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310476]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310481]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310483] kworker/2:0H    S ffff88021688f390     0    17      2 0x00000000
> [  236.310491]  ffff88021688f0d0 0000000000000046 0000000000011a80 ffff8802168dbfd8
> [  236.310496]  0000000000011a80 ffff8802168dbfd8 ffff88021fd116d8 ffff88021687c2b0
> [  236.310500]  ffff88021688f0d0 ffff88021688f0d0 ffff88021fd116c0 ffff88021687c280
> [  236.310505] Call Trace:
> [  236.310510]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.310516]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.310520]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310527]  [<ffffffff811e0000>] ? xfs_dir2_leafn_split+0x340/0x3c0
> [  236.310532]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310537]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310542]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310544] migration/3     S ffff88021688f980     0    18      2 0x00000000
> [  236.310549]  ffff88021688f6c0 0000000000000046 0000000000011a80 ffff8802168e1fd8
> [  236.310553]  0000000000011a80 ffff8802168e1fd8 ffff88021688f6c0 ffff880216802440
> [  236.310558]  ffffffff81a1ad40 ffff88021688f6c0 ffff88021688f6c0 0000000000000000
> [  236.310562] Call Trace:
> [  236.310568]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.310573]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.310578]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310585]  [<ffffffff81260303>] ? fbcon_debug_enter+0x3/0x60
> [  236.310589]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310594]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310599]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310602] ksoftirqd/3     S ffff8802168e82c0     0    19      2 0x00000000
> [  236.310606]  ffff8802168e8000 0000000000000046 0000000000011a80 ffff8802168e3fd8
> [  236.310610]  0000000000011a80 ffff8802168e3fd8 ffff8802168e8000 ffff880216802450
> [  236.310615]  ffffffff81a168e0 ffff8802168e8000 ffff8802168e8000 0000000000000000
> [  236.310619] Call Trace:
> [  236.310625]  [<ffffffff8108535e>] ? smpboot_thread_fn+0xbe/0x1a0
> [  236.310631]  [<ffffffff810852a0>] ? lg_global_unlock+0x60/0x60
> [  236.310635]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310642]  [<ffffffff81270303>] ? acpi_processor_set_pdc+0x110/0x185
> [  236.310647]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310652]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310657]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310659] kworker/3:0     S ffff8802168e88b0     0    20      2 0x00000000
> [  236.310667]  ffff8802168e85f0 0000000000000046 0000000000011a80 ffff8802168e5fd8
> [  236.310672]  0000000000011a80 ffff8802168e5fd8 ffff88021fd91318 ffff88021687c630
> [  236.310676]  ffff8802168e85f0 ffff8802168e85f0 ffff88021fd91300 ffff88021687c600
> [  236.310681] Call Trace:
> [  236.310686]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.310692]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.310696]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310703]  [<ffffffff812a0000>] ? n_tty_write+0xc0/0x480
> [  236.310708]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310713]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310718]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310720] kworker/3:0H    S ffff8802168e8ea0     0    21      2 0x00000000
> [  236.310728]  ffff8802168e8be0 0000000000000046 0000000000011a80 ffff8802168e7fd8
> [  236.310733]  0000000000011a80 ffff8802168e7fd8 ffff88021fd916d8 ffff88021687c7b0
> [  236.310737]  ffff8802168e8be0 ffff8802168e8be0 ffff88021fd916c0 ffff88021687c780
> [  236.310742] Call Trace:
> [  236.310747]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.310753]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.310757]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310762]  [<ffffffff812b0000>] ? gotoxy+0xa0/0xc0
> [  236.310767]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310772]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310777]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310779] khelper         S ffff8802168f82c0     0    22      2 0x00000000
> [  236.310787]  ffff8802168f8000 0000000000000046 0000000000011a80 ffff8802168f5fd8
> [  236.310792]  0000000000011a80 ffff8802168f5fd8 ffff88021687c900 ffff8802168f8000
> [  236.310796]  ffffffff81077c00 ffff88021687c930 0000000000000000 0000000000000000
> [  236.310801] Call Trace:
> [  236.310806]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.310812]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.310817]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.310821]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310829]  [<ffffffff81390000>] ? sumo_get_sleep_divider_id_from_clock+0x60/0x60
> [  236.310834]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310839]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310843]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310846] kdevtmpfs       S ffff8802168f88b0     0    23      2 0x00000000
> [  236.310850]  ffff8802168f85f0 0000000000000046 0000000000011a80 ffff88021692dfd8
> [  236.310855]  0000000000011a80 ffff88021692dfd8 0000000000000000 0000000000000000
> [  236.310859]  ffff8802168f85f0 0000000000000000 0000000000000000 0000000000000000
> [  236.310863] Call Trace:
> [  236.310870]  [<ffffffff813aef0b>] ? devtmpfsd+0x12b/0x140
> [  236.310877]  [<ffffffff813aede0>] ? handle_create.isra.2+0x1e0/0x1e0
> [  236.310881]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310886]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310891]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310896]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310898] writeback       S ffff8802168f8ea0     0    24      2 0x00000000
> [  236.310906]  ffff8802168f8be0 0000000000000046 0000000000011a80 ffff88021698dfd8
> [  236.310911]  0000000000011a80 ffff88021698dfd8 ffff88021687ff00 ffff8802168f8be0
> [  236.310915]  ffffffff81077c00 ffff88021687ff30 0000000000000000 0000000000000000
> [  236.310920] Call Trace:
> [  236.310925]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.310931]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.310936]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.310941]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.310945]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310950]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.310955]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.310958] bioset          S ffff8802169902c0     0    25      2 0x00000000
> [  236.310966]  ffff880216990000 0000000000000046 0000000000011a80 ffff88021698ffd8
> [  236.310970]  0000000000011a80 ffff88021698ffd8 ffff88021687ff80 ffff880216990000
> [  236.310975]  ffffffff81077c00 ffff88021687ffb0 0000000000000000 0000000000000000
> [  236.310979] Call Trace:
> [  236.310984]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.310990]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.310995]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.310999]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311004]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311009]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311013]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311016] kblockd         S ffff8802169908b0     0    26      2 0x00000000
> [  236.311024]  ffff8802169905f0 0000000000000046 0000000000011a80 ffff8802169c5fd8
> [  236.311028]  0000000000011a80 ffff8802169c5fd8 ffff880216978000 ffff8802169905f0
> [  236.311033]  ffffffff81077c00 ffff880216978030 0000000000000000 0000000000000000
> [  236.311037] Call Trace:
> [  236.311042]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311048]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311053]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311057]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311062]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311067]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311071]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311074] ata_sff         S ffff880216990ea0     0    27      2 0x00000000
> [  236.311082]  ffff880216990be0 0000000000000046 0000000000011a80 ffff880216a81fd8
> [  236.311086]  0000000000011a80 ffff880216a81fd8 ffff880216978a00 ffff880216990be0
> [  236.311091]  ffffffff81077c00 ffff880216978a30 0000000000000000 0000000000000000
> [  236.311095] Call Trace:
> [  236.311100]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311106]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311111]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311116]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311120]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311125]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311130]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311132] khubd           S ffff880216991490     0    28      2 0x00000000
> [  236.311137]  ffff8802169911d0 0000000000000046 0000000000011a80 ffff880216a85fd8
> [  236.311141]  0000000000011a80 ffff880216a85fd8 ffff8802169911d0 ffff880215838000
> [  236.311146]  ffff8802158380e8 0000000000000004 ffffffff81a42c50 ffff880215ec1a00
> [  236.311150] Call Trace:
> [  236.311156]  [<ffffffff81406292>] ? hub_thread+0x1032/0x1260
> [  236.311162]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.311167]  [<ffffffff81405260>] ? usb_reset_device+0x180/0x180
> [  236.311171]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311176]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311181]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311186]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311188] edac-poller     S ffff8802168f9490     0    29      2 0x00000000
> [  236.311196]  ffff8802168f91d0 0000000000000046 0000000000011a80 ffff880216a87fd8
> [  236.311201]  0000000000011a80 ffff880216a87fd8 ffff880216978d80 ffff8802168f91d0
> [  236.311205]  ffffffff81077c00 ffff880216978db0 0000000000000000 0000000000000000
> [  236.311210] Call Trace:
> [  236.311215]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311220]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311226]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311230]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311234]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311240]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311244]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311246] kworker/0:1     S ffff8802168f9a80     0    30      2 0x00000000
> [  236.311254]  ffff8802168f97c0 0000000000000046 0000000000011a80 ffff880216af9fd8
> [  236.311259]  0000000000011a80 ffff880216af9fd8 ffff88021fc11318 ffff880216ad1630
> [  236.311263]  ffff8802168f97c0 ffff8802168f97c0 ffff88021fc11300 ffff880216ad1600
> [  236.311268] Call Trace:
> [  236.311273]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.311279]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.311283]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311288]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311293]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311298]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311300] kvm-irqfd-clean S ffff8802168fa070     0    31      2 0x00000000
> [  236.311308]  ffff8802168f9db0 0000000000000046 0000000000011a80 ffff880216afbfd8
> [  236.311313]  0000000000011a80 ffff880216afbfd8 ffff880216ad4000 ffff8802168f9db0
> [  236.311317]  ffffffff81077c00 ffff880216ad4030 0000000000000000 0000000000000000
> [  236.311322] Call Trace:
> [  236.311327]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311333]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311338]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311342]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311347]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311352]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311356]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311359] kswapd0         S ffff8802168fa660     0    32      2 0x00000000
> [  236.311363]  ffff8802168fa3a0 0000000000000046 0000000000011a80 ffff88021616ffd8
> [  236.311367]  0000000000011a80 ffff88021616ffd8 ffffffff81a5f6c0 ffffffff81a60e48
> [  236.311372]  0000000000000000 ffffffff81a60e68 ffff88021616fe98 0000000000000000
> [  236.311376] Call Trace:
> [  236.311382]  [<ffffffff810c9697>] ? kswapd+0x2b7/0x2e0
> [  236.311387]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.311391]  [<ffffffff810c93e0>] ? balance_pgdat+0x500/0x500
> [  236.311395]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311400]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311405]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311410]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311412] khugepaged      S ffff8802168fac50     0    33      2 0x00000000
> [  236.311417]  ffff8802168fa990 0000000000000046 0000000000011a80 ffff8802161b3fd8
> [  236.311421]  0000000000011a80 ffff8802161b3fd8 ffff8802161b3d60 ffff8802161b3dd0
> [  236.311426]  00000000ffffbe0b ffffffff81b919c0 ffffffff81b919c0 0000000000000000
> [  236.311430] Call Trace:
> [  236.311437]  [<ffffffff8157f06c>] ? schedule_timeout+0x12c/0x1c0
> [  236.311443]  [<ffffffff8106cd00>] ? __internal_add_timer+0x100/0x100
> [  236.311450]  [<ffffffff810c5089>] ? __lru_cache_add+0x49/0x80
> [  236.311456]  [<ffffffff810f1914>] ? khugepaged+0x654/0xf20
> [  236.311462]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.311467]  [<ffffffff810f12c0>] ? collect_mm_slot+0xa0/0xa0
> [  236.311472]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311477]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311482]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311486]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311489] fsnotify_mark   S ffff8802168fb240     0    34      2 0x00000000
> [  236.311493]  ffff8802168faf80 0000000000000046 0000000000011a80 ffff8802161b5fd8
> [  236.311498]  0000000000011a80 ffff8802161b5fd8 ffff8802161b5e70 ffff8802161b5e70
> [  236.311502]  ffff8802168faf80 ffff8802161b5e98 ffff8802168faf80 ffff8802161b5e18
> [  236.311507] Call Trace:
> [  236.311513]  [<ffffffff8112edf2>] ? fsnotify_mark_destroy+0x132/0x180
> [  236.311518]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.311524]  [<ffffffff8112ecc0>] ? fsnotify_put_mark+0x40/0x40
> [  236.311528]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311532]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311537]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311542]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311545] xfsalloc        S ffff8802168fb830     0    35      2 0x00000000
> [  236.311553]  ffff8802168fb570 0000000000000046 0000000000011a80 ffff8802161b7fd8
> [  236.311557]  0000000000011a80 ffff8802161b7fd8 ffff880216ad4d00 ffff8802168fb570
> [  236.311562]  ffffffff81077c00 ffff880216ad4d30 0000000000000000 0000000000000000
> [  236.311566] Call Trace:
> [  236.311572]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311577]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311582]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311587]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311591]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311596]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311601]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311603] xfs_mru_cache   S ffff8802168fbe20     0    36      2 0x00000000
> [  236.311611]  ffff8802168fbb60 0000000000000046 0000000000011a80 ffff8802161b9fd8
> [  236.311616]  0000000000011a80 ffff8802161b9fd8 ffff880216ad4d80 ffff8802168fbb60
> [  236.311620]  ffffffff81077c00 ffff880216ad4db0 0000000000000000 0000000000000000
> [  236.311625] Call Trace:
> [  236.311630]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311635]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311640]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311645]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311649]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311654]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311659]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311661] xfslogd         S ffff8802168e9490     0    37      2 0x00000000
> [  236.311669]  ffff8802168e91d0 0000000000000046 0000000000011a80 ffff8802161bbfd8
> [  236.311674]  0000000000011a80 ffff8802161bbfd8 ffff880216ad4e00 ffff8802168e91d0
> [  236.311678]  ffffffff81077c00 ffff880216ad4e30 0000000000000000 0000000000000000
> [  236.311682] Call Trace:
> [  236.311688]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311693]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311698]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311703]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311707]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311712]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311717]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311719] crypto          S ffff8802168e9a80     0    38      2 0x00000000
> [  236.311727]  ffff8802168e97c0 0000000000000046 0000000000011a80 ffff8802161c1fd8
> [  236.311732]  0000000000011a80 ffff8802161c1fd8 ffff8802161ab200 ffff8802168e97c0
> [  236.311736]  ffffffff81077c00 ffff8802161ab230 0000000000000000 0000000000000000
> [  236.311741] Call Trace:
> [  236.311746]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311751]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311756]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311761]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311765]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311770]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311775]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311777] ttm_swap        S ffff8802162402c0     0    42      2 0x00000000
> [  236.311785]  ffff880216240000 0000000000000046 0000000000011a80 ffff880216249fd8
> [  236.311790]  0000000000011a80 ffff880216249fd8 ffff880216998e00 ffff880216240000
> [  236.311794]  ffffffff81077c00 ffff880216998e30 0000000000000000 0000000000000000
> [  236.311799] Call Trace:
> [  236.311804]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311809]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.311814]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.311819]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311824]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311829]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311833]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311836] scsi_eh_0       S ffff8802162408b0     0    43      2 0x00000000
> [  236.311840]  ffff8802162405f0 0000000000000046 0000000000011a80 ffff880215ec3fd8
> [  236.311845]  0000000000011a80 ffff880215ec3fd8 0000000000000246 ffff880216206000
> [  236.311849]  ffff8802162405f0 ffff880215ec3e78 ffff8802162405f0 0000000000000000
> [  236.311854] Call Trace:
> [  236.311859]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.311863]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.311868]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.311872]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311877]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311882]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311886]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311889] scsi_eh_1       S ffff880216240ea0     0    44      2 0x00000000
> [  236.311893]  ffff880216240be0 0000000000000046 0000000000011a80 ffff880215fa1fd8
> [  236.311898]  0000000000011a80 ffff880215fa1fd8 0000000000000246 ffff880216206800
> [  236.311902]  ffff880216240be0 ffff880215fa1e78 ffff880216240be0 0000000000000000
> [  236.311907] Call Trace:
> [  236.311911]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.311915]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.311920]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.311924]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311929]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311934]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311938]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311941] scsi_eh_2       S ffff880216241490     0    45      2 0x00000000
> [  236.311945]  ffff8802162411d0 0000000000000046 0000000000011a80 ffff880215fa3fd8
> [  236.311949]  0000000000011a80 ffff880215fa3fd8 0000000000000246 ffff880216207000
> [  236.311954]  ffff8802162411d0 ffff880215fa3e78 ffff8802162411d0 0000000000000000
> [  236.311958] Call Trace:
> [  236.311963]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.311967]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.311972]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.311976]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.311980]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311985]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.311990]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.311992] scsi_eh_3       S ffff880216241a80     0    46      2 0x00000000
> [  236.311997]  ffff8802162417c0 0000000000000046 0000000000011a80 ffff880215fa5fd8
> [  236.312001]  0000000000011a80 ffff880215fa5fd8 0000000000000246 ffff880216207800
> [  236.312005]  ffff8802162417c0 ffff880215fa5e78 ffff8802162417c0 0000000000000000
> [  236.312010] Call Trace:
> [  236.312015]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.312019]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.312023]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.312027]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312032]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312037]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312041]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312044] scsi_eh_4       S ffff880216242070     0    47      2 0x00000000
> [  236.312048]  ffff880216241db0 0000000000000046 0000000000011a80 ffff880215fc7fd8
> [  236.312053]  0000000000011a80 ffff880215fc7fd8 0000000000000246 ffff880215fc8000
> [  236.312057]  ffff880216241db0 ffff880215fc7e78 ffff880216241db0 0000000000000000
> [  236.312062] Call Trace:
> [  236.312066]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.312071]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.312075]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.312079]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312084]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312089]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312093]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312096] scsi_eh_5       S ffff880216242660     0    48      2 0x00000000
> [  236.312100]  ffff8802162423a0 0000000000000046 0000000000011a80 ffff880215fd1fd8
> [  236.312104]  0000000000011a80 ffff880215fd1fd8 0000000000000246 ffff880215fc8800
> [  236.312109]  ffff8802162423a0 ffff880215fd1e78 ffff8802162423a0 0000000000000000
> [  236.312113] Call Trace:
> [  236.312118]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.312122]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.312127]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.312131]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312135]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312140]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312145]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312147] kworker/u8:1    S ffff880216242c50     0    49      2 0x00000000
> [  236.312155]  ffff880216242990 0000000000000046 0000000000011a80 ffff880215fd3fd8
> [  236.312160]  0000000000011a80 ffff880215fd3fd8 ffff88021680d818 ffff880216883e30
> [  236.312164]  ffff880216242990 ffff880216242990 ffff88021680d800 ffff880216883e00
> [  236.312169] Call Trace:
> [  236.312174]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312180]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312184]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312189]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312194]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312198]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312201] kworker/u8:2    S ffff8802168fd5e0     0    50      2 0x00000000
> [  236.312209]  ffff8802168fd320 0000000000000046 0000000000011a80 ffff880215fd5fd8
> [  236.312213]  0000000000011a80 ffff880215fd5fd8 ffff88021680d818 ffff8802161b13b0
> [  236.312218]  ffff8802168fd320 ffff8802168fd320 ffff88021680d800 ffff8802161b1380
> [  236.312222] Call Trace:
> [  236.312228]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312233]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312237]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312242]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312247]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312251]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312254] kworker/u8:3    S ffff8802168ea070     0    51      2 0x00000000
> [  236.312262]  ffff8802168e9db0 0000000000000046 0000000000011a80 ffff880215fd7fd8
> [  236.312266]  0000000000011a80 ffff880215fd7fd8 ffff88021680d818 ffff880216934830
> [  236.312271]  ffff8802168e9db0 ffff8802168e9db0 ffff88021680d800 ffff880216934800
> [  236.312276] Call Trace:
> [  236.312281]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312286]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312291]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312295]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312300]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312305]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312307] kworker/u8:4    S ffff880216243240     0    52      2 0x00000000
> [  236.312315]  ffff880216242f80 0000000000000046 0000000000011a80 ffff880215fe1fd8
> [  236.312320]  0000000000011a80 ffff880215fe1fd8 ffff88021680d818 ffff880216883fb0
> [  236.312324]  ffff880216242f80 ffff880216242f80 ffff88021680d800 ffff880216883f80
> [  236.312329] Call Trace:
> [  236.312334]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312339]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312344]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312348]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312353]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312358]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312360] kworker/u8:5    S ffff880216243830     0    53      2 0x00000000
> [  236.312368]  ffff880216243570 0000000000000046 0000000000011a80 ffff880215fe3fd8
> [  236.312373]  0000000000011a80 ffff880215fe3fd8 ffff88021680d818 ffff880216883d30
> [  236.312377]  ffff880216243570 ffff880216243570 ffff88021680d800 ffff880216883d00
> [  236.312382] Call Trace:
> [  236.312387]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312393]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312397]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312402]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312406]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312411]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312413] kworker/u8:6    S ffff8802168fdbd0     0    54      2 0x00000000
> [  236.312422]  ffff8802168fd910 0000000000000046 0000000000011a80 ffff880215fedfd8
> [  236.312426]  0000000000011a80 ffff880215fedfd8 ffff88021680d818 ffff8802161b1530
> [  236.312430]  ffff8802168fd910 ffff8802168fd910 ffff88021680d800 ffff8802161b1500
> [  236.312435] Call Trace:
> [  236.312440]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312446]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312450]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312455]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312460]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312464]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312467] scsi_eh_6       S ffff8802168fe1c0     0    55      2 0x00000000
> [  236.312471]  ffff8802168fdf00 0000000000000046 0000000000011a80 ffff880215feffd8
> [  236.312475]  0000000000011a80 ffff880215feffd8 0000000000000246 ffff880215fc9000
> [  236.312480]  ffff8802168fdf00 ffff880215fefe78 ffff8802168fdf00 0000000000000000
> [  236.312484] Call Trace:
> [  236.312489]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.312493]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.312498]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.312502]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312507]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312512]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312516]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312519] scsi_eh_7       S ffff8802168fe7b0     0    56      2 0x00000000
> [  236.312523]  ffff8802168fe4f0 0000000000000046 0000000000011a80 ffff880215ff5fd8
> [  236.312527]  0000000000011a80 ffff880215ff5fd8 0000000000000246 ffff880215fc9800
> [  236.312532]  ffff8802168fe4f0 ffff880215ff5e78 ffff8802168fe4f0 0000000000000000
> [  236.312536] Call Trace:
> [  236.312541]  [<ffffffff813c1408>] ? scsi_error_handler+0x68/0x4a0
> [  236.312545]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.312550]  [<ffffffff813c13a0>] ? scsi_eh_ready_devs+0x6c0/0x6c0
> [  236.312554]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312559]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312564]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312568]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312570] kworker/u8:7    S ffff8802168feda0     0    57      2 0x00000000
> [  236.312578]  ffff8802168feae0 0000000000000046 0000000000011a80 ffff880215ff7fd8
> [  236.312583]  0000000000011a80 ffff880215ff7fd8 ffff88021680d818 ffff8802161b15b0
> [  236.312587]  ffff8802168feae0 ffff8802168feae0 ffff88021680d800 ffff8802161b1580
> [  236.312592] Call Trace:
> [  236.312597]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312603]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312607]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312612]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312617]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312621]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312623] kworker/u8:8    S ffff8802168ff390     0    58      2 0x00000000
> [  236.312631]  ffff8802168ff0d0 0000000000000046 0000000000011a80 ffff880215801fd8
> [  236.312636]  0000000000011a80 ffff880215801fd8 ffff88021680d818 ffff880216934ab0
> [  236.312640]  ffff8802168ff0d0 ffff8802168ff0d0 ffff88021680d800 ffff880216934a80
> [  236.312645] Call Trace:
> [  236.312650]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312656]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312660]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312664]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312669]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312674]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312676] kworker/1:1     S ffff8802168ff980     0    59      2 0x00000000
> [  236.312684]  ffff8802168ff6c0 0000000000000046 0000000000011a80 ffff880215803fd8
> [  236.312688]  0000000000011a80 ffff880215803fd8 ffff88021fc91318 ffff880215e80930
> [  236.312693]  ffff8802168ff6c0 ffff8802168ff6c0 ffff88021fc91300 ffff880215e80900
> [  236.312697] Call Trace:
> [  236.312703]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312708]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312712]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312717]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312722]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312726]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312729] kworker/2:1     S ffff880216243e20     0    60      2 0x00000000
> [  236.312737]  ffff880216243b60 0000000000000046 0000000000011a80 ffff88021582ffd8
> [  236.312741]  0000000000011a80 ffff88021582ffd8 ffff88021fd11318 ffff8802168f73b0
> [  236.312746]  ffff880216243b60 ffff880216243b60 ffff88021fd11300 ffff8802168f7380
> [  236.312750] Call Trace:
> [  236.312756]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312761]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312765]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312770]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312775]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312779]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312782] kworker/3:1     S ffff8802168ea660     0    61      2 0x00000000
> [  236.312790]  ffff8802168ea3a0 0000000000000046 0000000000011a80 ffff880215835fd8
> [  236.312794]  0000000000011a80 ffff880215835fd8 ffff88021fd91318 ffff880216934c30
> [  236.312799]  ffff8802168ea3a0 ffff8802168ea3a0 ffff88021fd91300 ffff880216934c00
> [  236.312803] Call Trace:
> [  236.312809]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312814]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312818]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312823]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312828]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312832]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312835] kworker/u8:9    S ffff8802168fcff0     0    62      2 0x00000000
> [  236.312843]  ffff8802168fcd30 0000000000000046 0000000000011a80 ffff880215863fd8
> [  236.312847]  0000000000011a80 ffff880215863fd8 ffff88021680d818 ffff88021582a130
> [  236.312852]  ffff8802168fcd30 ffff8802168fcd30 ffff88021680d800 ffff88021582a100
> [  236.312856] Call Trace:
> [  236.312862]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312867]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312871]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312876]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312881]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312885]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312888] kworker/0:2     S ffff8802168fca00     0    63      2 0x00000000
> [  236.312896]  ffff8802168fc740 0000000000000046 0000000000011a80 ffff8802158a7fd8
> [  236.312900]  0000000000011a80 ffff8802158a7fd8 ffff88021fc11318 ffff8802161b1d30
> [  236.312905]  ffff8802168fc740 ffff8802168fc740 ffff88021fc11300 ffff8802161b1d00
> [  236.312909] Call Trace:
> [  236.312915]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.312920]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.312925]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312929]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312934]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312939]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312941] hd-audio0       S ffff8802168fc410     0    64      2 0x00000000
> [  236.312949]  ffff8802168fc150 0000000000000046 0000000000011a80 ffff8802158f3fd8
> [  236.312953]  0000000000011a80 ffff8802158f3fd8 ffff88021582b880 ffff8802168fc150
> [  236.312958]  ffffffff81077c00 ffff88021582b8b0 0000000000000000 0000000000000000
> [  236.312962] Call Trace:
> [  236.312968]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.312973]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.312978]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.312983]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.312987]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312992]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.312997]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.312999] hd-audio1       S ffff8802158f82c0     0    65      2 0x00000000
> [  236.313007]  ffff8802158f8000 0000000000000046 0000000000011a80 ffff8802158f5fd8
> [  236.313012]  0000000000011a80 ffff8802158f5fd8 ffff88021582bd80 ffff8802158f8000
> [  236.313016]  ffffffff81077c00 ffff88021582bdb0 0000000000000000 0000000000000000
> [  236.313021] Call Trace:
> [  236.313026]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313031]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313036]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313041]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313045]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313050]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313055]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313057] deferwq         S ffff8802158f88b0     0    66      2 0x00000000
> [  236.313065]  ffff8802158f85f0 0000000000000046 0000000000011a80 ffff88021594dfd8
> [  236.313070]  0000000000011a80 ffff88021594dfd8 ffff8802158e2900 ffff8802158f85f0
> [  236.313074]  ffffffff81077c00 ffff8802158e2930 0000000000000000 0000000000000000
> [  236.313079] Call Trace:
> [  236.313084]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313089]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313094]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313099]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313103]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313108]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313113]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313115] xfs-data/sdc2   S ffff880216244410     0    67      2 0x00000000
> [  236.313123]  ffff880216244150 0000000000000046 0000000000011a80 ffff8802159cffd8
> [  236.313128]  0000000000011a80 ffff8802159cffd8 ffff88021693c300 ffff880216244150
> [  236.313132]  ffffffff81077c00 ffff88021693c330 0000000000000000 0000000000000000
> [  236.313137] Call Trace:
> [  236.313142]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313147]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313152]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313157]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313161]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313166]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313171]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313173] xfs-conv/sdc2   S ffff8802168eac50     0    68      2 0x00000000
> [  236.313181]  ffff8802168ea990 0000000000000046 0000000000011a80 ffff8802159e1fd8
> [  236.313186]  0000000000011a80 ffff8802159e1fd8 ffff88021693c480 ffff8802168ea990
> [  236.313190]  ffffffff81077c00 ffff88021693c4b0 0000000000000000 0000000000000000
> [  236.313195] Call Trace:
> [  236.313200]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313205]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313211]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313215]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313219]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313224]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313229]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313231] xfs-cil/sdc2    S ffff8802168eb240     0    69      2 0x00000000
> [  236.313239]  ffff8802168eaf80 0000000000000046 0000000000011a80 ffff8802159e3fd8
> [  236.313244]  0000000000011a80 ffff8802159e3fd8 ffff88021693c500 ffff8802168eaf80
> [  236.313248]  ffffffff81077c00 ffff88021693c530 0000000000000000 0000000000000000
> [  236.313253] Call Trace:
> [  236.313258]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313263]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313269]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313273]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313277]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313282]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313287]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313289] kworker/0:1H    S ffff880216991a80     0    70      2 0x00000000
> [  236.313297]  ffff8802169917c0 0000000000000046 0000000000011a80 ffff8802159e7fd8
> [  236.313302]  0000000000011a80 ffff8802159e7fd8 ffff88021fc116d8 ffff8802158e2c30
> [  236.313306]  ffff8802169917c0 ffff8802169917c0 ffff88021fc116c0 ffff8802158e2c00
> [  236.313311] Call Trace:
> [  236.313316]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.313322]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.313326]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313331]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313336]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313340]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313342] xfsaild/sdc2    S ffff880216992070     0    71      2 0x00000000
> [  236.313347]  ffff880216991db0 0000000000000046 0000000000011a80 ffff880215bddfd8
> [  236.313351]  0000000000011a80 ffff880215bddfd8 ffff8802158e2d90 ffff880215bdded0
> [  236.313356]  0000000000000000 ffff8802158e2dc0 0000000000000001 ffff8802158e2d80
> [  236.313360] Call Trace:
> [  236.313366]  [<ffffffff811fd5ab>] ? xfsaild+0x42b/0x4a0
> [  236.313372]  [<ffffffff811fd180>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
> [  236.313376]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313381]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313386]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313390]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313393] kworker/3:1H    S ffff8802158f8ea0     0    72      2 0x00000000
> [  236.313400]  ffff8802158f8be0 0000000000000046 0000000000011a80 ffff880215bf5fd8
> [  236.313405]  0000000000011a80 ffff880215bf5fd8 ffff88021fd916d8 ffff88021693c8b0
> [  236.313409]  ffff8802158f8be0 ffff8802158f8be0 ffff88021fd916c0 ffff88021693c880
> [  236.313414] Call Trace:
> [  236.313419]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.313425]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.313429]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313434]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313439]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313443]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313446] xfs-data/sdb    S ffff8802158f9490     0    79      2 0x00000000
> [  236.313454]  ffff8802158f91d0 0000000000000046 0000000000011a80 ffff8802156b5fd8
> [  236.313458]  0000000000011a80 ffff8802156b5fd8 ffff880215795a00 ffff8802158f91d0
> [  236.313463]  ffffffff81077c00 ffff880215795a30 0000000000000000 0000000000000000
> [  236.313467] Call Trace:
> [  236.313472]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313478]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313483]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313487]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313492]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313497]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313501]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313504] xfs-conv/sdb    S ffff8802158f9a80     0    80      2 0x00000000
> [  236.313512]  ffff8802158f97c0 0000000000000046 0000000000011a80 ffff8802156b7fd8
> [  236.313516]  0000000000011a80 ffff8802156b7fd8 ffff880215795a80 ffff8802158f97c0
> [  236.313521]  ffffffff81077c00 ffff880215795ab0 0000000000000000 0000000000000000
> [  236.313525] Call Trace:
> [  236.313531]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313536]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313541]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313545]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313550]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313555]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313559]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313562] xfs-cil/sdb     S ffff8802168ebe20     0    81      2 0x00000000
> [  236.313570]  ffff8802168ebb60 0000000000000046 0000000000011a80 ffff8802156b9fd8
> [  236.313574]  0000000000011a80 ffff8802156b9fd8 ffff880215795b00 ffff8802168ebb60
> [  236.313579]  ffffffff81077c00 ffff880215795b30 0000000000000000 0000000000000000
> [  236.313583] Call Trace:
> [  236.313589]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313594]  [<ffffffff81077e83>] ? rescuer_thread+0x283/0x300
> [  236.313599]  [<ffffffff81077c00>] ? worker_thread+0x3a0/0x3a0
> [  236.313603]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313608]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313613]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313617]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313620] xfsaild/sdb     S ffff880216992c50     0    82      2 0x00000000
> [  236.313624]  ffff880216992990 0000000000000046 0000000000011a80 ffff88021554ffd8
> [  236.313629]  0000000000011a80 ffff88021554ffd8 ffff8802157e2910 ffff88021554fed0
> [  236.313633]  0000000000000000 ffff8802157e2940 0000000000000001 ffff8802157e2900
> [  236.313637] Call Trace:
> [  236.313643]  [<ffffffff811fd5ab>] ? xfsaild+0x42b/0x4a0
> [  236.313648]  [<ffffffff811fd180>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
> [  236.313652]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.313657]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313662]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.313667]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.313669] syslog-ng       S ffff880216993830     0    85      1 0x00000000
> [  236.313673]  ffff880216993570 0000000000000086 0000000000011a80 ffff8802150c3fd8
> [  236.313678]  0000000000011a80 ffff8802150c3fd8 ffff8802150c3ec0 0000000001c9c37f
> [  236.313682]  0000000000000000 ffff880215546360 ffff880216993570 ffff8802150c3ec0
> [  236.313687] Call Trace:
> [  236.313692]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.313698]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.313704]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.313709]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.313715]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.313721]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.313723] mpd             S ffff880216245bd0     0    91      1 0x00000000
> [  236.313728]  ffff880216245910 0000000000000086 0000000000011a80 ffff88021534bfd8
> [  236.313732]  0000000000011a80 ffff88021534bfd8 ffff88021534bba8 0000000005f5e100
> [  236.313737]  0000000000000000 0000000000000000 0000000000000000 ffff88021534bbdc
> [  236.313741] Call Trace:
> [  236.313746]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.313752]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.313757]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.313762]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.313769]  [<ffffffff8153725f>] ? tcp_transmit_skb+0x3ff/0x820
> [  236.313775]  [<ffffffff814d61ef>] ? sk_reset_timer+0xf/0x20
> [  236.313780]  [<ffffffff81536cb1>] ? tcp_schedule_loss_probe+0x111/0x180
> [  236.313785]  [<ffffffff8123a120>] ? memcpy_toiovec+0x40/0x80
> [  236.313792]  [<ffffffff814dea0d>] ? skb_copy_datagram_iovec+0x4d/0x260
> [  236.313798]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.313803]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.313808]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.313813]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.313820]  [<ffffffff810f5d87>] ? do_sync_read+0x67/0xa0
> [  236.313825]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.313830]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.313837]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.313841]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.313847]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.313849] mpd             S ffff8802151cac50     0   130      1 0x00000000
> [  236.313854]  ffff8802151ca990 0000000000000086 0000000000011a80 ffff880212d7ffd8
> [  236.313858]  0000000000011a80 ffff880212d7ffd8 0000000000000000 ffff880212d7ff48
> [  236.313863]  0000000000000000 0000000000000000 0000000000000000 ffff880212d7fbc4
> [  236.313867] Call Trace:
> [  236.313872]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.313877]  [<ffffffff8108f0d1>] ? update_sd_lb_stats+0xf1/0x5c0
> [  236.313882]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.313887]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.313892]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.313899]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.313904]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.313911]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.313916]  [<ffffffff810d89a7>] ? handle_pte_fault+0x87/0x7c0
> [  236.313922]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.313926]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.313931]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.313936]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.313941]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.313943] mpd             S ffff8802151cb240     0   131      1 0x00000000
> [  236.313948]  ffff8802151caf80 0000000000000086 0000000000011a80 ffff880212d25fd8
> [  236.313952]  0000000000011a80 ffff880212d25fd8 ffff880212d25da0 0000000000000000
> [  236.313957]  ffffffff81b968d8 ffff8802151caf80 ffff880212d25db8 ffff8802151caf80
> [  236.313961] Call Trace:
> [  236.313968]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.313974]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.313979]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.313986]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.313992]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.313997]  [<ffffffff81583839>] ? stub_clone+0x69/0x90
> [  236.314002]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314005] mpd             S ffff8802158fca00     0   132      1 0x00000000
> [  236.314009]  ffff8802158fc740 0000000000000086 0000000000011a80 ffff880212d8dfd8
> [  236.314014]  0000000000011a80 ffff880212d8dfd8 ffff880212d8dda0 0000000000000000
> [  236.314018]  ffffffff81b974a8 ffff8802158fc740 ffff880212d8ddb8 ffff8802158fc740
> [  236.314023] Call Trace:
> [  236.314029]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.314034]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.314041]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.314047]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.314052]  [<ffffffff81231755>] ? __rwsem_do_wake+0xd5/0x160
> [  236.314056]  [<ffffffff8123183c>] ? rwsem_wake+0x3c/0x60
> [  236.314062]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.314068]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314070] mpd             S ffff8802158fc410     0   135      1 0x00000000
> [  236.314074]  ffff8802158fc150 0000000000000086 0000000000011a80 ffff880212dc7fd8
> [  236.314079]  0000000000011a80 ffff880212dc7fd8 ffff880212dc7da0 0000000000000000
> [  236.314083]  ffffffff81b97aa8 ffff8802158fc150 ffff880212dc7db8 ffff8802158fc150
> [  236.314088] Call Trace:
> [  236.314094]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.314100]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.314105]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.314111]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.314117]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.314123]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314125] ntpd            S ffff8802168eca00     0    92      1 0x00000000
> [  236.314130]  ffff8802168ec740 0000000000000086 0000000000011a80 ffff88021534dfd8
> [  236.314134]  0000000000011a80 ffff88021534dfd8 0000000000000000 ffff88021534dda0
> [  236.314138]  0000000000000040 0000000000100000 0000000000000014 0000000000000014
> [  236.314143] Call Trace:
> [  236.314148]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.314153]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.314157]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.314164]  [<ffffffff814df322>] ? datagram_poll+0x22/0x100
> [  236.314169]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.314174]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.314180]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314185]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314190]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314195]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314201]  [<ffffffff8154ea85>] ? inet_recvmsg+0x65/0x80
> [  236.314208]  [<ffffffff814d09f6>] ? sock_recvmsg+0x76/0xa0
> [  236.314214]  [<ffffffff8110ac30>] ? __d_alloc+0x110/0x160
> [  236.314218]  [<ffffffff81109eff>] ? dput+0x3f/0x2e0
> [  236.314223]  [<ffffffff8110a082>] ? dput+0x1c2/0x2e0
> [  236.314230]  [<ffffffff81080d5b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
> [  236.314235]  [<ffffffff812326d8>] ? timerqueue_add+0x58/0xa0
> [  236.314241]  [<ffffffff8108122b>] ? __hrtimer_start_range_ns+0x1eb/0x360
> [  236.314246]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.314253]  [<ffffffff810714d2>] ? signal_delivered+0x52/0x80
> [  236.314258]  [<ffffffff81033517>] ? do_signal+0x2f7/0x500
> [  236.314262]  [<ffffffff8103c355>] ? fpu_finit+0x15/0x40
> [  236.314266]  [<ffffffff8103c3c1>] ? init_fpu+0x41/0xa0
> [  236.314271]  [<ffffffff8103ce68>] ? __restore_xstate_sig+0x1a8/0x320
> [  236.314277]  [<ffffffff8106ea0e>] ? recalc_sigpending+0xe/0x40
> [  236.314282]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.314287]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314290] cupsd           S ffff880216994410     0    93      1 0x00000000
> [  236.314294]  ffff880216994150 0000000000000086 0000000000011a80 ffff88021534ffd8
> [  236.314299]  0000000000011a80 ffff88021534ffd8 0000000000000000 ffff88021534ff38
> [  236.314303]  0000000000000000 ffff880215546f60 ffff880216994150 0000000000000000
> [  236.314308] Call Trace:
> [  236.314313]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.314319]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.314325]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.314329]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.314336]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.314341]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314343] fcron           S ffff8802158fa660     0    96      1 0x00000000
> [  236.314348]  ffff8802158fa3a0 0000000000000086 0000000000011a80 ffff88021525bfd8
> [  236.314352]  0000000000011a80 ffff88021525bfd8 ffff88021525baf8 0000000005f5e100
> [  236.314357]  0000000000000000 0000000000000020 0000000000000005 0000000000000005
> [  236.314361] Call Trace:
> [  236.314366]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.314372]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.314377]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.314382]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.314387]  [<ffffffff8108f5c8>] ? find_busiest_group+0x28/0x4c0
> [  236.314393]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314399]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.314404]  [<ffffffff810ad176>] ? delayacct_end+0x76/0xa0
> [  236.314408]  [<ffffffff810b98a0>] ? sleep_on_page+0x20/0x20
> [  236.314414]  [<ffffffff8157f273>] ? __wait_on_bit_lock+0x93/0xc0
> [  236.314419]  [<ffffffff811e90ef>] ? xfs_iext_bno_to_ext+0x8f/0x180
> [  236.314424]  [<ffffffff810ba3b4>] ? find_get_page+0x14/0xa0
> [  236.314428]  [<ffffffff810ba4e5>] ? filemap_fault+0xa5/0x3c0
> [  236.314434]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.314439]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.314446]  [<ffffffff811e6574>] ? xfs_iunlock+0x34/0xa0
> [  236.314452]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.314457]  [<ffffffff8110a14d>] ? dput+0x28d/0x2e0
> [  236.314461]  [<ffffffff810f77d4>] ? __fput+0x134/0x200
> [  236.314467]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.314472]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.314477]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314479] udevd           S ffff8802169955e0     0    97      1 0x00000000
> [  236.314484]  ffff880216995320 0000000000000082 0000000000011a80 ffff8802152dffd8
> [  236.314488]  0000000000011a80 ffff8802152dffd8 0000000000000000 ffff8802152dff38
> [  236.314493]  0000000000000000 ffff8802157172a0 ffff880216995320 0000000000000000
> [  236.314497] Call Trace:
> [  236.314502]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.314509]  [<ffffffff81131933>] ? ep_scan_ready_list.isra.19+0x173/0x180
> [  236.314515]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.314519]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.314525]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.314530]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314533] kworker/3:2     S ffff880216994ff0     0   100      2 0x00000000
> [  236.314541]  ffff880216994d30 0000000000000046 0000000000011a80 ffff88021557bfd8
> [  236.314546]  0000000000011a80 ffff88021557bfd8 ffff88021fd91318 ffff88021693c230
> [  236.314550]  ffff880216994d30 ffff880216994d30 ffff88021fd91300 ffff88021693c200
> [  236.314555] Call Trace:
> [  236.314560]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.314566]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.314570]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.314575]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.314580]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.314584]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.314587] login           S ffff8802151cb830     0   143      1 0x00000000
> [  236.314591]  ffff8802151cb570 0000000000000086 0000000000011a80 ffff880212e6bfd8
> [  236.314596]  0000000000011a80 ffff880212e6bfd8 ffff8802151cb560 ffff880212e6bf08
> [  236.314600]  ffff8802151cb570 ffff8802151cb570 ffff8802151cb570 ffff8802151cb768
> [  236.314605] Call Trace:
> [  236.314610]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.314616]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.314622]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.314627]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314630] agetty          S ffff8802158fdbd0     0   144      1 0x00000000
> [  236.314634]  ffff8802158fd910 0000000000000082 0000000000011a80 ffff880215229fd8
> [  236.314638]  0000000000011a80 ffff880215229fd8 ffff880212cf7e00 ffff880215229de8
> [  236.314643]  7fffffffffffffff ffff880212d9fd80 7fffffffffffffff ffff880215325400
> [  236.314648] Call Trace:
> [  236.314654]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.314659]  [<ffffffff81109e20>] ? shrink_dentry_list+0x360/0x3e0
> [  236.314664]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.314671]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.314675]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.314679]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.314685]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.314689]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.314693]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.314698]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314701] squid           S ffff8802158fb830     0   146      1 0x00000000
> [  236.314705]  ffff8802158fb570 0000000000000082 0000000000011a80 ffff880212f81fd8
> [  236.314709]  0000000000011a80 ffff880212f81fd8 ffff880212f81ec0 00000000000f423f
> [  236.314714]  0000000000000000 ffff880212e334e0 ffff8802158fb570 ffff880212f81ec0
> [  236.314718] Call Trace:
> [  236.314723]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.314729]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.314735]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.314740]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.314746]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.314751]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314754] zsh             S ffff880216997390     0   169    143 0x00000000
> [  236.314758]  ffff8802169970d0 0000000000000086 0000000000011a80 ffff880210d1bfd8
> [  236.314763]  0000000000011a80 ffff880210d1bfd8 ffff8802169970d0 0000000002428050
> [  236.314767]  00000000004aef20 00007fff30cc6280 0000000000000000 0000000000000000
> [  236.314772] Call Trace:
> [  236.314776]  [<ffffffff810721b0>] ? sigsuspend+0x30/0x80
> [  236.314780]  [<ffffffff8107222e>] ? SyS_rt_sigsuspend+0x2e/0x80
> [  236.314785]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314788] startx          S ffff880216992660     0   180    169 0x00000000
> [  236.314792]  ffff8802169923a0 0000000000000082 0000000000011a80 ffff880210d17fd8
> [  236.314797]  0000000000011a80 ffff880210d17fd8 ffff880216992390 ffff880210d17f08
> [  236.314801]  ffff8802169923a0 ffff8802169923a0 ffff8802169923a0 ffff880216992598
> [  236.314806] Call Trace:
> [  236.314812]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.314817]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.314823]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.314828]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314831] xinit           S ffff880216993e20     0   196    180 0x00000000
> [  236.314835]  ffff880216993b60 0000000000000082 0000000000011a80 ffff880210d8dfd8
> [  236.314839]  0000000000011a80 ffff880210d8dfd8 ffff880216993b50 ffff880210d8df08
> [  236.314844]  ffff880216993b60 ffff880216993b60 ffff880216993b60 ffff880216993d58
> [  236.314848] Call Trace:
> [  236.314854]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.314860]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.314865]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.314871]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314873] X               S ffff8802151ce1c0     0   197    196 0x00000000
> [  236.314877]  ffff8802151cdf00 0000000000000082 0000000000011a80 ffff880210dcffd8
> [  236.314882]  0000000000011a80 ffff880210dcffd8 ffff880210dcfaf8 0000000005f5e100
> [  236.314886]  0000000000000000 0000000400000000 0000000000000022 0000000000000022
> [  236.314891] Call Trace:
> [  236.314895]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.314902]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.314907]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.314912]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.314918]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314923]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314928]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314933]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314938]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314943]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314949]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314954]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314959]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.314964]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.314969]  [<ffffffff8103ce68>] ? __restore_xstate_sig+0x1a8/0x320
> [  236.314975]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.314980]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.314986]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.314988] X               S ffff880216244a00     0   204    196 0x00000000
> [  236.314993]  ffff880216244740 0000000000000082 0000000000011a80 ffff880210e7ffd8
> [  236.314997]  0000000000011a80 ffff880210e7ffd8 ffff880210e7fda0 0000000000000000
> [  236.315002]  ffffffff81b96ce0 ffff880216244740 ffff880210e7fdb8 ffff880216244740
> [  236.315006] Call Trace:
> [  236.315012]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.315018]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.315024]  [<ffffffff8108702d>] ? check_preempt_curr+0x6d/0xa0
> [  236.315030]  [<ffffffff8108706d>] ? ttwu_do_wakeup+0xd/0xa0
> [  236.315034]  [<ffffffff81088d3b>] ? try_to_wake_up+0x1bb/0x240
> [  236.315040]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.315045]  [<ffffffff81033517>] ? do_signal+0x2f7/0x500
> [  236.315050]  [<ffffffff8103c355>] ? fpu_finit+0x15/0x40
> [  236.315054]  [<ffffffff8103c3c1>] ? init_fpu+0x41/0xa0
> [  236.315058]  [<ffffffff8103ce68>] ? __restore_xstate_sig+0x1a8/0x320
> [  236.315064]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.315070]  [<ffffffff81071e10>] ? restore_altstack+0x10/0x40
> [  236.315075]  [<ffffffff8103393e>] ? sys_rt_sigreturn+0x9e/0xc0
> [  236.315080]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315083] kworker/1:1H    S ffff8802158fe1c0     0   200      2 0x00000000
> [  236.315091]  ffff8802158fdf00 0000000000000046 0000000000011a80 ffff880210dddfd8
> [  236.315096]  0000000000011a80 ffff880210dddfd8 ffff88021fc916d8 ffff880210d66930
> [  236.315100]  ffff8802158fdf00 ffff8802158fdf00 ffff88021fc916c0 ffff880210d66900
> [  236.315105] Call Trace:
> [  236.315110]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.315116]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.315120]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.315125]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315130]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.315134]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315137] kworker/1:2     S ffff8802158ff980     0   205      2 0x00000000
> [  236.315145]  ffff8802158ff6c0 0000000000000046 0000000000011a80 ffff880210e81fd8
> [  236.315149]  0000000000011a80 ffff880210e81fd8 ffff88021fc91318 ffff880210d660b0
> [  236.315154]  ffff8802158ff6c0 ffff8802158ff6c0 ffff88021fc91300 ffff880210d66080
> [  236.315158] Call Trace:
> [  236.315164]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.315169]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.315174]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.315178]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315183]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.315188]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315190] kworker/2:1H    S ffff880216247980     0   208      2 0x00000000
> [  236.315198]  ffff8802162476c0 0000000000000046 0000000000011a80 ffff880210e45fd8
> [  236.315203]  0000000000011a80 ffff880210e45fd8 ffff88021fd116d8 ffff880212c9bcb0
> [  236.315207]  ffff8802162476c0 ffff8802162476c0 ffff88021fd116c0 ffff880212c9bc80
> [  236.315212] Call Trace:
> [  236.315217]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.315222]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.315227]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.315232]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315237]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.315241]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315243] startkde        S ffff880216994a00     0   221    196 0x00000000
> [  236.315248]  ffff880216994740 0000000000000086 0000000000011a80 ffff880210e73fd8
> [  236.315252]  0000000000011a80 ffff880210e73fd8 ffff880216994730 ffff880210e73f08
> [  236.315257]  ffff880216994740 ffff880216994740 ffff880216994740 ffff880216994938
> [  236.315261] Call Trace:
> [  236.315267]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.315273]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.315278]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.315284]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315286] xbindkeys       S ffff8802158fbe20     0   246      1 0x00000000
> [  236.315291]  ffff8802158fbb60 0000000000000086 0000000000011a80 ffff88020e485fd8
> [  236.315295]  0000000000011a80 ffff88020e485fd8 0000000000000000 ffff88020e485f48
> [  236.315299]  0000000000000000 0000000000000000 0000000000000000 ffff88020e485bc4
> [  236.315304] Call Trace:
> [  236.315309]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.315314]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.315320]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.315325]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.315330]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.315336]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.315341]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.315346]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.315351]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.315357]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.315363]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315369]  [<ffffffff814d09f6>] ? sock_recvmsg+0x76/0xa0
> [  236.315375]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.315381]  [<ffffffff814d128c>] ? SYSC_recvfrom+0xac/0x100
> [  236.315387]  [<ffffffff81071c7e>] ? do_sigaction+0x7e/0x1e0
> [  236.315392]  [<ffffffff810dcc28>] ? remove_vma+0x48/0x60
> [  236.315397]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.315402]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315405] dbus-launch     S ffff88020e469490     0   279      1 0x00000000
> [  236.315409]  ffff88020e4691d0 0000000000000082 0000000000011a80 ffff88020e4effd8
> [  236.315414]  0000000000011a80 ffff88020e4effd8 0000000000000000 ffff88020e4efda0
> [  236.315418]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
> [  236.315422] Call Trace:
> [  236.315427]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.315432]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.315438]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.315443]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.315448]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.315454]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315460]  [<ffffffff81088010>] ? rt_mutex_setprio+0x10/0x1e0
> [  236.315465]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.315470]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.315475]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.315481]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.315486]  [<ffffffff810ba3b4>] ? find_get_page+0x14/0xa0
> [  236.315492]  [<ffffffff814d09f6>] ? sock_recvmsg+0x76/0xa0
> [  236.315498]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.315503]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.315509]  [<ffffffff814d128c>] ? SYSC_recvfrom+0xac/0x100
> [  236.315514]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.315520]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315522] dbus-daemon     S ffff8802151cca00     0   280      1 0x00000000
> [  236.315526]  ffff8802151cc740 0000000000000082 0000000000011a80 ffff88020e5a7fd8
> [  236.315531]  0000000000011a80 ffff88020e5a7fd8 0000000000000000 ffff88020e5a7f38
> [  236.315535]  0000000000000000 ffff88021505bf60 ffff8802151cc740 0000000000000000
> [  236.315540] Call Trace:
> [  236.315545]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.315551]  [<ffffffff81131933>] ? ep_scan_ready_list.isra.19+0x173/0x180
> [  236.315557]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.315562]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.315568]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.315573]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315576] kdeinit4        S ffff8802151ce7b0     0   286      1 0x00000000
> [  236.315580]  ffff8802151ce4f0 0000000000000082 0000000000011a80 ffff88020e401fd8
> [  236.315585]  0000000000011a80 ffff88020e401fd8 0000000000000000 ffff88020e401da0
> [  236.315589]  0000000000000040 0000000000000200 0000000000000009 0000000000000009
> [  236.315593] Call Trace:
> [  236.315598]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.315603]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.315609]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.315614]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.315618]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.315624]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315630]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315635]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315640]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315645]  [<ffffffff81107282>] ? pollwake+0x62/0x80
> [  236.315649]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.315654]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.315660]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.315665]  [<ffffffff814d3e71>] ? sock_def_readable+0x31/0x60
> [  236.315671]  [<ffffffff8156496d>] ? unix_stream_sendmsg+0x3ad/0x3e0
> [  236.315676]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.315681]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.315686]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.315691]  [<ffffffff81064e7e>] ? do_wait+0x13e/0x240
> [  236.315696]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.315702]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.315707]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315710] kworker/2:2     S ffff88020e4688b0     0   287      2 0x00000000
> [  236.315718]  ffff88020e4685f0 0000000000000046 0000000000011a80 ffff88020e61ffd8
> [  236.315722]  0000000000011a80 ffff88020e61ffd8 ffff88021fd11318 ffff880212d4c530
> [  236.315727]  ffff88020e4685f0 ffff88020e4685f0 ffff88021fd11300 ffff880212d4c500
> [  236.315731] Call Trace:
> [  236.315737]  [<ffffffff81077a1d>] ? worker_thread+0x1bd/0x3a0
> [  236.315742]  [<ffffffff81077860>] ? process_one_work+0x3c0/0x3c0
> [  236.315747]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.315752]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315757]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.315761]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.315764] klauncher       S ffff8802151cd5e0     0   288    286 0x00000000
> [  236.315768]  ffff8802151cd320 0000000000000086 0000000000011a80 ffff88020e67ffd8
> [  236.315772]  0000000000011a80 ffff88020e67ffd8 0000000000000000 ffff88020e67ff48
> [  236.315777]  0000000000000000 0000000000000000 0000000000000000 ffff88020e67fbe4
> [  236.315781] Call Trace:
> [  236.315786]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.315791]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.315796]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.315801]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.315806]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.315813]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.315819]  [<ffffffff81562662>] ? unix_write_space+0x42/0x80
> [  236.315823]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.315829]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.315834]  [<ffffffff810ee3b7>] ? kmem_cache_free+0xd7/0x100
> [  236.315840]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315845]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315850]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315855]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315860]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315867]  [<ffffffff810f5d87>] ? do_sync_read+0x67/0xa0
> [  236.315871]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.315876]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.315881]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.315884] kded4           S ffff8802151cdbd0     0   290      1 0x00000000
> [  236.315888]  ffff8802151cd910 0000000000000082 0000000000011a80 ffff88020e79ffd8
> [  236.315892]  0000000000011a80 ffff88020e79ffd8 ffff88020e79fba8 00000000002d93f7
> [  236.315897]  0000000000000000 0000000000000000 0000000000000000 ffff88020e79fbf4
> [  236.315901] Call Trace:
> [  236.315906]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.315912]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.315917]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.315922]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.315929]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.315933]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.315939]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.315945]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315950]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315955]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315960]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315965]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315970]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315976]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315981]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.315985]  [<ffffffff81134a4a>] ? eventfd_read+0x2a/0x60
> [  236.315991]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.315996]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.316001]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316004] QProcessManager S ffff8802151cf980     0   298      1 0x00000000
> [  236.316008]  ffff8802151cf6c0 0000000000000082 0000000000011a80 ffff88020e5dbfd8
> [  236.316013]  0000000000011a80 ffff88020e5dbfd8 0000000000000000 ffff88020e5dbda0
> [  236.316017]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
> [  236.316022] Call Trace:
> [  236.316027]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316032]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.316037]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316042]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.316047]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316052]  [<ffffffff810d8d25>] ? handle_pte_fault+0x405/0x7c0
> [  236.316058]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.316063]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.316068]  [<ffffffff8158306f>] ? page_fault+0x1f/0x30
> [  236.316073]  [<ffffffff810f9a58>] ? __sb_start_write+0x58/0x120
> [  236.316080]  [<ffffffff8110c876>] ? update_time+0x76/0xc0
> [  236.316085]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.316091]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.316096]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.316101]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316104] QInotifyFileSys S ffff880208220ea0     0   304      1 0x00000000
> [  236.316109]  ffff880208220be0 0000000000000082 0000000000011a80 ffff88020967dfd8
> [  236.316113]  0000000000011a80 ffff88020967dfd8 0000000000000000 ffff88020967df48
> [  236.316117]  0000000000000000 0000000000000000 0000000000000000 ffff88020967dbcc
> [  236.316122] Call Trace:
> [  236.316127]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316132]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.316137]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.316142]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316147]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.316152]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.316158]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.316163]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.316169]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316174]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316179]  [<ffffffff810d77cb>] ? do_wp_page+0x36b/0x780
> [  236.316183]  [<ffffffff81580429>] ? down_write+0x9/0x26
> [  236.316187]  [<ffffffff810d8d25>] ? handle_pte_fault+0x405/0x7c0
> [  236.316193]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.316198]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.316203]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.316207]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.316212]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.316217]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316220] kglobalaccel    S ffff8802082208b0     0   303      1 0x00000000
> [  236.316224]  ffff8802082205f0 0000000000000086 0000000000011a80 ffff88020967bfd8
> [  236.316229]  0000000000011a80 ffff88020967bfd8 0000000000000000 ffff88020967bf48
> [  236.316233]  0000000000000000 0000000000000000 0000000000000000 ffff88020967bbd4
> [  236.316237] Call Trace:
> [  236.316242]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316247]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.316253]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.316258]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316263]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.316269]  [<ffffffff815639e7>] ? unix_stream_recvmsg+0x507/0x700
> [  236.316274]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.316279]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.316284]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.316290]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.316295]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316300]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316306]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316312]  [<ffffffff814d128c>] ? SYSC_recvfrom+0xac/0x100
> [  236.316317]  [<ffffffff81134a4a>] ? eventfd_read+0x2a/0x60
> [  236.316321]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.316326]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.316331]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316333] kwrapper4       S ffff8802158ff390     0   307    221 0x00000000
> [  236.316338]  ffff8802158ff0d0 0000000000000082 0000000000011a80 ffff880209457fd8
> [  236.316342]  0000000000011a80 ffff880209457fd8 ffff880208258368 ffff880209457cb0
> [  236.316347]  7fffffffffffffff 7fffffffffffffff ffff880208258300 0000000000000000
> [  236.316351] Call Trace:
> [  236.316357]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.316362]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.316368]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.316374]  [<ffffffff81563758>] ? unix_stream_recvmsg+0x278/0x700
> [  236.316379]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.316386]  [<ffffffff814d17f4>] ? sock_aio_read.part.30+0xf4/0x120
> [  236.316392]  [<ffffffff810f5d87>] ? do_sync_read+0x67/0xa0
> [  236.316397]  [<ffffffff810f67c5>] ? vfs_read+0x125/0x160
> [  236.316401]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.316405]  [<ffffffff8158306f>] ? page_fault+0x1f/0x30
> [  236.316411]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316413] ksmserver       S ffff880216246da0     0   308    286 0x00000000
> [  236.316417]  ffff880216246ae0 0000000000000082 0000000000011a80 ffff88020966ffd8
> [  236.316422]  0000000000011a80 ffff88020966ffd8 0000000000000000 ffff88020966ff48
> [  236.316426]  0000000000000000 0000000000000000 0000000000000000 ffff88020966fc24
> [  236.316431] Call Trace:
> [  236.316436]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316441]  [<ffffffff810c166e>] ? __get_free_pages+0xe/0x40
> [  236.316446]  [<ffffffff81107090>] ? __pollwait+0x90/0x100
> [  236.316450]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.316456]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.316461]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316466]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.316472]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.316477]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.316483]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.316488]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316494]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316499]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316504]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316509]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316514]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316519]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316525]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316530]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316535]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.316540]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316542] QProcessManager S ffff880208221a80     0   309    286 0x00000000
> [  236.316547]  ffff8802082217c0 0000000000000082 0000000000011a80 ffff880209675fd8
> [  236.316551]  0000000000011a80 ffff880209675fd8 0000000000000000 ffff880209675da0
> [  236.316556]  0000000000000040 0000000000000040 0000000000000006 0000000000000006
> [  236.316560] Call Trace:
> [  236.316565]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316571]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316576]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.316582]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316587]  [<ffffffff8108fb33>] ? load_balance+0xd3/0x6a0
> [  236.316592]  [<ffffffff8108f0d1>] ? update_sd_lb_stats+0xf1/0x5c0
> [  236.316599]  [<ffffffff810a1066>] ? generic_exec_single+0x86/0xa0
> [  236.316604]  [<ffffffff8105d360>] ? leave_mm+0x60/0x60
> [  236.316610]  [<ffffffff810a12e5>] ? smp_call_function_single+0xe5/0x180
> [  236.316615]  [<ffffffff8105d360>] ? leave_mm+0x60/0x60
> [  236.316619]  [<ffffffff8105d7e9>] ? flush_tlb_page+0x69/0xa0
> [  236.316625]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.316631]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.316637]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.316642]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.316648]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.316653]  [<ffffffff81074c8d>] ? SyS_prctl+0xcd/0x380
> [  236.316658]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316661] kwin            S ffff880208222070     0   310    308 0x00000000
> [  236.316665]  ffff880208221db0 0000000000000086 0000000000011a80 ffff88020830dfd8
> [  236.316669]  0000000000011a80 ffff88020830dfd8 ffff88020830daf8 00000000000f3f59
> [  236.316674]  0000000000000000 0000000000004000 000000000000000e 000000000000000e
> [  236.316678] Call Trace:
> [  236.316683]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.316690]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.316695]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316700]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.316705]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316711]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316716]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316721]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316726]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316731]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316737]  [<ffffffff814d09f6>] ? sock_recvmsg+0x76/0xa0
> [  236.316742]  [<ffffffff810f99b2>] ? __sb_end_write+0x32/0x80
> [  236.316747]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.316754]  [<ffffffff814d128c>] ? SYSC_recvfrom+0xac/0x100
> [  236.316760]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.316765]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.316770]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316772] kactivitymanage S ffff880208222660     0   312      1 0x00000000
> [  236.316777]  ffff8802082223a0 0000000000000086 0000000000011a80 ffff880207123fd8
> [  236.316781]  0000000000011a80 ffff880207123fd8 0000000000000000 ffff880207123f48
> [  236.316786]  0000000000000000 0000000000000000 0000000000000000 ffff880207123bdc
> [  236.316790] Call Trace:
> [  236.316795]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316800]  [<ffffffff8108df1f>] ? check_preempt_wakeup+0xff/0x240
> [  236.316805]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.316810]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.316815]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316820]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.316825]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.316831]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.316835]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.316841]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.316847]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316852]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316857]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316862]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316869]  [<ffffffff814d12c1>] ? SYSC_recvfrom+0xe1/0x100
> [  236.316873]  [<ffffffff810f6ae4>] ? vfs_write+0x124/0x1c0
> [  236.316878]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.316883]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316886] QThread         S ffff880208223240     0   318      1 0x00000000
> [  236.316890]  ffff880208222f80 0000000000000086 0000000000011a80 ffff880207363fd8
> [  236.316895]  0000000000011a80 ffff880207363fd8 0000000000000000 ffff880207363f48
> [  236.316899]  0000000000000000 0000000000000000 0000000000000000 ffff880207363bc4
> [  236.316903] Call Trace:
> [  236.316908]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.316914]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.316919]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.316924]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.316929]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.316935]  [<ffffffff814d1f0e>] ? sock_sendmsg+0x6e/0xa0
> [  236.316942]  [<ffffffff810ff959>] ? lookup_fast+0x39/0x2c0
> [  236.316946]  [<ffffffff812b0479>] ? scrup+0x79/0xe0
> [  236.316951]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.316958]  [<ffffffff814d2330>] ? ___sys_sendmsg+0x290/0x2a0
> [  236.316964]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.316969]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.316974]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.316978]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.316983]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.316988]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.316991] QThread         S ffff880208223830     0   319      1 0x00000000
> [  236.316995]  ffff880208223570 0000000000000086 0000000000011a80 ffff880209539fd8
> [  236.317000]  0000000000011a80 ffff880209539fd8 0000000000000000 ffff880209539f48
> [  236.317004]  0000000000000000 0000000000000000 0000000000000000 ffff880209539bc4
> [  236.317008] Call Trace:
> [  236.317013]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317019]  [<ffffffff814d8424>] ? __kmalloc_reserve.isra.32+0x24/0x80
> [  236.317024]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317029]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317036]  [<ffffffff814d1f0e>] ? sock_sendmsg+0x6e/0xa0
> [  236.317040]  [<ffffffff812b0479>] ? scrup+0x79/0xe0
> [  236.317045]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317052]  [<ffffffff814d2330>] ? ___sys_sendmsg+0x290/0x2a0
> [  236.317057]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.317063]  [<ffffffff812a00c9>] ? n_tty_write+0x189/0x480
> [  236.317068]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.317073]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.317078]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317083]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317086] QThread         S ffff880208223e20     0   320      1 0x00000000
> [  236.317090]  ffff880208223b60 0000000000000086 0000000000011a80 ffff88020953bfd8
> [  236.317094]  0000000000011a80 ffff88020953bfd8 0000000000000000 ffff88020953bf48
> [  236.317099]  0000000000000000 0000000000000000 0000000000000000 ffff88020953bbc4
> [  236.317103] Call Trace:
> [  236.317108]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317113]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317118]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.317124]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317129]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317134]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317140]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317146]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317152]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317157]  [<ffffffff810dd9dd>] ? vma_adjust+0x67d/0x760
> [  236.317161]  [<ffffffff81580429>] ? down_write+0x9/0x26
> [  236.317167]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.317172]  [<ffffffff810ed52e>] ? new_slab+0xce/0x260
> [  236.317178]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.317183]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.317187]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.317192]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.317197]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317202]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317205] QInotifyFileSys S ffff88020e46ac50     0   321      1 0x00000000
> [  236.317209]  ffff88020e46a990 0000000000000086 0000000000011a80 ffff880208215fd8
> [  236.317214]  0000000000011a80 ffff880208215fd8 0000000000000000 ffff880208215f48
> [  236.317218]  0000000000000000 0000000000000000 0000000000000000 ffff880208215bcc
> [  236.317222] Call Trace:
> [  236.317227]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317232]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317237]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.317242]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317247]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317253]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317258]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317264]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317269]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317274]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317279]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317284]  [<ffffffff81580429>] ? down_write+0x9/0x26
> [  236.317289]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.317294]  [<ffffffff810d8fbb>] ? handle_pte_fault+0x69b/0x7c0
> [  236.317300]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.317305]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.317309]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.317313]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.317318]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317324]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317326] QThread         S ffff88020e46b240     0   322      1 0x00000000
> [  236.317330]  ffff88020e46af80 0000000000000086 0000000000011a80 ffff880207361fd8
> [  236.317335]  0000000000011a80 ffff880207361fd8 0000000000000000 ffff880207361f48
> [  236.317339]  0000000000000000 0000000000000000 0000000000000000 ffff880207361bc4
> [  236.317343] Call Trace:
> [  236.317348]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317354]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317358]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.317363]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317368]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317374]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317379]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317384]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317390]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317395]  [<ffffffff810d7190>] ? unmap_single_vma+0x650/0x800
> [  236.317400]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.317404]  [<ffffffff81580429>] ? down_write+0x9/0x26
> [  236.317409]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.317414]  [<ffffffff810d8fbb>] ? handle_pte_fault+0x69b/0x7c0
> [  236.317420]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.317425]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.317429]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.317433]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.317438]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317443]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317446] knotify4        S ffff8802162467b0     0   315      1 0x00000000
> [  236.317450]  ffff8802162464f0 0000000000000082 0000000000011a80 ffff880207167fd8
> [  236.317455]  0000000000011a80 ffff880207167fd8 0000000000000000 ffff880207167f48
> [  236.317459]  0000000000000000 0000000000000000 0000000000000000 ffff880207167bdc
> [  236.317463] Call Trace:
> [  236.317468]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317473]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.317479]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.317484]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317489]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317494]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.317500]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.317504]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.317510]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.317516]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317521]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317526]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317531]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317538]  [<ffffffff814d12c1>] ? SYSC_recvfrom+0xe1/0x100
> [  236.317542]  [<ffffffff81134a4a>] ? eventfd_read+0x2a/0x60
> [  236.317546]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.317551]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317557]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317559] QInotifyFileSys S ffff8802162461c0     0   323      1 0x00000000
> [  236.317563]  ffff880216245f00 0000000000000082 0000000000011a80 ffff88020703dfd8
> [  236.317568]  0000000000011a80 ffff88020703dfd8 0000000000000000 ffff88020703df48
> [  236.317572]  0000000000000000 0000000000000000 0000000000000000 ffff88020703dbcc
> [  236.317576] Call Trace:
> [  236.317581]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317586]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.317591]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317596]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317602]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317608]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.317613]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317618]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317625]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.317629]  [<ffffffff810d89a7>] ? handle_pte_fault+0x87/0x7c0
> [  236.317635]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.317640]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.317644]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.317649]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.317654]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317659]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317662] plasma-desktop  S ffff8802158fd5e0     0   317      1 0x00000000
> [  236.317666]  ffff8802158fd320 0000000000000082 0000000000011a80 ffff88020724bfd8
> [  236.317670]  0000000000011a80 ffff88020724bfd8 ffff88020724bba8 00000000000eec4f
> [  236.317675]  0000000000000000 0000000000000000 0000000000000000 ffff88020724bc04
> [  236.317679] Call Trace:
> [  236.317684]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.317690]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.317695]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317700]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.317707]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.317711]  [<ffffffff814d3e71>] ? sock_def_readable+0x31/0x60
> [  236.317717]  [<ffffffff8156496d>] ? unix_stream_sendmsg+0x3ad/0x3e0
> [  236.317722]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.317728]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.317733]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317738]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317744]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317749]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317754]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317759]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317764]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317769]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317775]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317780]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.317785]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317787] plasma-desktop  S ffff880208224410     0   324      1 0x00000000
> [  236.317792]  ffff880208224150 0000000000000082 0000000000011a80 ffff880207125fd8
> [  236.317796]  0000000000011a80 ffff880207125fd8 ffff880207125da0 0000000000000000
> [  236.317801]  ffffffff81b96d70 ffff880208224150 ffff880207125db8 ffff880208224150
> [  236.317805] Call Trace:
> [  236.317811]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.317817]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.317823]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.317830]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.317836]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.317842]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.317847]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317850] QProcessManager S ffff880208224a00     0   326      1 0x00000000
> [  236.317854]  ffff880208224740 0000000000000082 0000000000011a80 ffff8802082d3fd8
> [  236.317859]  0000000000011a80 ffff8802082d3fd8 0000000000000000 ffff8802082d3da0
> [  236.317863]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
> [  236.317867] Call Trace:
> [  236.317872]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317878]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.317883]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.317889]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.317894]  [<ffffffff810c0947>] ? get_page_from_freelist+0xe7/0x5e0
> [  236.317901]  [<ffffffff810a1066>] ? generic_exec_single+0x86/0xa0
> [  236.317906]  [<ffffffff8105d360>] ? leave_mm+0x60/0x60
> [  236.317912]  [<ffffffff810a12e5>] ? smp_call_function_single+0xe5/0x180
> [  236.317917]  [<ffffffff8105d360>] ? leave_mm+0x60/0x60
> [  236.317921]  [<ffffffff8105d7e9>] ? flush_tlb_page+0x69/0xa0
> [  236.317927]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.317932]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.317938]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.317944]  [<ffffffff810ee1dd>] ? kmem_cache_alloc+0x1d/0xa0
> [  236.317949]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.317954]  [<ffffffff81074c8d>] ? SyS_prctl+0xcd/0x380
> [  236.317960]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.317962] ksysguardd      S ffff880208224ff0     0   327    317 0x00000000
> [  236.317966]  ffff880208224d30 0000000000000086 0000000000011a80 ffff88020e423fd8
> [  236.317971]  0000000000011a80 ffff88020e423fd8 0000000000000000 ffff88020e423da0
> [  236.317975]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
> [  236.317980] Call Trace:
> [  236.317985]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.317990]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.317995]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318000]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.318005]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318011]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318016]  [<ffffffff812346ae>] ? vsnprintf+0x40e/0x6a0
> [  236.318022]  [<ffffffff810ffe2c>] ? generic_permission+0xcc/0xe0
> [  236.318027]  [<ffffffff8110b212>] ? __d_lookup+0x72/0x140
> [  236.318033]  [<ffffffff81233510>] ? number.isra.1+0x2f0/0x320
> [  236.318038]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.318043]  [<ffffffff810d8fbb>] ? handle_pte_fault+0x69b/0x7c0
> [  236.318049]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.318053]  [<ffffffff810f9a58>] ? __sb_start_write+0x58/0x120
> [  236.318059]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.318063]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.318068]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.318074]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.318078]  [<ffffffff810f6c63>] ? SyS_write+0x43/0xa0
> [  236.318083]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318086] krunner         S ffff880208226da0     0   338      1 0x00000000
> [  236.318090]  ffff880208226ae0 0000000000000086 0000000000011a80 ffff8802071a9fd8
> [  236.318094]  0000000000011a80 ffff8802071a9fd8 0000000000000000 ffff8802071a9f48
> [  236.318099]  0000000000000000 0000000000000000 0000000000000000 ffff8802071a9bf4
> [  236.318103] Call Trace:
> [  236.318108]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318113]  [<ffffffff8108df1f>] ? check_preempt_wakeup+0xff/0x240
> [  236.318118]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.318123]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.318128]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318133]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.318140]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.318146]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.318151]  [<ffffffff814d939e>] ? skb_release_head_state+0x3e/0xa0
> [  236.318156]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.318162]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.318167]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318173]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318178]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318183]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318188]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318193]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318198]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318203]  [<ffffffff81134a4a>] ? eventfd_read+0x2a/0x60
> [  236.318208]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.318214]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318216] QInotifyFileSys S ffff880216244ff0     0   346      1 0x00000000
> [  236.318220]  ffff880216244d30 0000000000000086 0000000000011a80 ffff880200c49fd8
> [  236.318225]  0000000000011a80 ffff880200c49fd8 0000000000000000 ffff880200c49f48
> [  236.318229]  0000000000000000 0000000000000000 0000000000000000 ffff880200c49bcc
> [  236.318234] Call Trace:
> [  236.318238]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318244]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.318248]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.318254]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318258]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.318264]  [<ffffffff810835c0>] ? kexec_crash_size_show+0x40/0x40
> [  236.318269]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.318275]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.318281]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318286]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318292]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.318296]  [<ffffffff810d89a7>] ? handle_pte_fault+0x87/0x7c0
> [  236.318302]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.318307]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.318312]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.318316]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.318321]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.318326]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318329] konsole         S ffff880208227980     0   340      1 0x00000000
> [  236.318333]  ffff8802082276c0 0000000000000082 0000000000011a80 ffff880200e9dfd8
> [  236.318337]  0000000000011a80 ffff880200e9dfd8 ffff880200e9dba8 000000000007994f
> [  236.318342]  0000000000000000 0000000000000000 0000000000000000 ffff880200e9dbec
> [  236.318346] Call Trace:
> [  236.318351]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.318357]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.318362]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318367]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.318373]  [<ffffffff81233510>] ? number.isra.1+0x2f0/0x320
> [  236.318377]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.318383]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.318389]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318394]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318399]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318404]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318410]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318415]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318420]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318426]  [<ffffffff81111c97>] ? mntput_no_expire+0x17/0x140
> [  236.318431]  [<ffffffff8110a082>] ? dput+0x1c2/0x2e0
> [  236.318436]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.318441]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.318446]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318449] QProcessManager S ffff8802158feda0     0   347      1 0x00000000
> [  236.318453]  ffff8802158feae0 0000000000000082 0000000000011a80 ffff8801fd57bfd8
> [  236.318458]  0000000000011a80 ffff8801fd57bfd8 0000000000000000 ffff8801fd57bda0
> [  236.318462]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
> [  236.318467] Call Trace:
> [  236.318472]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318477]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.318482]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318487]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.318492]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318498]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.318504]  [<ffffffff810c0b5a>] ? get_page_from_freelist+0x2fa/0x5e0
> [  236.318510]  [<ffffffff810c0f23>] ? __alloc_pages_nodemask+0xe3/0x820
> [  236.318515]  [<ffffffff810f9a58>] ? __sb_start_write+0x58/0x120
> [  236.318520]  [<ffffffff8110c876>] ? update_time+0x76/0xc0
> [  236.318525]  [<ffffffff810f99b2>] ? __sb_end_write+0x32/0x80
> [  236.318530]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.318536]  [<ffffffff810f5d87>] ? do_sync_read+0x67/0xa0
> [  236.318542]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.318546]  [<ffffffff810f6bf4>] ? SyS_read+0x74/0xa0
> [  236.318551]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318554] polkit-kde-auth S ffff8802082255e0     0   342      1 0x00000000
> [  236.318558]  ffff880208225320 0000000000000086 0000000000011a80 ffff880200a43fd8
> [  236.318563]  0000000000011a80 ffff880200a43fd8 0000000000000000 ffff880200a43f48
> [  236.318567]  0000000000000000 0000000000000000 0000000000000000 ffff880200a43bdc
> [  236.318571] Call Trace:
> [  236.318576]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318581]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.318587]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.318592]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318597]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.318603]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.318608]  [<ffffffff814d4432>] ? sock_wfree+0x52/0x60
> [  236.318613]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.318618]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.318624]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.318630]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318635]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318640]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318645]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318652]  [<ffffffff814d128c>] ? SYSC_recvfrom+0xac/0x100
> [  236.318656]  [<ffffffff81134a4a>] ? eventfd_read+0x2a/0x60
> [  236.318660]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.318665]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.318670]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318673] start_tmux      S ffff8802158fb240     0   348    340 0x00000000
> [  236.318677]  ffff8802158faf80 0000000000000086 0000000000011a80 ffff8801fd53bfd8
> [  236.318682]  0000000000011a80 ffff8801fd53bfd8 ffff8802158faf70 ffff8801fd53bf08
> [  236.318686]  ffff8802158faf80 ffff8802158faf80 ffff8802158faf80 ffff8802158fb178
> [  236.318691] Call Trace:
> [  236.318696]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.318702]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.318708]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.318713]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318715] tmux            S ffff88020e46c410     0   350    348 0x00000000
> [  236.318720]  ffff88020e46c150 0000000000000082 0000000000011a80 ffff8801fd615fd8
> [  236.318724]  0000000000011a80 ffff8801fd615fd8 0000000000000000 ffff8801fd615f38
> [  236.318729]  0000000000000000 ffff880210e522a0 ffff88020e46c150 0000000000000000
> [  236.318733] Call Trace:
> [  236.318738]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318745]  [<ffffffff81131560>] ? ep_call_nested.constprop.24+0x120/0x120
> [  236.318751]  [<ffffffff8113153f>] ? ep_call_nested.constprop.24+0xff/0x120
> [  236.318757]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.318764]  [<ffffffff811321cb>] ? SyS_epoll_ctl+0xab/0x8a0
> [  236.318768]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.318774]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.318780]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318782] tmux            S ffff88020e46ca00     0   352      1 0x00000000
> [  236.318786]  ffff88020e46c740 0000000000000086 0000000000011a80 ffff8801fd5a3fd8
> [  236.318791]  0000000000011a80 ffff8801fd5a3fd8 ffff8801fd5a3ec0 000000000007a11f
> [  236.318795]  0000000000000000 ffff880212d49de0 ffff88020e46c740 ffff8801fd5a3ec0
> [  236.318800] Call Trace:
> [  236.318805]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.318811]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.318817]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.318821]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.318827]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.318832]  [<ffffffff810dfa46>] ? vm_munmap+0x46/0x60
> [  236.318837]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318839] sudo            S ffff8802082261c0     0   354    352 0x00000000
> [  236.318844]  ffff880208225f00 0000000000000082 0000000000011a80 ffff88020083dfd8
> [  236.318849]  0000000000011a80 ffff88020083dfd8 0000000000000000 ffff88020083dda0
> [  236.318853]  0000000000000040 0000000000000040 0000000000000006 0000000000000006
> [  236.318857] Call Trace:
> [  236.318862]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318868]  [<ffffffff81565957>] ? unix_dgram_poll+0x37/0x1e0
> [  236.318874]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318879]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.318885]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318890]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.318896]  [<ffffffff810c0f23>] ? __alloc_pages_nodemask+0xe3/0x820
> [  236.318900]  [<ffffffff810d7e6b>] ? copy_pte_range+0x28b/0x4c0
> [  236.318907]  [<ffffffff8122bea8>] ? cpumask_any_but+0x28/0x40
> [  236.318911]  [<ffffffff8105d7b8>] ? flush_tlb_page+0x38/0xa0
> [  236.318917]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.318922]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.318928]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.318934]  [<ffffffff8108703d>] ? check_preempt_curr+0x7d/0xa0
> [  236.318939]  [<ffffffff81088f01>] ? wake_up_new_task+0xc1/0x120
> [  236.318943]  [<ffffffff8105fbbd>] ? do_fork+0xdd/0x280
> [  236.318948]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.318954]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.318956] sudo            S ffff88020e46cff0     0   356    352 0x00000000
> [  236.318960]  ffff88020e46cd30 0000000000000086 0000000000011a80 ffff880208359fd8
> [  236.318965]  0000000000011a80 ffff880208359fd8 0000000000000000 ffff880208359da0
> [  236.318969]  0000000000000040 0000000000000040 0000000000000006 0000000000000006
> [  236.318974] Call Trace:
> [  236.318979]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.318985]  [<ffffffff81565957>] ? unix_dgram_poll+0x37/0x1e0
> [  236.318990]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.318995]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.319000]  [<ffffffff811d5d33>] ? xfs_da_read_buf+0xb3/0x1c0
> [  236.319006]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319011]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319017]  [<ffffffff810c0f23>] ? __alloc_pages_nodemask+0xe3/0x820
> [  236.319022]  [<ffffffff810d7e6b>] ? copy_pte_range+0x28b/0x4c0
> [  236.319028]  [<ffffffff810c4cca>] ? release_pages+0x18a/0x1c0
> [  236.319034]  [<ffffffff8122bea8>] ? cpumask_any_but+0x28/0x40
> [  236.319038]  [<ffffffff8105d7b8>] ? flush_tlb_page+0x38/0xa0
> [  236.319044]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.319049]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.319056]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.319062]  [<ffffffff8108702d>] ? check_preempt_curr+0x6d/0xa0
> [  236.319066]  [<ffffffff81088f01>] ? wake_up_new_task+0xc1/0x120
> [  236.319071]  [<ffffffff8105fbbd>] ? do_fork+0xdd/0x280
> [  236.319076]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.319081]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319084] sh              S ffff88020e46dbd0     0   358    352 0x00000000
> [  236.319088]  ffff88020e46d910 0000000000000086 0000000000011a80 ffff880200c8dfd8
> [  236.319093]  0000000000011a80 ffff880200c8dfd8 ffff88020e46d900 ffff880200c8df08
> [  236.319097]  ffff88020e46d910 ffff88020e46d910 ffff88020e46d910 ffff88020e46db08
> [  236.319102] Call Trace:
> [  236.319107]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.319113]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.319119]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.319124]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319126] ncmpcpp         S ffff880216247390     0   360    352 0x00000000
> [  236.319130]  ffff8802162470d0 0000000000000082 0000000000011a80 ffff880207317fd8
> [  236.319135]  0000000000011a80 ffff880207317fd8 ffff880207317af8 000000000007a11f
> [  236.319139]  0000000000000000 0000000000000010 0000000000000004 0000000000000004
> [  236.319144] Call Trace:
> [  236.319149]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.319155]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.319160]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.319165]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.319171]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319176]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319181]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319186]  [<ffffffff814d61ef>] ? sk_reset_timer+0xf/0x20
> [  236.319191]  [<ffffffff81536cb1>] ? tcp_schedule_loss_probe+0x111/0x180
> [  236.319197]  [<ffffffff81537870>] ? tcp_write_xmit+0x1f0/0xae0
> [  236.319202]  [<ffffffff814d651f>] ? release_sock+0xdf/0x160
> [  236.319206]  [<ffffffff81529f9e>] ? tcp_sendmsg+0x11e/0xd80
> [  236.319211]  [<ffffffff8108df66>] ? check_preempt_wakeup+0x146/0x240
> [  236.319217]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.319223]  [<ffffffff812a00c9>] ? n_tty_write+0x189/0x480
> [  236.319229]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.319234]  [<ffffffff81087e11>] ? __wake_up+0x31/0x60
> [  236.319240]  [<ffffffff81071c7e>] ? do_sigaction+0x7e/0x1e0
> [  236.319246]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.319251]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.319257]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319259] mutt            S ffff880208227390     0   362    352 0x00000000
> [  236.319263]  ffff8802082270d0 0000000000000082 0000000000011a80 ffff8802009bdfd8
> [  236.319268]  0000000000011a80 ffff8802009bdfd8 ffff8802009bdaf8 0000000005f5e100
> [  236.319272]  0000000000000000 0000000000000002 0000000000000001 0000000000000001
> [  236.319277] Call Trace:
> [  236.319282]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.319288]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.319293]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.319298]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.319304]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319309]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319314]  [<ffffffff8108f5c8>] ? find_busiest_group+0x28/0x4c0
> [  236.319320]  [<ffffffff8108fb33>] ? load_balance+0xd3/0x6a0
> [  236.319325]  [<ffffffff8108dfb6>] ? check_preempt_wakeup+0x196/0x240
> [  236.319330]  [<ffffffff8108703d>] ? check_preempt_curr+0x7d/0xa0
> [  236.319336]  [<ffffffff8108706d>] ? ttwu_do_wakeup+0xd/0xa0
> [  236.319340]  [<ffffffff81088d3b>] ? try_to_wake_up+0x1bb/0x240
> [  236.319345]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.319351]  [<ffffffff812a00c9>] ? n_tty_write+0x189/0x480
> [  236.319357]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.319362]  [<ffffffff81087e11>] ? __wake_up+0x31/0x60
> [  236.319368]  [<ffffffff81071c7e>] ? do_sigaction+0x7e/0x1e0
> [  236.319374]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.319379]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.319384]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319387] zsh             S ffff8802158fa070     0   365    352 0x00000000
> [  236.319391]  ffff8802158f9db0 0000000000000082 0000000000011a80 ffff880207301fd8
> [  236.319396]  0000000000011a80 ffff880207301fd8 ffff88020733a000 ffff880207301de8
> [  236.319400]  7fffffffffffffff ffff880210c77700 7fffffffffffffff ffff880208213800
> [  236.319405] Call Trace:
> [  236.319411]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.319415]  [<ffffffff810d77cb>] ? do_wp_page+0x36b/0x780
> [  236.319421]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.319426]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.319432]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.319436]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.319441]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.319446]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.319450]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.319454]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.319459]  [<ffffffff8158306f>] ? page_fault+0x1f/0x30
> [  236.319464]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319466] zsh             S ffff8802158fe7b0     0   367    352 0x00000000
> [  236.319471]  ffff8802158fe4f0 0000000000000086 0000000000011a80 ffff880200fb1fd8
> [  236.319475]  0000000000011a80 ffff880200fb1fd8 ffff8802158fe4f0 0000000000abe020
> [  236.319480]  00000000004aef20 00007fffb94b89f0 0000000000000000 0000000000000000
> [  236.319484] Call Trace:
> [  236.319489]  [<ffffffff810721b0>] ? sigsuspend+0x30/0x80
> [  236.319493]  [<ffffffff8107222e>] ? SyS_rt_sigsuspend+0x2e/0x80
> [  236.319498]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319500] zsh             S ffff8801fd5a88b0     0   369    352 0x00000000
> [  236.319505]  ffff8801fd5a85f0 0000000000000082 0000000000011a80 ffff880207029fd8
> [  236.319509]  0000000000011a80 ffff880207029fd8 ffff8801fd5a85f0 0000000002456060
> [  236.319514]  00000000004aef20 00007fff17556030 0000000000000000 0000000000000000
> [  236.319518] Call Trace:
> [  236.319523]  [<ffffffff810721b0>] ? sigsuspend+0x30/0x80
> [  236.319527]  [<ffffffff8107222e>] ? SyS_rt_sigsuspend+0x2e/0x80
> [  236.319532]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319534] zsh             S ffff8802151cbe20     0   371    352 0x00000000
> [  236.319538]  ffff8802151cbb60 0000000000000086 0000000000011a80 ffff880200b17fd8
> [  236.319543]  0000000000011a80 ffff880200b17fd8 ffff880200f7af00 ffff880200b17de8
> [  236.319547]  7fffffffffffffff ffff88020e428a00 7fffffffffffffff ffff8801fd4b0c00
> [  236.319552] Call Trace:
> [  236.319558]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.319564]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.319569]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.319575]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.319580]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.319584]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.319590]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.319594]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.319598]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.319602]  [<ffffffff8158306f>] ? page_fault+0x1f/0x30
> [  236.319608]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319610] zsh             S ffff880200ba82c0     0   373    352 0x00000000
> [  236.319614]  ffff880200ba8000 0000000000000086 0000000000011a80 ffff880200b43fd8
> [  236.319619]  0000000000011a80 ffff880200b43fd8 ffff880200831400 ffff880200b43de8
> [  236.319623]  7fffffffffffffff ffff88020e725740 7fffffffffffffff ffff880208212000
> [  236.319628] Call Trace:
> [  236.319634]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.319640]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.319645]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.319651]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.319655]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.319660]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.319665]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.319669]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.319673]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.319679]  [<ffffffff81584555>] ? device_not_available+0x15/0x20
> [  236.319684]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319686] su              S ffff88020e46eda0     0   374    354 0x00000000
> [  236.319691]  ffff88020e46eae0 0000000000000082 0000000000011a80 ffff8801fd599fd8
> [  236.319695]  0000000000011a80 ffff8801fd599fd8 ffff88020e46ead0 ffff8801fd599f08
> [  236.319700]  ffff88020e46eae0 ffff88020e46eae0 ffff88020e46eae0 ffff88020e46ecd8
> [  236.319704] Call Trace:
> [  236.319710]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.319716]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.319721]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.319727]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319729] su              S ffff880200b482c0     0   375    356 0x00000000
> [  236.319733]  ffff880200b48000 0000000000000082 0000000000011a80 ffff8801fd59bfd8
> [  236.319738]  0000000000011a80 ffff8801fd59bfd8 ffff880200b47ff0 ffff8801fd59bf08
> [  236.319742]  ffff880200b48000 ffff880200b48000 ffff880200b48000 ffff880200b481f8
> [  236.319747] Call Trace:
> [  236.319753]  [<ffffffff81064f53>] ? do_wait+0x213/0x240
> [  236.319758]  [<ffffffff81065d24>] ? SyS_wait4+0x64/0xe0
> [  236.319764]  [<ffffffff81064060>] ? task_stopped_code+0x60/0x60
> [  236.319769]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319771] zsh             S ffff8801fd5aac50     0   388    374 0x00000000
> [  236.319776]  ffff8801fd5aa990 0000000000000082 0000000000011a80 ffff88020719ffd8
> [  236.319780]  0000000000011a80 ffff88020719ffd8 ffff880200ed7700 ffff88020719fde8
> [  236.319785]  7fffffffffffffff ffff880209642900 7fffffffffffffff ffff880208211800
> [  236.319789] Call Trace:
> [  236.319796]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.319802]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.319807]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.319813]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.319817]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.319822]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.319827]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.319831]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.319835]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.319841]  [<ffffffff81584555>] ? device_not_available+0x15/0x20
> [  236.319846]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319848] zsh             S ffff8801fd5ab240     0   389    375 0x00000000
> [  236.319853]  ffff8801fd5aaf80 0000000000000082 0000000000011a80 ffff880200f2dfd8
> [  236.319857]  0000000000011a80 ffff880200f2dfd8 ffff8802071e7d00 ffff880200f2dde8
> [  236.319862]  7fffffffffffffff ffff880210c5fc80 7fffffffffffffff ffff880208210800
> [  236.319866] Call Trace:
> [  236.319873]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.319879]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.319884]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.319890]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.319894]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.319898]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.319904]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.319908]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.319912]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.319916]  [<ffffffff8158306f>] ? page_fault+0x1f/0x30
> [  236.319921]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.319924] kio_http        S ffff880200b488b0     0   398    286 0x00000000
> [  236.319928]  ffff880200b485f0 0000000000000086 0000000000011a80 ffff8802073a9fd8
> [  236.319933]  0000000000011a80 ffff8802073a9fd8 0000000000000000 ffff8802073a9da0
> [  236.319937]  0000000000000040 0000000000000080 0000000000000007 0000000000000007
> [  236.319941] Call Trace:
> [  236.319946]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.319951]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.319957]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.319962]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.319967]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.319972]  [<ffffffff8106d6b3>] ? mod_timer_pending+0xb3/0x100
> [  236.319978]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.319984]  [<ffffffff8123e0c4>] ? swiotlb_map_page+0x64/0x140
> [  236.319990]  [<ffffffff813f8137>] ? atl1e_xmit_frame+0x837/0xae0
> [  236.319996]  [<ffffffff81550042>] ? igmp_mc_seq_show+0xc2/0xe0
> [  236.320002]  [<ffffffff810ff959>] ? lookup_fast+0x39/0x2c0
> [  236.320008]  [<ffffffff810ffe2c>] ? generic_permission+0xcc/0xe0
> [  236.320014]  [<ffffffff811008f4>] ? link_path_walk+0x74/0x8c0
> [  236.320020]  [<ffffffff810ff959>] ? lookup_fast+0x39/0x2c0
> [  236.320026]  [<ffffffff810ff708>] ? complete_walk+0x68/0xe0
> [  236.320032]  [<ffffffff811011ab>] ? path_lookupat+0x6b/0x7a0
> [  236.320038]  [<ffffffff81521cb4>] ? ip_queue_xmit+0x134/0x360
> [  236.320043]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.320049]  [<ffffffff810fa7b1>] ? cp_new_stat+0x111/0x140
> [  236.320054]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.320060]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320062] sudo            S ffff88020e4682c0     0   400    358 0x00000000
> [  236.320067]  ffff88020e468000 0000000000000082 0000000000011a80 ffff8801fd4cffd8
> [  236.320071]  0000000000011a80 ffff8801fd4cffd8 0000000000000000 ffff8801fd4cfda0
> [  236.320076]  0000000000000040 0000000000000040 0000000000000006 0000000000000006
> [  236.320080] Call Trace:
> [  236.320085]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.320091]  [<ffffffff81565957>] ? unix_dgram_poll+0x37/0x1e0
> [  236.320096]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.320101]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.320107]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320112]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320118]  [<ffffffff810c0f23>] ? __alloc_pages_nodemask+0xe3/0x820
> [  236.320123]  [<ffffffff810d7e6b>] ? copy_pte_range+0x28b/0x4c0
> [  236.320129]  [<ffffffff810c4cca>] ? release_pages+0x18a/0x1c0
> [  236.320135]  [<ffffffff810c4dcd>] ? pagevec_lru_move_fn+0xcd/0x100
> [  236.320142]  [<ffffffff810c4180>] ? compound_unlock_irqrestore+0x20/0x20
> [  236.320147]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.320153]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.320159]  [<ffffffff8108702d>] ? check_preempt_curr+0x6d/0xa0
> [  236.320164]  [<ffffffff81088f01>] ? wake_up_new_task+0xc1/0x120
> [  236.320169]  [<ffffffff8105fbbd>] ? do_fork+0xdd/0x280
> [  236.320174]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.320179]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320181] multitail       S ffff880200b49a80     0   401    400 0x00000000
> [  236.320186]  ffff880200b497c0 0000000000000086 0000000000011a80 ffff8801fdbc9fd8
> [  236.320190]  0000000000011a80 ffff8801fdbc9fd8 ffff8801fdbc9af8 00000000004c4b2b
> [  236.320195]  0000000000000000 0000000000000040 0000000000000006 0000000000000006
> [  236.320199] Call Trace:
> [  236.320204]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.320210]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.320215]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.320220]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.320226]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320231]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320237]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320242]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320247]  [<ffffffff8110b212>] ? __d_lookup+0x72/0x140
> [  236.320253]  [<ffffffff810ffaa7>] ? lookup_fast+0x187/0x2c0
> [  236.320258]  [<ffffffff81109eff>] ? dput+0x3f/0x2e0
> [  236.320263]  [<ffffffff81109eff>] ? dput+0x3f/0x2e0
> [  236.320268]  [<ffffffff81111c97>] ? mntput_no_expire+0x17/0x140
> [  236.320274]  [<ffffffff81100af2>] ? link_path_walk+0x272/0x8c0
> [  236.320279]  [<ffffffff8110b212>] ? __d_lookup+0x72/0x140
> [  236.320284]  [<ffffffff810ffaa7>] ? lookup_fast+0x187/0x2c0
> [  236.320289]  [<ffffffff81109eff>] ? dput+0x3f/0x2e0
> [  236.320294]  [<ffffffff81111c97>] ? mntput_no_expire+0x17/0x140
> [  236.320300]  [<ffffffff81101207>] ? path_lookupat+0xc7/0x7a0
> [  236.320305]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.320311]  [<ffffffff810fa7b1>] ? cp_new_stat+0x111/0x140
> [  236.320317]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.320321]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.320327]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320329] tail            S ffff880200b4a070     0   402    401 0x00000000
> [  236.320334]  ffff880200b49db0 0000000000000082 0000000000011a80 ffff8802073c5fd8
> [  236.320338]  0000000000011a80 ffff8802073c5fd8 ffff880200ba1600 0000000000a281c0
> [  236.320343]  0000000000a281c0 0000000000000022 0000000000a28090 0000000000000001
> [  236.320347] Call Trace:
> [  236.320353]  [<ffffffff81130665>] ? inotify_read+0x285/0x340
> [  236.320359]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.320363]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.320367]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.320372]  [<ffffffff81584555>] ? device_not_available+0x15/0x20
> [  236.320378]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320380] tail            S ffff880200b4a660     0   403    401 0x00000000
> [  236.320384]  ffff880200b4a3a0 0000000000000082 0000000000011a80 ffff8801fdac9fd8
> [  236.320389]  0000000000011a80 ffff8801fdac9fd8 ffff8801fd8a0200 0000000001b621c0
> [  236.320393]  0000000001b621c0 0000000000000022 0000000001b620a0 0000000000000002
> [  236.320398] Call Trace:
> [  236.320404]  [<ffffffff81130665>] ? inotify_read+0x285/0x340
> [  236.320409]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.320413]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.320417]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.320422]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320425] firefox         S ffff88020e46e7b0     0   417    290 0x00000000
> [  236.320429]  ffff88020e46e4f0 0000000000000086 0000000000011a80 ffff880200bb1fd8
> [  236.320433]  0000000000011a80 ffff880200bb1fd8 0000000000000000 ffff880200bb1f48
> [  236.320438]  0000000000000000 0000000000000000 0000000000000000 ffff880200bb1bf4
> [  236.320442] Call Trace:
> [  236.320447]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.320452]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.320458]  [<ffffffff81563222>] ? unix_poll+0x22/0xc0
> [  236.320463]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.320468]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.320474]  [<ffffffff81087ebc>] ? __wake_up_sync_key+0x3c/0x60
> [  236.320480]  [<ffffffff815631e8>] ? unix_destruct_scm+0x68/0x80
> [  236.320484]  [<ffffffff8157fdc9>] ? mutex_lock_interruptible+0x9/0x40
> [  236.320490]  [<ffffffff81563b47>] ? unix_stream_recvmsg+0x667/0x700
> [  236.320496]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320501]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320506]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320511]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320516]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320521]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320526]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320533]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.320537]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.320543]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320545] Gecko_IOThread  S ffff880200baa070     0   420    290 0x00000000
> [  236.320550]  ffff880200ba9db0 0000000000000086 0000000000011a80 ffff8801fdadffd8
> [  236.320554]  0000000000011a80 ffff8801fdadffd8 0000000000000000 ffff8801fdadff38
> [  236.320559]  0000000000000000 ffff880200879960 ffff880200ba9db0 0000000000000000
> [  236.320563] Call Trace:
> [  236.320568]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.320574]  [<ffffffff81131933>] ? ep_scan_ready_list.isra.19+0x173/0x180
> [  236.320580]  [<ffffffff81131bb2>] ? ep_poll+0x252/0x340
> [  236.320584]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.320591]  [<ffffffff81132a8c>] ? SyS_epoll_wait+0xcc/0x100
> [  236.320596]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320599] Socket Thread   S ffff880200b4c410     0   422    290 0x00000000
> [  236.320603]  ffff880200b4c150 0000000000000086 0000000000011a80 ffff880200f8bfd8
> [  236.320607]  0000000000011a80 ffff880200f8bfd8 0000000000000000 ffff880200f8bf48
> [  236.320612]  0000000000000000 0000000000000000 0000000000000000 ffff880200f8bbc4
> [  236.320616] Call Trace:
> [  236.320621]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.320626]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.320631]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.320638]  [<ffffffff810a1066>] ? generic_exec_single+0x86/0xa0
> [  236.320643]  [<ffffffff8105d360>] ? leave_mm+0x60/0x60
> [  236.320648]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.320654]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.320659]  [<ffffffff810d89a7>] ? handle_pte_fault+0x87/0x7c0
> [  236.320665]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.320669]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.320674]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.320680]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320682] JS GC Helper    S ffff88020e46be20     0   423    290 0x00000000
> [  236.320686]  ffff88020e46bb60 0000000000000086 0000000000011a80 ffff880200f8dfd8
> [  236.320691]  0000000000011a80 ffff880200f8dfd8 ffff880200f8dda0 0000000000000000
> [  236.320695]  ffffffff81b96b00 ffff88020e46bb60 ffff880200f8ddb8 ffff88020e46bb60
> [  236.320700] Call Trace:
> [  236.320706]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.320712]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.320718]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.320725]  [<ffffffff8121deab>] ? blk_finish_plug+0xb/0x40
> [  236.320731]  [<ffffffff810d56ad>] ? SyS_madvise+0x4ed/0x660
> [  236.320736]  [<ffffffff8108b988>] ? __dequeue_entity+0x28/0x40
> [  236.320742]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.320746]  [<ffffffff815809c3>] ? __schedule+0x263/0x660
> [  236.320752]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320754] JS Sour~ Thread S ffff88020e46e1c0     0   424    290 0x00000000
> [  236.320759]  ffff88020e46df00 0000000000000086 0000000000011a80 ffff880200f8ffd8
> [  236.320763]  0000000000011a80 ffff880200f8ffd8 ffff880200f8fda0 0000000000000000
> [  236.320768]  ffffffff81b97868 ffff88020e46df00 ffff880200f8fdb8 ffff88020e46df00
> [  236.320772] Call Trace:
> [  236.320778]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.320784]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.320790]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.320796]  [<ffffffff8121deab>] ? blk_finish_plug+0xb/0x40
> [  236.320802]  [<ffffffff810d56ad>] ? SyS_madvise+0x4ed/0x660
> [  236.320808]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.320813]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320816] JS Watchdog     S ffff88020e46d5e0     0   425    290 0x00000000
> [  236.320820]  ffff88020e46d320 0000000000000086 0000000000011a80 ffff880200f85fd8
> [  236.320824]  0000000000011a80 ffff880200f85fd8 ffff880200f85da0 ffff880200f85d58
> [  236.320829]  ffffffff81b97a78 ffff88020e46d320 ffff880200f85db8 ffff88020e46d320
> [  236.320833] Call Trace:
> [  236.320839]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.320845]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.320851]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.320858]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.320863]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.320868]  [<ffffffff810aed40>] ? perf_event_task_match+0x20/0x20
> [  236.320874]  [<ffffffff810b2100>] ? perf_event_mmap_output+0x180/0x180
> [  236.320879]  [<ffffffff810aecde>] ? perf_event_aux+0x9e/0xe0
> [  236.320885]  [<ffffffff810b59ba>] ? perf_event_comm+0x1da/0x200
> [  236.320891]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.320896]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320899] Hang Monitor    S ffff880200b4ca00     0   426    290 0x00000000
> [  236.320903]  ffff880200b4c740 0000000000000086 0000000000011a80 ffff8801fdb97fd8
> [  236.320908]  0000000000011a80 ffff8801fdb97fd8 ffff8801fdb97da0 0000000000000000
> [  236.320912]  ffffffff81b97b80 ffff880200b4c740 ffff8801fdb97db8 ffff880200b4c740
> [  236.320917] Call Trace:
> [  236.320923]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.320929]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.320935]  [<ffffffff810b8205>] ? perf_output_end+0x5/0x20
> [  236.320940]  [<ffffffff810b222c>] ? perf_event_comm_output+0x12c/0x180
> [  236.320947]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.320951]  [<ffffffff810aec1b>] ? perf_event_aux_ctx+0x7b/0xa0
> [  236.320956]  [<ffffffff810aed40>] ? perf_event_task_match+0x20/0x20
> [  236.320961]  [<ffffffff810b2100>] ? perf_event_mmap_output+0x180/0x180
> [  236.320965]  [<ffffffff810aecde>] ? perf_event_aux+0x9e/0xe0
> [  236.320971]  [<ffffffff810b59ba>] ? perf_event_comm+0x1da/0x200
> [  236.320977]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.320982]  [<ffffffff81074c8d>] ? SyS_prctl+0xcd/0x380
> [  236.320987]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.320990] Timer           S ffff880200b4d5e0     0   434    290 0x00000000
> [  236.320994]  ffff880200b4d320 0000000000000086 0000000000011a80 ffff880200af5fd8
> [  236.320998]  0000000000011a80 ffff880200af5fd8 ffff880200af5da0 ffff880200af5d58
> [  236.321003]  ffffffff81b96ab8 ffff880200b4d320 ffff880200af5db8 ffff880200b4d320
> [  236.321008] Call Trace:
> [  236.321014]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321019]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321026]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.321032]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321036]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.321041]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.321048]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321053]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321056] mozStorage #1   S ffff880200bab240     0   435    290 0x00000000
> [  236.321060]  ffff880200baaf80 0000000000000086 0000000000011a80 ffff880200af7fd8
> [  236.321065]  0000000000011a80 ffff880200af7fd8 ffff880200af7da0 0000000000000000
> [  236.321069]  ffffffff81b96e48 ffff880200baaf80 ffff880200af7db8 ffff880200baaf80
> [  236.321074] Call Trace:
> [  236.321080]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321085]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321092]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321098]  [<ffffffff810f5d87>] ? do_sync_read+0x67/0xa0
> [  236.321104]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321108]  [<ffffffff810f6bf4>] ? SyS_read+0x74/0xa0
> [  236.321114]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321116] DOM Worker      S ffff880200b4cff0     0   436    290 0x00000000
> [  236.321120]  ffff880200b4cd30 0000000000000086 0000000000011a80 ffff880200af9fd8
> [  236.321125]  0000000000011a80 ffff880200af9fd8 ffff880200af9da0 0000000000000000
> [  236.321130]  ffffffff81b96c20 ffff880200b4cd30 ffff880200af9db8 ffff880200b4cd30
> [  236.321134] Call Trace:
> [  236.321140]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321146]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321151]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.321157]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321162]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.321168]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321172]  [<ffffffff810f6c94>] ? SyS_write+0x74/0xa0
> [  236.321177]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321180] DOM Worker      S ffff880200b4e1c0     0   437    290 0x00000000
> [  236.321184]  ffff880200b4df00 0000000000000086 0000000000011a80 ffff880200e0bfd8
> [  236.321189]  0000000000011a80 ffff880200e0bfd8 ffff880200e0bda0 0000000000000000
> [  236.321193]  ffffffff81b97508 ffff880200b4df00 ffff880200e0bdb8 ffff880200b4df00
> [  236.321198] Call Trace:
> [  236.321204]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321209]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321215]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.321221]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321227]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321232]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321235] Cache I/O       S ffff880200b4e7b0     0   438    290 0x00000000
> [  236.321239]  ffff880200b4e4f0 0000000000000086 0000000000011a80 ffff880200e0dfd8
> [  236.321243]  0000000000011a80 ffff880200e0dfd8 ffff880200e0dda0 0000000000000000
> [  236.321248]  ffffffff81b970d0 ffff880200b4e4f0 ffff880200e0ddb8 ffff880200b4e4f0
> [  236.321253] Call Trace:
> [  236.321259]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321264]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321270]  [<ffffffff810b8205>] ? perf_output_end+0x5/0x20
> [  236.321276]  [<ffffffff810b222c>] ? perf_event_comm_output+0x12c/0x180
> [  236.321282]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321287]  [<ffffffff810aec1b>] ? perf_event_aux_ctx+0x7b/0xa0
> [  236.321291]  [<ffffffff810aed40>] ? perf_event_task_match+0x20/0x20
> [  236.321297]  [<ffffffff810b2100>] ? perf_event_mmap_output+0x180/0x180
> [  236.321301]  [<ffffffff810aecde>] ? perf_event_aux+0x9e/0xe0
> [  236.321307]  [<ffffffff810b59ba>] ? perf_event_comm+0x1da/0x200
> [  236.321313]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321317]  [<ffffffff81074c8d>] ? SyS_prctl+0xcd/0x380
> [  236.321323]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321326] Cert Verify     S ffff880200b4eda0     0   439    290 0x00000000
> [  236.321330]  ffff880200b4eae0 0000000000000086 0000000000011a80 ffff880200a6ffd8
> [  236.321334]  0000000000011a80 ffff880200a6ffd8 ffff880200a6fda0 0000000000000000
> [  236.321339]  ffffffff81b96b60 ffff880200b4eae0 ffff880200a6fdb8 ffff880200b4eae0
> [  236.321343] Call Trace:
> [  236.321349]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321355]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321361]  [<ffffffff810d603a>] ? __do_fault+0x39a/0x480
> [  236.321368]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321373]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.321378]  [<ffffffff810aed40>] ? perf_event_task_match+0x20/0x20
> [  236.321383]  [<ffffffff810b2100>] ? perf_event_mmap_output+0x180/0x180
> [  236.321388]  [<ffffffff810aecde>] ? perf_event_aux+0x9e/0xe0
> [  236.321394]  [<ffffffff810b59ba>] ? perf_event_comm+0x1da/0x200
> [  236.321399]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321405]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321407] HTML5 Parser    S ffff880200b4f390     0   440    290 0x00000000
> [  236.321412]  ffff880200b4f0d0 0000000000000086 0000000000011a80 ffff880200881fd8
> [  236.321416]  0000000000011a80 ffff880200881fd8 ffff880200881da0 0000000000000000
> [  236.321421]  ffffffff81b974c0 ffff880200b4f0d0 ffff880200881db8 ffff880200b4f0d0
> [  236.321425] Call Trace:
> [  236.321431]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321437]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321442]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.321448]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321455]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321460]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321462] mozStorage #2   S ffff880200b4b240     0   445    290 0x00000000
> [  236.321467]  ffff880200b4af80 0000000000000086 0000000000011a80 ffff8801fd56bfd8
> [  236.321471]  0000000000011a80 ffff8801fd56bfd8 ffff8801fd56bda0 0000000000000000
> [  236.321476]  ffffffff81b96c08 ffff880200b4af80 ffff8801fd56bdb8 ffff880200b4af80
> [  236.321480] Call Trace:
> [  236.321486]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321492]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321498]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321505]  [<ffffffff810f5d87>] ? do_sync_read+0x67/0xa0
> [  236.321511]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321515]  [<ffffffff810f6bf4>] ? SyS_read+0x74/0xa0
> [  236.321520]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321522] gdbus           S ffff880200b4ac50     0   450    290 0x00000000
> [  236.321527]  ffff880200b4a990 0000000000000086 0000000000011a80 ffff8801fd663fd8
> [  236.321531]  0000000000011a80 ffff8801fd663fd8 0000000000000000 ffff8801fd663f48
> [  236.321536]  0000000000000000 0000000000000000 0000000000000000 ffff8801fd663bc4
> [  236.321540] Call Trace:
> [  236.321545]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.321550]  [<ffffffff8107e5d0>] ? add_wait_queue+0x10/0x40
> [  236.321555]  [<ffffffff8107e64d>] ? remove_wait_queue+0xd/0x60
> [  236.321560]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.321565]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.321571]  [<ffffffff815639e7>] ? unix_stream_recvmsg+0x507/0x700
> [  236.321577]  [<ffffffff81082d31>] ? atomic_notifier_call_chain+0x11/0x20
> [  236.321582]  [<ffffffff8108721b>] ? set_task_cpu+0x5b/0xe0
> [  236.321588]  [<ffffffff814d09f6>] ? sock_recvmsg+0x76/0xa0
> [  236.321594]  [<ffffffff8122be6d>] ? cpumask_next_and+0x2d/0x40
> [  236.321599]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.321605]  [<ffffffff8108706d>] ? ttwu_do_wakeup+0xd/0xa0
> [  236.321609]  [<ffffffff81088d3b>] ? try_to_wake_up+0x1bb/0x240
> [  236.321615]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.321621]  [<ffffffff81131d8b>] ? ep_poll_callback+0xeb/0x120
> [  236.321627]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.321632]  [<ffffffff81118f0a>] ? __inode_wait_for_writeback+0x6a/0xc0
> [  236.321638]  [<ffffffff8107e900>] ? autoremove_wake_function+0x40/0x40
> [  236.321644]  [<ffffffff8112e7e2>] ? fsnotify_clear_marks_by_inode+0x22/0x100
> [  236.321649]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.321654]  [<ffffffff810ee3b7>] ? kmem_cache_free+0xd7/0x100
> [  236.321659]  [<ffffffff810f67a4>] ? vfs_read+0x104/0x160
> [  236.321664]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.321669]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321672] localStorage DB S ffff88020e46f980     0   453    290 0x00000000
> [  236.321676]  ffff88020e46f6c0 0000000000000086 0000000000011a80 ffff8801fd935fd8
> [  236.321681]  0000000000011a80 ffff8801fd935fd8 ffff8801fd935da0 0000000000000000
> [  236.321685]  ffffffff81b966e0 ffff88020e46f6c0 ffff8801fd935db8 ffff88020e46f6c0
> [  236.321690] Call Trace:
> [  236.321696]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321701]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321708]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321713]  [<ffffffff81137915>] ? __posix_lock_file+0x335/0x560
> [  236.321718]  [<ffffffff81138dd2>] ? fcntl_setlk+0x52/0x2a0
> [  236.321724]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321729]  [<ffffffff81105811>] ? SyS_fcntl+0x131/0x4e0
> [  236.321735]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321737] mozStorage #3   S ffff8801fd5a9a80     0   456    290 0x00000000
> [  236.321741]  ffff8801fd5a97c0 0000000000000086 0000000000011a80 ffff8801f7541fd8
> [  236.321746]  0000000000011a80 ffff8801f7541fd8 ffff8801f7541da0 0000000000000000
> [  236.321750]  ffffffff81b96518 ffff8801fd5a97c0 ffff8801f7541db8 ffff8801fd5a97c0
> [  236.321755] Call Trace:
> [  236.321761]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321767]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321773]  [<ffffffff810668ad>] ? current_fs_time+0xd/0x60
> [  236.321779]  [<ffffffff8110e891>] ? file_update_time+0x31/0xc0
> [  236.321785]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321789]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.321795]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.321801]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321805]  [<ffffffff810f6c94>] ? SyS_write+0x74/0xa0
> [  236.321810]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321813] mozStorage #4   S ffff8802168eb830     0   457    290 0x00000000
> [  236.321817]  ffff8802168eb570 0000000000000086 0000000000011a80 ffff8801f751dfd8
> [  236.321822]  0000000000011a80 ffff8801f751dfd8 ffff8801f751dda0 0000000000000000
> [  236.321826]  ffffffff81b96bc0 ffff8802168eb570 ffff8801f751ddb8 ffff8802168eb570
> [  236.321831] Call Trace:
> [  236.321837]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321843]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321848]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.321854]  [<ffffffff810668ad>] ? current_fs_time+0xd/0x60
> [  236.321860]  [<ffffffff8110e891>] ? file_update_time+0x31/0xc0
> [  236.321866]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321871]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.321876]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.321882]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321886]  [<ffffffff810f6c94>] ? SyS_write+0x74/0xa0
> [  236.321892]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321894] DOM Worker      S ffff8801fd5ae7b0     0   519    290 0x00000000
> [  236.321899]  ffff8801fd5ae4f0 0000000000000086 0000000000011a80 ffff880200913fd8
> [  236.321903]  0000000000011a80 ffff880200913fd8 ffff880200913da0 0000000000000000
> [  236.321908]  ffffffff81b96710 ffff8801fd5ae4f0 ffff880200913db8 ffff8801fd5ae4f0
> [  236.321912] Call Trace:
> [  236.321918]  [<ffffffff8109d5b7>] ? futex_wait_queue_me+0xb7/0xe0
> [  236.321924]  [<ffffffff8109dd0a>] ? futex_wait+0x14a/0x240
> [  236.321929]  [<ffffffff8108d6b9>] ? enqueue_task_fair+0x2f9/0xa60
> [  236.321935]  [<ffffffff8109f722>] ? do_futex+0xe2/0xca0
> [  236.321939]  [<ffffffff810f6867>] ? do_sync_write+0x67/0xa0
> [  236.321946]  [<ffffffff810a0348>] ? SyS_futex+0x68/0x160
> [  236.321950]  [<ffffffff810f6c94>] ? SyS_write+0x74/0xa0
> [  236.321955]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.321958] gconfd-2        S ffff880200b4dbd0     0   452      1 0x00000000
> [  236.321962]  ffff880200b4d910 0000000000000086 0000000000011a80 ffff8801fd66bfd8
> [  236.321967]  0000000000011a80 ffff8801fd66bfd8 ffff8801fd66bba8 0000000001c94e4e
> [  236.321971]  0000000000000000 0000000000000000 0000000000000000 ffff8801fd66bbec
> [  236.321975] Call Trace:
> [  236.321980]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.321987]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.321992]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.321997]  [<ffffffff81108767>] ? do_sys_poll+0x4a7/0x560
> [  236.322004]  [<ffffffff811f5e40>] ? xfs_trans_add_item+0x20/0x60
> [  236.322009]  [<ffffffff811fdd7b>] ? _xfs_trans_bjoin+0x3b/0x60
> [  236.322014]  [<ffffffff811fe0de>] ? xfs_trans_read_buf_map+0x1de/0x2c0
> [  236.322021]  [<ffffffff811f2f75>] ? xfs_icsb_modify_counters+0x95/0x180
> [  236.322026]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322032]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322037]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322042]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322048]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322053]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322058]  [<ffffffff81109eff>] ? dput+0x3f/0x2e0
> [  236.322063]  [<ffffffff81111c97>] ? mntput_no_expire+0x17/0x140
> [  236.322068]  [<ffffffff8110413a>] ? do_unlinkat+0xba/0x220
> [  236.322074]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.322079]  [<ffffffff811088d8>] ? SyS_poll+0x58/0xe0
> [  236.322084]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.322086] mc              S ffff88020e46a660     0   477    369 0x00000000
> [  236.322091]  ffff88020e46a3a0 0000000000000086 0000000000011a80 ffff8801f741bfd8
> [  236.322095]  0000000000011a80 ffff8801f741bfd8 0000000000000000 ffff8801f741bda0
> [  236.322100]  0000000000000040 0000000000000040 0000000000000006 0000000000000006
> [  236.322104] Call Trace:
> [  236.322109]  [<ffffffff815803a5>] ? schedule_hrtimeout_range_clock+0x125/0x140
> [  236.322113]  [<ffffffff812a1847>] ? n_tty_poll+0x1a7/0x1c0
> [  236.322119]  [<ffffffff812a4c73>] ? tty_ldisc_deref+0x33/0xc0
> [  236.322124]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.322128]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.322133]  [<ffffffff811e90ef>] ? xfs_iext_bno_to_ext+0x8f/0x180
> [  236.322139]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322144]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322149]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322154]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322160]  [<ffffffff8108fb33>] ? load_balance+0xd3/0x6a0
> [  236.322165]  [<ffffffff8108dfb6>] ? check_preempt_wakeup+0x196/0x240
> [  236.322171]  [<ffffffff8108703d>] ? check_preempt_curr+0x7d/0xa0
> [  236.322176]  [<ffffffff8108706d>] ? ttwu_do_wakeup+0xd/0xa0
> [  236.322181]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.322188]  [<ffffffff810585e1>] ? __do_page_fault+0x181/0x440
> [  236.322193]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.322198]  [<ffffffff81087e11>] ? __wake_up+0x31/0x60
> [  236.322204]  [<ffffffff81071c7e>] ? do_sigaction+0x7e/0x1e0
> [  236.322209]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.322215]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.322218] zsh             S ffff8801fd5abe20     0   480    477 0x00000000
> [  236.322222]  ffff8801fd5abb60 0000000000000086 0000000000011a80 ffff8801f76bffd8
> [  236.322227]  0000000000011a80 ffff8801f76bffd8 ffff880200ec6100 ffff8801f76bfde8
> [  236.322231]  7fffffffffffffff ffff8801f7742900 7fffffffffffffff ffff8801fdb23000
> [  236.322236] Call Trace:
> [  236.322242]  [<ffffffff8157f0a5>] ? schedule_timeout+0x165/0x1c0
> [  236.322246]  [<ffffffff810d77cb>] ? do_wp_page+0x36b/0x780
> [  236.322252]  [<ffffffff810787bb>] ? flush_work+0xfb/0x140
> [  236.322257]  [<ffffffff8108596f>] ? __wake_up_common+0x4f/0x80
> [  236.322263]  [<ffffffff8129f6fa>] ? set_room+0x5a/0xc0
> [  236.322267]  [<ffffffff812a0998>] ? n_tty_read+0x278/0x8a0
> [  236.322272]  [<ffffffff81088e20>] ? wake_up_state+0x20/0x20
> [  236.322277]  [<ffffffff8129be6c>] ? tty_read+0x6c/0xe0
> [  236.322281]  [<ffffffff810f672e>] ? vfs_read+0x8e/0x160
> [  236.322285]  [<ffffffff810f6bc3>] ? SyS_read+0x43/0xa0
> [  236.322290]  [<ffffffff8158306f>] ? page_fault+0x1f/0x30
> [  236.322295]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.322297] qemu-system-x86 S ffff8801f74d9a80     0   600    367 0x00000000
> [  236.322302]  ffff8801f74d97c0 0000000000200086 0000000000011a80 ffff8801dff77fd8
> [  236.322306]  0000000000011a80 ffff8801dff77fd8 ffff8801dff77af8 00000000000f423f
> [  236.322310]  0000000000000000 0000000000008000 000000000000000f 000000000000000f
> [  236.322315] Call Trace:
> [  236.322320]  [<ffffffff8158037d>] ? schedule_hrtimeout_range_clock+0xfd/0x140
> [  236.322326]  [<ffffffff81080ca0>] ? __hrtimer_init+0x100/0x100
> [  236.322331]  [<ffffffff811074db>] ? poll_schedule_timeout+0x3b/0x60
> [  236.322336]  [<ffffffff81107c29>] ? do_select+0x6a9/0x780
> [  236.322342]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322347]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322352]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322357]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322362]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322368]  [<ffffffff81107220>] ? poll_select_copy_remaining+0x120/0x120
> [  236.322374]  [<ffffffff814d09f6>] ? sock_recvmsg+0x76/0xa0
> [  236.322379]  [<ffffffff81107e80>] ? core_sys_select+0x180/0x2a0
> [  236.322385]  [<ffffffff81093d79>] ? ktime_get+0x39/0xc0
> [  236.322390]  [<ffffffff812326d8>] ? timerqueue_add+0x58/0xa0
> [  236.322396]  [<ffffffff8108122b>] ? __hrtimer_start_range_ns+0x1eb/0x360
> [  236.322401]  [<ffffffff8123273e>] ? timerqueue_del+0x1e/0x60
> [  236.322406]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.322411]  [<ffffffff81134875>] ? eventfd_ctx_read+0x55/0x200
> [  236.322416]  [<ffffffff81093e3d>] ? ktime_get_ts+0x3d/0xe0
> [  236.322421]  [<ffffffff81108043>] ? SyS_select+0xa3/0x100
> [  236.322427]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.322429] qemu-system-x86 S ffffffff81011ddb     0   602    367 0x00000000
> [  236.322434]  ffff880200baa3a0 0000000000000086 0000000000011a80 ffff8801dff69fd8
> [  236.322438]  0000000000011a80 ffff8801dff69fd8 ffff8801df8b0000 ffff8801df8b0080
> [  236.322443]  ffff880200baa3a0 ffff8801df8b0000 0000000000000000 ffff8801df8b2050
> [  236.322447] Call Trace:
> [  236.322452]  [<ffffffff81004b06>] ? kvm_vcpu_block+0x66/0xa0
> [  236.322457]  [<ffffffff8107e8c0>] ? abort_exclusive_wait+0xa0/0xa0
> [  236.322464]  [<ffffffff8100fdb5>] ? kvm_arch_vcpu_ioctl_run+0x115/0x10c0
> [  236.322469]  [<ffffffff810067c0>] ? kvm_set_ioapic_irq+0x20/0x20
> [  236.322474]  [<ffffffff81088d3b>] ? try_to_wake_up+0x1bb/0x240
> [  236.322480]  [<ffffffff8100d10a>] ? kvm_arch_vcpu_load+0x4a/0x1e0
> [  236.322486]  [<ffffffff810022b1>] ? kvm_vcpu_ioctl+0x271/0x500
> [  236.322492]  [<ffffffff81003b6d>] ? kvm_vm_ioctl+0x54d/0x5a0
> [  236.322497]  [<ffffffff8112daae>] ? fsnotify+0x24e/0x340
> [  236.322502]  [<ffffffff811067ec>] ? do_vfs_ioctl+0x2cc/0x4a0
> [  236.322506]  [<ffffffff810f6ae4>] ? vfs_write+0x124/0x1c0
> [  236.322511]  [<ffffffff811069fc>] ? SyS_ioctl+0x3c/0x80
> [  236.322516]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.322519] qemu-system-x86 R  running task        0   603    367 0x00000000
> [  236.322523]  0000000000000000 0000000100000000 00007fff27e6b950 00000000000fee00
> [  236.322528]  ffff8801df8b3b90 00000000fee000b0 ffff8801dff0b0d1 0000000000000000
> [  236.322533]  ffff8801df8b3b90 ffff8801f7614040 0000000000000000 0000000000000000
> [  236.322537] Call Trace:
> [  236.322544]  [<ffffffff8102aea0>] ? nested_svm_get_tdp_cr3+0x20/0x20
> [  236.322551]  [<ffffffff810100b5>] ? kvm_arch_vcpu_ioctl_run+0x415/0x10c0
> [  236.322556]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.322561]  [<ffffffff810d8fbb>] ? handle_pte_fault+0x69b/0x7c0
> [  236.322567]  [<ffffffff8100d10a>] ? kvm_arch_vcpu_load+0x4a/0x1e0
> [  236.322573]  [<ffffffff810022b1>] ? kvm_vcpu_ioctl+0x271/0x500
> [  236.322578]  [<ffffffff811067ec>] ? do_vfs_ioctl+0x2cc/0x4a0
> [  236.322583]  [<ffffffff811069fc>] ? SyS_ioctl+0x3c/0x80
> [  236.322588]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b
> [  236.322590] kvm-pit/600     S ffff8801f7453240     0   604      2 0x00000000
> [  236.322595]  ffff8801f7452f80 0000000000000046 0000000000011a80 ffff8801f783ffd8
> [  236.322599]  0000000000011a80 ffff8801f783ffd8 ffff88021509d150 ffff8801f7452f80
> [  236.322604]  ffff8801f7452f80 ffff88021509d158 ffff8801f7452f80 0000000000000000
> [  236.322608] Call Trace:
> [  236.322614]  [<ffffffff8107e325>] ? kthread_worker_fn+0xc5/0x120
> [  236.322618]  [<ffffffff8107e260>] ? __init_kthread_worker+0x20/0x20
> [  236.322623]  [<ffffffff8107dccf>] ? kthread+0xaf/0xc0
> [  236.322627]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> [  236.322632]  [<ffffffff815834ec>] ? ret_from_fork+0x7c/0xb0
> [  236.322637]  [<ffffffff8107dc20>] ? __kthread_parkme+0x80/0x80
> -- 
> Markus

