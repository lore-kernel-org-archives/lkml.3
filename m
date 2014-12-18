Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaLRSuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:50:04 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38315 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLRSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:50:00 -0500
MIME-Version: 1.0
In-Reply-To: <1418156167-11724-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1418156167-11724-1-git-send-email-nick.dyer@itdev.co.uk>
Date: Thu, 18 Dec 2014 10:49:59 -0800
X-Google-Sender-Auth: 2Ec1nyoe6ml5yOzYNiQeOoVge88
Message-ID: <CANLzEktMgEDTu4SpNasO3A_bsLWd5QEKkmJ9FdHd3v9xamNn0Q@mail.gmail.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts - implement T100 touch object support
From: Benson Leung <bleung@chromium.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Chung-yih Wang <cywang@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick

On Tue, Dec 9, 2014 at 12:16 PM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> Add support for the new T100 object which replaces the previous T9 multitouch
> touchscreen object in recent maXTouch devices. T100 provides improved
> reporting with selectable auxiliary information, and a type field for
> hover/stylus/glove reporting.
>
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Yufeng Shen <miletus@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 326 ++++++++++++++++++++++++++++++-
>  1 file changed, 323 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index bb07020..569346e 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -79,6 +79,7 @@
>  #define MXT_SPT_DIGITIZER_T43          43
>  #define MXT_SPT_MESSAGECOUNT_T44       44
>  #define MXT_SPT_CTECONFIG_T46          46
> +#define MXT_TOUCH_MULTITOUCHSCREEN_T100 100
>
>  /* MXT_GEN_MESSAGE_T5 object */
>  #define MXT_RPTID_NOMSG                0xff
> @@ -188,6 +189,33 @@ struct t9_range {
>  #define MXT_RESET_VALUE                0x01
>  #define MXT_BACKUP_VALUE       0x55
>
> +/* T100 Multiple Touch Touchscreen */
> +#define MXT_T100_CTRL          0
> +#define MXT_T100_CFG1          1
> +#define MXT_T100_TCHAUX                3
> +#define MXT_T100_XRANGE                13
> +#define MXT_T100_YRANGE                24
> +
> +#define MXT_T100_CFG_SWITCHXY  (1 << 5)
> +
> +#define MXT_T100_TCHAUX_VECT   (1 << 0)
> +#define MXT_T100_TCHAUX_AMPL   (1 << 1)
> +#define MXT_T100_TCHAUX_AREA   (1 << 2)
> +
> +#define MXT_T100_DETECT                (1 << 7)
> +#define MXT_T100_TYPE_MASK     0x70
> +
> +enum t100_type {
> +       MXT_T100_TYPE_FINGER            = 1,
> +       MXT_T100_TYPE_PASSIVE_STYLUS    = 2,
> +       MXT_T100_TYPE_HOVERING_FINGER   = 4,
> +       MXT_T100_TYPE_GLOVE             = 5,
> +       MXT_T100_TYPE_LARGE_TOUCH       = 6,
> +};
> +
> +#define MXT_TOUCH_MAJOR_DEFAULT        1
> +#define MXT_PRESSURE_DEFAULT   1
> +
>  /* Delay times */
>  #define MXT_BACKUP_TIME                50      /* msec */
>  #define MXT_RESET_TIME         200     /* msec */
> @@ -247,6 +275,9 @@ struct mxt_data {
>         unsigned int max_y;
>         bool in_bootloader;
>         u16 mem_size;
> +       u8 t100_aux_ampl;
> +       u8 t100_aux_area;
> +       u8 t100_aux_vect;
>         u8 max_reportid;
>         u32 config_crc;
>         u32 info_crc;
> @@ -268,6 +299,8 @@ struct mxt_data {
>         u8 T9_reportid_max;
>         u8 T19_reportid;
>         u16 T44_address;
> +       u8 T100_reportid_min;
> +       u8 T100_reportid_max;
>
>         /* for fw update in bootloader */
>         struct completion bl_completion;
> @@ -761,6 +794,113 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>         data->update_input = true;
>  }
>
> +static void mxt_proc_t100_message(struct mxt_data *data, u8 *message)
> +{
> +       struct device *dev = &data->client->dev;
> +       struct input_dev *input_dev = data->input_dev;
> +       int id;
> +       u8 status;
> +       u8 type;
> +       int x;
> +       int y;
> +       int tool;
> +       u8 major = 0;
> +       u8 pressure = 0;
> +       u8 orientation = 0;
> +       bool active = false;
> +       bool hover = false;
> +
> +       id = message[0] - data->T100_reportid_min - 2;
> +
> +       /* ignore SCRSTATUS events */
> +       if (id < 0)
> +               return;
> +
> +       status = message[1];
> +       x = (message[3] << 8) | message[2];
> +       y = (message[5] << 8) | message[4];
> +
> +       if (status & MXT_T100_DETECT) {
> +               type = (status & MXT_T100_TYPE_MASK) >> 4;
> +
> +               switch (type) {
> +               case MXT_T100_TYPE_HOVERING_FINGER:
> +                       hover = true;
> +                       /* fall through */
> +               case MXT_T100_TYPE_FINGER:
> +               case MXT_T100_TYPE_GLOVE:
> +                       active = true;
> +                       tool = MT_TOOL_FINGER;
> +
> +                       if (data->t100_aux_area)
> +                               major = message[data->t100_aux_area];
> +                       if (data->t100_aux_ampl)
> +                               pressure = message[data->t100_aux_ampl];
> +                       if (data->t100_aux_vect)
> +                               orientation = message[data->t100_aux_vect];
> +
> +                       break;
> +
> +               case MXT_T100_TYPE_PASSIVE_STYLUS:
> +                       active = true;
> +                       tool = MT_TOOL_PEN;
> +
> +                       /* Passive stylus is reported with size zero so
> +                        * hardcode */
> +                       major = MXT_TOUCH_MAJOR_DEFAULT;
> +
> +                       if (data->t100_aux_ampl)
> +                               pressure = message[data->t100_aux_ampl];
> +
> +                       break;
> +
> +               case MXT_T100_TYPE_LARGE_TOUCH:
> +                       /* Ignore suppressed touch */
> +                       break;
> +
> +               default:
> +                       dev_dbg(dev, "Unexpected T100 type\n");
> +                       return;
> +               }
> +       }
> +
> +       if (hover) {
> +               pressure = 0;
> +               major = 0;
> +       } else if (active) {
> +               /*
> +                * Values reported should be non-zero if tool is touching the
> +                * device
> +                */
> +               if (pressure == 0)
> +                       pressure = MXT_PRESSURE_DEFAULT;
> +
> +               if (major == 0)
> +                       major = MXT_TOUCH_MAJOR_DEFAULT;
> +       }
> +
> +       input_mt_slot(input_dev, id);
> +
> +       if (active) {
> +               dev_dbg(dev, "[%u] type:%u x:%u y:%u a:%02X p:%02X v:%02X\n",
> +                       id, type, x, y, major, pressure, orientation);
> +
> +               input_mt_report_slot_state(input_dev, tool, 1);
> +               input_report_abs(input_dev, ABS_MT_POSITION_X, x);
> +               input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
> +               input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, major);
> +               input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
> +               input_report_abs(input_dev, ABS_MT_ORIENTATION, orientation);
> +       } else {
> +               dev_dbg(dev, "[%u] release\n", id);
> +
> +               /* close out slot */
> +               input_mt_report_slot_state(input_dev, 0, 0);
> +       }
> +
> +       data->update_input = true;
> +}
> +

Dmitry and Chung-Yih have had some discussion about how to handle
hovering fingers, and I think the direction they wanted to go was to
use ABS_MT_DISTANCE instead.

http://www.spinics.net/lists/linux-input/msg33950.html

Chung-Yih's also done some work on the forked chromeos-kernel driver
for this as well, if you want to see :
https://chromium-review.googlesource.com/#/c/219280/


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
