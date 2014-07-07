Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaGGN5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:57:43 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:36718 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaGGN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <1404022473-2862-1-git-send-email-borneo.antonio@gmail.com>
References: <1404022473-2862-1-git-send-email-borneo.antonio@gmail.com>
Date: Mon, 7 Jul 2014 09:57:38 -0400
Message-ID: <CAN+gG=G-xqc5J8J8ndfL2d8SY3K4+d80LNQX7cgfUeA3ap=oYA@mail.gmail.com>
Subject: Re: [PATCH] HID: cp2112: add I2C mode
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        David Barksdale <dbarksdale@uplogix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio,

On Sun, Jun 29, 2014 at 2:14 AM, Antonio Borneo
<borneo.antonio@gmail.com> wrote:
> cp2112 supports single I2C read/write transactions.
> It can't combine I2C transactions.
>
> Add master_xfer, using similar code flow as for smbus_xfer.

Thanks for taking the time to implement it. I wanted to add this
functionality, but did not found the time to finalize/submit the
patches.
So here is a review.

>
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> ---
>  drivers/hid/hid-cp2112.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 101 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
> index 3952d90..1260a8a 100644
> --- a/drivers/hid/hid-cp2112.c
> +++ b/drivers/hid/hid-cp2112.c
> @@ -429,6 +429,104 @@ static int cp2112_write_req(void *buf, u8 slave_address, u8 command, u8 *data,
>         return data_length + 4;
>  }
>
> +static int cp2112_i2c_write_req(void *buf, u8 slave_address, u8 *data,
> +                               u8 data_length)
> +{
> +       struct cp2112_write_req_report *report = buf;
> +
> +       if (data_length > sizeof(report->data))
> +               return -EINVAL;
> +
> +       report->report = CP2112_DATA_WRITE_REQUEST;
> +       report->slave_address = slave_address << 1;
> +       report->length = data_length;
> +       memcpy(report->data, data, data_length);
> +       return data_length + 3;
> +}
> +
> +static int cp2112_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
> +                          int num)
> +{
> +       struct cp2112_device *dev = (struct cp2112_device *)adap->algo_data;
> +       struct hid_device *hdev = dev->hdev;
> +       u8 buf[64];
> +       ssize_t count;
> +       unsigned int retries;
> +       int ret;
> +
> +       hid_dbg(hdev, "I2C %d messages\n", num);
> +
> +       if (num != 1) {
> +               hid_err(hdev,
> +                       "Multi-message I2C transactions not supported\n");

This is a shame. You can just externalize the following block (in pseudo code):
{ - read/write_req
  - hid_output
  - xfer_status
  - read}

and then just use a for loop to call this sequence for each incoming message.

> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (msgs->flags & I2C_M_RD)
> +               count = cp2112_read_req(buf, msgs->addr, msgs->len);
> +       else
> +               count = cp2112_i2c_write_req(buf, msgs->addr, msgs->buf,
> +                                            msgs->len);
> +
> +       if (count < 0)
> +               return count;
> +
> +       ret = hid_hw_power(hdev, PM_HINT_FULLON);
> +       if (ret < 0) {
> +               hid_err(hdev, "power management error: %d\n", ret);
> +               return ret;
> +       }
> +
> +       ret = cp2112_hid_output(hdev, buf, count, HID_OUTPUT_REPORT);
> +       if (ret < 0) {
> +               hid_warn(hdev, "Error starting transaction: %d\n", ret);
> +               goto power_normal;
> +       }
> +
> +       for (retries = 0; retries < XFER_STATUS_RETRIES; ++retries) {
> +               ret = cp2112_xfer_status(dev);
> +               if (-EBUSY == ret)
> +                       continue;
> +               if (ret < 0)
> +                       goto power_normal;
> +               break;
> +       }
> +
> +       if (XFER_STATUS_RETRIES <= retries) {
> +               hid_warn(hdev, "Transfer timed out, cancelling.\n");
> +               buf[0] = CP2112_CANCEL_TRANSFER;
> +               buf[1] = 0x01;
> +
> +               ret = cp2112_hid_output(hdev, buf, 2, HID_OUTPUT_REPORT);
> +               if (ret < 0)
> +                       hid_warn(hdev, "Error cancelling transaction: %d\n",
> +                                ret);
> +
> +               ret = -ETIMEDOUT;
> +               goto power_normal;
> +       }
> +
> +       if (!(msgs->flags & I2C_M_RD)) {
> +               ret = 0;
> +               goto power_normal;
> +       }
> +
> +       ret = cp2112_read(dev, msgs->buf, msgs->len);
> +       if (ret < 0)
> +               goto power_normal;
> +       if (ret != msgs->len) {
> +               hid_warn(hdev, "short read: %d < %d\n", ret, msgs->len);
> +               ret = -EIO;
> +               goto power_normal;
> +       }
> +
> +       ret = 0;

ret = num;

> +power_normal:
> +       hid_hw_power(hdev, PM_HINT_NORMAL);
> +       hid_dbg(hdev, "I2C transfer finished: %d\n", ret);
> +       return (ret) ? ret : 1;

and "return ret;"

> +}
> +
>  static int cp2112_xfer(struct i2c_adapter *adap, u16 addr,
>                        unsigned short flags, char read_write, u8 command,
>                        int size, union i2c_smbus_data *data)
> @@ -595,7 +693,8 @@ power_normal:
>
>  static u32 cp2112_functionality(struct i2c_adapter *adap)
>  {
> -       return I2C_FUNC_SMBUS_BYTE |
> +       return I2C_FUNC_I2C |
> +               I2C_FUNC_SMBUS_BYTE |
>                 I2C_FUNC_SMBUS_BYTE_DATA |
>                 I2C_FUNC_SMBUS_WORD_DATA |
>                 I2C_FUNC_SMBUS_BLOCK_DATA |
> @@ -605,6 +704,7 @@ static u32 cp2112_functionality(struct i2c_adapter *adap)
>  }
>
>  static const struct i2c_algorithm smbus_algorithm = {
> +       .master_xfer    = cp2112_i2c_xfer,
>         .smbus_xfer     = cp2112_xfer,
>         .functionality  = cp2112_functionality,
>  };
> --
> 2.0.1
>

Cheers,
Benjamin
