Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaBCP0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:26:23 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46384 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBCP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:26:21 -0500
MIME-Version: 1.0
In-Reply-To: <1391316630-29541-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 3 Feb 2014 16:26:21 +0100
Message-ID: <CANq1E4RD0OVTSVOXHPTchop0Y0q0p1_NEZZexSE4kvkp-17TKw@mail.gmail.com>
Subject: Re: [PATCH 01/11] HID: uHID: implement .raw_request
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> It was missing, so adding it.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/uhid.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
> index f5a2b19..438c9f1 100644
> --- a/drivers/hid/uhid.c
> +++ b/drivers/hid/uhid.c
> @@ -270,6 +270,22 @@ static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
>         return count;
>  }
>
> +static int uhid_raw_request(struct hid_device *hid, unsigned char reportnum,
> +                           __u8 *buf, size_t len, unsigned char rtype,
> +                           int reqtype)
> +{
> +       switch (reqtype) {
> +       case HID_REQ_GET_REPORT:
> +               return uhid_hid_get_raw(hid, reportnum, buf, len, rtype);
> +       case HID_REQ_SET_REPORT:
> +               if (buf[0] != reportnum)
> +                       return -EINVAL;
> +               return uhid_hid_output_raw(hid, buf, len, rtype);

But that one looks wrong. UHID does not have any SET_REPORT query in
the protocol, yet. You turn a SET_REPORT into an OUTPUT_REPORT here.
So if user-space gets the UHID_OUTPUT event, it doesn't know whether
to send a SET_REPORT@ctrl to the device, or an async
OUTPUT_REPORT@intr. This at least matters for low-energy BT in bluez,
which uses uhid.

So we'd have to add an UHID_SET_REPORT event. Note that currently
UHID_FEATURE is the equivalent of UHID_GET_REPORT, but just horribly
named..

Thanks
David

> +       default:
> +               return -EIO;
> +       }
> +}
> +
>  static struct hid_ll_driver uhid_hid_driver = {
>         .start = uhid_hid_start,
>         .stop = uhid_hid_stop,
> @@ -277,6 +293,7 @@ static struct hid_ll_driver uhid_hid_driver = {
>         .close = uhid_hid_close,
>         .parse = uhid_hid_parse,
>         .output_report = uhid_hid_output_report,
> +       .raw_request = uhid_raw_request,
>  };
>
>  #ifdef CONFIG_COMPAT
> --
> 1.8.3.1
>
