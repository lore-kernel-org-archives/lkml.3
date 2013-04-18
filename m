Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866Ab3DRHYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:24:52 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:39984 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073Ab3DRHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <ede8ee08bb2616c2ed642200e3357367@localhost>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<ede8ee08bb2616c2ed642200e3357367@localhost>
Date: Thu, 18 Apr 2013 12:54:50 +0530
Message-ID: <CAAHg+HhMmu5VZi=mhqgwBHGE=i+DsC8eA=iMzkNorB4LrTHBjQ@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linaro-kernel@lists.linaro.org, Anup Patel <anup.patel@linaro.org>,
        patches@linaro.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On 18 April 2013 12:19, Marc Zyngier <maz@misterjones.org> wrote:
> Hi Pranavkumar,
>
> On Thu, 18 Apr 2013 11:22:24 +0530, PranavkumarSawargaonkar
> <pranavkumar@linaro.org> wrote:
>> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>
>> This patch implements early printk support for virtio-mmio console
> devices
>> without using any hypercalls.
>>
>> The current virtio early printk code in kernel expects that hypervisor
>> will provide some mechanism generally a hypercall to support early
> printk.
>> This patch does not break existing hypercall based early print support.
>>
>> This implementation adds:
>> 1. Early read-write register named early_rw in virtio console's config
>> space.
>> 2. Two host feature flags namely VIRTIO_CONSOLE_F_EARLY_READ and
>> VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-read and
>> early-write capability in console device.
>>
>> Early write mechanism:
>> 1. When a guest wants to out some character, it has to simply write the
>> character to early_rw register in config space of virtio console device.
>>
>> Early read mechanism:
>> 1. When a guest wants to in some character, it has to simply read the
>> early_rw register in config space of virtio console device. Lets say we
> get
>> 32-bit value X.
>> 2. If most significant bit of X is set (i.e. X & 0x80000000 ==
> 0x80000000)
>> then least significant 8 bits of X represents input charaacter else
> guest
>> need to try again reading early_rw register.
>>
>> Note: This patch only includes kernel side changes for early printk, the
>> host/hypervisor side emulation of early_rw register is out of scope
> here.
>
> Well, that's unfortunate, as it makes it quite difficult to understand the
> impact of this patch.
> Has the virtio side been posted somewhere? I expect you've implemented
> something in kvmtool...

Yes i have implemented kvmtool side also and code change is really
small (not really a clean code currently)
I can post it also but since it is specific to kvmtool i have not
posted it with rfc.

>
>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>> ---
>>  arch/arm64/kernel/early_printk.c    |   24 ++++++++++++++++++++++++
>>  include/uapi/linux/virtio_console.h |    4 ++++
>>  2 files changed, 28 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/early_printk.c
>> b/arch/arm64/kernel/early_printk.c
>> index ac974f4..a82b5aa 100644
>> --- a/arch/arm64/kernel/early_printk.c
>> +++ b/arch/arm64/kernel/early_printk.c
>> @@ -25,6 +25,9 @@
>>
>>  #include <linux/amba/serial.h>
>>  #include <linux/serial_reg.h>
>> +#include <linux/virtio_ids.h>
>> +#include <linux/virtio_mmio.h>
>> +#include <linux/virtio_console.h>
>>
>>  static void __iomem *early_base;
>>  static void (*printch)(char ch);
>> @@ -53,6 +56,26 @@ static void smh_printch(char ch)
>>  }
>>
>>  /*
>> + * VIRTIO MMIO based debug console.
>> + */
>> +static void virtio_console_early_printch(char ch)
>> +{
>> +     u32 tmp;
>> +     struct virtio_console_config *p = early_base + VIRTIO_MMIO_CONFIG;
>> +
>> +     tmp = readl_relaxed(early_base + VIRTIO_MMIO_DEVICE_ID);
>> +     if (tmp != VIRTIO_ID_CONSOLE) {
>> +             return;
>> +     }
>> +
>> +     tmp = readl_relaxed(early_base + VIRTIO_MMIO_HOST_FEATURES);
>> +     if (!(tmp & (1 << VIRTIO_CONSOLE_F_EARLY_WRITE))) {
>> +             return;
>> +     }
>> +     writeb_relaxed(ch, &p->early_rw);
>
> So here, you end up trapping 3 times per character being output on the
> console. Surely there's a better way. How about remembering the result of
> these tests in a static variable?

Yeah surely it is a better idea to remember using static variable, so
that after initialize once, it will trap only one time.

>
>> +}
>> +
>> +/*
>>   * 8250/16550 (8-bit aligned registers) single character TX.
>>   */
>>  static void uart8250_8bit_printch(char ch)
>> @@ -82,6 +105,7 @@ static const struct earlycon_match earlycon_match[]
>> __initconst = {
>>       { .name = "smh", .printch = smh_printch, },
>>       { .name = "uart8250-8bit", .printch = uart8250_8bit_printch, },
>>       { .name = "uart8250-32bit", .printch = uart8250_32bit_printch, },
>> +     { .name = "virtio-console", .printch = virtio_console_early_printch,
> },
>>       {}
>>  };
>>
>> diff --git a/include/uapi/linux/virtio_console.h
>> b/include/uapi/linux/virtio_console.h
>> index ee13ab6..1171cb4 100644
>> --- a/include/uapi/linux/virtio_console.h
>> +++ b/include/uapi/linux/virtio_console.h
>> @@ -38,6 +38,8 @@
>>  /* Feature bits */
>>  #define VIRTIO_CONSOLE_F_SIZE        0       /* Does host provide console size? */
>>  #define VIRTIO_CONSOLE_F_MULTIPORT 1 /* Does host provide multiple
> ports?
>>  */
>> +#define VIRTIO_CONSOLE_F_EARLY_READ 2        /* Does host support early read?
> */
>> +#define VIRTIO_CONSOLE_F_EARLY_WRITE 3       /* Does host support early
> write?
>> */
>>
>>  #define VIRTIO_CONSOLE_BAD_ID                (~(u32)0)
>>
>> @@ -48,6 +50,8 @@ struct virtio_console_config {
>>       __u16 rows;
>>       /* max. number of ports this device can hold */
>>       __u32 max_nr_ports;
>> +     /* early read/write register */
>> +     __u32 early_rw;
>>  } __attribute__((packed));
>>
>>  /*
>
> So that bit is clearly a spec change. How does it work with PCI, or any
> other virtio transport?
>
> Overall, I'm a bit concerned with adding features that don't really match
> the way virtio is supposed to work. The whole goal of virtio is to minimize
> the amount of trapping, and here you end up trapping on each and every
> access.
>
> If you need an early console, why not simply wire the 8250 emulation in
> kvmtool to be useable from the MMIO bus? I reckon this would solve your
> problem in a more elegant way...
>
Emulation will solve the issue but having a virtio early read or write
has one more advantage i.e.
In case of mach-virt we might need early read-write support for virtio
console to see if kernel is not panic before actual virtio drivers
takes control.
Also if someone wants to have UEFI or uboot running on mach-virt then
we also need early input facility in virtio console.

> Cheers,
>
>         M.
> --
> Who you jivin' with that Cosmik Debris?

Thanks,
Pranav
