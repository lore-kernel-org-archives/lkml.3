Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab3CHNa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:30:27 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51761 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3CHNa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:30:26 -0500
Message-ID: <5139E7F3.5010906@gmail.com>
Date: Fri, 08 Mar 2013 14:30:27 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Afzal Mohammed <afzal.mohd.ma@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: Question about fixed-clock
References: <20130307184240.GA3327@afzal-ThinkPad-R50e> <5139155F.5050407@gmail.com> <20130308021527.GA28481@opensource.wolfsonmicro.com>
In-Reply-To: <20130308021527.GA28481@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.03.2013 03:15, Mark Brown wrote:
> On Thu, Mar 07, 2013 at 11:31:59PM +0100, Daniel Mack wrote:
>> On 07.03.2013 19:42, Afzal Mohammed wrote:
> 
>>> I feel that for a platform having it's clock tree in DT, of_clk_init
>>> would take care of it, but if clock tree data is not in DT, clock
>>> tree would have to be extended in a non-DT way.
> 
>> Hmm, I don't follow. So for generic OMAP board in general which does
>> *not* have its SoC clocks in DT, the question is who's in charge of
>> registering out-of-SoC fixed clocks that are defined in DT.
> 
>> Note that the clock I'm dealing with here is _outside_ of the SoC, and I
>> just need to have it in DT, so it can feed another clock chip's input pin.
> 
>> Grep'ing through arch/arm, it seems that the imx arch does the same
>> thing my patch does, but I could also imagine that it should be done
>> somewhere from the DT core. I copied Grant, Rob and Mark for more comments.
> 
> Wouldn't this just be set up by the DT in the same way that other
> off-SoC hardware is?

Well,  I thought so too. To repeat, in my DT, I have:

	ref25: ref25M {
		compatible = "fixed-clock";
		#clock-cells = <0>;
		clock-frequency = <25000000>;
	};

to represent an osciallator on the board. I need to specify it here so I
can pass a reference to another chip:

	si5351a: clock-generator@60 {
		compatible = "silabs,si5351a";
		clocks = <&ref25>;
	};

I would have expected that "fixed-clock" is matched by a driver lurking
around for DT boards, just like what the "fixed-regulator" driver does
for instance. But the clock device isn't initialized unless board code
explicitly calls of_clk_init() with a table mentioning "fixed-clock", as
in my patch.

I don't know the clock framework well enough, but it seems that either
all DT boards are supposed to do the same in their generic bits (which
sounds like a lot of code duplication), or the fixed-clock driver should
behave like any other driver wrt its probing from DT. I'm open to
suggestions :)


Daniel

