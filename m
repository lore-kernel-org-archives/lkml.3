Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbbAOQgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:36:33 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:43137 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbbAOQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:36:32 -0500
Message-ID: <54B7EC8D.5050505@imgtec.com>
Date: Thu, 15 Jan 2015 16:36:29 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        "Markos Chandras" <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>,
        "David Daney" <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 18/24] irqchip: mips-gic: Stop using per-platform mapping
 tables
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org> <1411076851-28242-19-git-send-email-abrestic@chromium.org> <54B7AB95.4080501@imgtec.com> <54B7EAE6.8040503@imgtec.com>
In-Reply-To: <54B7EAE6.8040503@imgtec.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 04:29 PM, James Hogan wrote:
> On 15/01/15 11:59, James Hogan wrote:
>> Hi Andrew,
>>
>> On 18/09/14 22:47, Andrew Bresticker wrote:
>>> Now that the GIC properly uses IRQ domains, kill off the per-platform
>>> routing tables that were used to make the GIC appear transparent.
>>>
>>> This includes:
>>>   - removing the mapping tables and the support for applying them,
>>>   - moving GIC IPI support to the GIC driver,
>>>   - properly routing the i8259 through the GIC on Malta, and
>>>   - updating IRQ assignments on SEAD-3 when the GIC is present.
>>>
>>> Platforms no longer will pass an interrupt mapping table to gic_init.
>>> Instead, they will pass the CPU interrupt vector (2 - 7) that they
>>> expect the GIC to route interrupts to.  Note that in EIC mode this
>>> value is ignored and all GIC interrupts are routed to EIC vector 1.
>>>
>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>> Acked-by: Jason Cooper <jason@lakedaemon.net>
>>> Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
>>> Tested-by: Qais Yousef <qais.yousef@imgtec.com>
>> This commit (18743d2781d01d34d132f952a2e16353ccb4c3de) appears to break
>> boot of interAptiv, dual core, dual vpe per core, on malta with
>> malta_defconfig.
>>
>> It gets to here:
>> ...
>> CPU1 revision is: 0001a120 (MIPS interAptiv (multi))
>> FPU revision is: 0173a000
>> Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
>> Primary data cache 64kB, 4-way, PIPT, no aliases, linesize 32 bytes
>> MIPS secondary cache 1024kB, 8-way, linesize 32 bytes.
>> Synchronize counters for CPU 1: done.
>> Brought up 2 CPUs
>>
>> and then appears to just hang. Passing nosmp works around it, allowing
>> it to get to userland.
>>
>> Is that a problem you've already come across?
>>
>> I'll keep debugging.
> Right, it appears the CPU IRQ line that the GIC is using doesn't get
> unmasked (STATUSF_IP2) when a new VPE is brought up, so only the first
> CPU will actually get any interrupts after your patch (including the
> rather critical IPIs), i.e. hacking it in vsmp_init_secondary() in
> smp-mt.c allows it to boot.
>
> Hmm, I'll have a think about what the most generic fix is, since
> arbitrary stuff may or may not have registered handlers for the raw CPU
> interrupts (timer, performance counter, gic etc)...
>
> Cheers
> James
>

Is this similar to the issue addressed by this (ff1e29ade4c6 MIPS: 
smp-cps: Enable all hardware interrupts on secondary CPUs)?

Qais
