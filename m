Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaH0INS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:13:18 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:43713 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaH0INP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:13:15 -0400
Date: Wed, 27 Aug 2014 10:13:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: picolcd: sanity check report size in
 raw_event() callback
Message-ID: <20140827101311.098f3fd1@pluto>
In-Reply-To: <alpine.LNX.2.00.1408270912310.2992@pobox.suse.cz>
References: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
	<alpine.LNX.2.00.1408270912310.2992@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 09:13:15 +0200 (CEST) Jiri Kosina wrote:
> The report passed to us from transport driver could potentially be 
> arbitrarily large, therefore we better sanity-check it so that raw_data 
> that we hold in picolcd_pending structure are always kept within proper 
> bounds.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Steven Vittitoe <scvitti@google.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Bruno Prémont <bonbons@linux-vserver.org>

> ---
>  drivers/hid/hid-picolcd_core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
> index acbb0210..020df3c 100644
> --- a/drivers/hid/hid-picolcd_core.c
> +++ b/drivers/hid/hid-picolcd_core.c
> @@ -350,6 +350,12 @@ static int picolcd_raw_event(struct hid_device *hdev,
>  	if (!data)
>  		return 1;
>  
> +	if (size > 64) {
> +		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
> +				size);

Is it worth adding report->id to this hid_warn()?

A valid device is not expected to ever send >64 bytes reports but in
case a firmware update would do so it would help to know for which
report it was.

> +		return 0;
> +	}
> +
>  	if (report->id == REPORT_KEY_STATE) {
>  		if (data->input_keys)
>  			ret = picolcd_raw_keypad(data, report, raw_data+1, size-1);
