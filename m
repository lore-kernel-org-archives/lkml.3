Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3H2LBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:01:32 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:61043 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3H2LBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:01:30 -0400
Message-ID: <521F2A03.8000905@gmail.com>
Date: Thu, 29 Aug 2013 13:01:23 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jean-Francois Moine <moinejf@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
References: <20130828113459.48ecbb34@armhf> <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130828131548.0009d613@skate> <521DE2B3.9050508@gmail.com> <20130828135827.2307c89e@skate> <521DEA20.8020103@gmail.com> <20130829120704.410ad309@armhf> <20130829101303.GR6617@n2100.arm.linux.org.uk>
In-Reply-To: <20130829101303.GR6617@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 12:13, Russell King - ARM Linux wrote:
> On Thu, Aug 29, 2013 at 12:07:04PM +0200, Jean-Francois Moine wrote:
>> On Wed, 28 Aug 2013 14:16:32 +0200
>> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>>
>> 	[snip]
>>>> Though, if the difference between the two units is the availability of
>>>> SPDIF support, then we shouldn't encode the channel number, but instead
>>>> the availability of SPDIF, i.e:
>>>>
>>>> 	audio0 {
>>>> 		reg = <... ...>;
>>>> 		compatible = "marvell,kirkwood-audio";
>>>> 		marvell,has-spdif;
>>>
>>> Agree, if you make it "marvell,has-spdif-in" and "marvell,has-spdif-out"
>>> Dove has either i2s-only or i2s+spdifo, kirkwood has i2s+spdifo+spdifi
>>> for the one audio controller available. Can't tell for Armada 370.
>>>
>>> BTW, you might have followed some of the DT discussions with Mark
>>> before; as he insists on having a separate sound card node, he might
>>> argue that above property should be part of that node instead.
>>
>> Yes. For the Cubox, the card will be described by something like:
>>
>> 	sound {
>> 		compatible = "simple-audio";
>> 		audio-controller = <&audio1>;
>> 		audio-codec = <&spdif>;
>> 		codec-dai-name = "dit-hifi";
>> 	};
>>
>> with:
>>
>> 	spdif: spdif {
>>   		compatible = "linux,spdif-dit";
>> 	};
>>
>> Then, the audio driver will know about s/pdif on the first open.
>
> I can tell that neither of you have taken notice of what I said about
> the "has" stuff - it's completely useless to the driver, it conveys no
> useful information.

You are right, of course, that has-spdif-foo properties are useless,
for the driver and the DT. For a working audio setup, we need to link
the codecs anyway and we can put that information in there.

> Moreover, the above isn't going to be the answer to this.  With DPCM
> you need:
>
> 1. two DAI links to be setup:
> 1a. one to connect the CPU DAI to the dummy codec
> 1b. one to connect the dummy platform/CPU DAI to the SPDIF codec

Taking the sound node above:

sound {
	compatible = "whatever-audio";
	...
	audio-codec = <&rt1234 1>, <&spdif 0>;
	audio-codec-names = "i2s", "spdifo";
	...
};

Each audio-codec phandle with arg links to one specific "port" at some
"codec". The audio-codec-names property allows the ASoC driver to
determine the local "ports" where the above codecs are connected.
The dummy codecs are ASoC specific and must be added by the driver.

Basically, it is the same approach as we have for clocks, maybe the 
property names are not best suited, but it should give an impression of
how it _could_ be done.

Unfortunately, the fsl spdif discussion I referenced earlier ended up
with
a) a special machine driver and its own DT binding
b) using that "has" properties approach

> 2. DAPM routes to connect the CPU DAI audio stream(s) to the Codec stream(s)

I am not yet sure how that could be solved easily with DT, nor if it
should go in there at all. But I have not dug into ASoC and DAPM enough.

Can you point out, given the above linking, what you think is missing
to allow the driver to find all it needs wrt to DAIs and DAPM?

> If you have both I2S and SPDIF, then you need another DAI link and a
> few more DAPM routes.  Even if you have just one codec connected, you
> will need this structure so that the CPU DAI knows which audio outputs
> are to be enabled.  If no DAPM routes exist, the CPU DAI will not enable
> any outputs.
>
> Or at least that's the theory when ASoC DPCM eventually works.
>

