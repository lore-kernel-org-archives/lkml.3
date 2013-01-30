Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3A3K40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:56:26 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34919 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3A3K4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:56:23 -0500
Message-ID: <5108FC31.3000507@ti.com>
Date: Wed, 30 Jan 2013 16:25:45 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Richard Cochran <richardcochran@gmail.com>, Matt Porter <mporter@ti.com>,
        Chase Maupin <chase.maupin@ti.com>, Jason Kridner <jdk@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com> <5107B650.5090901@ti.com> <3DE2C638-6AE8-4BC9-AD68-3AAA40CD6233@antoniou-consulting.com> <5108E1C6.9020201@ti.com> <0FB10FF4-6639-472E-943C-61CEDB0336E0@antoniou-consulting.com>
In-Reply-To: <0FB10FF4-6639-472E-943C-61CEDB0336E0@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2013 3:06 PM, Pantelis Antoniou wrote:
> Hi,
>
> On Jan 30, 2013, at 11:03 AM, Mugunthan V N wrote:
>
>> On 1/30/2013 2:06 PM, Pantelis Antoniou wrote:
>>> Hi Mugunthan,
>>>
>>> On Jan 29, 2013, at 1:45 PM, Mugunthan V N wrote:
>>>
>>>> On 1/28/2013 6:41 PM, Pantelis Antoniou wrote:
>>>>> Fix interrupt storm on bone A4 cause by non-by-the-book interrupt handling.
>>>>> While at it, added a non-NAPI mode (which is easier to debug), plus
>>>>> some general fixes.
>>>>>
>>>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>>>> ---
>>>>>   Documentation/devicetree/bindings/net/cpsw.txt |   1 +
>>>>>   drivers/net/ethernet/ti/cpsw.c                 | 222 +++++++++++++++++++++----
>>>>>   drivers/net/ethernet/ti/davinci_cpdma.c        |   4 +-
>>>>>   drivers/net/ethernet/ti/davinci_cpdma.h        |   2 +-
>>>>>   include/linux/platform_data/cpsw.h             |   1 +
>>>>>   5 files changed, 194 insertions(+), 36 deletions(-)
>>>> I have tested CPSW on AM335x EVM 1.5A with flood ping and i am not
>>>> seeing any interrupt storm.
>>>> Can you provide more details on how to reproduce the issue.
>>>>
>>> A beaglebone prototype with the new silicon version, with the ethernet errata
>>> fixed displays this. You can't trigger it on old silicon.
>>>
>>> The TI people on the CC list can confirm.
>> But i have the same silicon revision (PG2.0) in my EVM and I am not seeing any issues. Can you
>> point me to the ethernet errata which you are mentioning?
>>
>> Regards
>> Mugunthan V N
> What kernel version are you using? This is only triggered on the mainline driver.
>
> The advisory in question: From http://www.ti.com/lit/er/sprz360c/sprz360c.pdf
>
> Advisory 1.0.9: "Ethernet Media Access Controller and Switch Subsystem: C0_TX_PEND
> and C0_RX_PEND Interrupts Not Connected to ARM Cortex-A8"
>
> I bet you're using an old kernel driver with the workarounds with the timers.
>
> If I had to guess (although I didn't use a probe or anything) is that the
> interrupts are now proper level interrupts, instead of working in edge
> triggered mode due to the workaround.
>
> Apparently the interrupt was never acked properly in the original driver
> (the sequence described in the TRM is not followed).
>
> Looking at the TRM (spruh73g.pdf) 14.3.1.3 Interrupts in particular, the
> the status registers are not read, and more damning the proper values to the
> CPDMA_EOI_VECTOR register are not written.
>
> The original driver blindly wrote zero (cpdma_ctlr_eoi), while you have to
> write different values according to the interrupt you ack.
>
> What happened was that on the first interrupt, the interrupt was never acked,
> and we had an irq storm...
>
> Regards
>
> -- Pantelis
The above mentioned advisory is for PG1.0 and not for PG2.0
I am booting net-next kernel.

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.8.0-rc5-01248-gd2ed273 
(a0131834@a0131834-linux) (gcc version 4.5.3 20110311 (prerelease) (GCC) 
) #21 SMP Wed Jan 30 163
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), 
cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing 
instruction cache

[root@arago /]# uname -a
Linux arago 3.8.0-rc5-01248-gd2ed273 #21 SMP Wed Jan 30 16:13:26 IST 
2013 armv7l GNU/Linux

In theory what you are mentioning is correct. I have a beagle bone black 
and yet to try it.

Regards
Mugunthan V N
