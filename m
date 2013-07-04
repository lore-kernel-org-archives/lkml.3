Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3GDNoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:44:46 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47417 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab3GDNon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <51D4CC94.3020908@atmel.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-2-git-send-email-richard.genoud@gmail.com>
 <51D24299.9050209@atmel.com> <CACQ1gAgcc=j3kmcpjp8bbdHhxr_k=h8jJs6R_paJbPUMv74uGg@mail.gmail.com>
 <51D29927.80900@atmel.com> <CACQ1gAhnDk-qSt_5xrsMakXqGGDO5pEbA-9UDWCJG=AABDc+zg@mail.gmail.com>
 <CACQ1gAgPaRm3gxxJNgfj9bR565Q0+SNY3+EcjA_mrh1N+yPzSA@mail.gmail.com> <51D4CC94.3020908@atmel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 4 Jul 2013 15:44:21 +0200
Message-ID: <CACQ1gAio0ekQMgyfrLjTHmMPGJQoKoe61GreFQDN-iLjxbLQ0w@mail.gmail.com>
Subject: Re: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
To: Bo Shen <voice.shen@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: multipart/mixed; boundary=bcaec529a017cb012304e0afc717
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec529a017cb012304e0afc717
Content-Type: text/plain; charset=UTF-8

2013/7/4 Bo Shen <voice.shen@atmel.com>:
> Hi Richard,
>
>
> On 7/3/2013 23:51, Richard Genoud wrote:
>>>
>>> >but there's a violent hang (kernel stops, no trace) when I try the
>>> > record :
>>> >arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav
>>> >last thing I see is :
>>> >dma dma0chan3: atc_control (3)
>
>
> I don't meet this issue. Playback and recording works well on my side on
> at91sam9g35ek board.
>
>
>>> >I'll try to trace that.
>>
>> I think it's DMA related.
>> the last thing done by the kernel is:
>>   i2c i2c-0: i2c_outb: 0x34 A
>>   i2c i2c-0: i2c_outb: 0x0c A
>>   i2c i2c-0: i2c_outb: 0x5a A
>> meaning: enable power on, LINE IN, ADC, OSC, on the WM8731
>> so, after that, data is comming from the codec to the SSC and then is
>> handled by the DMA.
>> there must be something nasty on the DMA bus to hang everything like
>> that...
>
>
> Will you try i2c without DMA support to test this issue?

Ok, I nailed it !

To be sure we are on the same base, here is what I have done:
onto next-20130704:
- your 5 patches:
ASoC: atmel_ssc_dai: move set dma data to startup callback
ASoC: atmel_ssc_dai: add error mask define
ASoC: atmel-pcm-dma: move prepare for dma to dai prepare
ARM: atmel-ssc: change phybase type to dma_addr_t
ASoC: atmel-pcm: use generic dmaengine framework
- my patches 4-8:
ARM: at91: DTS: sam9x5: add SSC DMA parameters
ARM: AT91: DTS: sam9x5ek: add WM8731 codec
ARM: AT91: DTS: sam9x5ek: add sound configuration
ARM: AT91: DTS: sam9x5ek: enable SSC
sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards

To be sure that dma-I2c doesn't disturb something, I use i2c gpio bitbang:
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi
b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 6684d4b..53a991e 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -57,15 +57,6 @@
 				status = "okay";
 			};

