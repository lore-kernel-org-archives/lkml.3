Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3AOJhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:37:45 -0500
Received: from smtp208.alice.it ([82.57.200.104]:42618 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3AOJhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:37:42 -0500
Date: Tue, 15 Jan 2013 10:36:38 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add support for Sony RF receiver with USB product
 id 0x0374
Message-Id: <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>
In-Reply-To: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 12:43:48 +0900
Fernando Luis Vázquez Cao  <fernando_b1@lab.ntt.co.jp> wrote:

Hi Fernando,

> Some Vaio desktop computers, among them the VGC-LN51JGB multimedia PC, have
> a RF receiver, multi-interface USB device 054c:0374, that is used to connect
> a wireless keyboard and a wireless mouse.
> 
> The keyboard works flawlessly, but the mouse (VGP-WMS3 in my case) does not
> seem to be generating any pointer events. The problem is that the mouse pointer
> is wrongly declared as a constant non-data variable in the report descriptor
> (see lsusb and usbhid-dump output below), with the consenquence that it is

typo: consequence

> ignored by the HID code.
> 
> Add this device to the have-special-driver list and fix up the report
> descriptor in the Sony-specific driver which happens to already have a fixup
> for a similar firmware bug.
> 
> # lsusb -vd 054C:0374
> Bus 003 Device 002: ID 054c:0374 Sony Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         8
>   idVendor           0x054c Sony Corp.
>   idProduct          0x0374
>   iSerial                 0
> [...]
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      1 Boot Interface Subclass
>       bInterfaceProtocol      2 Mouse
>       iInterface              2 RF Receiver
> [...]
>           Report Descriptor: (length is 100)
>             Item(Global): Usage Page, data= [ 0x01 ] 1
>                             Generic Desktop Controls
>             Item(Local ): Usage, data= [ 0x30 ] 48
>                             Direction-X
>             Item(Local ): Usage, data= [ 0x31 ] 49
>                             Direction-Y
>             Item(Global): Report Count, data= [ 0x02 ] 2
>             Item(Global): Report Size, data= [ 0x08 ] 8
>             Item(Global): Logical Minimum, data= [ 0x81 ] 129
>             Item(Global): Logical Maximum, data= [ 0x7f ] 127
>             Item(Main  ): Input, data= [ 0x07 ] 7
>                             Constant Variable Relative No_Wrap Linear
>                             Preferred_State No_Null_Position Non_Volatile Bitfield
> 
> # sudo usbhid-dump
> 
> 003:002:001:DESCRIPTOR         1357910009.758544
>  05 01 09 02 A1 01 05 01 09 02 A1 02 85 01 09 01
>  A1 00 05 09 19 01 29 05 95 05 75 01 15 00 25 01
>  81 02 75 03 95 01 81 01 05 01 09 30 09 31 95 02
>  75 08 15 81 25 7F 81 07 A1 02 85 01 09 38 35 00
>  45 00 15 81 25 7F 95 01 75 08 81 06 C0 A1 02 85
>  01 05 0C 15 81 25 7F 95 01 75 08 0A 38 02 81 06
>  C0 C0 C0 C0
> 
> Cc: linux-input@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-3.8-rc3-orig/drivers/hid/hid-core.c linux-3.8-rc3/drivers/hid/hid-core.c
> --- linux-3.8-rc3-orig/drivers/hid/hid-core.c	2013-01-13 20:54:36.846952518 +0900
> +++ linux-3.8-rc3/drivers/hid/hid-core.c	2013-01-13 18:21:19.901347327 +0900
> @@ -1697,6 +1697,7 @@ static const struct hid_device_id hid_ha
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
> diff -urNp linux-3.8-rc3-orig/drivers/hid/hid-ids.h linux-3.8-rc3/drivers/hid/hid-ids.h
> --- linux-3.8-rc3-orig/drivers/hid/hid-ids.h	2013-01-13 20:54:36.850952537 +0900
> +++ linux-3.8-rc3/drivers/hid/hid-ids.h	2013-01-13 18:21:19.901347327 +0900
> @@ -706,6 +706,7 @@
>  
>  #define USB_VENDOR_ID_SONY			0x054c
>  #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
> +#define USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE	0x0374
>  #define USB_DEVICE_ID_SONY_PS3_BDREMOTE		0x0306
>  #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
>  #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
> diff -urNp linux-3.8-rc3-orig/drivers/hid/hid-sony.c linux-3.8-rc3/drivers/hid/hid-sony.c
> --- linux-3.8-rc3-orig/drivers/hid/hid-sony.c	2012-12-11 12:30:57.000000000 +0900
> +++ linux-3.8-rc3/drivers/hid/hid-sony.c	2013-01-13 18:21:19.901347327 +0900
> @@ -44,19 +44,21 @@ static __u8 *sony_report_fixup(struct hi
>  	struct sony_sc *sc = hid_get_drvdata(hdev);
>  
>  	if ((sc->quirks & VAIO_RDESC_CONSTANT) &&
> -			*rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
> -		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
> +	    *rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
> +		hid_info(hdev,
> +		         "Fixing up Sony RF Receiver report descriptor\n");

Changing the message does make sense, but try to avoid mixing
functional changes with style changes (I am referring to the change of
indentation here).

If you _really_ want to change the style send a separate patch stating
clearly in the commit message that there are no functionality changes.

This makes the review easier for both kind of patches.

>  		rdesc[55] = 0x06;
>  	}
>  
>  	/* The HID descriptor exposed over BT has a trailing zero byte */
>  	if ((((sc->quirks & SIXAXIS_CONTROLLER_USB) && *rsize == 148) ||
> -			((sc->quirks & SIXAXIS_CONTROLLER_BT) && *rsize == 149)) &&
> -			rdesc[83] == 0x75) {
> +	        ((sc->quirks & SIXAXIS_CONTROLLER_BT) && *rsize == 149)) &&
> +	    rdesc[83] == 0x75) {

Ditto, style changes.

>  		hid_info(hdev, "Fixing up Sony Sixaxis report descriptor\n");
>  		memcpy((void *)&rdesc[83], (void *)&sixaxis_rdesc_fixup,
>  			sizeof(sixaxis_rdesc_fixup));
>  	}
> +

Ditto.

>  	return rdesc;
>  }
>  
> @@ -217,6 +219,8 @@ static const struct hid_device_id sony_d
>  		.driver_data = SIXAXIS_CONTROLLER_BT },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE),
>  		.driver_data = VAIO_RDESC_CONSTANT },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE),
> +		.driver_data = VAIO_RDESC_CONSTANT },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(hid, sony_devices);
> 
> 

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
