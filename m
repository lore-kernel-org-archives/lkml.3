Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab3EBOxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:53:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3EBOxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:53:10 -0400
Message-ID: <51827DB1.7000304@redhat.com>
Date: Thu, 02 May 2013 11:52:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        =?UTF-8?B?RXplcXVpZWwgR2FyY8OtYQ==?= <elezegarcia@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <518157EB.3010700@infradead.org>
In-Reply-To: <518157EB.3010700@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-05-2013 14:59, Randy Dunlap escreveu:
> On 05/01/13 01:37, Stephen Rothwell wrote:
>> Hi all,
>>
>> Please do not add any v3.11 destined work to your linux-next included
>> branches until after v3.10-rc1 is released.
>>
>> Changes since 20130430:
>>
>
>
> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
> CONFIG_VIDEO_STK1160=y
> CONFIG_VIDEO_STK1160_AC97=y
>
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x122706): undefined reference to `snd_card_create'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x1227cd): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x122832): undefined reference to `snd_card_register'
> drivers/built-in.o: In function `stk1160_ac97_unregister':
> (.text+0x12285e): undefined reference to `snd_card_free'
>
>
> This kconfig fragment:
> config VIDEO_STK1160_AC97
> 	bool "STK1160 AC97 codec support"
> 	depends on VIDEO_STK1160 && SND
> 	select SND_AC97_CODEC
>
> is unreliable (doesn't do what some people expect) when SND=m and SND_AC97_CODEC=m,
> since VIDEO_STK1160_AC97 is a bool.

Using select is always tricky.

I can see a few possible fixes for it:

1) split the alsa part into a separate module. IMHO, this is cleaner,
but requires a little more work.

2) Use the Kconfig syntax:

	depends on SND || (SND=n)

on a tristate symbol. That behaves like:

	if SND is 'n', it won't depend on SND;
	if SND is 'm', the symbol will be 'm'
	if SND is 'y', the symbol will be 'y'.

However, as as VIDEO_STK1160_AC97 is boolean, this will require
an additional hidden Kconfig. Something like:

config VIDEO_STK1160_COMMON
	tristate "STK1160 USB video capture support"
	depends on VIDEO_DEV && I2C

config VIDEO_STK1160_AC97
	bool "STK1160 AC97 codec support"
	depends on VIDEO_STK1160_COMMON && SND

config VIDEO_STK1160
	tristate
	depends on ((SND || (SND=n) || !VIDEO_STK1160_AC97) && VIDEO_STK1160_COMMON
	default y
	select SND_AC97_CODEC if SND
	select VIDEOBUF2_VMALLOC
	select VIDEO_SAA711X
	select SND_AC97_CODEC

We do already something similar to the above for the mutual dependency
of most media drivers for I2C and V4L2 and/or DVB core.

There's just one small drawback with the above: if SND='m', even if
the user selects VIDEO_STK1160_COMMON='y', VIDEO_STK1160 will be 'm'.

A quick test here with make allyesconfig and then changing SND to m
seemed to produce the right value for CONFIG_VIDEO_STK1160:

Selecting STK1160_AC97:

$ grep -e STK1160 -e SND= .config
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160_AC97=y
CONFIG_VIDEO_STK1160=m
CONFIG_SND=m

Unselecting STK1160_AC97:

$ grep -e STK1160 -e SND= .config
CONFIG_VIDEO_STK1160_COMMON=y
# CONFIG_VIDEO_STK1160_AC97 is not set
CONFIG_VIDEO_STK1160=y
CONFIG_SND=m

With a little more work, it could be possible to find a way to
avoid the drawback of saying to the user that the module will be
builtin, but compiling it as a module.

Regards,
Mauro.

-

[media] stk1160: Make stk1160 module if SND is m and audio support is selected

As reported by Randy:

When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
CONFIG_VIDEO_STK1160=y
CONFIG_VIDEO_STK1160_AC97=y

drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x122706): undefined reference to `snd_card_create'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x1227b2): undefined reference to `snd_ac97_bus'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x1227cd): undefined reference to `snd_card_free'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x12281b): undefined reference to `snd_ac97_mixer'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x122832): undefined reference to `snd_card_register'
drivers/built-in.o: In function `stk1160_ac97_unregister':
(.text+0x12285e): undefined reference to `snd_card_free'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 1c3a1ec..2bf6392 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -1,8 +1,6 @@
-config VIDEO_STK1160
+config VIDEO_STK1160_COMMON
  	tristate "STK1160 USB video capture support"
  	depends on VIDEO_DEV && I2C
-	select VIDEOBUF2_VMALLOC
-	select VIDEO_SAA711X
  
  	---help---
  	  This is a video4linux driver for STK1160 based video capture devices.
@@ -12,9 +10,14 @@ config VIDEO_STK1160
  
  config VIDEO_STK1160_AC97
  	bool "STK1160 AC97 codec support"
-	depends on VIDEO_STK1160 && SND
-	select SND_AC97_CODEC
-
+	depends on VIDEO_STK1160_COMMON && SND
  	---help---
  	  Enables AC97 codec support for stk1160 driver.
-.
+
+config VIDEO_STK1160
+	tristate
+	depends on (!VIDEO_STK1160_AC97 || (SND='n') || SND) && VIDEO_STK1160_COMMON
+	default y
+	select VIDEOBUF2_VMALLOC
+	select VIDEO_SAA711X
+	select SND_AC97_CODEC if SND


