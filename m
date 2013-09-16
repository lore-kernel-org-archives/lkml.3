Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3IPPU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:20:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36762 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3IPPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:20:25 -0400
Date: Mon, 16 Sep 2013 08:20:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, linux-input@vger.kernel.org,
        vojtech@suse.cz, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
 synthetic keyboard
Message-ID: <20130916152019.GB12105@core.coreip.homeip.net>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379309334-25042-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi K. Y.

On Sun, Sep 15, 2013 at 10:28:54PM -0700, K. Y. Srinivasan wrote:
> Add a new driver to support synthetic keyboard. On the next generation
> Hyper-V guest firmware, many legacy devices will not be emulated and this
> driver will be required.
> 
> I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
> details of the AT keyboard driver. 
> 

In addition to what Dan said:

> +
> +struct synth_kbd_protocol_response {
> +	struct synth_kbd_msg_hdr header;
> +	u32 accepted:1;
> +	u32 reserved:31;
> +};

Use of bitfields for on the wire structures makes me uneasy. I know that
currently you only going to run LE on LE, but still, maybe using
explicit shifts and masks would be better,

> +
> +struct synth_kbd_keystroke {
> +	struct synth_kbd_msg_hdr header;
> +	u16 make_code;
> +	u16 reserved0;
> +	u32 is_unicode:1;
> +	u32 is_break:1;
> +	u32 is_e0:1;
> +	u32 is_e1:1;
> +	u32 reserved:28;
> +};

Same here.

> +
> +
> +#define HK_MAXIMUM_MESSAGE_SIZE 256
> +
> +#define KBD_VSC_SEND_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
> +#define KBD_VSC_RECV_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
> +
> +#define XTKBD_EMUL0     0xe0
> +#define XTKBD_EMUL1     0xe1
> +#define XTKBD_RELEASE   0x80
> +
> +
> +/*
> + * Represents a keyboard device
> + */
> +struct hv_kbd_dev {
> +	unsigned char keycode[256];

I do not see anything using keycode table? This is wrong level for it
regardless.

> +	struct hv_device	*device;
> +	struct synth_kbd_protocol_request protocol_req;
> +	struct synth_kbd_protocol_response protocol_resp;
> +	/* Synchronize the request/response if needed */
> +	struct completion	wait_event;
> +	struct serio		*hv_serio;
> +};
> +
> +
> +static struct hv_kbd_dev *hv_kbd_alloc_device(struct hv_device *device)
> +{
> +	struct hv_kbd_dev *kbd_dev;
> +	struct serio	*hv_serio;

You are aligning with tabs half of declarations, leaving the others. Can
we not align at all?

> +
> +	kbd_dev = kzalloc(sizeof(struct hv_kbd_dev), GFP_KERNEL);
> +
> +	if (!kbd_dev)
> +		return NULL;
> +
> +	hv_serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
> +
> +	if (hv_serio == NULL) {
> +		kfree(kbd_dev);
> +		return NULL;
> +	}
> +
> +	hv_serio->id.type	= SERIO_8042_XL;
> +	strlcpy(hv_serio->name, dev_name(&device->device),
> +		sizeof(hv_serio->name));
> +	strlcpy(hv_serio->phys, dev_name(&device->device),
> +		sizeof(hv_serio->phys));
> +	hv_serio->dev.parent  = &device->device;

Do you also want to set up serio's parent device to point to hv device?

> +
> +
> +	kbd_dev->device = device;
> +	kbd_dev->hv_serio = hv_serio;
> +	hv_set_drvdata(device, kbd_dev);
> +	init_completion(&kbd_dev->wait_event);
> +
> +	return kbd_dev;
> +}
> +
> +static void hv_kbd_free_device(struct hv_kbd_dev *device)
> +{
> +	serio_unregister_port(device->hv_serio);
> +	kfree(device->hv_serio);

Serio ports are refcounted, do not free them explicitly after they have
been registered.

> +	hv_set_drvdata(device->device, NULL);
> +	kfree(device);
> +}


Thanks.

-- 
Dmitry
