Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaKQUfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:35:39 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58326 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaKQUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:35:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAOiHx=mGzPKO4N7KR+5FM1RfFDF+-wncdBz6PavR0q47Gtd2Jg@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <1416097066-20452-23-git-send-email-cernekee@gmail.com> <CAOiHx=mGzPKO4N7KR+5FM1RfFDF+-wncdBz6PavR0q47Gtd2Jg@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 17 Nov 2014 12:35:15 -0800
Message-ID: <CAJiQ=7AMiRq8rbLmsKe0s9+vr91BRrL4s3mZWcsVgyS0bLgThw@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Jonas Gorski <jogo@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 6:44 AM, Jonas Gorski <jogo@openwrt.org> wrote:
> On Sun, Nov 16, 2014 at 1:17 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
>> bmips_be_defconfig supports Linux running on the following CM and DSL
>> SoCs:
>>
>>  - BCM3384 (BMIPS5000) cable modem application processor, BE, SMP
>>  - BCM3384 (BMIPS4355) cable modem "spare CPU"*, BE
>>  - BCM6328 (BMIPS4355) ADSL chip, BE
>
> Is BMIPS435*5* intentional? I would have assumed at least 6328 is also
> MIPS4350 like BCM6368.

Welcome back Jonas - and thanks for reviewing :-)

According to my cheat sheet, BCM6328 has the newer BMIPS4355 core,
which includes the "DMA" features used for prefetching packet data.
BCM6368 has the old BMIPS4350.

>> diff --git a/Documentation/devicetree/bindings/mips/brcm/bmips.txt b/Documentation/devicetree/bindings/mips/brcm/bmips.txt
>> new file mode 100644
>> index 0000000..4a8cd8f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mips/brcm/bmips.txt
>> @@ -0,0 +1,8 @@
>> +* Broadcom MIPS (BMIPS) CPUs
>> +
>> +Required properties:
>> +- compatible: "brcm,bmips3300", "brcm,bmips4350", "brcm,bmips4380"
>> +              "brcm,bmips5000"
>> +
>> +- mips-hpt-frequency: This is common to all CPUs in the system so it lives
>> +  under the "cpus" node.
>
> Is it a good idea to hardcode this? Some SoC CPUs allow running with
> different frequencies, which will directly affect this.

On some of the BCM7xxx kernels there is a timer peripheral that always
runs at 27 MHz.  It is used to derive the CPU frequency at runtime, so
no hardcoding is necessary:

https://github.com/BlackPole/vuplus-kernel/blob/master/arch/mips/brcmstb/time.c#L119

On a generic BMIPS kernel it might be harder to rely on an external timer.

Is there a better solution (or should we implement some sort of
fallback if the mips-hpt-frequency property is missing)?

> Also I would
> assume this would break once we add support for runtime clock changes
> for BMIPS; at least on the DSL platform you can change the clock
> between 1/4 (IIRC) and 1/1 for power saving.

I don't know the 435x's very well, but I believe all BMIPS CPUs allow
selecting between 1:1, 1:2, 1:4, and 1:8.  BMIPS5000 also allows 1:16.

FWIW, this feature is unstable on several of the 40nm chips.

Also, some older versions of the core (65nm, 130nm) scaled down the
MIPS CP0 counter frequency when the base clock changed.  The newer
BMIPS438x cores, and all BMIPS5000 cores, do not.  CP0 $22,0 bit 6 on
BMIPS438x should be '1' if the counter frequency is fixed.  Not sure
about BMIPS435x.

We will have to put some thought into implementing cpufreq in a generic way...

>> +SoCs:
>> +
>> +Required properties:
>> +- compatible: "brcm,bcm3384", "brcm,bcm33843"
>> +              "brcm,bcm3384-viper", "brcm,bcm33843-viper"
>> +              "brcm,bcm6328", "brcm,bcm6368",
>> +              "brcm,bcm7125", "brcm,bcm7346", "brcm,bcm7360",
>> +              "brcm,bcm7420", "brcm,bcm7425"
>> +
>> +Boards:
>> +
>> +Required properties:
>> +- compatible: "brcm,bcm93384wvg", "brcm,bcm93384wvg-viper"
>> +              "brcm,bcm9ejtagprb", "brcm,bcm96368mvwg",
>> +              "brcm,bcm97125cbmb", "brcm,bcm97346dbsmb", "brcm,bcm97360svmb",
>> +              "brcm,bcm97420c", "brcm,bcm97425svmb"
>
> Should the list of supported boards really be hardcoded here/in the
> kernel? It doesn't match what the code does, as it (as far as I can
> tell) accepts dtbs without any of the board compatible ids when passed
> from bootloader.

