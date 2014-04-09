Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaDINSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:18:32 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:56967 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaDINS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:18:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140409113246.GA8778@pd.tnic>
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com>
	<a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
	<20140409113246.GA8778@pd.tnic>
Date: Wed, 9 Apr 2014 08:18:28 -0500
Message-ID: <CAL_Jsq+gszc+R_BrLtHKEBGYd=3T+sE1d+-HoF9aYZt6C2k5-g@mail.gmail.com>
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
From: Rob Herring <robherring2@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        Doug Thompson <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        punnaia@xilinx.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 6:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Mar 02, 2014 at 08:02:40PM +0530, Punnaiah Choudary Kalluri wrote:
>> Add support for ARM Pl310 L2 cache controller parity error
>>
>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>> ---
>>  .../devicetree/bindings/edac/pl310_edac_l2.txt     |   19 ++
>>  drivers/edac/Kconfig                               |    7 +
>>  drivers/edac/Makefile                              |    1 +
>>  drivers/edac/pl310_edac_l2.c                       |  236 ++++++++++++++++++++
>>  4 files changed, 263 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
>>  create mode 100644 drivers/edac/pl310_edac_l2.c
>>
>> diff --git a/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt b/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
>> new file mode 100644
>> index 0000000..94fbb8d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
>> @@ -0,0 +1,19 @@
>> +Pl310 L2 Cache EDAC driver, it does reports the data and tag ram parity errors.
>> +
>> +Required properties:
>> +- compatible: Should be "arm,pl310-cache".
>> +- intterupts: Interrupt number to the cpu.
>> +- reg: Physical base address and size of cache controller's memory mapped
>> +  registers
>> +
>> +Example:
>> +++++++++
>> +
>> +     L2: cache-controller {
>> +             compatible = "arm,pl310-cache";
>> +             interrupts = <0 2 4>;
>> +             reg = <0xf8f02000 0x1000>;
>> +     };
>> +
>> +PL310 L2 Cache EDAC driver detects the Parity enable state by reading the
>> +appropriate control register.
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 878f090..059ac31 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -326,6 +326,13 @@ config EDAC_TILE
>>         Support for error detection and correction on the
>>         Tilera memory controller.
>>
>> +config EDAC_PL310_L2
>> +     tristate "Pl310 L2 Cache Controller"
>> +     depends on EDAC_MM_EDAC && ARM
>> +     help
>> +       Support for parity error detection on L2 cache controller
>> +       data and tag ram memory
>> +
>
>
> Ok, so I'm looking at this after having looked at the synopsys thing
> and it looks very similar in functionality - it does the basic dance of
> registering and setting up stuff, only using different devicetree nodes,
> regs, etc.
>
> However, it adds a new file under drivers/edac/ and I'm wondering if it
> wouldn't be better to simply create a xilinx_edac.c and put all your
> stuff in there, maybe even share code by abstracting it nicely. Having
> a separate driver only for a single L2 cache controller seems kinda too
> granulary for me.

I don't think so, the PL310 is present on lots of ARM chips besides
Xilinx. I don't know how many support parity as that is optional. In
fact the highbank_l2_edac.c is for the PL310 as well, but the
registers it uses is all custom logic added for ECC and there is no
part of the PL310 h/w used by the driver.

If there is lots duplication, then that's a sign the framework needs
to handle more of the boilerplate pieces. There could be a "simple"
driver/library for devices which are no more than some registers, an
interrupt handler and static information about the type of EDAC
device.

Rob
