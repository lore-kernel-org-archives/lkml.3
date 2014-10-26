Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaJZTdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 15:33:22 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:45850 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaJZTdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 15:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <20141025090307.GA31078@hardeman.nu>
References: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
	<20141025090307.GA31078@hardeman.nu>
Date: Sun, 26 Oct 2014 21:33:19 +0200
X-Google-Sender-Auth: 9W8LjnCz_6cabV5SCHSbPdU2Scs
Message-ID: <CACraW2pZnOnjj4iXoAN4A23efWVoL4ZjFXvXiS4ktxZ5YYEz9Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] [media] rc-core: fix protocol_change regression in ir_raw_event_register
From: Tomas Melin <tomas.melin@iki.fi>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Tomas Melin <tomas.melin@iki.fi>, james.hogan@imgtec.com,
        =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
        =?UTF-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCR0LXRgNGB0LXQvdC10LI=?= 
	<bay@hackerdom.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 12:03 PM, David Härdeman <david@hardeman.nu> wrote:
> Wouldn't something like this be a simpler way of achieving the same
> result? (untested):

The idea was to remove the empty change_protocol function that had
been added in the breaking commit.
IMHO, it would be better to not have functions that don't do anything.
Actually, another problem with that empty function is that if the
driver first sets up a "real" change_protocol function and related
data, and then calls rc_register_device, the driver defined
change_protocol function would be overwritten.


> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index a7991c7..d521f20 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1421,6 +1421,9 @@ int rc_register_device(struct rc_dev *dev)
>
>         if (dev->change_protocol) {
>                 u64 rc_type = (1 << rc_map->rc_type);
> +               if (dev->driver_type == RC_DRIVER_IR_RAW)
> +                       rc_type |= RC_BIT_LIRC;
> +
>                 rc = dev->change_protocol(dev, &rc_type);
>                 if (rc < 0)
>                         goto out_raw;

But otherwise yes, your suggestion could work, with the addition that
we still need to update enabled_protocols (and not init
enabled_protocols anymore in ir_raw_event_register() ).
+               dev->enabled_protocols = (rc_type | RC_BIT_LIRC);

Please let me know your preferences on which you prefer, and, if
needed, I'll make a new patch version.
Tomas
