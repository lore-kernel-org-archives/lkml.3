Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3HUQgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:36:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37927 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3HUQgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:36:05 -0400
MIME-Version: 1.0
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 21 Aug 2013 20:35:44 +0400
Message-ID: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
Subject: Potential use-after-free in ____call_usermodehelper
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

I'm working on a memory error detector AddressSanitizer for Linux
kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
it can detect use-after-free and buffer-overflow errors. Currently the
tool is in very early stage and it can contain bugs.

Here is one of the reports produced during testing:

[  196.951434] ERROR: AddressSanitizer: heap-use-after-free on address
ffff880008a632c4
[  196.952135] Stack trace:
[  196.952380]   [<ffffffff810dd1f5>] asan_report_error+0x85/0x2c0
[  196.952890]   [<ffffffff810dc700>] asan_check_region+0x30/0x40
[  196.953466]   [<ffffffff810dd553>] __tsan_write4+0x13/0x20
[  196.953987]   [<ffffffff8110a76a>] ____call_usermodehelper+0x21a/0x240
[  196.954651]   [<ffffffff8110a7cc>] call_helper+0x3c/0x50
[  196.955155]   [<ffffffff81924b5c>] ret_from_fork+0x7c/0xb0
[  196.955686]   [<ffffffffffffffff>] 0xffffffffffffffff
[  196.956230] Free stack trace:
[  196.956532]   [<ffffffff810dc831>] asan_slab_free+0x61/0xb0
[  196.957052]   [<ffffffff8128070a>] kfree+0x9a/0x240
[  196.957558]   [<ffffffff8110a165>] call_usermodehelper_freeinfo+0x35/0x40
[  196.958308]   [<ffffffff8110aabe>] call_usermodehelper_exec+0xae/0x1d0
[  196.958920]   [<ffffffff8110af81>] call_usermodehelper+0x61/0x90
[  196.959490]   [<ffffffff814d7e4e>] kobject_uevent_env+0x5be/0x5f0
[  196.960161]   [<ffffffff814d7ea3>] kobject_uevent+0x23/0x40
[  196.960706]   [<ffffffff814d63ad>] kobject_release+0xad/0xc0
[  196.961274]   [<ffffffff814d618a>] kobject_put+0x3a/0x80
[  196.961889]   [<ffffffff8181af6c>] net_rx_queue_update_kobjects+0x12c/0x170
[  196.962701]   [<ffffffff8181b1b2>] netdev_unregister_kobject+0x62/0xa0
[  196.963475]   [<ffffffff817f342b>] rollback_registered_many+0x27b/0x340
[  196.964175]   [<ffffffff817f35d5>] unregister_netdevice_many+0x35/0xe0
[  196.964836]   [<ffffffff817f43f7>] default_device_exit_batch+0x107/0x180
[  196.965568]   [<ffffffff817ebb1c>] ops_exit_list.isra.3+0x8c/0xa0


I've looked at the sources, but I can't say that I fully understand
them. The report looks valid, though. I see several potential issues
in the code.

1. When wait=UMH_WAIT_EXEC and do_execve() fails,
____call_usermodehelper() writes sub_info->retval=retval to freed
memory. This is the use-after-free reported by the tool.

2. When wait=UMH_NO_WAIT, __call_usermodehelper() starts child thread
and instantly frees subprocess_info. The child thread reads
subprocess_info. Looks like another use-after-free.

3. UMH_WAIT_EXEC does not actually wait for exec, it only waits for
starting the child thread that will do exec. I don't know whether it's
a problem with the code or with the name.

The kernel version is 3.11-rc4 (last commit:
b7bc9e7d808ba55729bd263b0210cda36965be32).

Please help to confirm these issues, and advice what to do next with them.

TIA
