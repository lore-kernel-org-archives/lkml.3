Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaIKRO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:14:56 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38801 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaIKROy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <1410397358-15308-1-git-send-email-aduggan@synaptics.com>
References: <1410397358-15308-1-git-send-email-aduggan@synaptics.com>
Date: Thu, 11 Sep 2014 13:14:53 -0400
Message-ID: <CAN+gG=GTN3Va=w5Hcz8A4_Np4V1wKkJSxhZHuzM8h8jw0K38Mw@mail.gmail.com>
Subject: Re: [PATCH v2] HID: rmi: check sanity of the incoming report
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 9:02 PM, Andrew Duggan <aduggan@synaptics.com> wrote:
> From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> In the Dell XPS 13 9333, it appears that sometimes the bus get confused
> and corrupts the incoming data. It fills the input report with the
> sentinel value "ff". Synaptics told us that such behavior does not comes
> from the touchpad itself, so we filter out such reports here.
>
> Unfortunately, we can not simply discard the incoming data because they
> may contain useful information. Most of the time, the misbehavior is
> quite near the end of the report, so we can still use the valid part of
> it.
>
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=1123584
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---
> Here is a v2 based of Benjamin's patch with the feedback from the list.
> I added size checks to rmi_f11_input_event and rmi_f30_input_event. For F30 I
> print a message it any data is missing so that a user is notified if a button click
> doesn't get reported. Also, I decided to only warn once if a corrupted report is
> received. Based on the data I have seen I don't think dropped reports will be a
> significanly noticible issue. But, I also added a debug message which could be turned on
> if soneone wants to see exactly how often incomplete reports are being received.

Fine by me. Thanks for fixing this Andrew!

Cheers,
Benjamin

>
>  drivers/hid/hid-rmi.c | 44 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 38 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 578bbe6..54966ca 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -320,10 +320,7 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>         int offset;
>         int i;
>
> -       if (size < hdata->f11.report_size)
> -               return 0;
> -
> -       if (!(irq & hdata->f11.irq_mask))
> +       if (!(irq & hdata->f11.irq_mask) || size <= 0)
>                 return 0;
>
>         offset = (hdata->max_fingers >> 2) + 1;
> @@ -332,9 +329,19 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>                 int fs_bit_position = (i & 0x3) << 1;
>                 int finger_state = (data[fs_byte_position] >> fs_bit_position) &
>                                         0x03;
> +               int position = offset + 5 * i;
> +
> +               if (position + 5 > size) {
> +                       /* partial report, go on with what we received */
> +                       printk_once(KERN_WARNING
> +                               "%s %s: Detected incomplete finger report. Finger reports may occasionally get dropped on this platform.\n",
> +                                dev_driver_string(&hdev->dev),
> +                                dev_name(&hdev->dev));
> +                       hid_dbg(hdev, "Incomplete finger report\n");
> +                       break;
> +               }
>
> -               rmi_f11_process_touch(hdata, i, finger_state,
> -                               &data[offset + 5 * i]);
> +               rmi_f11_process_touch(hdata, i, finger_state, &data[position]);
>         }
>         input_mt_sync_frame(hdata->input);
>         input_sync(hdata->input);
> @@ -352,6 +359,11 @@ static int rmi_f30_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>         if (!(irq & hdata->f30.irq_mask))
>                 return 0;
>
> +       if (size < (int)hdata->f30.report_size) {
> +               hid_warn(hdev, "Click Button pressed, but the click data is missing\n");
> +               return 0;
> +       }
> +
>         for (i = 0; i < hdata->gpio_led_count; i++) {
>                 if (test_bit(i, &hdata->button_mask)) {
>                         value = (data[i / 8] >> (i & 0x07)) & BIT(0);
> @@ -412,9 +424,29 @@ static int rmi_read_data_event(struct hid_device *hdev, u8 *data, int size)
>         return 1;
>  }
>
> +static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
> +{
> +       int valid_size = size;
> +       /*
> +        * On the Dell XPS 13 9333, the bus sometimes get confused and fills
> +        * the report with a sentinel value "ff". Synaptics told us that such
> +        * behavior does not comes from the touchpad itself, so we filter out
> +        * such reports here.
> +        */
> +
> +       while ((data[valid_size - 1] == 0xff) && valid_size > 0)
> +               valid_size--;
> +
> +       return valid_size;
> +}
> +
>  static int rmi_raw_event(struct hid_device *hdev,
>                 struct hid_report *report, u8 *data, int size)
>  {
> +       size = rmi_check_sanity(hdev, data, size);
> +       if (size < 2)
> +               return 0;
> +
>         switch (data[0]) {
>         case RMI_READ_DATA_REPORT_ID:
>                 return rmi_read_data_event(hdev, data, size);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
