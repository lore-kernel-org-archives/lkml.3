Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3HWPtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:49:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46076 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3HWPtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
References: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 23 Aug 2013 19:48:44 +0400
Message-ID: <CACT4Y+artcxiies1q3XP3+yCh+QzPZQ96dDttpdYXoQ+w2xosQ@mail.gmail.com>
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

On Wed, Aug 21, 2013 at 8:35 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> Hi,
>
> I'm working on a memory error detector AddressSanitizer for Linux
> kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
> it can detect use-after-free and buffer-overflow errors. Currently the
> tool is in very early stage and it can contain bugs.
>
> Here is one of the reports produced during testing:
>
> [  196.951434] ERROR: AddressSanitizer: heap-use-after-free on address
> ffff880008a632c4
> [  196.952135] Stack trace:
> [  196.952380]   [<ffffffff810dd1f5>] asan_report_error+0x85/0x2c0
> [  196.952890]   [<ffffffff810dc700>] asan_check_region+0x30/0x40
> [  196.953466]   [<ffffffff810dd553>] __tsan_write4+0x13/0x20
> [  196.953987]   [<ffffffff8110a76a>] ____call_usermodehelper+0x21a/0x240
> [  196.954651]   [<ffffffff8110a7cc>] call_helper+0x3c/0x50
> [  196.955155]   [<ffffffff81924b5c>] ret_from_fork+0x7c/0xb0
> [  196.955686]   [<ffffffffffffffff>] 0xffffffffffffffff
> [  196.956230] Free stack trace:
> [  196.956532]   [<ffffffff810dc831>] asan_slab_free+0x61/0xb0
> [  196.957052]   [<ffffffff8128070a>] kfree+0x9a/0x240
> [  196.957558]   [<ffffffff8110a165>] call_usermodehelper_freeinfo+0x35/0x40
> [  196.958308]   [<ffffffff8110aabe>] call_usermodehelper_exec+0xae/0x1d0
> [  196.958920]   [<ffffffff8110af81>] call_usermodehelper+0x61/0x90
> [  196.959490]   [<ffffffff814d7e4e>] kobject_uevent_env+0x5be/0x5f0
> [  196.960161]   [<ffffffff814d7ea3>] kobject_uevent+0x23/0x40
> [  196.960706]   [<ffffffff814d63ad>] kobject_release+0xad/0xc0
> [  196.961274]   [<ffffffff814d618a>] kobject_put+0x3a/0x80
> [  196.961889]   [<ffffffff8181af6c>] net_rx_queue_update_kobjects+0x12c/0x170
> [  196.962701]   [<ffffffff8181b1b2>] netdev_unregister_kobject+0x62/0xa0
> [  196.963475]   [<ffffffff817f342b>] rollback_registered_many+0x27b/0x340
> [  196.964175]   [<ffffffff817f35d5>] unregister_netdevice_many+0x35/0xe0
> [  196.964836]   [<ffffffff817f43f7>] default_device_exit_batch+0x107/0x180
> [  196.965568]   [<ffffffff817ebb1c>] ops_exit_list.isra.3+0x8c/0xa0
>
>
> I've looked at the sources, but I can't say that I fully understand
> them. The report looks valid, though. I see several potential issues
> in the code.
>
> 1. When wait=UMH_WAIT_EXEC and do_execve() fails,
> ____call_usermodehelper() writes sub_info->retval=retval to freed
> memory. This is the use-after-free reported by the tool.
>
> 2. When wait=UMH_NO_WAIT, __call_usermodehelper() starts child thread
> and instantly frees subprocess_info. The child thread reads
> subprocess_info. Looks like another use-after-free.
>
> 3. UMH_WAIT_EXEC does not actually wait for exec, it only waits for
> starting the child thread that will do exec. I don't know whether it's
> a problem with the code or with the name.
>
> The kernel version is 3.11-rc4 (last commit:
> b7bc9e7d808ba55729bd263b0210cda36965be32).
>
> Please help to confirm these issues, and advice what to do next with them.
>
> TIA



Here is more detailed report with allocation stack and thread ids:

