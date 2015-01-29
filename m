Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbbA2NMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:12:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbbA2NMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:12:50 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH 1/3] hv: hv_util: move vmbus_open() to a later place
References: <1422529347-28192-1-git-send-email-decui@microsoft.com>
Date: Thu, 29 Jan 2015 14:12:33 +0100
In-Reply-To: <1422529347-28192-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Thu, 29 Jan 2015 03:02:27 -0800")
Message-ID: <87k3057mta.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> Before the line vmbus_open() returns, srv->util_cb can be already running
> and the variablies, like util_fw_version, are needed by the srv->util_cb.
>
> So we have to make sure the variables are initialized before the vmbus_open().
>
> CC: "K. Y. Srinivasan" <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

It is not said in the description but moving hv_set_drvdata() before
vmbus_open() make sense in case probe and remove can collide (can
they?).

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  drivers/hv/hv_util.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 3b9c9ef..c5be773 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -340,12 +340,8 @@ static int util_probe(struct hv_device *dev,
>
>  	set_channel_read_state(dev->channel, false);
>
> -	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
> -			srv->util_cb, dev->channel);
> -	if (ret)
> -		goto error;
> -
>  	hv_set_drvdata(dev, srv);
> +
>  	/*
>  	 * Based on the host; initialize the framework and
>  	 * service version numbers we will negotiate.
> @@ -365,6 +361,11 @@ static int util_probe(struct hv_device *dev,
>  		hb_srv_version = HB_VERSION;
>  	}
>
> +	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
> +			srv->util_cb, dev->channel);
> +	if (ret)
> +		goto error;
> +
>  	return 0;
>
>  error:

-- 
  Vitaly
