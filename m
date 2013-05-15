Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3EOHiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:38:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3EOHiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:38:10 -0400
Date: Wed, 15 May 2013 09:37:52 +0200
From: Libor Pechacek <lpechacek@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jkosina@suse.cz, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Petr Ostadal <postadal@suse.cz>, Oliver Neukum <oliver@neukum.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Egbert Eich <eich@suse.com>
Subject: Re: [PATCH 2/2] HID: elo-hid, add quirks for broken firmware
Message-ID: <20130515073752.GD11916@fmn.suse.cz>
References: <1367919659-1548-1-git-send-email-jslaby@suse.cz> <1367919659-1548-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367919659-1548-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07-05-13 11:40:59, Jiri Slaby wrote:
> One firmare version in the devices the driver takes care of is
> completely broken and needs periodic pokes from our side. We
> implemented this as a periodic delayed queue. The idea of the pokes
> was taken from the suse enterprise kernel, in particular from Libor's
> "Elo touchscreen firmware M workaround".
> 
> I am quoting him here:
>   This patch adds periodic polling of the Elo USB touchscreens. Needed
>   as a workaround for devices with M-level firmware, otherwise these
>   devices are known to misbehave (as reported by Elo developers).
> 
> [v2]
> - allocate the buffer only once (per Oliver)
> - add use_fw_quirk module parameter (per Libor)

Thanks, looks OK to me.

