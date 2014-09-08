Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaIHINW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:13:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaIHINU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:13:20 -0400
Date: Mon, 8 Sep 2014 10:13:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: check sanity of the incoming report
In-Reply-To: <1409925435-6556-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1409081012160.5523@pobox.suse.cz>
References: <1409925435-6556-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Benjamin Tissoires wrote:

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
>  drivers/hid/hid-rmi.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 8389e81..db92c3b 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -320,9 +320,6 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>  	int offset;
>  	int i;
>  
> -	if (size < hdata->f11.report_size)
> -		return 0;
> -
>  	if (!(irq & hdata->f11.irq_mask))
>  		return 0;
>  
> @@ -332,9 +329,13 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
>  		int fs_bit_position = (i & 0x3) << 1;
>  		int finger_state = (data[fs_byte_position] >> fs_bit_position) &
>  					0x03;
> +		int position = offset + 5 * i;
> +
> +		if (position + 5 > size)
> +			/* partial report, go on with what we received */
> +			break;

Do you perhaps want to warn the user here, so that he knows that things 
are getting a little bit hairy? Or is this happening so often that it 
makes no sense to warn about it?

-- 
Jiri Kosina
SUSE Labs
