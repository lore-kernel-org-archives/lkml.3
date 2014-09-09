Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaIIAsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:48:13 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:28871 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755318AbaIIAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:48:12 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 08 Sep 2014 18:02:22 -0700
Message-ID: <540E4C3A.3000408@synaptics.com>
Date: Mon, 8 Sep 2014 17:39:22 -0700
From: Andrew Duggan <aduggan@synaptics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: rmi: check sanity of the incoming report
References: <1409925435-6556-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1409925435-6556-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 06:57 AM, Benjamin Tissoires wrote:
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
> ---
>   drivers/hid/hid-rmi.c | 31 ++++++++++++++++++++++++++-----
>   1 file changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 8389e81..db92c3b 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -320,9 +320,6 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>   	int offset;
>   	int i;
>   
> -	if (size < hdata->f11.report_size)
> -		return 0;
> -
>   	if (!(irq & hdata->f11.irq_mask))
>   		return 0;
>   
> @@ -332,9 +329,13 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>   		int fs_bit_position = (i & 0x3) << 1;
>   		int finger_state = (data[fs_byte_position] >> fs_bit_position) &
>   					0x03;
> +		int position = offset + 5 * i;
> +
> +		if (position + 5 > size)
> +			/* partial report, go on with what we received */
> +			break;
>   
> -		rmi_f11_process_touch(hdata, i, finger_state,
> -				&data[offset + 5 * i]);
> +		rmi_f11_process_touch(hdata, i, finger_state, &data[position]);
>   	}
>   	input_mt_sync_frame(hdata->input);
>   	input_sync(hdata->input);
> @@ -412,9 +413,29 @@ static int rmi_read_data_event(struct hid_device *hdev, u8 *data, int size)
>   	return 1;
>   }
>   
> +static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
> +{
> +	int valid_size = size;
> +	/*
> +	 * On the Dell XPS 13 9333, the bus sometimes get confused and fills
> +	 * the report with a sentinel value "ff". Synaptics told us that such
> +	 * behavior does not comes from the touchpad itself, so we filter out
> +	 * such reports here.
> +	 */
> +
> +	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
> +		valid_size--;
> +
> +	return valid_size;
> +}
> +
>   static int rmi_raw_event(struct hid_device *hdev,
>   		struct hid_report *report, u8 *data, int size)
>   {
> +	size = rmi_check_sanity(hdev, data, size);
> +	if (size < 2)
> +		return 0;
> +
>   	switch (data[0]) {
>   	case RMI_READ_DATA_REPORT_ID:
>   		return rmi_read_data_event(hdev, data, size);
I think there should also be a check in rmi_f30_input_event to make sure 
that the F30 data is also valid. The F30 data is at the end of the HID 
report so if the F30 interrupt bit is set, but the value in the report 
is FF then there might be some unintended button events. I think 
checking that size > 0 would be sufficient to make sure the F30 data is 
valid.

Other then that, the sanity check and validation in rmi_f11_input_event 
look good to me.

Andrew
