Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3CRJbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:31:31 -0400
Received: from canardo.mork.no ([148.122.252.1]:58187 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab3CRJb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:31:28 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: Re: [RFC V1 7/8] smi2021: Add smi2021_bl.c
Organization: m
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
	<1363270024-12127-8-git-send-email-jonarne@jonarne.no>
Date: Mon, 18 Mar 2013 10:31:14 +0100
In-Reply-To: <1363270024-12127-8-git-send-email-jonarne@jonarne.no> ("Jon
 Arne
	=?utf-8?Q?J=C3=B8rgensen=22's?= message of "Thu, 14 Mar 2013 15:07:03
 +0100")
Message-ID: <871ubd3vh9.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Arne Jørgensen <jonarne@jonarne.no> writes:

> This is the smi2021-bootloader module.
> This module will upload the firmware for the different somagic devices.

I really don't understand why you want to make that a separate module.
Building both the bootlader driver and the real driver into the same
module will make sure that either both or none are available, document
the relationship to the end user, and allow you to tell the user that
firmware files may be needed for the real driver by using the
MODULE_FIRMWARE macro (which you should do, IMHO).

> +static unsigned int firmware_version;
> +module_param(firmware_version, int, 0644);
> +MODULE_PARM_DESC(firmware_version,
> +			"Firmware version to be uploaded to device\n"
> +			"if there are more than one firmware present");
> +
> +struct usb_device_id smi2021_bootloader_id_table[] = {
> +	{ USB_DEVICE(0x1c88, 0x0007) },
> +	{ }
> +};
> +
> +struct smi2021_firmware {
> +	int		id;
> +	const char	*name;
> +	int		found;
> +};
> +
> +struct smi2021_firmware available_fw[] = {
> +	{
> +		.id = 0x3c,
> +		.name = "smi2021_3c.bin",
> +	},
> +	{
> +		.id = 0x3e,
> +		.name = "smi2021_3e.bin",
> +	},
> +	{
> +		.id = 0x3f,
> +		.name = "smi2021_3f.bin",
> +	}
> +};


How does the user know which firmware to select?  Will any of them work,
or are they device specific? Either way I believe you should publish all
three names using MODULE_FIRMWARE.


> +static int smi2021_load_firmware(struct usb_device *udev,
> +					const struct firmware *firmware)
> +{
> +	int i, size, rc = 0;
> +	u8 *chunk;
> +	u16 ack = 0x0000;
> +
> +	if (udev == NULL)
> +		goto end_out;

Is this possible? 



> +	size = FIRMWARE_CHUNK_SIZE + FIRMWARE_HEADER_SIZE;
> +	chunk = kzalloc(size, GFP_KERNEL);
> +	chunk[0] = 0x05;
> +	chunk[1] = 0xff;
> +
> +	if (chunk == NULL) {

This on the other hand, will happen.  But you have already oopsed when
you test it here...


Bjørn
