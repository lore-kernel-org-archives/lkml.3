Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbaFRHlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:41:01 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62942 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134AbaFRHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:40:57 -0400
Date: Wed, 18 Jun 2014 08:40:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Simon Glass <sjg@chromium.org>, Andrew Bresticker <abrestic@chromium.org>,
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
Subject: Re: [PATCH 08/10] mfd: cros_ec: cleanup: Remove EC wrapper functions
Message-ID: <20140618074049.GD21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-9-git-send-email-dianders@chromium.org>
 <CAPnjgZ3GhvHog5Pb3_DxYSWF0t4mgR=7HBe2KrfKcsJ=zwmFhQ@mail.gmail.com>
 <CAD=FV=Ue9OBkXtii4aKrCbKPd--7ZRN_G0pw2ZtX89mcz_hfzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=Ue9OBkXtii4aKrCbKPd--7ZRN_G0pw2ZtX89mcz_hfzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> >> index 4083796..dc37b6b 100644
> >> --- a/drivers/input/keyboard/cros_ec_keyb.c
> >> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> >> @@ -191,8 +191,18 @@ static void cros_ec_keyb_close(struct input_dev *dev)
> >>
> >>  static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
> >>  {
> >> -       return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
> >> -                                         kb_state, ckdev->cols);
> >> +       int ret;
> >> +       struct cros_ec_command msg = {
> >> +               .version = 0,
> >> +               .command = EC_CMD_MKBP_STATE,
> >> +               .outdata = NULL,
> >> +               .outsize = 0,
> >> +               .indata = kb_state,
> >> +               .insize = ckdev->cols,
> >> +       };
> >> +
> >> +       ret = ckdev->ec->cmd_xfer(ckdev->ec, &msg);
> >
> > Do we need ret?
> 
> No.  If you wish I will spin without it.  Let me know.
> 
> Note that locally this code includes a comment between the above and the return:
>   /* FIXME: This assumes msg.result == EC_RES_SUCCESS */
> 
> Given that this is not a new problem introduced in this code, that it
> still hasn't been fixed locally in the ChromeOS tree, and that
> generally FIXMEs don't seem to be left in the code upstream, I left it
> out.

As you're re-spinning anyway, please fix this and add my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

> >> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> >> index 2b0c598..60c0880 100644
> >> --- a/include/linux/mfd/cros_ec.h
> >> +++ b/include/linux/mfd/cros_ec.h
> >> @@ -63,9 +63,10 @@ struct cros_ec_command {
> >>   * @was_wake_device: true if this device was set to wake the system from
> >>   * sleep at the last suspend
> >>   * @event_notifier: interrupt event notifier for transport devices
> >> - * @command_send: send a command
> >> - * @command_recv: receive a response
> >> - * @command_sendrecv: send a command and receive a response
> >> + * @cmd_xfer: send command to EC and get response
> >> + *     Returns 0 if the communication succeeded, but that doesn't mean the EC
> >> + *     was happy with the command it got. Caller should check msg.result for
> >> + *     the EC's result code.
> >>   *
> >>   * @priv: Private data
> >>   * @irq: Interrupt to use
> >> @@ -83,7 +84,6 @@ struct cros_ec_command {
> >>   * @parent: pointer to parent device (e.g. i2c or spi device)
> >>   * @wake_enabled: true if this device can wake the system from sleep
> >>   * @lock: one transaction at a time
> >> - * @cmd_xfer: low-level channel to the EC
> >>   */
> >>  struct cros_ec_device {
> >>
> >> @@ -94,13 +94,8 @@ struct cros_ec_device {
> >>         bool was_wake_device;
> >>         struct class *cros_class;
> >>         struct blocking_notifier_head event_notifier;
> >> -       int (*command_send)(struct cros_ec_device *ec,
> >> -                           uint16_t cmd, void *out_buf, int out_len);
> >> -       int (*command_recv)(struct cros_ec_device *ec,
> >> -                           uint16_t cmd, void *in_buf, int in_len);
> >> -       int (*command_sendrecv)(struct cros_ec_device *ec,
> >> -                               uint16_t cmd, void *out_buf, int out_len,
> >> -                               void *in_buf, int in_len);
> >> +       int (*cmd_xfer)(struct cros_ec_device *ec,
> >> +                       struct cros_ec_command *msg);
> >>
> >>         /* These are used to implement the platform-specific interface */
> >>         void *priv;
> >> @@ -112,8 +107,6 @@ struct cros_ec_device {
> >>         struct device *parent;
> >>         bool wake_enabled;
> >>         struct mutex lock;
> >> -       int (*cmd_xfer)(struct cros_ec_device *ec,
> >> -                       struct cros_ec_command *msg);
> >
> > Seems odd - maybe this line move of cmd_xfer() should be in an earlier patch?
> 
> It got moved from "private" to public.  Bill reorganized all the
> public stuff at the top and the private at the bottom.
> 
> -Doug

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
