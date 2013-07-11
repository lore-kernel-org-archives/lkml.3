Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3GKWuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:50:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab3GKWuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:50:44 -0400
Date: Fri, 12 Jul 2013 00:50:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Bluetooth: hidp: implement hidinput_input_event
 callback
In-Reply-To: <1373550090-30379-2-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1307120050170.29788@pobox.suse.cz>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com> <1373550090-30379-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Benjamin Tissoires wrote:

> We can re-enable hidinput_input_event to allow the leds of bluetooth
> keyboards to be set.
> Now the callbacks uses hid core to retrieve the right HID report to
> send, so this version is safer.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

> ---
>  net/bluetooth/hidp/core.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index f13a8da..9c8b50d 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -238,6 +238,31 @@ static int hidp_send_report(struct hidp_session *session, struct hid_report *rep
>  	return hidp_send_intr_message(session, hdr, buf, rsize);
>  }
>  
> +static int hidp_hidinput_event(struct input_dev *dev, unsigned int type,
> +			       unsigned int code, int value)
> +{
> +	struct hid_device *hid = input_get_drvdata(dev);
> +	struct hidp_session *session = hid->driver_data;
> +	struct hid_field *field;
> +	int offset;
> +
> +	BT_DBG("session %p type %d code %d value %d",
> +	       session, type, code, value);
> +
> +	if (type != EV_LED)
> +		return -1;
> +
> +	offset = hidinput_find_field(hid, type, code, &field);
> +	if (offset == -1) {
> +		hid_warn(dev, "event field not found\n");
> +		return -1;
> +	}
> +
> +	hid_set_field(field, offset, value);
> +
> +	return hidp_send_report(session, field->report);
> +}
> +
>  static int hidp_get_raw_report(struct hid_device *hid,
>  		unsigned char report_number,
>  		unsigned char *data, size_t count,
> @@ -711,6 +736,7 @@ static struct hid_ll_driver hidp_hid_driver = {
>  	.stop = hidp_stop,
>  	.open  = hidp_open,
>  	.close = hidp_close,
> +	.hidinput_input_event = hidp_hidinput_event,
>  };
>  
>  /* This function sets up the hid device. It does not add it
> -- 
> 1.8.3.1
> 

-- 
Jiri Kosina
SUSE Labs
