Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbbAWSzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:55:00 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46422 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbAWSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:54:57 -0500
MIME-Version: 1.0
In-Reply-To: <0000014b17cfde4d-df42e887-9524-4f07-a46b-5d81f01fc687-000000@email.amazonses.com>
References: <1422033640-4104-1-git-send-email-jimkeir@oracledbadirect.com>
	<0000014b17cfde4d-df42e887-9524-4f07-a46b-5d81f01fc687-000000@email.amazonses.com>
Date: Fri, 23 Jan 2015 13:54:56 -0500
Message-ID: <CAN+gG=FHtsRzouBNY-YqXhH8SXKCc4Gw2TF6Z+_-+Cp_iPj6RA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Fix force effect modifications for the Microsoft
 Sidewinder Force Feedback Pro 2 joystick
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jim Keir <jimkeir@oracledbadirect.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no clue what this code is doing (don't know much about the ff system).
Quoting your initial 0001/0001, I thing the commit message should be
the following.
Jim, can you please validate it?

"
The FF2 driver (usbhid/hid-pidff.c) does not set the effect ID when
uploading an effect. The result is that the initial upload works but
subsequent uploads to modify effect parameters are all directed at the
last-created effect.

The targeted effect ID must be passed back to the device when effect
parameters are changed. This is done at the start of
"pidff_set_condition_report", "pidff_set_periodic_report" etc. based on
the value of "pidff->block_load[PID_EFFECT_
BLOCK_INDEX].value[0]".
However, this value is only ever set during pidff_request_effect_upload.
The result is stored in "pidff->pid_id[effect->id]" at the end of
pid_upload_effect, for later use. However, if an effect is modified and
re-sent then this identifier is not being copied back from
pidff->pid_id[effect->id] before sending the command to the device. The
fix is to do this at the start of pidff_upload_effect.
"

---

As said, I have no clue* of what this is supposed to do, so I can not
add my reviewed-by here. The patch seems good however so nothing
should prevent us to take it if it fixes your problem :)

Cheers,
Benjamin

* OK, I am pushing a little bit, I just don't want today to go deep in
the code :-)


On Fri, Jan 23, 2015 at 12:21 PM, Jim Keir <jimkeir@oracledbadirect.com> wrote:
> ---
> Hi,
>
> Changes from previous patches:
> - All changes removed from higher-level files
> - Extra debug line removed
>
> Signed-off-by: Jim Keir <jimkeir@oracledbadirect.com>
>
>  drivers/hid/usbhid/hid-pidff.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
> index 0b531c6..1b3fa70 100644
> --- a/drivers/hid/usbhid/hid-pidff.c
> +++ b/drivers/hid/usbhid/hid-pidff.c
> @@ -568,6 +568,12 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
>         int type_id;
>         int error;
>
> +       pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
> +       if (old && effect) {
> +               pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] =
> +                       pidff->pid_id[effect->id];
> +       }
> +
>         switch (effect->type) {
>         case FF_CONSTANT:
>                 if (!old) {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
