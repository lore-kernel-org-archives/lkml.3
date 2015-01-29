Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbbA2LUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:20:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54887 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbA2LUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:20:31 -0500
Message-ID: <54CA173F.1070301@ti.com>
Date: Thu, 29 Jan 2015 13:19:27 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jarkko Nikula <jarkko.nikula@bitmer.com>, Pavel Machek <pavel@ucw.cz>
CC: <pali.rohar@gmail.com>, <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <aaro.koskinen@iki.fi>, <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
References: <20150106170433.GA5408@amd> <20150118120139.GA1509@amd> <54C63F1C.6010703@ti.com> <54C92752.9000004@bitmer.com> <20150128224144.GA28956@amd> <20150129073529.GA19122@bitmer.com>
In-Reply-To: <20150129073529.GA19122@bitmer.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 09:35 AM, Jarkko Nikula wrote:
> On Wed, Jan 28, 2015 at 11:41:44PM +0100, Pavel Machek wrote:
>> On Wed 2015-01-28 20:15:46, Jarkko Nikula wrote:
>>> On 01/26/2015 03:20 PM, Peter Ujfalusi wrote:
>>>> On 01/18/2015 02:01 PM, Pavel Machek wrote:
>>> No need to go that far. N900 has been supported in mainline since 2.6.39
>>> or so. Part A of AIC34 (which is basically dual AIC33 in a same package)
>>> drives 2 V for the digital microphone bias and part B 2.5 V for the headset.
>>
>> Let me try... Umm, no change here :-(
>>
>> root@n900:/tmp# arecord delme
>> Recording WAVE 'delme' : Unsigned 8 bit, Rate 8000 Hz, Mono
>> ^CAborted by signal Interrupt...
>> root@n900:/tmp# hexdump delme
>> 0000000 4952 4646 987c 0000 4157 4556 6d66 2074
>> 0000010 0010 0000 0001 0001 1f40 0000 1f40 0000
>> 0000020 0001 0008 6164 6174 9858 0000 8080 8080
>> 0000030 8080 8080 8080 8080 8080 8080 8080 8080
>> *
>> 0009880
>> root@n900:/tmp# aplay delme
>> Playing WAVE 'delme' : Unsigned 8 bit, Rate 8000 Hz, Mono
>> root@n900:/tmp#
>>
>> I did this:
>>
>> I'm not sure which one is "main" microphone and which is headset, but
>> I guess 2V should be "close enough" to 2.5V to produce something
>> different from zeros..?
>>
> Main or integrated is digital microphone which does AD conversion itself
> and headset is analogue. If DMIC is without bias codec will sample plain
> zeros from DMIC input but analogue input should always produce some random
> LSB bits from codec's AD converter.
> 
> If codec produces zeros also from analogue input then I suppose codec
> ADC is not powered up or similar. One way to hunt regression if
> bisecting is not possible due reason or another is to dump and diff codec
> registers from /sys/kernel/debug/regmap/ using both working commit and head.
> 
>> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
>> index 48b0987..f18a5b0 100644
>> --- a/arch/arm/boot/dts/omap3-n900.dts
>> +++ b/arch/arm/boot/dts/omap3-n900.dts
>> @@ -491,6 +491,8 @@
>>  		DRVDD-supply = <&vmmc2>;
>>  		IOVDD-supply = <&vio>;
>>  		DVDD-supply = <&vio>;
>> +
>> +		ai3x-micbias-vg = <1>;
>>  	};
> Looks ok for digital mic.
> 
>>  
>>  	tlv320aic3x_aux: tlv320aic3x@19 {
>> @@ -502,6 +504,8 @@
>>  		DRVDD-supply = <&vmmc2>;
>>  		IOVDD-supply = <&vio>;
>>  		DVDD-supply = <&vio>;
>> +
>> +		ai3x-micbias-vg = <1>;
>>  	};
> This should be 2, i.e. 2.5 V according to
> Documentation/devicetree/bindings/sound/tlv320aic3x.txt. I think 2 V is
> too low for some headset mics and that was the reason for 2.5 V.

Can you also try this patch to correct the DAPM route for the rx51:

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 04896d6252a2..7f299357c2d2 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -250,14 +250,14 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"FM Transmitter", NULL, "LLOUT"},
 	{"FM Transmitter", NULL, "RLOUT"},

-	{"DMic Rate 64", NULL, "Mic Bias"},
-	{"Mic Bias", NULL, "DMic"},
+	{"DMic Rate 64", NULL, "DMic"},
+	{"DMic", NULL, "Mic Bias"},

 	{"b LINE2R", NULL, "MONO_LOUT"},
 	{"Earphone", NULL, "b HPLOUT"},

-	{"LINE1L", NULL, "b Mic Bias"},
-	{"b Mic Bias", NULL, "HS Mic"}
+	{"LINE1L", NULL, "HS Mic"},
+	{"HS Mic", NULL, "b Mic Bias"},
 };

 static const char * const spk_function[] = {"Off", "On"};

-- 
Péter
