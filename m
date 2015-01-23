Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbbAWSsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:48:55 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:55889 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbbAWSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:48:51 -0500
MIME-Version: 1.0
In-Reply-To: <0000014b17cfda93-ba54b0fb-23f4-4005-95c1-6ae695a48369-000000@email.amazonses.com>
References: <0000014b17cfda93-ba54b0fb-23f4-4005-95c1-6ae695a48369-000000@email.amazonses.com>
Date: Fri, 23 Jan 2015 13:48:50 -0500
Message-ID: <CAN+gG=FC1gOCY1FQhHa16NALuyx2z5w7088k87O3eFM5518_Ug@mail.gmail.com>
Subject: Re: [PATCH 1/2] Fix initialisation for the Microsoft Sidewinder Force
 Feedback Pro 2 joystick
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

You are missing here (before the first '---' the commit message which
should state why you want to have this patch merged.

To rephrase and continue what you wrote in your very first submission
of this series, this could be (including your Signed-of-by):

The FF2 driver (usbhid/hid-pidff.c) sends commands to the stick
during ff_init. However, this is called inside a block where
driver_input_lock is locked, so the results of these initial commands
are discarded. This behavior is the "killer", without this nothing else works.

ff_init issues commands using "hid_hw_request". This eventually goes to
hid_input_report, which returns -EBUSY because driver_input_lock is
locked. The change is to delay the ff_init call in hid-core.c until
after this lock has been released.

Calling hid_device_io_start() releases the lock so the device can be configured.
We also need to call hid_device_io_stop() on exit for the lock to
remain locked while ending the init of the drivers.

Signed-off-by: Jim Keir <jimkeir@oracledbadirect.com>

---

With the changes above (or if you fix my typos), the patch is
Reviewed-by: Benjamin.tissoires <benjamin.tissoires@redhat.com>

Jiri, could you amend the commit with the above so that Jim won't be
desperate by submitting a patch?

Cheers,
Benjamin


On Fri, Jan 23, 2015 at 12:21 PM, Jim Keir <jimkeir@oracledbadirect.com> wrote:
> ---
> Hi,
>
> Changes from previous patches:
> - All changes removed from higher-level files
> - Calls to hid_device_io_start/stop added here
>
> Signed-off-by: Jim Keir <jimkeir@oracledbadirect.com>
>
>  drivers/hid/usbhid/hid-pidff.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
> index 10b6167..0b531c6 100644
> --- a/drivers/hid/usbhid/hid-pidff.c
> +++ b/drivers/hid/usbhid/hid-pidff.c
> @@ -1252,6 +1252,8 @@ int hid_pidff_init(struct hid_device *hid)
>
>         pidff->hid = hid;
>
> +       hid_device_io_start(hid);
> +
>         pidff_find_reports(hid, HID_OUTPUT_REPORT, pidff);
>         pidff_find_reports(hid, HID_FEATURE_REPORT, pidff);
>
> @@ -1315,9 +1317,13 @@ int hid_pidff_init(struct hid_device *hid)
>
>         hid_info(dev, "Force feedback for USB HID PID devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
>
> +       hid_device_io_stop(hid);
> +
>         return 0;
>
>   fail:
> +       hid_device_io_stop(hid);
> +
>         kfree(pidff);
>         return error;
>  }
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
