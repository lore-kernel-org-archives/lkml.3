Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3AJWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:23:18 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:47135 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3AJWXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:23:16 -0500
MIME-Version: 1.0
In-Reply-To: <20130106091026.GA17618@core.coreip.homeip.net>
References: <1356057191-24664-1-git-send-email-shawnn@chromium.org>
	<20130106091026.GA17618@core.coreip.homeip.net>
Date: Thu, 10 Jan 2013 14:23:15 -0800
X-Google-Sender-Auth: 6MQ6-mTIRYJDlXVFMrlkk6YrCcM
Message-ID: <CALaWCOMqm4fk5sC1VrngTBn4OPbUwxpOmWeMS8ww1eaGpaUhBw@mail.gmail.com>
Subject: Re: [PATCH v2] atkbd: Fix multi-char scancode handling on reconnect.
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: jj@chaosbits.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sun, Jan 6, 2013 at 1:10 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Shawn,
>
> On Thu, Dec 20, 2012 at 06:33:11PM -0800, Shawn Nematbakhsh wrote:
>> On resume from suspend there is a possibility for multi-byte scancodes
>> to be handled incorrectly. atkbd_reconnect disables the processing of
>> scancodes in software by calling atkbd_disable, but the keyboard may
>> still be active because no disconnect command was sent. Later, software
>> handling is re-enabled. If a multi-byte scancode sent from the keyboard
>> straddles the re-enable, only the latter byte(s) will be handled.
>>
>> In practice, this leads to cases where multi-byte break codes (ex. "e0
>> 4d" - break code for right-arrow) are misread as make codes ("4d" - make
>> code for numeric 6), leading to one or more unwanted, untyped characters
>> being interpreted.
>>
>> The solution implemented here involves sending command f5 (reset
>> disable) to the keyboard prior to disabling software handling of codes.
>> Later, the command to re-enable the keyboard is sent only after we are
>> prepared to handle scancodes.
>
> The core tries to avoid disturbing devices that are not keyboards, so I
> believe we should check the device ID first and if it is keyboard, then
> do the reset. We should also reset the internal state (emul and xl_bit)
> when re-enabling the device.
>
> Does the version of the patch below work for you?
>
> Thanks.
>
> --
> Dmitry

Thanks for the revision. This version of the patch tests good. I agree
with your changes, it makes sense to deactivate the keyboard from both
connect and reconnect, just in case the keyboard is able to send
scancodes at this point.

--
Shawn

>
> Input: atkbd - fix multi-byte scancode handling on reconnect
>
> From: Shawn Nematbakhsh <shawnn@chromium.org>
>
> On resume from suspend there is a possibility for multi-byte scancodes
> to be handled incorrectly. atkbd_reconnect disables the processing of
> scancodes in software by calling atkbd_disable, but the keyboard may
> still be active because no disconnect command was sent. Later, software
> handling is re-enabled. If a multi-byte scancode sent from the keyboard
> straddles the re-enable, only the latter byte(s) will be handled.
>
> In practice, this leads to cases where multi-byte break codes (ex. "e0
> 4d" - break code for right-arrow) are misread as make codes ("4d" - make
> code for numeric 6), leading to one or more unwanted, untyped characters
> being interpreted.
>
> The solution implemented here involves sending command f5 (reset
> disable) to the keyboard prior to disabling software handling of codes.
> Later, the command to re-enable the keyboard is sent only after we are
> prepared to handle scancodes.
>
> Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/keyboard/atkbd.c |   72 ++++++++++++++++++++++++++++------------
>  1 file changed, 51 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index 33d0fcd..2626773 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -676,6 +676,39 @@ static inline void atkbd_disable(struct atkbd *atkbd)
>         serio_continue_rx(atkbd->ps2dev.serio);
>  }
>
> +static int atkbd_activate(struct atkbd *atkbd)
> +{
> +       struct ps2dev *ps2dev = &atkbd->ps2dev;
> +
> +/*
> + * Enable the keyboard to receive keystrokes.
> + */
> +
> +       if (ps2_command(ps2dev, NULL, ATKBD_CMD_ENABLE)) {
> +               dev_err(&ps2dev->serio->dev,
> +                       "Failed to enable keyboard on %s\n",
> +                       ps2dev->serio->phys);
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * atkbd_deactivate() resets and disables the keyboard from sending
> + * keystrokes.
> + */
> +
> +static void atkbd_deactivate(struct atkbd *atkbd)
> +{
> +       struct ps2dev *ps2dev = &atkbd->ps2dev;
> +
> +       if (ps2_command(ps2dev, NULL, ATKBD_CMD_RESET_DIS))
> +               dev_err(&ps2dev->serio->dev,
> +                       "Failed to deactivate keyboard on %s\n",
> +                       ps2dev->serio->phys);
> +}
> +
>  /*
>   * atkbd_probe() probes for an AT keyboard on a serio port.
>   */
> @@ -731,6 +764,12 @@ static int atkbd_probe(struct atkbd *atkbd)
>                 return -1;
>         }
>
> +/*
> + * Make sure nothing is coming from the keyboard and disturbs our
> + * internal state.
> + */
> +       atkbd_deactivate(atkbd);
> +
>         return 0;
>  }
>
> @@ -825,24 +864,6 @@ static int atkbd_reset_state(struct atkbd *atkbd)
>         return 0;
>  }
>
> -static int atkbd_activate(struct atkbd *atkbd)
> -{
> -       struct ps2dev *ps2dev = &atkbd->ps2dev;
> -
> -/*
> - * Enable the keyboard to receive keystrokes.
> - */
> -
> -       if (ps2_command(ps2dev, NULL, ATKBD_CMD_ENABLE)) {
> -               dev_err(&ps2dev->serio->dev,
> -                       "Failed to enable keyboard on %s\n",
> -                       ps2dev->serio->phys);
> -               return -1;
> -       }
> -
> -       return 0;
> -}
> -
>  /*
>   * atkbd_cleanup() restores the keyboard state so that BIOS is happy after a
>   * reboot.
> @@ -1150,7 +1171,6 @@ static int atkbd_connect(struct serio *serio, struct serio_driver *drv)
>
>                 atkbd->set = atkbd_select_set(atkbd, atkbd_set, atkbd_extra);
>                 atkbd_reset_state(atkbd);
> -               atkbd_activate(atkbd);
>
>         } else {
>                 atkbd->set = 2;
> @@ -1165,6 +1185,8 @@ static int atkbd_connect(struct serio *serio, struct serio_driver *drv)
>                 goto fail3;
>
>         atkbd_enable(atkbd);
> +       if (serio->write)
> +               atkbd_activate(atkbd);
>
>         err = input_register_device(atkbd->dev);
>         if (err)
> @@ -1208,8 +1230,6 @@ static int atkbd_reconnect(struct serio *serio)
>                 if (atkbd->set != atkbd_select_set(atkbd, atkbd->set, atkbd->extra))
>                         goto out;
>
> -               atkbd_activate(atkbd);
> -
>                 /*
>                  * Restore LED state and repeat rate. While input core
>                  * will do this for us at resume time reconnect may happen
> @@ -1223,7 +1243,17 @@ static int atkbd_reconnect(struct serio *serio)
>
>         }
>
> +       /*
> +        * Reset our state machine in case reconnect happened in the middle
> +        * of multi-byte scancode.
> +        */
> +       atkbd->xl_bit = 0;
> +       atkbd->emul = 0;
> +
>         atkbd_enable(atkbd);
> +       if (atkbd->write)
> +               atkbd_activate(atkbd);
> +
>         retval = 0;
>
>   out:
