Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbaGOTHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760AbaGOTHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:07:16 -0400
Date: Tue, 15 Jul 2014 15:07:02 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: rmi: add additional checks for the existence of
 optional queries in order to compute the address of Query 12.
Message-ID: <20140715190702.GB21045@mail.corp.redhat.com>
References: <1405114551-24354-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405114551-24354-1-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11 2014 or thereabouts, Andrew Duggan wrote:
> There are additional queries which are optional and may not be present depending on the configuration of the firmware. Knowing which queries are present is needed to properly compute the address of Query 12 and all subsequent queries. Additional bits in Query 1 are used to indicate the presence of these optional queries.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---

Looks good to me

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>  drivers/hid/hid-rmi.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 578bbe6..3221a95 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -549,10 +549,12 @@ static int rmi_populate_f11(struct hid_device *hdev)
>  	u8 buf[20];
>  	int ret;
>  	bool has_query9;
> -	bool has_query10;
> +	bool has_query10 = false;
>  	bool has_query11;
>  	bool has_query12;
>  	bool has_physical_props;
> +	bool has_gestures;
> +	bool has_rel;
>  	unsigned x_size, y_size;
>  	u16 query12_offset;
>  
> @@ -589,19 +591,32 @@ static int rmi_populate_f11(struct hid_device *hdev)
>  		return -ENODEV;
>  	}
>  
> -	/* query 8 to find out if query 10 exists */
> -	ret = rmi_read(hdev, data->f11.query_base_addr + 8, buf);
> -	if (ret) {
> -		hid_err(hdev, "can not read gesture information: %d.\n", ret);
> -		return ret;
> +	has_rel = !!(buf[0] & BIT(3));
> +	has_gestures = !!(buf[0] & BIT(5));
> +
> +	if (has_gestures) {
> +		/* query 8 to find out if query 10 exists */
> +		ret = rmi_read(hdev, data->f11.query_base_addr + 8, buf);
> +		if (ret) {
> +			hid_err(hdev, "can not read gesture information: %d.\n",
> +				ret);
> +			return ret;
> +		}
> +		has_query10 = !!(buf[0] & BIT(2));
>  	}
> -	has_query10 = !!(buf[0] & BIT(2));
>  
>  	/*
> -	 * At least 8 queries are guaranteed to be present in F11
> -	 * +1 for query12.
> +	 * At least 4 queries are guaranteed to be present in F11
> +	 * +1 for query 5 which is present since absolute events are
> +	 * reported and +1 for query 12.
>  	 */
> -	query12_offset = 9;
> +	query12_offset = 6;
> +
> +	if (has_rel)
> +		++query12_offset; /* query 6 is present */
> +
> +	if (has_gestures)
> +		query12_offset += 2; /* query 7 and 8 are present */
>  
>  	if (has_query9)
>  		++query12_offset;
> -- 
> 1.9.1
> 
