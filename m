Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaDWMRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:17:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaDWMRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:17:52 -0400
Message-ID: <1398255470.32091.3.camel@linux-fkkt.site>
Subject: Re: [PATCH v2 11/24] input: Port hid-holtekff to ff-memless-next
From: Oliver Neukum <oneukum@suse.de>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Date: Wed, 23 Apr 2014 14:17:50 +0200
In-Reply-To: <1398175209-9565-12-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
	 <1398175209-9565-12-git-send-email-madcatxster@devoid-pointer.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
>  static int holtekff_play(struct input_dev *dev, void *data,
> -                        struct ff_effect *effect)
> +                        const struct mlnx_effect_command *command)
>  {
>         struct hid_device *hid = input_get_drvdata(dev);
>         struct holtekff_device *holtekff = data;
> +       const struct mlnx_rumble_force *rumble_force =
> &command->u.rumble_force;
>         int left, right;
>         /* effect type 1, length 65535 msec */
>         u8 buf[HOLTEKFF_MSG_LENGTH] =
>                 { 0x01, 0x01, 0xff, 0xff, 0x10, 0xe0, 0x00 };

On the kernel stack.

>  
> -       left = effect->u.rumble.strong_magnitude;
> -       right = effect->u.rumble.weak_magnitude;
> -       dbg_hid("called with 0x%04x 0x%04x\n", left, right);
> +       switch (command->cmd) {
> +       case MLNX_START_RUMBLE:
> +               left = rumble_force->strong;
> +               right = rumble_force->weak;
> +               dbg_hid("called with 0x%04x 0x%04x\n", left, right);
>  
> -       if (!left && !right) {
> -               holtekff_send(holtekff, hid, stop_all6);
> -               return 0;
> -       }
> +               if (!left && !right) {
> +                       holtekff_send(holtekff, hid, stop_all6);
> +                       return 0;
> +               }
>  
> -       if (left)
> -               buf[1] |= 0x80;
> -       if (right)
> -               buf[1] |= 0x40;
> +               if (left)
> +                       buf[1] |= 0x80;
> +               if (right)
> +                       buf[1] |= 0x40;
>  
> -       /* The device takes a single magnitude, so we just sum them
> up. */
> -       buf[6] = min(0xf, (left >> 12) + (right >> 12));
> +               /* The device takes a single magnitude, so we just sum
> them up. */
> +               buf[6] = min(0xf, (left >> 12) + (right >> 12));
>  
> -       holtekff_send(holtekff, hid, buf);
> -       holtekff_send(holtekff, hid, start_effect_1);
> +               holtekff_send(holtekff, hid, buf);
> +               holtekff_send(holtekff, hid, start_effect_1);
> +               return 0;
> +       case MLNX_STOP_RUMBLE:
> +               holtekff_send(holtekff, hid, stop_all6);
> +               return 0;
> +       default:
> +               return -EINVAL;
> +       }
>  
>         return 0;
>  }

This looks very much like doing DMA on the kernel stack.
That is very strictly forbidden. The bug is also in the current
code, but would you care to fix it up?

	Regards
		Oliver


