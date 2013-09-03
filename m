Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab3ICNt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:49:26 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58249 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3ICNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <CACT4Y+artcxiies1q3XP3+yCh+QzPZQ96dDttpdYXoQ+w2xosQ@mail.gmail.com>
References: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
 <CACT4Y+artcxiies1q3XP3+yCh+QzPZQ96dDttpdYXoQ+w2xosQ@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 3 Sep 2013 17:49:03 +0400
Message-ID: <CACT4Y+YobKoy9Yp5b6eM21oQrt+bj74qW6uM_DYPkeL-TVA3dQ@mail.gmail.com>
Subject: Re: Potential use-after-free in ____call_usermodehelper
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Alexander Potapenko <glider@google.com>,
        Evgeniy Stepanov <eugenis@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is anybody reading this? Is it a correct place to post such things?
Maybe there is a more appropriate place?

I am hitting basically thousands of this use-after-free bug.
Here is a more detailed report with line numbers:

[  107.292348] ERROR: AddressSanitizer: heap-use-after-free on address
ffff8800320f7b84
[  107.293494] ffff8800320f7b84 is located 68 bytes inside of 96-byte
region [ffff8800320f7b40, ffff8800320f7ba0)
[  107.294992] Accessed by thread T5540:
[  107.295685]          inlined      in describe_heap_address
./arch/x86/mm/asan/report.c:164
[  107.295685]   #0 ffffffff810dd277 in asan_report_error
./arch/x86/mm/asan/report.c:278
[  107.296731]   #1 ffffffff810dc6a0 in asan_check_region
./arch/x86/mm/asan/asan.c:37
[  107.297759]   #2 ffffffff810dd4a3 in __tsan_write4 ??:0
[  107.298718]   #3 ffffffff8110aa1a in ____call_usermodehelper
./kernel/kmod.c:250
[  107.299819]   #4 ffffffff8110aa7c in call_helper ./kernel/kmod.c:258
[  107.300772]   #5 ffffffff8192841c in ret_from_fork
./arch/x86/kernel/entry_64.S:570
[  107.301691]
[  107.301905] Freed by thread T5457:
[  107.302531]   #0 ffffffff810dc839 in asan_slab_free
./arch/x86/mm/asan/asan.c:130
[  107.303454]          inlined      in __cache_free ./mm/slab.c:3591
[  107.303454]   #1 ffffffff8128194a in kfree ./mm/slab.c:3831
[  107.304294]   #2 ffffffff8110a415 in call_usermodehelper_freeinfo
./kernel/kmod.c:266
[  107.305368]   #3 ffffffff8110ad6e in call_usermodehelper_exec
././arch/x86/include/asm/atomic.h:123
[  107.306410]   #4 ffffffff8110b231 in call_usermodehelper ./kernel/kmod.c:642
[  107.307387]   #5 ffffffff814d861b in kobject_uevent_env
./lib/kobject_uevent.c:311
[  107.308393]   #6 ffffffff814d8673 in kobject_uevent
./lib/kobject_uevent.c:333
[  107.309302]          inlined      in netdev_queue_add_kobject
./net/core/net-sysfs.c:1071
[  107.309302]   #7 ffffffff8181bd1a in netdev_queue_update_kobjects
./net/core/net-sysfs.c:1088
[  107.310410]          inlined      in register_queue_kobjects
./net/core/net-sysfs.c:1132
[  107.310410]   #8 ffffffff8181bf5d in netdev_register_kobject
./net/core/net-sysfs.c:1291
[  107.311449]   #9 ffffffff817fdaf8 in register_netdevice ./net/core/dev.c:5425
[  107.312436]   #10 ffffffff817fdca3 in register_netdev ./net/core/dev.c:5536
[  107.313392]   #11 ffffffff816bd643 in loopback_net_init loopback.c:0
[  107.314363]   #12 ffffffff817ec8a4 in ops_init ./net/core/net_namespace.c:107
[  107.315236]   #13 ffffffff817ecac3 in setup_net
./net/core/net_namespace.c:168
[  107.315947]   #14 ffffffff817ed4e4 in copy_net_ns
./net/core/net_namespace.c:255
[  107.316858]   #15 ffffffff81123980 in create_new_namespaces
./kernel/nsproxy.c:94
[  107.318259] Allocated by thread T5457:
[  107.318764]   #0 ffffffff810dc768 in asan_slab_alloc
./arch/x86/mm/asan/asan.c:91
[  107.319691]          inlined      in slab_alloc ./mm/slab.c:3475
[  107.319691]          inlined      in __do_kmalloc ./mm/slab.c:3749
[  107.319691]   #1 ffffffff812832ec in __kmalloc ./mm/slab.c:3763
[  107.320564]   #2 ffffffff8110a464 in call_usermodehelper_setup
./kernel/kmod.c:541
[  107.321617]   #3 ffffffff8110b222 in call_usermodehelper ./kernel/kmod.c:639
[  107.322603]   #4 ffffffff814d861b in kobject_uevent_env
./lib/kobject_uevent.c:311
[  107.323607]   #5 ffffffff814d8673 in kobject_uevent
./lib/kobject_uevent.c:333
[  107.324526]          inlined      in netdev_queue_add_kobject
./net/core/net-sysfs.c:1071
[  107.324526]   #6 ffffffff8181bd1a in netdev_queue_update_kobjects
./net/core/net-sysfs.c:1088
[  107.325621]          inlined      in register_queue_kobjects
./net/core/net-sysfs.c:1132
[  107.325621]   #7 ffffffff8181bf5d in netdev_register_kobject
./net/core/net-sysfs.c:1291
[  107.326662]   #8 ffffffff817fdaf8 in register_netdevice ./net/core/dev.c:5425
[  107.327645]   #9 ffffffff817fdca3 in register_netdev ./net/core/dev.c:5536
[  107.328576]   #10 ffffffff816bd643 in loopback_net_init loopback.c:0
[  107.329548]   #11 ffffffff817ec8a4 in ops_init ./net/core/net_namespace.c:107
[  107.330469]   #12 ffffffff817ecac3 in setup_net
./net/core/net_namespace.c:168
[  107.331359]   #13 ffffffff817ed4e4 in copy_net_ns
./net/core/net_namespace.c:255
[  107.332268]   #14 ffffffff81123980 in create_new_namespaces
./kernel/nsproxy.c:94
[  107.333295]   #15 ffffffff81123ccc in unshare_nsproxy_namespaces
./kernel/nsproxy.c:201
[  107.334346]
[  107.334557] Shadow bytes around the buggy address:
[  107.335472]   ffff8800320f7900: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.336699]   ffff8800320f7980: 00 00 00 00 00 00 00 00 00 00 00 00
fa fa fa fa
[  107.337904]   ffff8800320f7a00: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.339209]   ffff8800320f7a80: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.340423]   ffff8800320f7b00: fa fa fa fa fa fa fa fa fd fd fd fd
fd fd fd fd
[  107.341649] =>ffff8800320f7b80:[fd]fd fd fd fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.342859]   ffff8800320f7c00: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.344129]   ffff8800320f7c80: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.345341]   ffff8800320f7d00: fd fd fd fd fd fd fd fd fd fd fd fd
fa fa fa fa
[  107.346557]   ffff8800320f7d80: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.347771]   ffff8800320f7e00: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  107.348953] Shadow byte legend (one shadow byte represents 8
application bytes):
[  107.350093]   Addressable:           00
[  107.350603]   Partially addressable: 01 02 03 04 05 06 07
[  107.351485]   Heap redzone:          fa
[  107.351994]   Heap kmalloc redzone:  fb
[  107.352677]   Freed heap region:     fd
[  107.353355]   Shadow gap:            fe





