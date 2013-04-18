Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966621Ab3DRIsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:48:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34564 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965897Ab3DRIsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <bb1193983de3ea9f4df1a570441df34c@localhost>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<ede8ee08bb2616c2ed642200e3357367@localhost>
	<CAAHg+HhajHFC=1nh6YQNgpf=Na2FqcsYJ=t+ag9QiTg6TxUz9w@mail.gmail.com>
	<bb1193983de3ea9f4df1a570441df34c@localhost>
Date: Thu, 18 Apr 2013 14:18:49 +0530
Message-ID: <CAAHg+HhtCorArCmx=ha0=64+SJZiizzrDUKSPLV=N+OzO8zAxQ@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linaro-kernel@lists.linaro.org, Anup Patel <anup.patel@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On 18 April 2013 13:06, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Thu, 18 Apr 2013 12:47:18 +0530, Pranavkumar Sawargaonkar
> <pranavkumar@linaro.org> wrote:
>> Hi Marc,
>>
>> On 18 April 2013 12:19, Marc Zyngier <maz@misterjones.org> wrote:
>>
>>> Hi Pranavkumar,
>>>
>>> On Thu, 18 Apr 2013 11:22:24 +0530, PranavkumarSawargaonkar
>>> <pranavkumar@linaro.org> wrote:
>>> > From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>> >
>>> > This patch implements early printk support for virtio-mmio console
>>> devices
>>> > without using any hypercalls.
>>> >
>>> > The current virtio early printk code in kernel expects that
> hypervisor
>>> > will provide some mechanism generally a hypercall to support early
>>> printk.
>>> > This patch does not break existing hypercall based early print
> support.
>>> >
>>> > This implementation adds:
>>> > 1. Early read-write register named early_rw in virtio console's
> config
>>> > space.
>>> > 2. Two host feature flags namely VIRTIO_CONSOLE_F_EARLY_READ and
>>> > VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-read and
>>> > early-write capability in console device.
>>> >
>>> > Early write mechanism:
>>> > 1. When a guest wants to out some character, it has to simply write
> the
>>> > character to early_rw register in config space of virtio console
>>> > device.
>>> >
>>> > Early read mechanism:
>>> > 1. When a guest wants to in some character, it has to simply read the
>>> > early_rw register in config space of virtio console device. Lets say
> we
>>> get
>>> > 32-bit value X.
>>> > 2. If most significant bit of X is set (i.e. X & 0x80000000 ==
>>> 0x80000000)
>>> > then least significant 8 bits of X represents input charaacter else
>>> guest
>>> > need to try again reading early_rw register.
>>> >
>>> > Note: This patch only includes kernel side changes for early printk,
>>> > the
>>> > host/hypervisor side emulation of early_rw register is out of scope
>>> here.
>>>
>>> Well, that's unfortunate, as it makes it quite difficult to understand
>>> the
>>> impact of this patch.
>>> Has the virtio side been posted somewhere? I expect you've implemented
>>> something in kvmtool...
>>>
>>
>> Yes i have implemented kvmtool side also and code change is really small
>> (not really a clean code currently)
>> I can post it also but since it is specific to kvmtool i have not posted
> it
>> with rfc.
>
> Doesn't really if the code needs some rework at this point (I expect the
> patch to be fairly small indeed). Any chance you could post it to the KVM
> list?
Yeah patch is very small, i will post it on kvm list. I have tested
patch on foundation model.
>
>>>
>>> > Signed-off-by: Anup Patel <anup.patel@linaro.org>
>>> > ---
>>> >  arch/arm64/kernel/early_printk.c    |   24 ++++++++++++++++++++++++
>>> >  include/uapi/linux/virtio_console.h |    4 ++++
>>> >  2 files changed, 28 insertions(+)
>>> >
>>> > diff --git a/arch/arm64/kernel/early_printk.c
>>> > b/arch/arm64/kernel/early_printk.c
>>> > index ac974f4..a82b5aa 100644
>>> > --- a/arch/arm64/kernel/early_printk.c
>>> > +++ b/arch/arm64/kernel/early_printk.c
>>> > @@ -25,6 +25,9 @@
>>> >
>>> >  #include <linux/amba/serial.h>
>>> >  #include <linux/serial_reg.h>
>>> > +#include <linux/virtio_ids.h>
>>> > +#include <linux/virtio_mmio.h>
>>> > +#include <linux/virtio_console.h>
>>> >
>>> >  static void __iomem *early_base;
>>> >  static void (*printch)(char ch);
>>> > @@ -53,6 +56,26 @@ static void smh_printch(char ch)
>>> >  }
>>> >
>>> >  /*
>>> > + * VIRTIO MMIO based debug console.
>>> > + */
>>> > +static void virtio_console_early_printch(char ch)
>>> > +{
>>> > +     u32 tmp;
>>> > +     struct virtio_console_config *p = early_base +
>>> > VIRTIO_MMIO_CONFIG;
>>> > +
>>> > +     tmp = readl_relaxed(early_base + VIRTIO_MMIO_DEVICE_ID);
>>> > +     if (tmp != VIRTIO_ID_CONSOLE) {
>>> > +             return;
>>> > +     }
>>> > +
>>> > +     tmp = readl_relaxed(early_base + VIRTIO_MMIO_HOST_FEATURES);
>>> > +     if (!(tmp & (1 << VIRTIO_CONSOLE_F_EARLY_WRITE))) {
>>> > +             return;
>>> > +     }
>>> > +     writeb_relaxed(ch, &p->early_rw);
>>>
>>> So here, you end up trapping 3 times per character being output on the
>>> console. Surely there's a better way. How about remembering the result
> of
>>> these tests in a static variable?
>>>
>> Yeah surely it is a better idea to remember using static variable, so
> that
>> after initialize once, it will trap only one time.
>
> Also, would it be possible to directly get the base address from DT? It
> would save having to pass the address (which is not known before runtime in
> the case of kvmtool). Not sure if it is available that early though...

Early printk code initializes earlier (from  parse_early_param in
arch/arm64/setup.c) than fdt un-flattened call (unflatten_device_tree)
. Hence using dts to pass this is not possible for passing the
address.

>
>>>
>>> > +}
>>> > +
>>> > +/*
>>> >   * 8250/16550 (8-bit aligned registers) single character TX.
>>> >   */
>>> >  static void uart8250_8bit_printch(char ch)
>>> > @@ -82,6 +105,7 @@ static const struct earlycon_match
> earlycon_match[]
>>> > __initconst = {
>>> >       { .name = "smh", .printch = smh_printch, },
>>> >       { .name = "uart8250-8bit", .printch = uart8250_8bit_printch, },
>>> >       { .name = "uart8250-32bit", .printch = uart8250_32bit_printch,
> },
>>> > +     { .name = "virtio-console", .printch =
>>> virtio_console_early_printch,
>>> },
>>> >       {}
>>> >  };
>>> >
>>> > diff --git a/include/uapi/linux/virtio_console.h
>>> > b/include/uapi/linux/virtio_console.h
>>> > index ee13ab6..1171cb4 100644
>>> > --- a/include/uapi/linux/virtio_console.h
>>> > +++ b/include/uapi/linux/virtio_console.h
>>> > @@ -38,6 +38,8 @@
>>> >  /* Feature bits */
>>> >  #define VIRTIO_CONSOLE_F_SIZE        0       /* Does host provide
>>> console size? */
>>> >  #define VIRTIO_CONSOLE_F_MULTIPORT 1 /* Does host provide multiple
>>> ports?
>>> >  */
>>> > +#define VIRTIO_CONSOLE_F_EARLY_READ 2        /* Does host support
>>> > early
>>> read?
>>> */
>>> > +#define VIRTIO_CONSOLE_F_EARLY_WRITE 3       /* Does host support
>>> > early
>>> write?
>>> > */
>>> >
>>> >  #define VIRTIO_CONSOLE_BAD_ID                (~(u32)0)
>>> >
>>> > @@ -48,6 +50,8 @@ struct virtio_console_config {
>>> >       __u16 rows;
>>> >       /* max. number of ports this device can hold */
>>> >       __u32 max_nr_ports;
>>> > +     /* early read/write register */
>>> > +     __u32 early_rw;
>>> >  } __attribute__((packed));
>>> >
>>> >  /*
>>>
>>> So that bit is clearly a spec change. How does it work with PCI, or any
>>> other virtio transport?
>>>
>> I am not sure about PCI hence just posted for MMIO.
>>
>>>
>>> Overall, I'm a bit concerned with adding features that don't really
> match
>>> the way virtio is supposed to work. The whole goal of virtio is to
>>> minimize
>>> the amount of trapping, and here you end up trapping on each and every
>>> access.
>>>
>>> If you need an early console, why not simply wire the 8250 emulation in
>>> kvmtool to be useable from the MMIO bus? I reckon this would solve your
>>> problem in a more elegant way...
>>>
>> Emulation will solve the issue but having a virtio early read or write
> has
>> one more advantage i.e.
>> In case of mach-virt we might need early read-write support for virtio
>> console to see if kernel is not panic before actual virtio drivers takes
>> control.
>> Also if someone wants to have UEFI or uboot running on mach-virt then we
>> also need early input facility in virtio console.
>
> That's exactly why I was suggesting using the 8250 emulation. It is
> supported by everything under the sun. I do not immediately see what the
> gain is with this virtio approach, as compared to 8250 emulation.
>
> Don't misunderstand me, I like the idea of having a virtio-only system,
Definitely not.
> specially if we can make it work with other transports. I just want to
> outline that there may be a simpler way for your particular use case.

Actually i thought adding a config register will be easier to add a
code than writing entire emulation as 8250 emulation will require to
deal with dealing with more registers and more code.

Thanks,
Pranav

>
> Thanks,
>
>         M.
> --
> Fast, cheap, reliable. Pick two.
