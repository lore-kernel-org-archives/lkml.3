Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966582AbaLLLfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:35:48 -0500
Received: from lekensteyn.nl ([178.21.112.251]:37620 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966072AbaLLLfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:35:46 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: logitech-hidpp: prefix the name with Logitech
Date: Fri, 12 Dec 2014 12:35:37 +0100
Message-ID: <1793038.ms5vbWQ64b@al>
User-Agent: KMail/4.14.3 (Linux/3.17.0-rc4-custom-00168-g7ec62d4; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418337599-10239-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1418337599-10239-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 17:39:59 Benjamin Tissoires wrote:
> Current names are reported as "K750", "M705", and it can be misleading
> for the users when they look at their input device list.
> 
> Prefixing the names with "Logitech " makes things better.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Reviewed-by: Peter Wu <peter@lekensteyn.nl>

I have not tested this one, but the approach looks correct. What I have
also been thinking of is the possibility that Logitech adds "LOGITECH"
or "Logicool" (the Japanese trademark) before devices, but I think that
is unlikely so there is no need to check for other strings.

> ---
> 
> Changes in v2:
> - renamed PREFIX_SIZE into PREFIX_LENGTH
> - changed "name_length + PREFIX_LENGTH;" into "PREFIX_LENGTH + name_length;"
> - rebased on Peter's last patch series
> 
>  drivers/hid/hid-logitech-hidpp.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index 2f420c0..274dbb7 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -282,6 +282,33 @@ static inline bool hidpp_report_is_connect_event(struct hidpp_report *report)
>  		(report->rap.sub_id == 0x41);
>  }
>  
> +/**
> + * hidpp_prefix_name() prefixes the current given name with "Logitech ".
> + */
> +static void hidpp_prefix_name(char **name, int name_length)
> +{
> +#define PREFIX_LENGTH 9 /* "Logitech " */
> +
> +	int new_length;
> +	char *new_name;
> +
> +	if (name_length > PREFIX_LENGTH &&
> +	    strncmp(*name, "Logitech ", PREFIX_LENGTH) == 0)
> +		/* The prefix has is already in the name */
> +		return;
> +
> +	new_length = PREFIX_LENGTH + name_length;
> +	new_name = kzalloc(new_length, GFP_KERNEL);
> +	if (!new_name)
> +		return;
> +
> +	snprintf(new_name, new_length, "Logitech %s", *name);
> +
> +	kfree(*name);
> +
> +	*name = new_name;
> +}
> +
>  /* -------------------------------------------------------------------------- */
>  /* HIDP++ 1.0 commands                                                        */
>  /* -------------------------------------------------------------------------- */
> @@ -321,6 +348,10 @@ static char *hidpp_get_unifying_name(struct hidpp_device *hidpp_dev)
>  		return NULL;
>  
>  	memcpy(name, &response.rap.params[2], len);
> +
> +	/* include the terminating '\0' */
> +	hidpp_prefix_name(&name, len + 1);
> +
>  	return name;
>  }
>  
> @@ -498,6 +529,9 @@ static char *hidpp_get_device_name(struct hidpp_device *hidpp)
>  		index += ret;
>  	}
>  
> +	/* include the terminating '\0' */
> +	hidpp_prefix_name(&name, __name_length + 1);
> +
>  	return name;
>  }
>  
> 

-- 
Kind regards,
Peter
https://lekensteyn.nl

