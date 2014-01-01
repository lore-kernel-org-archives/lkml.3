Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaAASqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 13:46:20 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48493 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaAASqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 13:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <52C42079.6060604@blueyonder.co.uk>
References: <52C29918.4060102@blueyonder.co.uk>
	<CAKb7UvhBunpMC6mzjRg7Zb5gGPPYj99=2jd+Lgnr-qeXFs0w9A@mail.gmail.com>
	<52C3644C.9090809@blueyonder.co.uk>
	<CAKb7UviLpfZMtZM9X1R0Eaj=5ww2k=T+7x01dZH3ns2Ew1HuFw@mail.gmail.com>
	<52C42079.6060604@blueyonder.co.uk>
Date: Wed, 1 Jan 2014 13:46:18 -0500
X-Google-Sender-Auth: RW62Vvv45Wpv9Wo9jojC6ZbauYc
Message-ID: <CAKb7Uvj97SgHp1b11_MMt1UR-NUpQ_2LuGhwjyk_a7_VLqN+KQ@mail.gmail.com>
Subject: Re: Possible 3.13-rc nouveau regression with GT 560 Ti
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: sboyce@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 1, 2014 at 9:04 AM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> On 01/01/14 00:55, Ilia Mirkin wrote:
>>
>> On Tue, Dec 31, 2013 at 7:41 PM, Sid Boyce <sboyce@blueyonder.co.uk>
>> wrote:
>>>
>>> On 31/12/13 10:36, Ilia Mirkin wrote:
>>>> Having a dmesg would be nice. One thing I can think of off-hand is
>>>> that 3.13-rc has MSI turned on by default. You can turn it off by
>>>> adding "nouveau.config=NvMSI=0" to your kernel cmdline. If that
>>>> doesn't help, a bisect restricted to drivers/gpu/drm/nouveau should
>>>> show the offending commit fairly quickly.
>>>>
>>>>     -ilia
>>>>
>>> Adding "nouveau.config=NvMSI=0" to the command line fixed the problem.
>>> So it looks like commit 049ffa8ab33a63b3bff672d1a0ee6a35ad253fe8
>>> introduced
>>> it.
>>
>> Any chance you might mmiotrace the blob (version 325 or later) to see
>> which registers it fiddles with? Or alternatively, if you have a NVCE
>> card (you never did end up providing the logs which would have made
>> that apparent), could you try replacing nvc3_mc_oclass with
>> nvc0_mc_oclass for the 0xce case in
>> drivers/gpu/drm/nouveau/core/engine/device/nvc0.c? (and boot without
>> the MSI disabling.) The switch has already been made for NVC8 in
>> 0bae1d61c75 -- perhaps there are more "odd" ones.
>>
>>    -ilia
>>
> Fails exactly the same.
>         case 0xc3:
>                 device->cname = "GF106";
>
>                 device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
>                 device->oclass[NVDEV_SUBDEV_GPIO   ] = &nv50_gpio_oclass;
>                 device->oclass[NVDEV_SUBDEV_I2C    ] = &nv94_i2c_oclass;
>                 device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
>                 device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
>                 device->oclass[NVDEV_SUBDEV_MXM    ] = &nv50_mxm_oclass;
>                 device->oclass[NVDEV_SUBDEV_DEVINIT] = &nvc0_devinit_oclass;
>                 device->oclass[NVDEV_SUBDEV_MC     ] = nvc0_mc_oclass;
> <<<<<====
>                 device->oclass[NVDEV_SUBDEV_BUS    ] = nvc0_bus_oclass;
>                 device->oclass[NVDEV_SUBDEV_TIMER  ] = &nv04_timer_oclass;

That's the 0xc3 case... you have a nvce card, not nvc3 -- you would
need to change the NVDEV_SUBDEV_MC line to nvc0_mc_oclass for the 0xce
case.

>
> The dmesg and Xorg.0.log with the problem captured across a ssh link.
>
> # ps fax|grep X
>  5633 pts/0    S+     0:00          \_ grep --color=auto X
>  5160 tty7     Ss+    0:08  \_ /usr/bin/Xorg -br :0 vt7 -nolisten tcp -auth
> /var/lib/kdm/AuthFiles/A:0-yqspza
>
> Also
> # echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
> -bash: echo: write error: Invalid argument.

Take a look at https://wiki.ubuntu.com/X/MMIOTracing

  -ilia