Honestly I'd prefer to nuke them from the bindings doc.  But
checkpatch was complaining that they were undocumented.

Any opinions?

>> +extern char __dtb_bcm9ejtagprb_begin;
>> +extern char __dtb_bcm96368mvwg_begin;
>> +extern char __dtb_bcm97125cbmb_begin;
>> +extern char __dtb_bcm97346dbsmb_begin;
>> +extern char __dtb_bcm97360svmb_begin;
>> +extern char __dtb_bcm97420c_begin;
>> +extern char __dtb_bcm97425svmb_begin;
>
> I think it would be a good idea to have the embedded dtbs optional,
> especially if you already provide an interface for passing a dtb
> pointer.

So, our options include:

1) Use a bool option for each one; leave the setup.c heuristic logic
in place.  Multiplatform kernels still work with existing bootloaders.
Need a bunch of new #ifdefs in this section of code.

2) Use a choice option to allow one DTS file (or no DTS file) to be compiled in.

3) Forbid compiling in DTS files; make people use a sensible
bootloader or wrapper.

4) Leave everything as-is.

The short term plan can be different from the long term plan.

What does everyone prefer?

>> +static void __init *find_dtb(void)
>> +{
>> +       u32 chip_id;
>> +       char boardname[64] = "";
>> +       const struct bmips_board_list *b;
>> +
>> +       /* Intended to somewhat resemble ARM; see Documentation/arm/Booting */
>> +       if (fw_arg0 == 0 && fw_arg1 == 0xffffffff)
>> +               return phys_to_virt(fw_arg2);
>
> I know a bit late, but how about using the OF_DT_MAGIC (0xd00dfeed)
> for indicating that there is a device tree in arg2?

No preference either way.  Should we stick with the ARM convention, or
use a more unique magic number?

>> +       /*
>> +        * Unfortunately the CFE API doesn't seem to provide chip
>> +        * identification, but we can check the entry point to see whether
>> +        * the current platform is a DSL chip or STB chip.  On STB,
>> +        * CAE_STKSIZE = _regidx(13) = 13*8 = 104, so the first instruction is:
>> +        * 0:   23bdff98        addi    sp,sp,-104
>> +        */
>> +       if (__raw_readl((void *)fw_arg2) == 0x23bdff98) {
>> +               chip_id = __raw_readl(REG_STB_CHIP_ID);
>> +               cfe_init(fw_arg0, fw_arg2);
>> +               cfe_getenv("CFE_BOARDNAME", boardname, sizeof(boardname));
>> +       } else {
>> +               /*
>> +                * This works on most modern chips, but will break on older
>> +                * ones like 6358
>> +                */
>> +               chip_id = __raw_readl(REG_DSL_CHIP_ID);
>
> Unfortunately I don't know any good way to discriminate between the
> "old" and the "new" chips except by looking a the PRID and REV
> (BMIPS3300 <= 3.2 || BMIPS4350 <= 1.0 => 0xfff00000, BMIPS3300 >= 3.3
> || BMIPS4350 >= 3.0 => 0xb0000000).

I suspect that if somebody is motivated to support the older chips in
arch/mips/bmips, our setup.c will start borrowing the existing bcm63xx
logic.

OTOH this could also be an opportunity to drop obsolete platforms that
have a small number of users or a large number of hacks.

>
>> +       }
>> +
>> +       /* 4-digit parts use bits [31:16]; 5-digit parts use [27:8] */
>
> This might be true for the STB chips, but the DSL 5-digit parts use
> [31:12]. And to add insult to insury, some 4-digit parts use [15:12]
> for the chip variant, so you can't just check [15:12] for 0 or != 0
> either (I would assume 63381 and 6328 (variant 63281) will have both 1
> at [15:12].

How unfortunate.  A lot of effort/persuasion went into standardizing
this format on STB.

I can change this to use a value/mask test for non-STB?

My 6328 says:

# devmem 0x10000000
0x632830B0

Will need to double check our 6329's (I think their upper halfword is
still 0x6328).

>> +       if (chip_id & 0xf0000000)
>> +               chip_id >>= 16;
>> +       else
>> +               chip_id >>= 8;
>> +
>> +       for (b = bmips_board_list; b->dtb; b++) {
>> +               if (b->chip_id != chip_id)
>> +                       continue;
>> +               if (b->boardname && strcmp(b->boardname, boardname))
>> +                       continue;
>> +               if (b->quirk_fn)
>> +                       b->quirk_fn();
>
> Hmm, maybe move running the quirk out of here and into
> plat_mem_setup()? Currently e.g. a BCM6328 with a bootloader passed
> dtb won't have its quirk run.

Good idea.  My current line of thinking is to restructure quirks into
its own table, indexed by the compatible string.

>> +int __init plat_of_setup(void)
>> +{
>> +       return __dt_register_buses("brcm,bmips", "simple-bus");
>
> Huh, "brcm,bmips" does not appear anywhere else. How does this work?
> Should this be a required compatible?

I saw other platforms passing in strings like "lantiq,falcon" and did
likewise...

I can experiment with removing that bus registration entirely to see
what happens.

> Minor stilistic nitpick: I would use
>
> dtb-$(CONFIG_BMIPS_MULTIPLATFORM)      += \
>                                           bcm93384wvg.dtb \
>
> so that adding a board before bcm963384wvg would only require an
> insert, not also a modification.

OK

>> diff --git a/arch/mips/boot/dts/bcm3384_common.dtsi b/arch/mips/boot/dts/bcm3384_common.dtsi
>> new file mode 100644
>> index 0000000..448cb5b
>> --- /dev/null
>> +++ b/arch/mips/boot/dts/bcm3384_common.dtsi
>> @@ -0,0 +1,44 @@
>> +/ {
>> +       clocks {
>> +               #address-cells = <1>;
>
> This does not really make sense, as there is no address used at all
> for the periph_clk.
>
>> +               #size-cells = <0>;
>> +
>> +               periph_clk: periph_clk@0 {
>
> Same for the @0 - there is no appropriate reg = <0>, so using an
> address here does not make sense.

OK

>> diff --git a/arch/mips/boot/dts/bcm6328.dtsi b/arch/mips/boot/dts/bcm6328.dtsi
>> new file mode 100644
>> index 0000000..a7e397f
>> --- /dev/null
>> +++ b/arch/mips/boot/dts/bcm6328.dtsi
>> @@ -0,0 +1,63 @@
>> +/ {
>> +       #address-cells = <1>;
>> +       #size-cells = <1>;
>> +       compatible = "brcm,bcm6328";
>> +
>> +       cpus {
>> +               #address-cells = <1>;
>> +               #size-cells = <0>;
>> +
>> +               mips-hpt-frequency = <160000000>;
>> +
>> +               cpu@0 {
>> +                       compatible = "brcm,bmips4350";
>> +                       device_type = "cpu";
>> +                       reg = <0>;
>> +               };
>
> Since there are SMP-enabled variants, maybe it should have its second
> thread documented here (but defaulting to "disabled")?

That looks like a goof.  There is code in setup.c that knows whether
to enable/disable CPU1 on 6328 based on OTP.  Will fix.

>> +       cpu_intc: cpu_intc@0 {
>
> It does not have an address, so it should not have @0 in the node name I think.

I have no preference either way, but
Documentation/devicetree/bindings/mips/cpu_irq.txt has the "@0".

>
>> +               #address-cells = <0>;
>> +               compatible = "mti,cpu-interrupt-controller";
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <1>;
>> +       };
>> +
>> +       periph_intc: periph_intc@10000024 {
>> +               compatible = "brcm,bcm7120-l2-intc";
>> +               reg = <0x10000024 0x4 0x1000002c 0x4
>> +                      0x10000020 0x4 0x10000028 0x4>;
>
> The "lowest" register address you use is 0x10000020, so the name
> should arguably be periph_intc@10000020, not periph_intc@10000024. I
> guess the second cpu block (10000030 - 1000003c) wired to hw irq 3 can
> be added later.

OK

> This will easily translate to a lot of io(re)map calls in case of
> 63268/6318 when describing both cpu blocks ( a total of 16 "reg"s).
>
> Also I wonder how you properly describe the intc of 63381, where it
> has separate mask registers, but a shared status register.

If you aren't putting any IRQs on CPU1 you can probably get away with
only mentioning the status register once, for now.

irq-bcm7120-l2.c will need some additional work before it can handle
multiple CPUs.
