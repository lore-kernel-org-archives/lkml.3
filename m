Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaKQFMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:12:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:61080 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbaKQFMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:12:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,400,1413270000"; 
   d="scan'208";a="638043987"
Message-ID: <546983B1.6060105@linux.intel.com>
Date: Mon, 17 Nov 2014 13:12:17 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for Nov 14
References: <20141114192738.08e744cc@canb.auug.org.au> <20141115211922.GA2347@roeck-us.net> <54680D0A.7070900@linux.intel.com> <5468185D.5020400@roeck-us.net>
In-Reply-To: <5468185D.5020400@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/16 11:22, Guenter Roeck wrote:
> On 11/15/2014 06:33 PM, Jiang Liu wrote:
>> Hi Guenter,
>>     Could you please help to provide the config file and
>> error messages?
> 
> Config file:
>     https://github.com/groeck/linux-build-test/blob/master/rootfs/x86/qemu_x86_pc_nosmp_defconfig
> 
> 
> Error log:
>     http://server.roeck-us.net:8010/builders/qemu-x86-next/builds/44/steps/qemubuildcommand/logs/stdio
> 
> 
> You can find the root file system used for the test as well as the test
> script at
>     https://github.com/groeck/linux-build-test/tree/master/rootfs/x86
> 
> There isn't really an error message, though - the boot stalls until the
> controlling daemon
> kills the qemu session.
Hi Guenter,
	With the test suite at
https://github.com/groeck/linux-build-test/tree/master/rootfs/x86
and configuration file qemu_x86_pc_nosmp_defconfig, I have
following findings:
1) disabling PCI_MSI, <OK>.
2) manually turning on X86_IO_APIC, <OK>.
3) with 3.16 kernel, disabling PCI_MSI, <OK>
4) with 3.16 kernel, disabling PCI_MSI, enabling X86_UP_APIC, <fail>

So the root cause is that KVM doesn't support the configuration with
LOCAL_APIC enabled but IO_APIC disabled, though this configuration
works with bare-metal machines.
There are two possible solutions here:
1) ALways enalbe IO_APIC if KVM is enabled.
2) Enhance KVM to support LOCAL_APIC when IOAPIC is disabled.

But I'm not familiar with KVM and don't know how to achieve solution 2.
Any suggestions?
Regards!
Gerry

> 
> Guenter
> 
>> Thanks!
>> Gerry
>>
>> On 2014/11/16 5:19, Guenter Roeck wrote:
>>> On Fri, Nov 14, 2014 at 07:27:38PM +1100, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20141113:
>>>>
>>>> New tree: overlayfs
>>>>
>>>> The idle tree gained a conflict against Linus' tree.
>>>>
>>>> The scsi tree gained a conflict against the usb tree.
>>>>
>>>> Non-merge commits (relative to Linus' tree): 6264
>>>>   6509 files changed, 209171 insertions(+), 167101 deletions(-)
>>>>
>>>
>>> I bisected the x86-nosmp qemu runtime failure I have seen for
>>> the last few days. Here is the result:
>>>
>>> bb46613f7099f70bc68c1c684cfa22d6863cd8eb is the first bad commit
>>> commit bb46613f7099f70bc68c1c684cfa22d6863cd8eb
>>> Author: Jiang Liu <jiang.liu@linux.intel.com>
>>> Date:   Mon Oct 27 16:12:06 2014 +0800
>>>
>>>      x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
>>>
>>> Detailed log:
>>>
>>> git bisect start 'HEAD' 'v3.18-rc4'
>>> # good: [97bf3e2baed8f45432933bf15535061fb5acda44] Merge
>>> remote-tracking branch 'sound-asoc/for-next'
>>> git bisect good 97bf3e2baed8f45432933bf15535061fb5acda44
>>> # bad: [d23dcf93e7ad8004ef80726717f700316e53f44d] Merge
>>> remote-tracking branch 'usb-serial/usb-next'
>>> git bisect bad d23dcf93e7ad8004ef80726717f700316e53f44d
>>> # bad: [cff78d32f4c15b7b2cb173c8e6097c513f406da0] Merge
>>> remote-tracking branch 'kvm/linux-next'
>>> git bisect bad cff78d32f4c15b7b2cb173c8e6097c513f406da0
>>> # good: [09dc3f20206821e06b1b281b1ae4451777f707c4] Merge
>>> remote-tracking branch 'audit/next'
>>> git bisect good 09dc3f20206821e06b1b281b1ae4451777f707c4
>>> # bad: [caf0fea9e728916a92c508988fd2ae84a08c280b] Merge branch
>>> 'x86/vdso'
>>> git bisect bad caf0fea9e728916a92c508988fd2ae84a08c280b
>>> # good: [9aa5f98820067b00456c42347fc0ff48d2d2474f] Merge branch
>>> 'sched/urgent'
>>> git bisect good 9aa5f98820067b00456c42347fc0ff48d2d2474f
>>> # bad: [46fe562d914fde0a43ee339a0fcfd4af829cb8f7] Merge branch
>>> 'x86/boot'
>>> git bisect bad 46fe562d914fde0a43ee339a0fcfd4af829cb8f7
>>> # good: [b26ea43d0bb1539ce047206a57c7fd8d636e7f22] x86, irq: Protect
>>> __clear_irq_vector() with vector_lock
>>> git bisect good b26ea43d0bb1539ce047206a57c7fd8d636e7f22
>>> # bad: [e1d8f79a27a41493c8f1ad0bde440048e17f9494] iommu/amd: Use
>>> helpers to access irq_cfg data structure associated with IRQ
>>> git bisect bad e1d8f79a27a41493c8f1ad0bde440048e17f9494
>>> # good: [051825cab15c8180f2f0dbc3a9de5a3db7476065] x86, irq: Move HT
>>> IRQ related code from io_apic.c into htirq.c
>>> git bisect good 051825cab15c8180f2f0dbc3a9de5a3db7476065
>>> # bad: [bb46613f7099f70bc68c1c684cfa22d6863cd8eb] x86, irq: Make MSI
>>> and HT_IRQ indepenent of X86_IO_APIC
>>> git bisect bad bb46613f7099f70bc68c1c684cfa22d6863cd8eb
>>> # good: [b09198f7b59101e52bcf238ed3b7bfc64de055ef] x86, irq: Move IRQ
>>> initialization routines from io_apic.c into vector.c
>>> git bisect good b09198f7b59101e52bcf238ed3b7bfc64de055ef
>>> # first bad commit: [bb46613f7099f70bc68c1c684cfa22d6863cd8eb] x86,
>>> irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
>>>
>>> I'll be happy to provide the configuration if needed.
>>>
>>> Guenter
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
> 
