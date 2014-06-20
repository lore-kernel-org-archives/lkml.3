Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030243AbaFTUmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:42:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50866 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030238AbaFTUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:42:32 -0400
Message-ID: <53A49CF9.3050400@oracle.com>
Date: Fri, 20 Jun 2014 16:43:37 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com> <20140620152312.GB11391@pd.tnic> <53A45627.6090306@oracle.com> <20140620155845.GC11391@pd.tnic> <53A45E67.7070000@oracle.com> <20140620175240.GE11391@pd.tnic> <53A48DF6.9020503@oracle.com> <20140620200358.GK11391@pd.tnic> <53A496B2.2090701@oracle.com> <20140620202900.GL11391@pd.tnic>
In-Reply-To: <20140620202900.GL11391@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 04:29 PM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 04:16:50PM -0400, Boris Ostrovsky wrote:
>> Sorry, mce_device_create().
>>
>> We can't call it in the notifier until mcheck_init_device() has been
>> successfully executed (we need subsys_system_register(&mce_subsys)). I don't
>> know whether we can call subsys_system_register() in mcheck_init() -- it is
>> quite early in the boot.
> I don't think it matters: we want to add only this oneliner to
> mcheck_init():
>
> 	__register_hotcpu_notifier(&mce_cpu_notifier);
>
> and remove it from mcheck_init_device(), nothing else. And we don't need
> the synchronization even because we're BSP only then.
>
> I mean, we won't be able to offline CPUs that early anyway - thus
> call mce_device_create() in the notifier callback - as we don't have
> userspace to do "echo 0 > ..."
>
> The rest of the code remains and mcheck_init_device() executes when it
> does. Unless I'm missing something, of course...

We are getting CPU_ONLINE notifier for ASPs during boot:


[   14.489595] cpu 1 spinlock event irq 48
[   14.502908] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000060
[   14.527373] IP: [<ffffffff8144deec>] bus_add_device+0xfc/0x1e0
[   14.545859] PGD 0
[   14.552380] Oops: 0000 [#1] SMP
[   14.562711] Modules linked in:
[   14.572494] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
3.16.0-rc1-pmu-dom0 #195
[   14.595307] Hardware name: Intel Corporation Shark Bay Client 
platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0109.R03.1301282055 
01/28/2013
[   14.634718] task: ffff88022f5a0000 ti: ffff88022f53c000 task.ti: 
ffff88022f53c000
[   14.658364] RIP: e030:[<ffffffff8144deec>] [<ffffffff8144deec>] 
bus_add_device+0xfc/0x1e0
[   14.684457] RSP: e02b:ffff88022f53fc68  EFLAGS: 00010246
[   14.701310] RAX: 0000000000000000 RBX: ffff88023d411810 RCX: 
00000000d7c6bb9d
[   14.723875] RDX: ffff88023d402a60 RSI: ffff88023d411810 RDI: 
ffff88023d411810
[   14.746427] RBP: ffff88022f53fc98 R08: 0000000000000000 R09: 
0000000000000000
[   14.768962] R10: ffffffff8133bbc0 R11: ffffea0008bd9600 R12: 
ffff88023d411800
[   14.791522] R13: ffffffff81c284b8 R14: ffffffff81c284a0 R15: 
0000000000000000
[   14.814087] FS:  0000000000000000(0000) GS:ffff88023da00000(0000) 
knlGS:0000000000000000
[   14.839632] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.857845] CR2: 0000000000000060 CR3: 0000000001c10000 CR4: 
0000000000042660
[   14.880413] Stack:
[   14.886913]  ffff88023d411800 ffff88023d411800 0000000000000000 
0000000000000000
[   14.910293]  ffff88023d411810 0000000000000000 ffff88022f53fcf8 
ffffffff8144be3f
[   14.933692]  00000000fffffffb 0000000000000000 ffff88022f53fcd8 
ffffffff81459c85
[   14.957075] Call Trace:
[   14.964971]  [<ffffffff8144be3f>] device_add+0x43f/0x5e0
[   14.981809]  [<ffffffff81459c85>] ? pm_runtime_init+0xe5/0xf0
[   15.000014]  [<ffffffff8144c1be>] device_register+0x1e/0x30
[   15.017697]  [<ffffffff8103b04c>] mce_device_create+0x7c/0x1c0
[   15.036168]  [<ffffffff8103b2a8>] mce_cpu_callback+0x118/0x140
[   15.054636]  [<ffffffff810abb3d>] notifier_call_chain+0x4d/0x70
[   15.073371]  [<ffffffff810abc4e>] __raw_notifier_call_chain+0xe/0x10
[   15.093466]  [<ffffffff81085460>] __cpu_notify+0x20/0x40
[   15.110321]  [<ffffffff81085495>] cpu_notify+0x15/0x20
[   15.126613]  [<ffffffff81085767>] _cpu_up+0x107/0x160
[   15.142649]  [<ffffffff81085819>] cpu_up+0x59/0x80
[   15.157870]  [<ffffffff81d46fdf>] smp_init+0x60/0x8c
[   15.173620]  [<ffffffff81d2616a>] kernel_init_freeable+0xfa/0x20d
[   15.192908]  [<ffffffff8100332e>] ? xen_end_context_switch+0x1e/0x30
[   15.213023]  [<ffffffff816aecf0>] ? rest_init+0x80/0x80
[   15.229592]  [<ffffffff816aecfe>] kernel_init+0xe/0xf0
[   15.245904]  [<ffffffff816c0ebc>] ret_from_fork+0x7c/0xb0
[   15.263034]  [<ffffffff816aecf0>] ? rest_init+0x80/0x80
[   15.279607] Code: d2 ff ff 85 c0 41 89 c7 0f 85 88 00 00 00 49 8b 54 
24 50 48 85 d2 0f 84 93 00 00 00 49 8b 86 90 00 00 00 49 8d 5c 24 10 48 
89 de <48> 8b 78 60 48 83 c7 18 e8 c7 00 e0 ff 85 c0 41 89 c7 74 10 4c
[   15.338846] RIP  [<ffffffff8144deec>] bus_add_device+0xfc/0x1e0
[   15.357605]  RSP <ffff88022f53fc68>
[   15.368729] CR2: 0000000000000060
[   15.379338] ---[ end trace d288f65f5999f472 ]---
[   15.394005] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x00000009



-boris


>
> Oh, not quite. We probably should remove the
>
> 	__unregister_hotcpu_notifier(&mce_cpu_notifier);
>
> from the error path too, as you suggest.
>
> When you do, please hold that down in the commit message so that it is
> clear what we're doing.
>