[  957.069245] ERROR: AddressSanitizer: heap-use-after-free on address
ffff8800148452c4
[  957.070438] Accessed by thread T22400:
[  957.071134]   #0 ffffffff810dd260 (asan_report_error+0xb0/0x250)
[  957.071947]   #1 ffffffff810dc6d0 (asan_check_region+0x30/0x40)
[  957.072766]   #2 ffffffff810dd523 (__tsan_write4+0x13/0x20)
[  957.073559]   #3 ffffffff8110a77a (____call_usermodehelper+0x21a/0x240)
[  957.074488]   #4 ffffffff8110a7dc (call_helper+0x3c/0x50)
[  957.075266]   #5 ffffffff8192569c (ret_from_fork+0x7c/0xb0)

[  957.076006] Allocated by thread T506:
[  957.076662]   #0 ffffffff810dc794 (asan_slab_alloc+0x44/0xa0)
[  957.077475]   #1 ffffffff812821bc (__kmalloc+0xbc/0x500)
[  957.078239]   #2 ffffffff8110a1c4 (call_usermodehelper_setup+0x44/0x120)
[  957.079173]   #3 ffffffff8110af82 (call_usermodehelper+0x52/0x90)
[  957.081469]   #4 ffffffff814d831e (kobject_uevent_env+0x5be/0x5f0)
[  957.082329]   #5 ffffffff814d8373 (kobject_uevent+0x23/0x40)
[  957.083116]   #6 ffffffff814d687d (kobject_release+0xad/0xc0)
[  957.085582]   #7 ffffffff814d665a (kobject_put+0x3a/0x80)
[  957.086348]   #8 ffffffff8181b873 (netdev_queue_update_kobjects+0x133/0x1a0)
[  957.087324]   #9 ffffffff8181b94f (netdev_unregister_kobject+0x6f/0xa0)
[  957.088232]   #10 ffffffff817f3b9b (rollback_registered_many+0x27b/0x340)
[  957.089159]   #11 ffffffff817f3d45 (unregister_netdevice_many+0x35/0xe0)
[  957.090091]   #12 ffffffff817f4b67 (default_device_exit_batch+0x107/0x180)
[  957.091010]   #13 ffffffff817ec27c (ops_exit_list.isra.3+0x8c/0xa0)
[  957.091899]   #14 ffffffff817ed0c9 (cleanup_net+0x229/0x390)
[  957.092699]   #15 ffffffff811113af (process_one_work+0x2cf/0x750)

[  957.093555] Freed by thread T506:
[  957.094185]   #0 ffffffff810dc867 (asan_slab_free+0x77/0xb0)
[  957.094958]   #1 ffffffff8128081a (kfree+0x9a/0x240)
[  957.095659]   #2 ffffffff8110a175 (call_usermodehelper_freeinfo+0x35/0x40)
[  957.096608]   #3 ffffffff8110aace (call_usermodehelper_exec+0xae/0x1d0)
[  957.097520]   #4 ffffffff8110af91 (call_usermodehelper+0x61/0x90)
[  957.098377]   #5 ffffffff814d831e (kobject_uevent_env+0x5be/0x5f0)
[  957.099235]   #6 ffffffff814d8373 (kobject_uevent+0x23/0x40)
[  957.099984]   #7 ffffffff814d687d (kobject_release+0xad/0xc0)
[  957.100781]   #8 ffffffff814d665a (kobject_put+0x3a/0x80)
[  957.101541]   #9 ffffffff8181b873 (netdev_queue_update_kobjects+0x133/0x1a0)
[  957.102515]   #10 ffffffff8181b94f (netdev_unregister_kobject+0x6f/0xa0)
[  957.103460]   #11 ffffffff817f3b9b (rollback_registered_many+0x27b/0x340)
[  957.104419]   #12 ffffffff817f3d45 (unregister_netdevice_many+0x35/0xe0)
[  957.105352]   #13 ffffffff817f4b67 (default_device_exit_batch+0x107/0x180)
[  957.106342]   #14 ffffffff817ec27c (ops_exit_list.isra.3+0x8c/0xa0)
[  957.107182]   #15 ffffffff817ed0c9 (cleanup_net+0x229/0x390)