On Fri, Aug 23, 2013 at 7:48 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Wed, Aug 21, 2013 at 8:35 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
>> Hi,
>>
>> I'm working on a memory error detector AddressSanitizer for Linux
>> kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
>> it can detect use-after-free and buffer-overflow errors. Currently the
>> tool is in very early stage and it can contain bugs.
>>
>> Here is one of the reports produced during testing:
>>
>> [  196.951434] ERROR: AddressSanitizer: heap-use-after-free on address
>> ffff880008a632c4
>> [  196.952135] Stack trace:
>> [  196.952380]   [<ffffffff810dd1f5>] asan_report_error+0x85/0x2c0
>> [  196.952890]   [<ffffffff810dc700>] asan_check_region+0x30/0x40
>> [  196.953466]   [<ffffffff810dd553>] __tsan_write4+0x13/0x20
>> [  196.953987]   [<ffffffff8110a76a>] ____call_usermodehelper+0x21a/0x240
>> [  196.954651]   [<ffffffff8110a7cc>] call_helper+0x3c/0x50
>> [  196.955155]   [<ffffffff81924b5c>] ret_from_fork+0x7c/0xb0
>> [  196.955686]   [<ffffffffffffffff>] 0xffffffffffffffff
>> [  196.956230] Free stack trace:
>> [  196.956532]   [<ffffffff810dc831>] asan_slab_free+0x61/0xb0
>> [  196.957052]   [<ffffffff8128070a>] kfree+0x9a/0x240
>> [  196.957558]   [<ffffffff8110a165>] call_usermodehelper_freeinfo+0x35/0x40
>> [  196.958308]   [<ffffffff8110aabe>] call_usermodehelper_exec+0xae/0x1d0
>> [  196.958920]   [<ffffffff8110af81>] call_usermodehelper+0x61/0x90
>> [  196.959490]   [<ffffffff814d7e4e>] kobject_uevent_env+0x5be/0x5f0
>> [  196.960161]   [<ffffffff814d7ea3>] kobject_uevent+0x23/0x40
>> [  196.960706]   [<ffffffff814d63ad>] kobject_release+0xad/0xc0
>> [  196.961274]   [<ffffffff814d618a>] kobject_put+0x3a/0x80
>> [  196.961889]   [<ffffffff8181af6c>] net_rx_queue_update_kobjects+0x12c/0x170
>> [  196.962701]   [<ffffffff8181b1b2>] netdev_unregister_kobject+0x62/0xa0
>> [  196.963475]   [<ffffffff817f342b>] rollback_registered_many+0x27b/0x340
>> [  196.964175]   [<ffffffff817f35d5>] unregister_netdevice_many+0x35/0xe0
>> [  196.964836]   [<ffffffff817f43f7>] default_device_exit_batch+0x107/0x180
>> [  196.965568]   [<ffffffff817ebb1c>] ops_exit_list.isra.3+0x8c/0xa0
>>
>>
>> I've looked at the sources, but I can't say that I fully understand
>> them. The report looks valid, though. I see several potential issues
>> in the code.
>>
>> 1. When wait=UMH_WAIT_EXEC and do_execve() fails,
>> ____call_usermodehelper() writes sub_info->retval=retval to freed
>> memory. This is the use-after-free reported by the tool.
>>
>> 2. When wait=UMH_NO_WAIT, __call_usermodehelper() starts child thread
>> and instantly frees subprocess_info. The child thread reads
>> subprocess_info. Looks like another use-after-free.
>>
>> 3. UMH_WAIT_EXEC does not actually wait for exec, it only waits for
>> starting the child thread that will do exec. I don't know whether it's
>> a problem with the code or with the name.
>>
>> The kernel version is 3.11-rc4 (last commit:
>> b7bc9e7d808ba55729bd263b0210cda36965be32).
>>
>> Please help to confirm these issues, and advice what to do next with them.
>>
>> TIA
>
>
>
> Here is more detailed report with allocation stack and thread ids:
>
> [  957.069245] ERROR: AddressSanitizer: heap-use-after-free on address
> ffff8800148452c4
> [  957.070438] Accessed by thread T22400:
> [  957.071134]   #0 ffffffff810dd260 (asan_report_error+0xb0/0x250)
> [  957.071947]   #1 ffffffff810dc6d0 (asan_check_region+0x30/0x40)
> [  957.072766]   #2 ffffffff810dd523 (__tsan_write4+0x13/0x20)
> [  957.073559]   #3 ffffffff8110a77a (____call_usermodehelper+0x21a/0x240)
> [  957.074488]   #4 ffffffff8110a7dc (call_helper+0x3c/0x50)
> [  957.075266]   #5 ffffffff8192569c (ret_from_fork+0x7c/0xb0)
>
> [  957.076006] Allocated by thread T506:
> [  957.076662]   #0 ffffffff810dc794 (asan_slab_alloc+0x44/0xa0)
> [  957.077475]   #1 ffffffff812821bc (__kmalloc+0xbc/0x500)
> [  957.078239]   #2 ffffffff8110a1c4 (call_usermodehelper_setup+0x44/0x120)
> [  957.079173]   #3 ffffffff8110af82 (call_usermodehelper+0x52/0x90)
> [  957.081469]   #4 ffffffff814d831e (kobject_uevent_env+0x5be/0x5f0)
> [  957.082329]   #5 ffffffff814d8373 (kobject_uevent+0x23/0x40)
> [  957.083116]   #6 ffffffff814d687d (kobject_release+0xad/0xc0)
> [  957.085582]   #7 ffffffff814d665a (kobject_put+0x3a/0x80)
> [  957.086348]   #8 ffffffff8181b873 (netdev_queue_update_kobjects+0x133/0x1a0)
> [  957.087324]   #9 ffffffff8181b94f (netdev_unregister_kobject+0x6f/0xa0)
> [  957.088232]   #10 ffffffff817f3b9b (rollback_registered_many+0x27b/0x340)
> [  957.089159]   #11 ffffffff817f3d45 (unregister_netdevice_many+0x35/0xe0)
> [  957.090091]   #12 ffffffff817f4b67 (default_device_exit_batch+0x107/0x180)
> [  957.091010]   #13 ffffffff817ec27c (ops_exit_list.isra.3+0x8c/0xa0)
> [  957.091899]   #14 ffffffff817ed0c9 (cleanup_net+0x229/0x390)
> [  957.092699]   #15 ffffffff811113af (process_one_work+0x2cf/0x750)
>
> [  957.093555] Freed by thread T506:
> [  957.094185]   #0 ffffffff810dc867 (asan_slab_free+0x77/0xb0)
> [  957.094958]   #1 ffffffff8128081a (kfree+0x9a/0x240)
> [  957.095659]   #2 ffffffff8110a175 (call_usermodehelper_freeinfo+0x35/0x40)
> [  957.096608]   #3 ffffffff8110aace (call_usermodehelper_exec+0xae/0x1d0)
> [  957.097520]   #4 ffffffff8110af91 (call_usermodehelper+0x61/0x90)
> [  957.098377]   #5 ffffffff814d831e (kobject_uevent_env+0x5be/0x5f0)
> [  957.099235]   #6 ffffffff814d8373 (kobject_uevent+0x23/0x40)
> [  957.099984]   #7 ffffffff814d687d (kobject_release+0xad/0xc0)
> [  957.100781]   #8 ffffffff814d665a (kobject_put+0x3a/0x80)
> [  957.101541]   #9 ffffffff8181b873 (netdev_queue_update_kobjects+0x133/0x1a0)
> [  957.102515]   #10 ffffffff8181b94f (netdev_unregister_kobject+0x6f/0xa0)
> [  957.103460]   #11 ffffffff817f3b9b (rollback_registered_many+0x27b/0x340)
> [  957.104419]   #12 ffffffff817f3d45 (unregister_netdevice_many+0x35/0xe0)
> [  957.105352]   #13 ffffffff817f4b67 (default_device_exit_batch+0x107/0x180)
> [  957.106342]   #14 ffffffff817ec27c (ops_exit_list.isra.3+0x8c/0xa0)
> [  957.107182]   #15 ffffffff817ed0c9 (cleanup_net+0x229/0x390)
