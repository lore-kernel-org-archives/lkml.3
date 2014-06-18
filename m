Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbaFRDmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:42:19 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42995 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaFRDmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <1402954800-28215-9-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-9-git-send-email-dianders@chromium.org>
Date: Tue, 17 Jun 2014 20:42:14 -0700
X-Google-Sender-Auth: JwK0_TsP2MlwuVKKRxkYqn2Ye0o
Message-ID: <CAPnjgZ3GhvHog5Pb3_DxYSWF0t4mgR=7HBe2KrfKcsJ=zwmFhQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] mfd: cros_ec: cleanup: Remove EC wrapper functions
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
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 16 June 2014 14:39, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> Remove the three wrapper functions that talk to the EC without passing all
> the desired arguments and just use the underlying communication function
> that passes everything in a struct intead.
>
> This is internal code refactoring only. Nothing should change.
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/i2c/busses/i2c-cros-ec-tunnel.c | 15 +++++++++++----
>  drivers/input/keyboard/cros_ec_keyb.c   | 14 ++++++++++++--
>  drivers/mfd/cros_ec.c                   | 32 --------------------------------
>  include/linux/mfd/cros_ec.h             | 19 ++++++-------------
>  4 files changed, 29 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> index 8e7a714..dd07818 100644
> --- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> +++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
> @@ -183,6 +183,7 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>         u8 *request = NULL;
>         u8 *response = NULL;
>         int result;
> +       struct cros_ec_command msg;
>
>         request_len = ec_i2c_count_message(i2c_msgs, num);
>         if (request_len < 0) {
> @@ -218,9 +219,15 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
>         }
>
>         ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
> -       result = bus->ec->command_sendrecv(bus->ec, EC_CMD_I2C_PASSTHRU,
> -                                          request, request_len,
> -                                          response, response_len);
> +
> +       msg.version = 0;
> +       msg.command = EC_CMD_I2C_PASSTHRU;
> +       msg.outdata = request;
> +       msg.outsize = request_len;
> +       msg.indata = response;
> +       msg.insize = response_len;
> +
> +       result = bus->ec->cmd_xfer(bus->ec, &msg);
>         if (result)
>                 goto exit;
>
> @@ -258,7 +265,7 @@ static int ec_i2c_probe(struct platform_device *pdev)
>         u32 remote_bus;
>         int err;
>
> -       if (!ec->command_sendrecv) {
> +       if (!ec->cmd_xfer) {
>                 dev_err(dev, "Missing sendrecv\n");
>                 return -EINVAL;
>         }
> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index 4083796..dc37b6b 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -191,8 +191,18 @@ static void cros_ec_keyb_close(struct input_dev *dev)
>
>  static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
>  {
> -       return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
> -                                         kb_state, ckdev->cols);
> +       int ret;
> +       struct cros_ec_command msg = {
> +               .version = 0,
> +               .command = EC_CMD_MKBP_STATE,
> +               .outdata = NULL,
> +               .outsize = 0,
> +               .indata = kb_state,
> +               .insize = ckdev->cols,
> +       };
> +
> +       ret = ckdev->ec->cmd_xfer(ckdev->ec, &msg);

Do we need ret?

> +       return ret;
>  }
>
>  static int cros_ec_keyb_work(struct notifier_block *nb,
> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index d242714..6dd91e9 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -44,34 +44,6 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
>  }
>  EXPORT_SYMBOL(cros_ec_prepare_tx);
>
> -static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
> -               uint16_t cmd, void *out_buf, int out_len,
> -               void *in_buf, int in_len)
> -{
> -       struct cros_ec_command msg;
> -
> -       msg.version = cmd >> 8;
> -       msg.command = cmd & 0xff;
> -       msg.outdata = out_buf;
> -       msg.outsize = out_len;
> -       msg.indata = in_buf;
> -       msg.insize = in_len;
> -
> -       return ec_dev->cmd_xfer(ec_dev, &msg);
> -}
> -
> -static int cros_ec_command_recv(struct cros_ec_device *ec_dev,
> -               uint16_t cmd, void *buf, int buf_len)
> -{
> -       return cros_ec_command_sendrecv(ec_dev, cmd, NULL, 0, buf, buf_len);
> -}
> -
> -static int cros_ec_command_send(struct cros_ec_device *ec_dev,
> -               uint16_t cmd, void *buf, int buf_len)
> -{
> -       return cros_ec_command_sendrecv(ec_dev, cmd, buf, buf_len, NULL, 0);
> -}
> -
>  static irqreturn_t ec_irq_thread(int irq, void *data)
>  {
>         struct cros_ec_device *ec_dev = data;
> @@ -104,10 +76,6 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
>
>         BLOCKING_INIT_NOTIFIER_HEAD(&ec_dev->event_notifier);
>
> -       ec_dev->command_send = cros_ec_command_send;
> -       ec_dev->command_recv = cros_ec_command_recv;
> -       ec_dev->command_sendrecv = cros_ec_command_sendrecv;
> -
>         if (ec_dev->din_size) {
>                 ec_dev->din = devm_kzalloc(dev, ec_dev->din_size, GFP_KERNEL);
>                 if (!ec_dev->din)
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 2b0c598..60c0880 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -63,9 +63,10 @@ struct cros_ec_command {
>   * @was_wake_device: true if this device was set to wake the system from
>   * sleep at the last suspend
>   * @event_notifier: interrupt event notifier for transport devices
> - * @command_send: send a command
> - * @command_recv: receive a response
> - * @command_sendrecv: send a command and receive a response
> + * @cmd_xfer: send command to EC and get response
> + *     Returns 0 if the communication succeeded, but that doesn't mean the EC
> + *     was happy with the command it got. Caller should check msg.result for
> + *     the EC's result code.
>   *
>   * @priv: Private data
>   * @irq: Interrupt to use
> @@ -83,7 +84,6 @@ struct cros_ec_command {
>   * @parent: pointer to parent device (e.g. i2c or spi device)
>   * @wake_enabled: true if this device can wake the system from sleep
>   * @lock: one transaction at a time
> - * @cmd_xfer: low-level channel to the EC
>   */
>  struct cros_ec_device {
>
> @@ -94,13 +94,8 @@ struct cros_ec_device {
>         bool was_wake_device;
>         struct class *cros_class;
>         struct blocking_notifier_head event_notifier;
> -       int (*command_send)(struct cros_ec_device *ec,
> -                           uint16_t cmd, void *out_buf, int out_len);
> -       int (*command_recv)(struct cros_ec_device *ec,
> -                           uint16_t cmd, void *in_buf, int in_len);
> -       int (*command_sendrecv)(struct cros_ec_device *ec,
> -                               uint16_t cmd, void *out_buf, int out_len,
> -                               void *in_buf, int in_len);
> +       int (*cmd_xfer)(struct cros_ec_device *ec,
> +                       struct cros_ec_command *msg);
>
>         /* These are used to implement the platform-specific interface */
>         void *priv;
> @@ -112,8 +107,6 @@ struct cros_ec_device {
>         struct device *parent;
>         bool wake_enabled;
>         struct mutex lock;
> -       int (*cmd_xfer)(struct cros_ec_device *ec,
> -                       struct cros_ec_command *msg);

Seems odd - maybe this line move of cmd_xfer() should be in an earlier patch?

Regards,
Simon
