Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaI2Ecv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:32:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaI2Ect (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:32:49 -0400
Message-ID: <5428E0ED.1050107@suse.com>
Date: Mon, 29 Sep 2014 06:32:45 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen-scsiback: Need go to fail after xenbus_dev_error()
References: <5425967F.7020002@gmail.com>
In-Reply-To: <5425967F.7020002@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 06:38 PM, Chen Gang wrote:
> When failure occurs, after xenbus_dev_error(), need go to fail to let
> upper caller know about it.
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   drivers/xen/xen-scsiback.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index 847bc9c..3e430e1 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -1222,8 +1222,10 @@ static int scsiback_probe(struct xenbus_device *dev,
>
>   	err = xenbus_printf(XBT_NIL, dev->nodename, "feature-sg-grant", "%u",
>   			    SG_ALL);
> -	if (err)
> +	if (err) {
>   		xenbus_dev_error(dev, err, "writing feature-sg-grant");
> +		goto fail;
> +	}
>
>   	xenbus_switch_state(dev, XenbusStateInitWait);
>   	return 0;
>

Hmm, not testing for failure was on purpose. Advertising this feature
is just for tuning purposes, not mandatory.

OTOH it would really be a strange error if this xenbus_printf() fails
but all other operations are working, and signaling an error at the
time when it first shows up is a good thing. So:

Acked-by: Juergen Gross <jgross@suse.com>