Libor

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Petr Ostadal <postadal@suse.cz>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: Vojtech Pavlik <vojtech@suse.cz>
> Cc: Egbert Eich <eich@suse.com>
> Cc: Libor Pechacek <lpechacek@suse.cz>
> ---
>  drivers/hid/hid-elo.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 143 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
> index 56143e0..f042a6c 100644
> --- a/drivers/hid/hid-elo.c
> +++ b/drivers/hid/hid-elo.c
> @@ -11,9 +11,32 @@
>  #include <linux/hid.h>
>  #include <linux/input.h>
>  #include <linux/module.h>
> +#include <linux/usb.h>
> +#include <linux/workqueue.h>
>  
>  #include "hid-ids.h"
>  
> +#define ELO_PERIODIC_READ_INTERVAL	HZ
> +#define ELO_SMARTSET_CMD_TIMEOUT	2000 /* msec */
> +
> +/* Elo SmartSet commands */
> +#define ELO_FLUSH_SMARTSET_RESPONSES	0x02 /* Flush all pending smartset responses */
> +#define ELO_SEND_SMARTSET_COMMAND	0x05 /* Send a smartset command */
> +#define ELO_GET_SMARTSET_RESPONSE	0x06 /* Get a smartset response */
> +#define ELO_DIAG			0x64 /* Diagnostics command */
> +#define ELO_SMARTSET_PACKET_SIZE	8
> +
> +struct elo_priv {
> +	struct usb_device *usbdev;
> +	struct delayed_work work;
> +	unsigned char buffer[ELO_SMARTSET_PACKET_SIZE];
> +};
> +
> +static struct workqueue_struct *wq;
> +static bool use_fw_quirk = true;
> +module_param(use_fw_quirk, bool, S_IRUGO);
> +MODULE_PARM_DESC(use_fw_quirk, "Do periodic pokes for broken M firmwares (default = true)");
> +
>  static void elo_input_configured(struct hid_device *hdev,
>  		struct hid_input *hidinput)
>  {
> @@ -73,10 +96,108 @@ static int elo_raw_event(struct hid_device *hdev, struct hid_report *report,
>  	return 0;
>  }
>  
> +static int elo_smartset_send_get(struct usb_device *dev, u8 command,
> +		void *data)
> +{
> +	unsigned int pipe;
> +	u8 dir;
> +
> +	if (command == ELO_SEND_SMARTSET_COMMAND) {
> +		pipe = usb_sndctrlpipe(dev, 0);
> +		dir = USB_DIR_OUT;
> +	} else if (command == ELO_GET_SMARTSET_RESPONSE) {
> +		pipe = usb_rcvctrlpipe(dev, 0);
> +		dir = USB_DIR_IN;
> +	} else
> +		return -EINVAL;
> +
> +	return usb_control_msg(dev, pipe, command,
> +			dir | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0, 0, data, ELO_SMARTSET_PACKET_SIZE,
> +			ELO_SMARTSET_CMD_TIMEOUT);
> +}
> +
> +static int elo_flush_smartset_responses(struct usb_device *dev)
> +{
> +	return usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +			ELO_FLUSH_SMARTSET_RESPONSES,
> +			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
> +}
> +
> +static void elo_work(struct work_struct *work)
> +{
> +	struct elo_priv *priv = container_of(work, struct elo_priv, work.work);
> +	struct usb_device *dev = priv->usbdev;
> +	unsigned char *buffer = priv->buffer;
> +	int ret;
> +
> +	ret = elo_flush_smartset_responses(dev);
> +	if (ret < 0) {
> +		dev_err(&dev->dev, "initial FLUSH_SMARTSET_RESPONSES failed, error %d\n",
> +				ret);
> +		goto fail;
> +	}
> +
> +	/* send Diagnostics command */
> +	*buffer = ELO_DIAG;
> +	ret = elo_smartset_send_get(dev, ELO_SEND_SMARTSET_COMMAND, buffer);
> +	if (ret < 0) {
> +		dev_err(&dev->dev, "send Diagnostics Command failed, error %d\n",
> +				ret);
> +		goto fail;
> +	}
> +
> +	/* get the result */
> +	ret = elo_smartset_send_get(dev, ELO_GET_SMARTSET_RESPONSE, buffer);
> +	if (ret < 0) {
> +		dev_err(&dev->dev, "get Diagnostics Command response failed, error %d\n",
> +				ret);
> +		goto fail;
> +	}
> +
> +	/* read the ack */
> +	if (*buffer != 'A') {
> +		ret = elo_smartset_send_get(dev, ELO_GET_SMARTSET_RESPONSE,
> +				buffer);
> +		if (ret < 0) {
> +			dev_err(&dev->dev, "get acknowledge response failed, error %d\n",
> +					ret);
> +			goto fail;
> +		}
> +	}
> +
> +fail:
> +	ret = elo_flush_smartset_responses(dev);
> +	if (ret < 0)
> +		dev_err(&dev->dev, "final FLUSH_SMARTSET_RESPONSES failed, error %d\n",
> +				ret);
> +	queue_delayed_work(wq, &priv->work, ELO_PERIODIC_READ_INTERVAL);
> +}
> +
> +/*
> + * Not all Elo devices need the periodic HID descriptor reads.
> + * Only firmware version M needs this.
> + */
> +static bool elo_broken_firmware(struct usb_device *dev)
> +{
> +	return use_fw_quirk && le16_to_cpu(dev->descriptor.bcdDevice) == 0x10d;
> +}
> +
>  static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  {
> +	struct elo_priv *priv;
>  	int ret;
>  
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	INIT_DELAYED_WORK(&priv->work, elo_work);
> +	priv->usbdev = interface_to_usbdev(to_usb_interface(hdev->dev.parent));
> +
> +	hid_set_drvdata(hdev, priv);
> +
>  	ret = hid_parse(hdev);
>  	if (ret) {
>  		hid_err(hdev, "parse failed\n");
> @@ -89,14 +210,24 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  		goto err_free;
>  	}
>  
> +	if (elo_broken_firmware(priv->usbdev)) {
> +		hid_info(hdev, "broken firmware found, installing workaround\n");
> +		queue_delayed_work(wq, &priv->work, ELO_PERIODIC_READ_INTERVAL);
> +	}
> +
>  	return 0;
>  err_free:
> +	kfree(priv);
>  	return ret;
>  }
>  
>  static void elo_remove(struct hid_device *hdev)
>  {
> +	struct elo_priv *priv = hid_get_drvdata(hdev);
> +
>  	hid_hw_stop(hdev);
> +	flush_workqueue(wq);
> +	kfree(priv);
>  }
>  
>  static const struct hid_device_id elo_devices[] = {
> @@ -117,13 +248,24 @@ static struct hid_driver elo_driver = {
>  
>  static int __init elo_driver_init(void)
>  {
> -	return hid_register_driver(&elo_driver);
> +	int ret;
> +
> +	wq = create_singlethread_workqueue("elousb");
> +	if (!wq)
> +		return -ENOMEM;
> +
> +	ret = hid_register_driver(&elo_driver);
> +	if (ret)
> +		destroy_workqueue(wq);
> +
> +	return ret;
>  }
>  module_init(elo_driver_init);
>  
>  static void __exit elo_driver_exit(void)
>  {
>  	hid_unregister_driver(&elo_driver);
> +	destroy_workqueue(wq);
>  }
>  module_exit(elo_driver_exit);
>  
> -- 
> 1.8.2.1
> 

-- 
Libor Pechacek
Project Manager SUSE Labs, Prague
