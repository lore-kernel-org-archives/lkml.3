Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbaH0Nyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:54:35 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:48903 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbaH0Nye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
References: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
Date: Wed, 27 Aug 2014 09:54:33 -0400
Message-ID: <CAN+gG=G_o4ZBDqYT+HvYCW2TwQaw-TcF1FzBSp7dzFpfet_Z+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: magicmouse: sanity check report size in
 raw_event() callback
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:12 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> The report passed to us from transport driver could potentially be
> arbitrarily large, therefore we better sanity-check it so that
> magicmouse_emit_touch() gets only valid values of raw_id.
>
> Cc: stable@vger.kernel.org
> Reported-by: Steven Vittitoe <scvitti@google.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Fair enough.
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

> ---
>  drivers/hid/hid-magicmouse.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index ecc2cbf..29a74c1 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -290,6 +290,11 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>                 if (size < 4 || ((size - 4) % 9) != 0)
>                         return 0;
>                 npoints = (size - 4) / 9;
> +               if (npoints > 15) {
> +                       hid_warn(hdev, "invalid size value (%d) for TRACKPAD_REPORT_ID\n",
> +                                       size);
> +                       return 0;
> +               }
>                 msc->ntouches = 0;
>                 for (ii = 0; ii < npoints; ii++)
>                         magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
> @@ -307,6 +312,11 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>                 if (size < 6 || ((size - 6) % 8) != 0)
>                         return 0;
>                 npoints = (size - 6) / 8;
> +               if (npoints > 15) {
> +                       hid_warn(hdev, "invalid size value (%d) for MOUSE_REPORT_ID\n",
> +                                       size);
> +                       return 0;
> +               }
>                 msc->ntouches = 0;
>                 for (ii = 0; ii < npoints; ii++)
>                         magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
> --
> 1.9.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
