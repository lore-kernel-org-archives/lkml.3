Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaKXQHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:07:46 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:64406 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaKXQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:07:43 -0500
MIME-Version: 1.0
In-Reply-To: <1416415597-21235-1-git-send-email-borneo.antonio@gmail.com>
References: <1416149064-25655-1-git-send-email-borneo.antonio@gmail.com>
	<1416415597-21235-1-git-send-email-borneo.antonio@gmail.com>
Date: Mon, 24 Nov 2014 11:07:42 -0500
Message-ID: <CAN+gG=HttchOAYcumPkZHKqfGb5FN83P3P8c3aKod25NXxZX1Q@mail.gmail.com>
Subject: Re: [PATCH V2] HID: i2c-hid: fix race condition reading reports
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:46 AM, Antonio Borneo
<borneo.antonio@gmail.com> wrote:
> From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
>
> Current driver uses a common buffer for reading reports either
> synchronously in i2c_hid_get_raw_report() and asynchronously in
> the interrupt handler.
> There is race condition if an interrupt arrives immediately after
> the report is received in i2c_hid_get_raw_report(); the common
> buffer is modified by the interrupt handler with the new report
> and then i2c_hid_get_raw_report() proceed using wrong data.
>
> Fix it by using a separate buffers for synchronous reports.
>
> Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> [Antonio Borneo: cleanup, rebase to v3.17, submit mainline]
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> V1 -> V2
>         rename the synchronous buffer as rawbuf (instead of the
>         asynchronous one)

Sorry for the lag and thanks for resubmitting.

This one is reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>
>  drivers/hid/i2c-hid/i2c-hid.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 933bf10..c66e6ac 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -137,6 +137,7 @@ struct i2c_hid {
>                                                    * descriptor. */
>         unsigned int            bufsize;        /* i2c buffer size */
>         char                    *inbuf;         /* Input buffer */
> +       char                    *rawbuf;        /* Raw Input buffer */
>         char                    *cmdbuf;        /* Command buffer */
>         char                    *argsbuf;       /* Command arguments buffer */
>
> @@ -504,9 +505,11 @@ static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
>  static void i2c_hid_free_buffers(struct i2c_hid *ihid)
>  {
>         kfree(ihid->inbuf);
> +       kfree(ihid->rawbuf);
>         kfree(ihid->argsbuf);
>         kfree(ihid->cmdbuf);
>         ihid->inbuf = NULL;
> +       ihid->rawbuf = NULL;
>         ihid->cmdbuf = NULL;
>         ihid->argsbuf = NULL;
>         ihid->bufsize = 0;
> @@ -522,10 +525,11 @@ static int i2c_hid_alloc_buffers(struct i2c_hid *ihid, size_t report_size)
>                        report_size; /* report */
>
>         ihid->inbuf = kzalloc(report_size, GFP_KERNEL);
> +       ihid->rawbuf = kzalloc(report_size, GFP_KERNEL);
>         ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
>         ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
>
> -       if (!ihid->inbuf || !ihid->argsbuf || !ihid->cmdbuf) {
> +       if (!ihid->inbuf || !ihid->rawbuf || !ihid->argsbuf || !ihid->cmdbuf) {
>                 i2c_hid_free_buffers(ihid);
>                 return -ENOMEM;
>         }
> @@ -552,12 +556,12 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
>
>         ret = i2c_hid_get_report(client,
>                         report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> -                       report_number, ihid->inbuf, ask_count);
> +                       report_number, ihid->rawbuf, ask_count);
>
>         if (ret < 0)
>                 return ret;
>
> -       ret_count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
> +       ret_count = ihid->rawbuf[0] | (ihid->rawbuf[1] << 8);
>
>         if (ret_count <= 2)
>                 return 0;
> @@ -566,7 +570,7 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
>
>         /* The query buffer contains the size, dropping it in the reply */
>         count = min(count, ret_count - 2);
> -       memcpy(buf, ihid->inbuf + 2, count);
> +       memcpy(buf, ihid->rawbuf + 2, count);
>
>         return count;
>  }
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
