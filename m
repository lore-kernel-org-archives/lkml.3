Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBLK3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:29:35 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55950 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaBLK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:29:31 -0500
MIME-Version: 1.0
In-Reply-To: <1392055139-19631-5-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-5-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 12 Feb 2014 11:29:31 +0100
Message-ID: <CANq1E4Qr1g7_BuKejQP66QAgDCu+QhtwE+LwpEVzeLKX7zt2YQ@mail.gmail.com>
Subject: Re: [PATCH 04/14] HID: i2c-hid: implement ll_driver transport-layer callbacks
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Add output_report and raw_request to i2c-hid.
> The current implementation of i2c_hid_output_raw_report decides
> by itself if it should use a direct send of the output report
> or use the data register (SET_REPORT). Split that by reimplement
> the logic in __i2c_hid_output_raw_report() which will be dropped
> soon.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 69 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 60 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index f57de7f..07a054a 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -257,12 +257,21 @@ static int i2c_hid_get_report(struct i2c_client *client, u8 reportType,
>         return 0;
>  }
>
> -static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
> -               u8 reportID, unsigned char *buf, size_t data_len)
> +/**
> + * i2c_hid_set_or_send_report: forward an incoming report to the device
> + * @client: the i2c_client of the device
> + * @reportType: 0x03 for HID_FEATURE_REPORT ; 0x02 for HID_OUTPUT_REPORT
> + * @reportID: the report ID
> + * @buf: the actual data to transfer, without the report ID
> + * @len: size of buf
> + * @use_data: true: use SET_REPORT HID command, false: send plain OUTPUT report
> + */
> +static int i2c_hid_set_or_send_report(struct i2c_client *client, u8 reportType,
> +               u8 reportID, unsigned char *buf, size_t data_len, bool use_data)
>  {
>         struct i2c_hid *ihid = i2c_get_clientdata(client);
>         u8 *args = ihid->argsbuf;
> -       const struct i2c_hid_cmd * hidcmd = &hid_set_report_cmd;
> +       const struct i2c_hid_cmd *hidcmd;
>         int ret;
>         u16 dataRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
>         u16 outputRegister = le16_to_cpu(ihid->hdesc.wOutputRegister);
> @@ -279,6 +288,9 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>
>         i2c_hid_dbg(ihid, "%s\n", __func__);
>
> +       if (!use_data && maxOutputLength == 0)
> +               return -ENOSYS;
> +
>         if (reportID >= 0x0F) {
>                 args[index++] = reportID;
>                 reportID = 0x0F;
> @@ -288,9 +300,10 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>          * use the data register for feature reports or if the device does not
>          * support the output register
>          */
> -       if (reportType == 0x03 || maxOutputLength == 0) {
> +       if (use_data) {
>                 args[index++] = dataRegister & 0xFF;
>                 args[index++] = dataRegister >> 8;
> +               hidcmd = &hid_set_report_cmd;
>         } else {
>                 args[index++] = outputRegister & 0xFF;
>                 args[index++] = outputRegister >> 8;
> @@ -559,7 +572,7 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
>  }
>
>  static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
> -               size_t count, unsigned char report_type)
> +               size_t count, unsigned char report_type, bool use_data)
>  {
>         struct i2c_client *client = hid->driver_data;
>         int report_id = buf[0];
> @@ -573,9 +586,9 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
>                 count--;
>         }
>
> -       ret = i2c_hid_set_report(client,
> +       ret = i2c_hid_set_or_send_report(client,
>                                 report_type == HID_FEATURE_REPORT ? 0x03 : 0x02,
> -                               report_id, buf, count);
> +                               report_id, buf, count, use_data);
>
>         if (report_id && ret >= 0)
>                 ret++; /* add report_id to the number of transfered bytes */
> @@ -583,6 +596,42 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
>         return ret;
>  }
>
> +static int __i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
> +               size_t count, unsigned char report_type)
> +{
> +       struct i2c_client *client = hid->driver_data;
> +       struct i2c_hid *ihid = i2c_get_clientdata(client);
> +       bool data = true; /* SET_REPORT */
> +
> +       if (report_type == HID_OUTPUT_REPORT)
> +               data = le16_to_cpu(ihid->hdesc.wMaxOutputLength) == 0;

Yepp, thanks for splitting that logic out of the report-handling,
makes it much easier to follow.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> +
> +       return i2c_hid_output_raw_report(hid, buf, count, report_type, data);
> +}
> +
> +static int i2c_hid_output_report(struct hid_device *hid, __u8 *buf,
> +               size_t count)
> +{
> +       return i2c_hid_output_raw_report(hid, buf, count, HID_OUTPUT_REPORT,
> +                       false);
> +}
> +
> +static int i2c_hid_raw_request(struct hid_device *hid, unsigned char reportnum,
> +                              __u8 *buf, size_t len, unsigned char rtype,
> +                              int reqtype)
> +{
> +       switch (reqtype) {
> +       case HID_REQ_GET_REPORT:
> +               return i2c_hid_get_raw_report(hid, reportnum, buf, len, rtype);
> +       case HID_REQ_SET_REPORT:
> +               if (buf[0] != reportnum)
> +                       return -EINVAL;
> +               return i2c_hid_output_raw_report(hid, buf, len, rtype, true);
> +       default:
> +               return -EIO;
> +       }
> +}
> +
>  static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
>                 int reqtype)
>  {
> @@ -606,7 +655,7 @@ static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
>                 break;
>         case HID_REQ_SET_REPORT:
>                 hid_output_report(rep, buf);
> -               i2c_hid_output_raw_report(hid, buf, len, rep->type);
> +               i2c_hid_output_raw_report(hid, buf, len, rep->type, true);
>                 break;
>         }
>
> @@ -769,6 +818,8 @@ static struct hid_ll_driver i2c_hid_ll_driver = {
>         .close = i2c_hid_close,
>         .power = i2c_hid_power,
>         .request = i2c_hid_request,
> +       .output_report = i2c_hid_output_report,
> +       .raw_request = i2c_hid_raw_request,
>  };
>
>  static int i2c_hid_init_irq(struct i2c_client *client)
> @@ -1003,7 +1054,7 @@ static int i2c_hid_probe(struct i2c_client *client,
>
>         hid->driver_data = client;
>         hid->ll_driver = &i2c_hid_ll_driver;
> -       hid->hid_output_raw_report = i2c_hid_output_raw_report;
> +       hid->hid_output_raw_report = __i2c_hid_output_raw_report;
>         hid->dev.parent = &client->dev;
>         ACPI_COMPANION_SET(&hid->dev, ACPI_COMPANION(&client->dev));
>         hid->bus = BUS_I2C;
> --
> 1.8.3.1
>
