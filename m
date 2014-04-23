Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaDWOZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:25:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30453 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaDWOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:21:31 -0400
Message-ID: <5357CD0B.5050003@oracle.com>
Date: Wed, 23 Apr 2014 10:24:11 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andrew Lutomirski <amluto@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <535714A1.9080502@linux.intel.com> <CAObL_7HsnpGKRoBh+NZkW7SURqGx_4Dkfow=1-_7UU9uBV4UkA@mail.gmail.com> <53571A7D.8050702@zytor.com>
In-Reply-To: <53571A7D.8050702@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 09:42 PM, H. Peter Anvin wrote:
> On 04/22/2014 06:23 PM, Andrew Lutomirski wrote:
>> What's the to_dmesg thing for?
>>
> It's for debugging... the espfix page tables generate so many duplicate
> entries that trying to output it via a seqfile runs out of memory.  I
> suspect we need to do something like skip the espfix range or some other
> hack.
>
>> It looks sane, although I haven't checked the detailed register manipulation.
>>
>> Users of big systems may complain when every single CPU lines up for
>> that mutex.  Maybe no one cares.
> Right now the whole smpboot sequence is fully serialized... that needs
> to be fixed.
>
> Konrad - I really could use some help figuring out what needs to be done
> for this not to break Xen.

This does break Xen PV:

[    3.683735] ------------[ cut here ]------------
[    3.683807] WARNING: CPU: 0 PID: 0 at arch/x86/xen/multicalls.c:129 
xen_mc_flush+0x1c8/0x1d0()
[    3.683903] Modules linked in:
[    3.684006] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc2 #2

[    3.684176]  0000000000000009 ffffffff81c01de0 ffffffff816cfb15 
0000000000000000
[    3.684416]  ffffffff81c01e18 ffffffff81084abd 0000000000000000 
0000000000000001
[    3.684654]  0000000000000000 ffff88023da0b180 0000000000000010 
ffffffff81c01e28
[    3.684893] Call Trace:
[    3.684962]  [<ffffffff816cfb15>] dump_stack+0x45/0x56
[    3.685032]  [<ffffffff81084abd>] warn_slowpath_common+0x7d/0xa0
[    3.685102]  [<ffffffff81084b9a>] warn_slowpath_null+0x1a/0x20
[    3.685171]  [<ffffffff810050a8>] xen_mc_flush+0x1c8/0x1d0
[    3.685240]  [<ffffffff81008155>] xen_set_pgd+0x1f5/0x220
[    3.685310]  [<ffffffff8101975a>] init_espfix_this_cpu+0x36a/0x380
[    3.685379]  [<ffffffff813cb559>] ? acpi_tb_initialize_facs+0x31/0x33
[    3.685450]  [<ffffffff81d27ec6>] start_kernel+0x37f/0x411
[    3.685517]  [<ffffffff81d27950>] ? repair_env_string+0x5c/0x5c
[    3.685586]  [<ffffffff81d27606>] x86_64_start_reservations+0x2a/0x2c
[    3.685654]  [<ffffffff81d2a6df>] xen_start_kernel+0x594/0x5a0
[    3.685728] ---[ end trace a2cf2d7b2ecab826 ]---

But then I think we may want to rearrange preempt_enable/disable in 
xen_set_pgd().

-boris
