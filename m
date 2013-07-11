Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3GKNvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:51:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58170 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3GKNva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
	<1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 11 Jul 2013 15:51:30 +0200
Message-ID: <CANq1E4T4oiHe-15u3bEBOZx27pE3tDMZQfSXHx4Q=J-h3644yg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Bluetooth: hidp: remove wrong send_report at init
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jul 11, 2013 at 3:41 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> The USB hid implementation does retrieve the reports during the start.
> However, this implementation does not call the HID command GET_REPORT
> (which would fetch the current status of each report), but use the
> DATA command, which is an Output Report (so transmitting data from the
> host to the device).
> The Wiimote controller is already guarded against this problem in the
> protocol, but it is not conformant to the specification to set all the
> reports to 0 on start.

I always wondered whether report-setup is really needed for BT-HIDP.
The BT profile doesn't mention it but I thought it was part of the
USBHID core specification.
During hid-wiimote development I added support for
HID_QUIRK_NO_INIT_REPORTS to HIDP to silence the wiimote errors. But
if you say that it's specific to USBHID, I am fine with this. I never
read the USBHID specs, though, I rely on your comment here.

Anyway, code looks good:
  Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks!
David

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  net/bluetooth/hidp/core.c | 14 --------------
>  1 file changed, 14 deletions(-)
>
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 9c8b50d..59d132a 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -703,20 +703,6 @@ static int hidp_parse(struct hid_device *hid)
>
>  static int hidp_start(struct hid_device *hid)
>  {
> -       struct hidp_session *session = hid->driver_data;
> -       struct hid_report *report;
> -
> -       if (hid->quirks & HID_QUIRK_NO_INIT_REPORTS)
> -               return 0;
> -
> -       list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].
> -                       report_list, list)
> -               hidp_send_report(session, report);
> -
> -       list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].
> -                       report_list, list)
> -               hidp_send_report(session, report);
> -
>         return 0;
>  }
>
> --
> 1.8.3.1
>
