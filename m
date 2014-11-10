Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaKJGrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:47:07 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:12825 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaKJGrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:47:04 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat/gNPsyuGM
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [Gta04-owner] [PATCH 2/3] ASoC: twl4030: allow voice port to be connected externally.
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20141110102551.2678d342@notabene.brown>
Date: Mon, 10 Nov 2014 07:46:50 +0100
Cc: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        alsa-devel@alsa-project.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1B5F0B4F-2F19-4692-BB95-C6D916DAD3A7@goldelico.com>
References: <20141108002637.6561.19002.stgit@notabene.brown> <20141108003803.6561.57464.stgit@notabene.brown> <20141108092622.GC2722@sirena.org.uk> <20141110102551.2678d342@notabene.brown>
To: List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 10.11.2014 um 00:25 schrieb NeilBrown <neilb@suse.de>:

> On Sat, 8 Nov 2014 09:26:22 +0000 Mark Brown <broonie@kernel.org> wrote:
> 
>> On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:
>> 
>>> If voice port on twl4030 is not connected to a McBSP (or similar)
>>> then we cannot configure the format the way we normally do for a DAI.
>> 
>> Yes we can, you need to represent the DAI link to whatever else the
>> device is connected to in the driver like we do anything else - and in
>> any case this isn't a device specific issue so we shouldn't be doing
>> something driver specific to solve it.  Look at something like speyside.
> 
> Hi Mark,
> thanks for the reply ... I might need a little bit more help though.
> 
> I had a look at sound/soc/samsung/speyside.c, but I'm not entirely sure what
> I'm looking for.
> Presumably this is an audio processor not unlike the audio module in the
> twl4030.
> 
> I see that there are 3 dai-links:
>  CPU-DSP
>  DSP-CODEC
>  Baseband
> 
> Presumably "Baseband" is similar, in purpose at least, to the "voice"
> interface on the twl4030.
> 
> Each dai-link has a "cpu_dai_name" and a "codec_dai_name", even though it
> appears that only "CPU-DSP" is connected to the CPU.  Maybe that naming is
> the source of some of my confusion.
> 
> "Baseband" declares
>                .cpu_dai_name = "wm8996-aif2",
> so wm8996 is something with 2 audio interfaces, (aif), and this is the second
> one?  Maybe the  wm8996 is the audio module, so what is the "speyside"?
> 
> http://opensource.wolfsonmicro.com/content/speyside-audio
> 
> says it is a "reference platform".  Does that mean it is a board with a bunch
> of chips soldered onto it?  If it were a board it should be described by a
> dts file, not by a pile of C code (I thought), so I must be wrong about that.
> 
> 
> In my case, I have a board with a GSM module and the twl4030 module.  Each
> has an audio interface and these are connected.  I assume that I need to
> express this connection in the dts file.
> The GSM module doesn't currently appear in the dts file as it is usb-attached.
> However I've been thinking that we will need to add it so we can express
> power-on controls (twiddling some GPIOs).  So let's suppose we have the GSM
> module in the dts file (child of a USB interface)

It is a quite complex connection pattern and I am not sure if the modem is really
a logical child of the USB interface. Powering up/down the USB interface has nothing
to do with the modem power. Rather, it continues to operate if USB is suspended
and the modem notifies USB that it has become active.

The connections on this GTA04 board are:

Modem USB <—> CPU USB
Modem PCM <—> TWL4030 Voice <—> OMAP3 McBSP4 (yes, it is a 3-way connection)
Modem Power control <—> 1 or 2 GPIOs (depending on board variant)

The reason for the 3-way connection is that user space can chose if the GSM
voice is routed directly to the TWL codec (low latency, independent of CPU) or
goes through the CPU (e.g. for DTAM or voice scrambling by software) and
then through the other PCM link between the CPU and the TWL.

This is why I would make the McBSP4 a separate sound card.

And, this is why it needs some control and tri-state of the TWL4030 and OMAP3
McBSP4 since only one can provide a digital PCM stream to the modem.

One more thing to consider for a general solution is that there are modem modules
that communicate data through UART or SPI - but otherwise have a similar connection
for digital audio. So forcing the power control driver to be a subnode of USB doesn’t
appear general enough to me.

Finally, this connection pattern is not specific to this modem (OPTION GTM601) on this
GTA04 board. We plan to use a Gemalto PHS8  in the Pyra-Handheld and the Neo900
devices - but the general connection pattern as defined above remains the same.

So my proposal is to have a specific wwan-power driver for this type of modems.
And power control can and should be kept separately from USB (except the case
where only 1 GPIO exists and USB must be tapped to detect the modem power
state). You can find work in progress for this approach here:

<http://git.goldelico.com/?p=gta04-kernel.git;a=blob;f=drivers/misc/wwan-on-off.c;h=e13f47dbd734d14f4e38ea9cf622982dc3550212;hb=154bcd388a8f5bcc7fcf0e57e93b6388daa16980>

> and the twl4030 as well
> (beneath an i2c interface).
> 
> The twl4030 needs to know the master/polarity of the clk/frm lines.  The GSM
> module declares that these are.  So presumably we need some sort of linkage.
> Ahhhh... I found Documentation/devicetree/bindings/sound/simple-card.txt
> 
> So I need to make the "voice" port on the twl4030 look like a "cpu" end of a
> dai-link, and create a "codec" end in the GSM module, and use "sound-dai" to
> point from the twl4030 to the GSM module.

What I wonder a little is that we have all these dai-links working since your 3.7
kernel for GTA04. Is it necessary to re-invent a solution or should we just make
the solution device tree compatible?

> Then I use frame-master, bitclock-master, bitclock-inversion, frame-inversion
> for the settings I need.
> 
> I suspect I can make that work.
> 
> Am I on the right track?
> 
> Thanks,
> NeilBrown
> _______________________________________________
> Gta04-owner mailing list
> Gta04-owner@goldelico.com
> http://lists.goldelico.com/mailman/listinfo.cgi/gta04-owner

