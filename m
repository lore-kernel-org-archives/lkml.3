Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbaFRDq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:46:29 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:45026 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbaFRDq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <1402954800-28215-11-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-11-git-send-email-dianders@chromium.org>
Date: Tue, 17 Jun 2014 20:46:26 -0700
X-Google-Sender-Auth: IvLpvrpDvQvnBbYL8Q6yycFPsXM
Message-ID: <CAPnjgZ1+y6QYpdio9inzLTi9g4Ew7vkco_MU3GO1_gpndp3dxA@mail.gmail.com>
Subject: Re: [PATCH 10/10] mfd: cros_ec: ec_dev->cmd_xfer() returns number of
 bytes received from EC
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16 June 2014 14:40, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> When communicating with the EC, the cmd_xfer() function should return the
> number of bytes it received from the EC, or negative on error.

This is just for the I2C tunnel feature, right? If so, I think this
should be mentioned here. It seems to be affecting ec_i2c_xfer(), not
cmd_xfer().

>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/i2c/busses/i2c-cros-ec-tunnel.c | 2 +-
>  drivers/mfd/cros_ec_i2c.c               | 2 +-
>  drivers/mfd/cros_ec_spi.c               | 2 +-
>  include/linux/mfd/cros_ec.h             | 8 ++++----
>  4 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> index dd07818..05e033c 100644
> --- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> +++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> @@ -228,7 +228,7 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>         msg.insize = response_len;
>
>         result = bus->ec->cmd_xfer(bus->ec, &msg);
> -       if (result)
> +       if (result < 0)
>                 goto exit;
>
>         result = ec_i2c_parse_response(response, i2c_msgs, &num);
> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> index 2276096..dc0ba29 100644
> --- a/drivers/mfd/cros_ec_i2c.c
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -120,7 +120,7 @@ static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
>                 goto done;
>         }
>
> -       ret = 0;
> +       ret = i2c_msg[1].buf[1];
>   done:
>         kfree(in_buf);
>         kfree(out_buf);
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 4d34f1c..beba1bc 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -333,7 +333,7 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
>                 goto exit;
>         }
>
> -       ret = 0;
> +       ret = len;
>  exit:
>         mutex_unlock(&ec_spi->lock);
>         return ret;
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 60c0880..7b65a75 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -41,7 +41,7 @@ enum {
>   * @outdata: Outgoing data to EC
>   * @outsize: Outgoing length in bytes
>   * @indata: Where to put the incoming data from EC
> - * @insize: Incoming length in bytes (filled in by EC)
> + * @insize: Max number of bytes to accept from EC
>   * @result: EC's response to the command (separate from communication failure)
>   */
>  struct cros_ec_command {
> @@ -64,9 +64,9 @@ struct cros_ec_command {
>   * sleep at the last suspend
>   * @event_notifier: interrupt event notifier for transport devices
>   * @cmd_xfer: send command to EC and get response
> - *     Returns 0 if the communication succeeded, but that doesn't mean the EC
> - *     was happy with the command it got. Caller should check msg.result for
> - *     the EC's result code.
> + *     Returns the number of bytes received if the communication succeeded, but
> + *     that doesn't mean the EC was happy with the command. The caller
> + *     should check msg.result for the EC's result code.
>   *
>   * @priv: Private data
>   * @irq: Interrupt to use
> --
> 2.0.0.526.g5318336
>

Regards,
Simon
