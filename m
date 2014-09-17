Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaIQQgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:36:11 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:33414 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaIQQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <54194CB9.4010200@imgtec.com>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
	<1410825087-5497-4-git-send-email-abrestic@chromium.org>
	<54194CB9.4010200@imgtec.com>
Date: Wed, 17 Sep 2014 09:36:06 -0700
X-Google-Sender-Auth: l9jw2oDJEcwK8g8o3aSJ81TQt28
Message-ID: <CAL1qeaGNF_8XNTQiWomiJjbuN0mVgayFNKWfMVzrd=bBtwEY7g@mail.gmail.com>
Subject: Re: [PATCH 03/24] MIPS: Provide a generic plat_irq_dispatch
From: Andrew Bresticker <abrestic@chromium.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 1:56 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
> Hi Andrew,
>
>
> On 09/16/2014 12:51 AM, Andrew Bresticker wrote:
>>
>> For platforms which boot with device-tree or have correctly chained
>> all external interrupt controllers, a generic plat_irq_dispatch() can
>> be used.  Implement a plat_irq_dispatch() which simply handles all the
>> pending interrupts as reported by C0_Cause.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>   arch/mips/kernel/irq_cpu.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
>> index ca98a9f..f17bd08 100644
>> --- a/arch/mips/kernel/irq_cpu.c
>> +++ b/arch/mips/kernel/irq_cpu.c
>> @@ -94,6 +94,21 @@ static struct irq_chip mips_mt_cpu_irq_controller = {
>>         .irq_eoi        = unmask_mips_irq,
>>   };
>>   +asmlinkage void __weak plat_irq_dispatch(void)
>> +{
>> +       unsigned long pending = read_c0_cause() & read_c0_status() &
>> ST0_IM;
>> +       int irq;
>> +
>> +       if (!pending) {
>> +               spurious_interrupt();
>> +               return;
>> +       }
>> +
>> +       pending >>= CAUSEB_IP;
>> +       for_each_set_bit(irq, &pending, 8)
>> +               do_IRQ(MIPS_CPU_IRQ_BASE + irq);
>> +}
>> +
>
>
> If I read the for_each_set_bit() macro correctly it'll iterate through the
> bits from least to most significant ones which is the reversed priority
> expected. Some platforms set timer interrupt to bit 7 which is should be the
> highest priority interrupt. Also when cpu_has_vint is set the hardware
> prioritirise from most significant to least significant bits so if
> plat_irq_dispatch() is used with set_vi_handler() it'll cause interrupts to
> be serviced in the wrong order.

Ah, right.  I'll flip the order here.
