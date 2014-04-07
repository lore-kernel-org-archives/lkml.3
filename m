Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaDGWao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:30:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbaDGWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:30:39 -0400
Message-ID: <53432701.8020403@oracle.com>
Date: Mon, 07 Apr 2014 18:30:25 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: make sure we unregister a trigger only once
References: <1396630873-17372-1-git-send-email-sasha.levin@oracle.com> <CAK5ve-KGQJbWPO0N6rWJG4Z+aoEtr4+Whv5UkVCVyk8PzjNyvw@mail.gmail.com>
In-Reply-To: <CAK5ve-KGQJbWPO0N6rWJG4Z+aoEtr4+Whv5UkVCVyk8PzjNyvw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 06:08 PM, Bryan Wu wrote:
> On Fri, Apr 4, 2014 at 10:01 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Currently, we may attempt to unregister a trigger more than once, for
>> example when we receive two consecutive reboot notifications, or when
>> we do a regular unregistration plus reboot notification.
>>
>> This leads to the following error since we try to delete the list node
>> twice:
>>
>> [ 2780.254922] WARNING: CPU: 0 PID: 13764 at lib/list_debug.c:53 __list_del_entry+0x3e/0xe0()
>> [ 2780.265559] list_del corruption, ffffffffa5eb6470->next is LIST_POISON1 (dead000000100100)
>> [ 2780.271710] Modules linked in:
>> [ 2780.274156] CPU: 0 PID: 13764 Comm: kworker/0:2 Tainted: G        W     3.14.0-next-20140403-sasha-00012-gef5fa7d-dirty #373
>> [ 2780.283063] Workqueue: events do_poweroff
>> [ 2780.285644]  0000000000000009 ffff8800330dbb38 ffffffffa34bfa33 0000000000002fe0
>> [ 2780.291571]  ffff8800330dbb88 ffff8800330dbb78 ffffffffa015a37c ffff8800330dbb68
>> [ 2780.296670]  ffffffffa5eb6470 0000000000000000 ffffffffa5eb6400 ffffffffa5ad7430
>> [ 2780.299756] Call Trace:
>> [ 2780.301530] dump_stack (lib/dump_stack.c:52)
>> [ 2780.303802] warn_slowpath_common (kernel/panic.c:418)
>> [ 2780.306151] warn_slowpath_fmt (kernel/panic.c:433)
>> [ 2780.308156] __list_del_entry (lib/list_debug.c:51 (discriminator 1))
>> [ 2780.310800] list_del (lib/list_debug.c:78)
>> [ 2780.313175] led_trigger_unregister (drivers/leds/led-triggers.c:225)
>> [ 2780.315599] heartbeat_reboot_notifier (drivers/leds/trigger/ledtrig-heartbeat.c:119)
>> [ 2780.317247] notifier_call_chain (kernel/notifier.c:95)
>> [ 2780.320014] __blocking_notifier_call_chain (kernel/notifier.c:316)
>> [ 2780.323263] blocking_notifier_call_chain (kernel/notifier.c:326)
>> [ 2780.326096] kernel_power_off (include/linux/kmod.h:95 kernel/reboot.c:153 kernel/reboot.c:179)
>> [ 2780.327883] do_poweroff (kernel/power/poweroff.c:23)
>> [ 2780.330748] process_one_work (kernel/workqueue.c:2221 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2226)
>> [ 2780.333027] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
>> [ 2780.335487] process_scheduled_works (include/linux/list.h:188 kernel/workqueue.c:2277)
>> [ 2780.337101] worker_thread (kernel/workqueue.c:2352)
>> [ 2780.338712] ? rescuer_thread (kernel/workqueue.c:2297)
>> [ 2780.341326] kthread (kernel/kthread.c:219)
>> [ 2780.343446] ? kthread_create_on_node (kernel/kthread.c:185)
>> [ 2780.345733] ret_from_fork (arch/x86/kernel/entry_64.S:555)
>> [ 2780.347168] ? kthread_create_on_node (kernel/kthread.c:185)
>>
>> Prevent it by making sure we don't attempt to unregister a trigger that
>> is not in the triggers list.
>>
> 
> Looks good to me literally, could you please provide some simple test
> case for me? I need verify it on my side.

First, make sure you test it on a kernel with list debugging enabled,
otherwise there won't be noticeable result unless you end up corrupting
something important in the memory.

Try calling reboot() and unregistering a device that has a led trigger
at the same time (from two different threads) and hope you hit that race.


Thanks,
Sasha

