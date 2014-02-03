Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaBCP30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:29:26 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59502 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaBCP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <1391316630-29541-4-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-4-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 3 Feb 2014 16:29:23 +0100
Message-ID: <CANq1E4Q2uuz5avEpEXHZdjysRi=TWZm9SvUzyOYyWTt7k-dSBQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] HID: add inliners for ll_driver transport-layer callbacks
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Those callbacks are not mandatory, so it's better to add inliners
> to use them safely.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  include/linux/hid.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 003cc8e..dddcad0 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -680,6 +680,8 @@ struct hid_driver {
>   *        shouldn't allocate anything to not leak memory
>   * @request: send report request to device (e.g. feature report)
>   * @wait: wait for buffered io to complete (send/recv reports)
> + * @raw_request: send raw report request to device (e.g. feature report)
> + * @output_report: send output report to device
>   * @idle: send idle request to device
>   */
>  struct hid_ll_driver {
> @@ -974,6 +976,49 @@ static inline void hid_hw_request(struct hid_device *hdev,
>  }
>
>  /**
> + * hid_hw_raw_request - send report request to device
> + *
> + * @hdev: hid device
> + * @reportnum: report ID
> + * @buf: in/out data to transfer
> + * @len: length of buf
> + * @rtype: HID report type
> + * @reqtype: HID_REQ_GET_REPORT or HID_REQ_SET_REPORT
> + *
> + * @return: count of data transfered, negative if error
> + *
> + * Same behavior as hid_hw_request, but with raw buffers instead.
> + */
> +static inline int hid_hw_raw_request(struct hid_device *hdev,
> +                                 unsigned char reportnum, __u8 *buf,
> +                                 size_t len, unsigned char rtype, int reqtype)
> +{
> +       if (hdev->ll_driver->raw_request)
> +               return hdev->ll_driver->raw_request(hdev, reportnum, buf, len,
> +                                                   rtype, reqtype);
> +
> +       return -ENOSYS;
> +}
> +
> +/**
> + * hid_hw_output_report - send output report to device
> + *
> + * @hdev: hid device
> + * @buf: raw data to transfer
> + * @len: length of buf
> + *
> + * @return: count of data transfered, negative if error
> + */
> +static inline int hid_hw_output_report(struct hid_device *hdev, __u8 *buf,
> +                                       size_t len)
> +{
> +       if (hdev->ll_driver->output_report)
> +               return hdev->ll_driver->output_report(hdev, buf, len);
> +
> +       return -ENOSYS;
> +}
> +
> +/**
>   * hid_hw_idle - send idle request to device
>   *
>   * @hdev: hid device
> --
> 1.8.3.1
>
