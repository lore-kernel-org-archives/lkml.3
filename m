Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3J1PCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:02:18 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:33968 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3J1PCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:02:13 -0400
Message-ID: <526E7C6B.6070603@t-online.de>
Date: Mon, 28 Oct 2013 16:02:03 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during
 shutdown
References: <525BD08C.2080101@t-online.de>	<CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>	<CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com> <CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
In-Reply-To: <CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: XYbpQyZXghP3IPajge+b3By7Eu+LVY0YZrjm0Y4gXke1z3yQ5PKZeB0q66jVtOwZGZ
X-TOI-MSGID: 63242cbd-b258-4a0d-82c0-ec013745e83e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.10.2013 11:02, Linus Torvalds wrote:
> Adding more people, so quoting the whole email for them.
>
> We definitely have some module unload issues. Guys, try the following
> a few times to unload modules:
>
>      lsmod | grep ' 0 '| cut -d' ' -f1 | xargs sudo rmmod
>
> (a few times because unloading one module will then potentially make

I do use a quite monolithic kernel with only a few modules, and one of the machines is
pretty stripped down:

I was unable to trigger any unusual kernel reaction within 10000 rmmod / modprobe cycles.


lsmod
=====

Module                  Size  Used by
ip6t_REJECT            12489  3
nf_conntrack_ipv6      13453  3
nf_defrag_ipv6         49936  1 nf_conntrack_ipv6
ip6table_raw           12565  1
ipt_REJECT             12485  3
xt_tcpudp              12531  6
xt_pkttype             12456  3
xt_LOG                 17205  12
xt_limit               12570  12
iptable_raw            12561  1
xt_CT                  12820  4
iptable_filter         12666  1
ip6table_mangle        12579  0
nf_conntrack_netbios_ns    12585  0
nf_conntrack_broadcast    12541  1 nf_conntrack_netbios_ns
nf_conntrack_ipv4      13655  3
nf_defrag_ipv4         12649  1 nf_conntrack_ipv4
ip_tables              17713  2 iptable_raw,iptable_filter
xt_conntrack           12664  6
nf_conntrack           67920  6 nf_conntrack_ipv6,xt_CT,nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_conntrack_ipv4,xt_conntrack
ip6table_filter        12670  1
ip6_tables             17740  3 ip6table_raw,ip6table_mangle,ip6table_filter
x_tables               21937  15 ip6t_REJECT,ip6table_raw,ipt_REJECT,xt_tcpudp,xt_pkttype,xt_LOG,xt_limit,iptable_raw,xt_CT,iptable_filter,ip6table_mangle,ip_tables,xt_conntrack,ip6table_filter,ip6_tables
snd_rme96              24387  0
snd_hda_intel          34073  0
snd_hda_codec_realtek    41826  1
snd_hda_codec         129150  2 snd_hda_intel,snd_hda_codec_realtek
snd_pcm                73096  3 snd_rme96,snd_hda_intel,snd_hda_codec
snd_timer              24441  1 snd_pcm
snd_page_alloc         14230  2 snd_hda_intel,snd_pcm
snd                    58328  6 snd_rme96,snd_hda_intel,snd_hda_codec_realtek,snd_hda_codec,snd_pcm,snd_timer
soundcore              14599  1 snd
binfmt_misc            13111  1
ipv6                  272895  24 ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6,ip6table_mangle






> other modules unloadable).
>
> On my machine, I can trigger this, for example:
>
>    ------------[ cut here ]------------
>    WARNING: CPU: 0 PID: 3217 at fs/sysfs/file.c:498 sysfs_attr_ns+0x91/0xa0()
>    sysfs: kobject (null) without dirent
>    Modules linked in: fuse nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_$
>    CPU: 0 PID: 3217 Comm: rmmod Not tainted 3.12.0-rc6-00284-ge6036c0b8896 #19
>    Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS R0270V7 05/17/2013
>     0000000000000009 ffff8800aca35df8 ffffffff8160aab5 ffff8800aca35e40
>     ffff8800aca35e30 ffffffff810514b8 ffffffffa013f080 ffff8801194a6040
>     0000000000000800 0000000000000000 0000000000c5b3e0 ffff8800aca35e90
>    Call Trace:
>     [<ffffffff8160aab5>] dump_stack+0x45/0x56
>     [<ffffffff810514b8>] warn_slowpath_common+0x78/0xa0
>     [<ffffffff81051527>] warn_slowpath_fmt+0x47/0x50
>     [<ffffffff810b5960>] ? module_refcount+0xb0/0xb0
>     [<ffffffff811e5c61>] sysfs_attr_ns+0x91/0xa0
>     [<ffffffff811e5d2a>] sysfs_remove_file+0x1a/0x50
>     [<ffffffff814c88a3>] cpufreq_sysfs_remove_file+0x13/0x30
>     [<ffffffffa013d350>] acpi_cpufreq_exit+0x2e/0xcde [acpi_cpufreq]
>     [<ffffffff810b7d1d>] SyS_delete_module+0x15d/0x2c0
>     [<ffffffff81002929>] ? do_notify_resume+0x59/0x90
>     [<ffffffff81618f62>] system_call_fastpath+0x16/0x1b
>    ---[ end trace f887112caaa5c4ab ]---
>
> so at least we have a cpufreq/sysfs interaction bug. There may be others.
>
> This particular cpufreq issue may be triggered by the fact that
> acpi-cpufreq isn't actually in use (pstate is). Or it might be some
> generic cpufreq/sysfs bug. Rafael, Greg, ideas?
>
> I don't see that this particular one would be the one that causes the
> timer issues, but it's an example of the fact that module unload tends
> to be special and not necessarily well tested.
>
>                     Linus
>
> On Fri, Oct 25, 2013 at 9:38 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Hmm.. I just got a run_timer_softirq oops on my own laptop, slightly
>> different. That was not during shutdown, although there was a "yum
>> upgrade" finishing when that happened, so it's quite likely that there
>> was a service shutdown (and then restart).
>>
>> I think it's related. But my oops has almost no information: the IP
>> that was jumped to was bogus, and the callchain is just CPU idle
>> followed by the softirq -> run_timers_softirq handling, so there's no
>> real way to see *what* triggered it.
>>
>> The bad rip was ffffffffa051e250, which is not a valid code address.
>> It *might* be a module address, though. So this might be triggered by
>> rmmod on some module that doesn't remove all its timers...
>>
>> Ideas?
>>
>>                   Linus

