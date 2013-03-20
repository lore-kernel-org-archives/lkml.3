Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3CTI4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:56:43 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:47047 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754703Ab3CTI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:56:40 -0400
Date: Wed, 20 Mar 2013 09:59:53 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: Re: [RFC V1 7/8] smi2021: Add smi2021_bl.c
Message-ID: <20130320085953.GG17291@dell.arpanet.local>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <1363270024-12127-8-git-send-email-jonarne@jonarne.no>
 <871ubd3vh9.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871ubd3vh9.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:31:14AM +0100, Bjørn Mork wrote:
> Jon Arne Jørgensen <jonarne@jonarne.no> writes:
> 
> > This is the smi2021-bootloader module.
> > This module will upload the firmware for the different somagic devices.
> 
> I really don't understand why you want to make that a separate module.
> Building both the bootlader driver and the real driver into the same
> module will make sure that either both or none are available, document
> the relationship to the end user, and allow you to tell the user that
> firmware files may be needed for the real driver by using the
> MODULE_FIRMWARE macro (which you should do, IMHO).
>

I made this a separate module because there is one version of this
device that doesn't need any firmware.
But I think it would be better to include the bootloader in the real driver
for simplicity.

> > +static unsigned int firmware_version;
> > +module_param(firmware_version, int, 0644);
> > +MODULE_PARM_DESC(firmware_version,
> > +			"Firmware version to be uploaded to device\n"
> > +			"if there are more than one firmware present");
> > +
> > +struct usb_device_id smi2021_bootloader_id_table[] = {
> > +	{ USB_DEVICE(0x1c88, 0x0007) },
> > +	{ }
> > +};
> > +
> > +struct smi2021_firmware {
> > +	int		id;
> > +	const char	*name;
> > +	int		found;
> > +};
> > +
> > +struct smi2021_firmware available_fw[] = {
> > +	{
> > +		.id = 0x3c,
> > +		.name = "smi2021_3c.bin",
> > +	},
> > +	{
> > +		.id = 0x3e,
> > +		.name = "smi2021_3e.bin",
> > +	},
> > +	{
> > +		.id = 0x3f,
> > +		.name = "smi2021_3f.bin",
> > +	}
> > +};
> 
> 
> How does the user know which firmware to select?  Will any of them work,
> or are they device specific? Either way I believe you should publish all
> three names using MODULE_FIRMWARE.
> 
>

The problem with this device is that there is no way for the user to
know what version of the device he's got before the firmware is uploaded
to the device.

Any device will accept any firmware, but it will not function without
the correct firmware.

The only way to see what version of the firmware you will need is to
test the driver on a Windows machine with the driver that came with the
device. I have no idea about what the windows driver will do if you have
more than one version of this device.

> > +static int smi2021_load_firmware(struct usb_device *udev,
> > +					const struct firmware *firmware)
> > +{
> > +	int i, size, rc = 0;
> > +	u8 *chunk;
> > +	u16 ack = 0x0000;
> > +
> > +	if (udev == NULL)
> > +		goto end_out;
> 
> Is this possible? 
> 
> 
> 

Probably not, I'll remove this check :)

> > +	size = FIRMWARE_CHUNK_SIZE + FIRMWARE_HEADER_SIZE;
> > +	chunk = kzalloc(size, GFP_KERNEL);
> > +	chunk[0] = 0x05;
> > +	chunk[1] = 0xff;
> > +
> > +	if (chunk == NULL) {
> 
> This on the other hand, will happen.  But you have already oopsed when
> you test it here...
> 
>

Yes, that is true.
I will fix,

thank you for your review.

> Bjørn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
