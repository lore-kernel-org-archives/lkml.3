Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaFRUqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:46:42 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:33816 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbaFRUqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <201406182122.29623@pali>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com> <201406182122.29623@pali>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 18 Jun 2014 15:46:19 -0500
Message-ID: <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 2:22 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 18 June 2014 21:07:35 Rob Herring wrote:
>> On Wed, Jun 18, 2014 at 11:54 AM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>> > Machine name from board description is some generic name on
>> > DT kernel. DT provides machine name property which is
>> > specific for board, so use it instead generic one when
>> > possible.
>> >
>> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> > ---
>> >
>> >  arch/arm/kernel/setup.c |    7 +++++--
>> >  1 file changed, 5 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/arm/kernel/setup.c
>> > b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f 100644
>> > --- a/arch/arm/kernel/setup.c
>> > +++ b/arch/arm/kernel/setup.c
>> > @@ -875,10 +875,13 @@ void __init setup_arch(char
>> > **cmdline_p)
>> >
>> >         setup_processor();
>> >         mdesc = setup_machine_fdt(__atags_pointer);
>> >
>> > -       if (!mdesc)
>> > +       if (mdesc)
>> > +               machine_name =
>> > of_flat_dt_get_machine_name(); +       else
>> >
>> >                 mdesc = setup_machine_tags(__atags_pointer,
>> >                 __machine_arch_type);
>> >
>> >         machine_desc = mdesc;
>> >
>> > -       machine_name = mdesc->name;
>> > +       if (!machine_name)
>> > +               machine_name = mdesc->name;
>> >
>> >         if (mdesc->reboot_mode != REBOOT_HARD)
>> >
>> >                 reboot_mode = mdesc->reboot_mode;
>>
>> I did a similar patch previously[1]. Like my original patch,
>> your patch unconditionally changes the name which could be
>> considered part of the userspace ABI. It's arguably not good
>> practice for userspace to depend on the name, but there are
>> likely cases that do. So I think this needs to be optional
>> and only use the DT name if the machine desc name is NULL.
>>
>> So something like the below and then change the machine
>> descriptors you care about. The default generic DT machine
>> desc should definitely be changed.
>>
>> I had a follow-up discussion with Grant about his concerns in
>> the thread about knowing which machine desc used to boot. He
>> said he was okay if just the machine desc address is printed
>> out.
>>
>>
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index 50e198c..1479250 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -887,7 +887,7 @@ void __init setup_arch(char **cmdline_p)
>>         if (!mdesc)
>>                 mdesc = setup_machine_tags(__atags_pointer,
>> __machine_arch_type);
>>         machine_desc = mdesc;
>> -       machine_name = mdesc->name;
>> +       machine_name = mdesc->name ? mdesc->name :
>> of_flat_dt_get_machine_name();
>>
>>         if (mdesc->reboot_mode != REBOOT_HARD)
>>                 reboot_mode = mdesc->reboot_mode;
>>
>>
>> [1]
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-No
>> vember/208878.html
>
> Hi,
>
> now legacy board code for Nokia N900 (RX-51) is migrating to DT
> kernel and there is problem with info which /proc/cpuinfo reports

Thanks for providing your motivation which was missing from the commit message.

>
> New DT kernel (3.16-rc1) reports:
>
> # busybox cat /proc/cpuinfo
> processor       : 0
> model name      : ARMv7 Processor rev 3 (v7l)
> Features        : swp half thumb fastmult vfp edsp thumbee neon
> vfpv3 tls vfpd32
> CPU implementer : 0x41
> CPU architecture: 7
> CPU variant     : 0x2
> CPU part        : 0xc08
> CPU revision    : 3
>
> Hardware        : Generic OMAP3 (Flattened Device Tree)
> Revision        : 0000
> Serial          : 0000000000000000
>
> But legacy board code kernel reports:
>
> # busybox cat /proc/cpuinfo
> processor       : 0
> model name      : ARMv7 Processor rev 3 (v7l)
> Features        : swp half thumb fastmult vfp edsp thumbee neon
> vfpv3 tls vfpd32
> CPU implementer : 0x41
> CPU architecture: 7
> CPU variant     : 0x2
> CPU part        : 0xc08
> CPU revision    : 3
>
> Hardware        : Nokia RX-51 board
> Revision        : 0012
> Serial          : 0000000000000000
>
> Basically in DT kernel is missing Hardware, Revision and probably
> also Serial key. (Now I used only qemu for testing which set
> serial key to 0). All these informations is used by userspace
> applications which determinate how to behave.

It is somewhat fragile to expect the name in the DT to match the old
name from the kernel. As your patch to n900 dts shows, we'd probably
have to update every dts file to make them match. While I think we
should work to remove this string from the kernel, userspace depending
on the DT model string is a bad idea. For example, if you had some
platform with multiple OEMs just rebranding the same base design, they
may all want to put their own model string into each product. The true
h/w id is the compatible string.

Serial number is easy. There is already a standard although not widely
used property for it with "/serial-number". You just need to wire it
up to cpuinfo.

> So without this patch DT migration for Nokia N900 cannot be done
> without breaking userspace - which is not acceptable...

I agree, but I would like to come up with something that prevents
future dependence on this string.

> Also I still did not know why DT kernel does not report Revision
> number which is passed by bootloader via atags. Any idea?

Probably because no one cared until now and revision info for every
SOC is different. I would like to see revision info set in the DT in a
standard way and remove the various SOC specific kernel
implementations.

Rob