-			i2c0: i2c@f8010000 {
-				status = "okay";
-
-				wm8731: wm8731@1a {
-					compatible = "wm8731";
-					reg = <0x1a>;
-				};
-			};
-
 			pinctrl@fffff400 {
 				mmc0 {
 					pinctrl_board_mmc0: mmc0-board {
@@ -114,6 +105,15 @@
 		};
 	};

+	i2c@0 {
+		status = "okay";
+
+		wm8731: wm8731@1a {
+			compatible = "wm8731";
+			reg = <0x1a>;
+		};
+	};
+
 	sound {
 		compatible = "atmel,sam9x5-audio-wm8731";

with that configuration, it hangs when I do a:
arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav

Now, if I remove the overrun error on ssc in rx_mask:
diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 0ecf356..c04e825 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -83,7 +83,6 @@ static struct atmel_ssc_mask ssc_rx_mask = {
 	.ssc_disable	= SSC_BIT(CR_RXDIS),
 	.ssc_endx	= SSC_BIT(SR_ENDRX),
 	.ssc_endbuf	= SSC_BIT(SR_RXBUFF),
-	.ssc_error	= SSC_BIT(SR_OVRUN),
 	.pdc_enable	= ATMEL_PDC_RXTEN,
 	.pdc_disable	= ATMEL_PDC_RXTDIS,
 };

It doesn't hang any more doing a simple record.
BUT it still hangs if we do record and play at the same time.

Removing the overrun on tx_mask prevent the hang:
diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 0ecf356..41e15c2 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -73,7 +73,6 @@ static struct atmel_ssc_mask ssc_tx_mask = {
 	.ssc_disable	= SSC_BIT(CR_TXDIS),
 	.ssc_endx	= SSC_BIT(SR_ENDTX),
 	.ssc_endbuf	= SSC_BIT(SR_TXBUFE),
-	.ssc_error	= SSC_BIT(SR_OVRUN),
 	.pdc_enable	= ATMEL_PDC_TXTEN,
 	.pdc_disable	= ATMEL_PDC_TXTDIS,
 };

i.e. when I revert "ASoC: atmel_ssc_dai: add error mask define", I
don't see any hang.

Could you test and confirm that behaviour please ?

I attached a the (simple) .config I used for the tests.

PS: I hope the patches won't be mangled by gmail...

Best regards,
Richard.

--bcaec529a017cb012304e0afc717
Content-Type: application/octet-stream; name=snd_9x5_defconfig
Content-Disposition: attachment; filename=snd_9x5_defconfig
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hiq07ypt0

IyBDT05GSUdfTE9DQUxWRVJTSU9OX0FVVE8gaXMgbm90IHNldAojIENPTkZJR19TV0FQIGlzIG5v
dCBzZXQKQ09ORklHX1NZU1ZJUEM9eQpDT05GSUdfTE9HX0JVRl9TSElGVD0xNApDT05GSUdfQkxL
X0RFVl9JTklUUkQ9eQpDT05GSUdfQ0NfT1BUSU1JWkVfRk9SX1NJWkU9eQpDT05GSUdfS0FMTFNZ
TVNfQUxMPXkKQ09ORklHX0VNQkVEREVEPXkKQ09ORklHX1NMQUI9eQojIENPTkZJR19MQkRBRiBp
cyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQlNHIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9TQ0hF
RF9ERUFETElORSBpcyBub3Qgc2V0CiMgQ09ORklHX0lPU0NIRURfQ0ZRIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfQVQ5MT15CkNPTkZJR19TT0NfQVQ5MVNBTTlYNT15CkNPTkZJR19NQUNIX0FUOTFT
QU05X0RUPXkKQ09ORklHX0FUOTFfUFJPR1JBTU1BQkxFX0NMT0NLUz15CkNPTkZJR19BVDkxX1RJ
TUVSX0haPTEyOApDT05GSUdfQUVBQkk9eQojIENPTkZJR19PQUJJX0NPTVBBVCBpcyBub3Qgc2V0
CkNPTkZJR19VQUNDRVNTX1dJVEhfTUVNQ1BZPXkKQ09ORklHX1pCT09UX1JPTV9URVhUPTB4MApD
T05GSUdfWkJPT1RfUk9NX0JTUz0weDAKQ09ORklHX0FSTV9BUFBFTkRFRF9EVEI9eQpDT05GSUdf
Q01ETElORT0iY29uc29sZT10dHlTMCwxMTUyMDAgbG9nbGV2ZWw9OCBpcD1kaGNwIHJvb3Q9L2Rl
di9uZnMgbmZzcm9vdD0xMC4xMjguMC45Oi9uZnNyb290LHYzIHJ3IgpDT05GSUdfQ01ETElORV9G
T1JDRT15CkNPTkZJR19LRVhFQz15CkNPTkZJR19BVVRPX1pSRUxBRERSPXkKIyBDT05GSUdfQ09S
RV9EVU1QX0RFRkFVTFRfRUxGX0hFQURFUlMgaXMgbm90IHNldApDT05GSUdfTkVUPXkKQ09ORklH
X1BBQ0tFVD15CkNPTkZJR19VTklYPXkKQ09ORklHX0lORVQ9eQpDT05GSUdfSVBfTVVMVElDQVNU
PXkKQ09ORklHX0lQX1BOUD15CkNPTkZJR19JUF9QTlBfREhDUD15CkNPTkZJR19JUF9QTlBfQk9P
VFA9eQpDT05GSUdfSVBfUE5QX1JBUlA9eQojIENPTkZJR19JTkVUX1hGUk1fTU9ERV9UUkFOU1BP
UlQgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fTU9ERV9UVU5ORUwgaXMgbm90IHNldAoj
IENPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9ESUFH
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1RSQU5TUE9SVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVU
Nl9YRlJNX01PREVfQkVFVCBpcyBub3Qgc2V0CkNPTkZJR19JUFY2X1NJVF82UkQ9eQpDT05GSUdf
VUVWRU5UX0hFTFBFUl9QQVRIPSIvc2Jpbi9ob3RwbHVnIgpDT05GSUdfREVWVE1QRlM9eQpDT05G
SUdfREVWVE1QRlNfTU9VTlQ9eQojIENPTkZJR19TVEFOREFMT05FIGlzIG5vdCBzZXQKIyBDT05G
SUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRCBpcyBub3Qgc2V0CkNPTkZJR19QUk9DX0RFVklDRVRS
RUU9eQpDT05GSUdfQkxLX0RFVl9MT09QPXkKQ09ORklHX0FUTUVMX1BXTT15CkNPTkZJR19BVE1F
TF9UQ0xJQj15CkNPTkZJR19BVE1FTF9TU0M9eQpDT05GSUdfRUVQUk9NXzkzQ1g2PXkKQ09ORklH
X1NDU0k9eQpDT05GSUdfQkxLX0RFVl9TRD15CkNPTkZJR19TQ1NJX01VTFRJX0xVTj15CiMgQ09O
RklHX1NDU0lfTE9XTEVWRUwgaXMgbm90IHNldApDT05GSUdfTkVUREVWSUNFUz15CiMgQ09ORklH
X05FVF9WRU5ET1JfQVJDIGlzIG5vdCBzZXQKQ09ORklHX01BQ0I9eQojIENPTkZJR19ORVRfVkVO
RE9SX0JST0FEQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9DSVJSVVMgaXMgbm90
IHNldAojIENPTkZJR19ORVRfVkVORE9SX0ZBUkFEQVkgaXMgbm90IHNldAojIENPTkZJR19ORVRf
VkVORE9SX0lOVEVMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9NQVJWRUxMIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9NSUNSRUwgaXMgbm90IHNldAojIENPTkZJR19ORVRf
VkVORE9SX05BVFNFTUkgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1NFRVEgaXMgbm90
IHNldAojIENPTkZJR19ORVRfVkVORE9SX1NNU0MgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVO
RE9SX1NUTUlDUk8gaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1ZJQSBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVF9WRU5ET1JfV0laTkVUIGlzIG5vdCBzZXQKQ09ORklHX0RBVklDT01fUEhZ
PXkKQ09ORklHX01JQ1JFTF9QSFk9eQojIENPTkZJR19XTEFOIGlzIG5vdCBzZXQKQ09ORklHX0lO
UFVUX1BPTExERVY9eQojIENPTkZJR19JTlBVVF9NT1VTRURFVl9QU0FVWCBpcyBub3Qgc2V0CkNP
TkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWD00ODAKQ09ORklHX0lOUFVUX01PVVNFREVWX1ND
UkVFTl9ZPTI3MgpDT05GSUdfSU5QVVRfSk9ZREVWPXkKQ09ORklHX0lOUFVUX0VWREVWPXkKIyBD
T05GSUdfS0VZQk9BUkRfQVRLQkQgaXMgbm90IHNldApDT05GSUdfS0VZQk9BUkRfR1BJTz15CiMg
Q09ORklHX0lOUFVUX01PVVNFIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX1RPVUNIU0NSRUVOPXkK
IyBDT05GSUdfU0VSSU8gaXMgbm90IHNldApDT05GSUdfTEVHQUNZX1BUWV9DT1VOVD00CkNPTkZJ
R19TRVJJQUxfQVRNRUw9eQpDT05GSUdfU0VSSUFMX0FUTUVMX0NPTlNPTEU9eQojIENPTkZJR19T
RVJJQUxfQVRNRUxfUERDIGlzIG5vdCBzZXQKQ09ORklHX0kyQz15CkNPTkZJR19JMkNfR1BJTz15
CkNPTkZJR19JMkNfREVCVUdfQ09SRT15CkNPTkZJR19JMkNfREVCVUdfQUxHTz15CkNPTkZJR19J
MkNfREVCVUdfQlVTPXkKIyBDT05GSUdfSFdNT04gaXMgbm90IHNldApDT05GSUdfV0FUQ0hET0c9
eQpDT05GSUdfQVQ5MVNBTTlYX1dBVENIRE9HPXkKQ09ORklHX1NTQj15CkNPTkZJR19TT1VORD15
CkNPTkZJR19TTkQ9eQpDT05GSUdfU05EX1ZFUkJPU0VfUFJJTlRLPXkKQ09ORklHX1NORF9ERUJV
Rz15CkNPTkZJR19TTkRfREVCVUdfVkVSQk9TRT15CiMgQ09ORklHX1NORF9EUklWRVJTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX0FSTSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfU09DPXkKQ09ORklH
X1NORF9BVE1FTF9TT0M9eQpDT05GSUdfU05EX0FUOTFfU09DX1NBTTlYNV9XTTg3MzE9eQojIENP
TkZJR19VU0JfU1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19ORVdfTEVEUz15CkNPTkZJR19MRURT
X0NMQVNTPXkKQ09ORklHX0xFRFNfR1BJTz15CkNPTkZJR19MRURTX1RSSUdHRVJTPXkKQ09ORklH
X0xFRFNfVFJJR0dFUl9USU1FUj15CkNPTkZJR19MRURTX1RSSUdHRVJfSEVBUlRCRUFUPXkKQ09O
RklHX0xFRFNfVFJJR0dFUl9HUElPPXkKQ09ORklHX1JUQ19DTEFTUz15CkNPTkZJR19SVENfRFJW
X1JWMzAyOUMyPXkKQ09ORklHX1JUQ19EUlZfQVQ5MVJNOTIwMD15CkNPTkZJR19SVENfRFJWX0FU
OTFTQU05PXkKQ09ORklHX0RNQURFVklDRVM9eQpDT05GSUdfRE1BREVWSUNFU19ERUJVRz15CkNP
TkZJR19ETUFERVZJQ0VTX1ZERUJVRz15CkNPTkZJR19BVF9IRE1BQz15CiMgQ09ORklHX0lPTU1V
X1NVUFBPUlQgaXMgbm90IHNldApDT05GSUdfRkFOT1RJRlk9eQpDT05GSUdfVE1QRlM9eQpDT05G
SUdfQ09ORklHRlNfRlM9eQojIENPTkZJR19NSVNDX0ZJTEVTWVNURU1TIGlzIG5vdCBzZXQKQ09O
RklHX05GU19GUz15CkNPTkZJR19ST09UX05GUz15CkNPTkZJR19QUklOVEtfVElNRT15CkNPTkZJ
R19ERUZBVUxUX01FU1NBR0VfTE9HTEVWRUw9NwojIENPTkZJR19TQ0hFRF9ERUJVRyBpcyBub3Qg
c2V0CkNPTkZJR19ERUJVR19JTkZPPXkKIyBDT05GSUdfRlRSQUNFIGlzIG5vdCBzZXQKQ09ORklH
X0RFQlVHX1VTRVI9eQpDT05GSUdfQ1JZUFRPX0NSQzMyQz15CiMgQ09ORklHX0NSWVBUT19BTlNJ
X0NQUk5HIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0hXIGlzIG5vdCBzZXQKQ09ORklHX0NS
QzE2PXkK
--bcaec529a017cb012304e0afc717--
