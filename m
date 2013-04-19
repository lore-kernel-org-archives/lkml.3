Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967724Ab3DSBFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 21:05:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3830 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966825Ab3DSBF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 21:05:29 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: Yan Vugenfirer <yvugenfi@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wangrui (K)" <moon.wangrui@huawei.com>
Subject: Re: KVM VM(windows xp) reseted when running geekbench for about 2
 days
Thread-Topic: KVM VM(windows xp) reseted when running geekbench for about 2
 days
Thread-Index: Ac48LEpguUL++1wxQxiPGnnKCoktbv//iVQAgAAIdQD//rsf4A==
Date: Fri, 19 Apr 2013 01:05:08 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE1F16A@szxeml556-mbx.china.huawei.com>
References: <D3E216785288A145B7BC975F83A2ED103FE1E7A5@szxeml556-mbx.china.huawei.com>
 <20130418125532.GW8997@redhat.com>
 <9C764699-6F9C-4AD8-A6C9-34D818753452@redhat.com>
In-Reply-To: <9C764699-6F9C-4AD8-A6C9-34D818753452@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Thu, Apr 18, 2013 at 12:00:49PM +0000, Zhanghaoyu (A) wrote:
>>> I start 10 VMs(windows xp), then running geekbench tool on them, 
>>> about 2 days, one of them was reset, I found the reset operation is 
>>> done by int kvm_cpu_exec(CPUArchState *env) {
>>>    ...
>>>       switch (run->exit_reason)
>>>       ...
>>>        case KVM_EXIT_SHUTDOWN:
>>>            DPRINTF("shutdown\n");
>>>            qemu_system_reset_request();
>>>            ret = EXCP_INTERRUPT;
>>>            break;
>>>    ...
>>> }
>>> 
>>> KVM_EXIT_SHUTDOWN exit reason was set previously in triple fault handle handle_triple_fault().
>>> 
>> How do you know that reset was done here? This is not the only place 
>> where qemu_system_reset_request() is called.
I used gdb to debug QEMU process, and add a breakpoint in qemu_system_reset_request(), when the case occurred, backtrace shown as below,
(gdb) bt
#0  qemu_system_reset_request () at vl.c:1964
#1  0x00007f9ef9dc5991 in kvm_cpu_exec (env=0x7f9efac47100)
    at /gt/qemu-kvm-1.4/qemu-kvm-1.4/kvm-all.c:1602
#2  0x00007f9ef9d5b229 in qemu_kvm_cpu_thread_fn (arg=0x7f9efac47100)
    at /gt/qemu-kvm-1.4/qemu-kvm-1.4/cpus.c:759
#3  0x00007f9ef898b5f0 in start_thread () from /lib64/libpthread.so.0
#4  0x00007f9ef86fa84d in clone () from /lib64/libc.so.6
#5  0x0000000000000000 in ?? ()

And, I add printk log in all place where KVM_EXIT_SHUTDOWN exit reason is set, only handle_triple_fault() was called.
>
>Make sure XP is not set to auto-reset in case of BSOD. 
No, winxp is not set to auto-reset in case of BSOD. No Winxp event log reported.
>
>Best regards,
>Yan.
>
>> 
>>> What causes the triple fault?
>>> 
>> Are you asking what is triple fault or why it happened in your case?
What I asked is why triple fault happened in my case.
>> For the former see here: http://en.wikipedia.org/wiki/Triple_fault
>> For the later it is to late to tell after VM reset. You can run QEMU 
>> with -no-reboot -no-shutdown. VM will pause instead of rebooting and 
>> then you can examine what is going on.
Great thanks, I'll run QEMU with -no-reboot -no-shutdown options, if VM paused in my case, what should I examined?

Thanks,
Zhang Haoyu
