Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaJHUxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:53:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaJHUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:53:35 -0400
Message-ID: <5435A44D.2050609@infradead.org>
Date: Wed, 08 Oct 2014 13:53:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
References: <20141008174923.76786a03@canb.auug.org.au>	<543570C3.9080207@infradead.org> <20141008153105.2fe82fca@recife.lan>
In-Reply-To: <20141008153105.2fe82fca@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/14 11:31, Mauro Carvalho Chehab wrote:
> Em Wed, 08 Oct 2014 10:13:39 -0700
> Randy Dunlap <rdunlap@infradead.org> escreveu:
> 
>> On 10/07/14 23:49, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Please do not add any material intended for v3.19 to you linux-next
>>> included trees until after v3.18-rc1 has been released.
>>>
>>> Changes since 20141007:
>>>
>>
>> I saw these build errors in gspca when CONFIG_INPUT=m but the gspca
>> sub-drivers are builtin:
>>
>> drivers/built-in.o: In function `gspca_dev_probe2':
>> (.text+0x10ef43): undefined reference to `input_allocate_device'
>> drivers/built-in.o: In function `gspca_dev_probe2':
>> (.text+0x10efdd): undefined reference to `input_register_device'
>> drivers/built-in.o: In function `gspca_dev_probe2':
>> (.text+0x10f002): undefined reference to `input_free_device'
>> drivers/built-in.o: In function `gspca_dev_probe2':
>> (.text+0x10f0ac): undefined reference to `input_unregister_device'
>> drivers/built-in.o: In function `gspca_disconnect':
>> (.text+0x10f186): undefined reference to `input_unregister_device'
>> drivers/built-in.o: In function `sd_int_pkt_scan':
>> se401.c:(.text+0x11373d): undefined reference to `input_event'
>> se401.c:(.text+0x11374e): undefined reference to `input_event'
>> drivers/built-in.o: In function `sd_pkt_scan':
>> t613.c:(.text+0x119f0e): undefined reference to `input_event'
>> t613.c:(.text+0x119f1f): undefined reference to `input_event'
>> drivers/built-in.o: In function `sd_stopN':
>> t613.c:(.text+0x11a047): undefined reference to `input_event'
>> drivers/built-in.o:t613.c:(.text+0x11a058): more undefined references to `input_event' follow
>>
>> These could be fixed in Kconfig by something like (for each sub-driver that tests
>> CONFIG_INPUT):
>>
>> 	depends on INPUT || INPUT=n
>>
>> Do you have another preference for fixing this?
> 
> Hmm... The code at the gspca subdrivers looks like:
> 
> #if IS_ENABLED(CONFIG_INPUT)

For builtin only, that should be

#if IS_BUILTIN(CONFIG_INPUT)

> 		if (data[0] & 0x20) {
> 			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
> 			input_sync(gspca_dev->input_dev);
> 			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
> 			input_sync(gspca_dev->input_dev);
> 		}
> #endif
> 
> As we never got any report about such bug, and this is there for a long
> time, I suspect that maybe the IS_ENABLED() macro had some changes on
> its behavior. So, IMHO, we should first check if something changed there.

I don't see any changes in <linux/kconfig.h>.

> From gpsca's PoV, IMHO, it should be fine to disable the webcam buttons if
> the webcam was compiled as builtin and the input subsystem is compiled as 
> module. The core feature expected on a camera is to capture streams. 
> Buttons are just a plus.
> 
> Also, most cams don't even have buttons. The gspca subdriver has support 
> for buttons for the few models that have it.
> 
> So, IMHO, it should be ok to have GSPCA=y and INPUT=m, provided that 
> the buttons will be disabled.

Then all of the sub-drivers that use IS_ENABLED(CONFIG_INPUT) should be
changed to use IS_BUILTIN(CONFIG_INPUT).

But that is too restrictive IMO.  The input subsystem will work fine when
CONFIG_INPUT=m and the GSPCA drivers are also loadable modules.
That's simple to express in Kconfig language but probly more messy in CPP.


Thanks.


-- 
~Randy
