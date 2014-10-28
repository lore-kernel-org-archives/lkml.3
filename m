Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaJ1Ur7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:47:59 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45083 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1Ur5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <1414404527-17526-1-git-send-email-cywang@chromium.org>
References: <1412861506-21732-1-git-send-email-cywang@chromium.org>
	<1414404527-17526-1-git-send-email-cywang@chromium.org>
Date: Tue, 28 Oct 2014 16:47:56 -0400
Message-ID: <CAN+gG=G+YYntYg3rpGP+rUU8wT6Ejny8nrdG7K_cfyt7BwkWbA@mail.gmail.com>
Subject: Re: [PATCH v2] input: fix BTN_TOUCH reporting in input_mt_report_pointer_emulation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Chung-yih Wang <cywang@chromium.org>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chung-yih,

On Mon, Oct 27, 2014 at 6:08 AM, Chung-yih Wang <cywang@chromium.org> wrote:
>   From the definition of BTN_TOUCH, BTN_TOOL_<name> and BTN_TOUCH codes
> are orthogonal. BTN_TOUCH should be zero if there is no physical contact
> happened on device. With ABS_MT_DISTANCE information, the patch uses
> touch_count and finger_count to get the final reporting code for
> BTN_TOUCH and BTN_TOOL_<name>, respectively.
>
> Signed-off-by: Chung-yih Wang <cywang@chromium.org>
> ---
>  drivers/input/input-mt.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index fbe29fc..a2ab8e3 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -192,18 +192,21 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
>  {
>         struct input_mt *mt = dev->mt;
>         struct input_mt_slot *oldest;
> -       int oldid, count, i;
> +       int oldid, i;
> +       int touch_count, finger_count;
>
>         if (!mt)
>                 return;
>
>         oldest = NULL;
>         oldid = mt->trkid;
> -       count = 0;
> +       touch_count = 0;
> +       finger_count = 0;
>
>         for (i = 0; i < mt->num_slots; ++i) {
>                 struct input_mt_slot *ps = &mt->slots[i];
>                 int id = input_mt_get_value(ps, ABS_MT_TRACKING_ID);
> +               int distance = input_mt_get_value(ps, ABS_MT_DISTANCE);

I don't really like this statement, even if it works. Some devices do
not report ABS_MT_DISTANCE, and the value for them should not be
considered as '0' but 'undefined'.

>
>                 if (id < 0)
>                         continue;
> @@ -211,12 +214,14 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
>                         oldest = ps;
>                         oldid = id;
>                 }
> -               count++;
> +               finger_count++;
> +               if (distance == 0)

I'd rather test here if ABS_MT_DISTANCE is used, and then if the value is 0.

> +                       touch_count++;
>         }
>
> -       input_event(dev, EV_KEY, BTN_TOUCH, count > 0);
> +       input_event(dev, EV_KEY, BTN_TOUCH, touch_count > 0);

For the record, I *think* this will not break user space. This is used
in the touchpad part of libinput, and does not seemed to be impacted
by the change.
Adding Peter and Hans in CC who can tell us if I am assuming right.

Cheers,
Benjamin

>         if (use_count)
> -               input_mt_report_finger_count(dev, count);
> +               input_mt_report_finger_count(dev, finger_count);
>
>         if (oldest) {
>                 int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
> --
> 2.1.2
>
