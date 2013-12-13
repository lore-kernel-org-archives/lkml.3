Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3LMTEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:04:06 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55950 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3LMTEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:04:04 -0500
Date: Fri, 13 Dec 2013 12:04:00 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] eisa: call put_device if device_register fails
Message-ID: <20131213190400.GB6746@google.com>
References: <1386959996-7958-1-git-send-email-levex@linux.com>
 <1386959996-7958-3-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386959996-7958-3-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 07:39:54PM +0100, Levente Kurusa wrote:
> We need to give up the last reference to edev->dev, so
> we need to call put_device().
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Levente Kurusa <levex@linux.com>

I applied this and will push it through my PCI tree, since I don't think
anybody really takes care of EISA these days.

I looked at other callers of device_register(), and most of them look like
they have the same problem.  Can you fix the others, too?  This patch says
"2/4", so maybe you already are, but I can't find the other patches in the
series.

Bjorn

> ---
>  drivers/eisa/eisa-bus.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
> index 272a3ec..8842cde 100644
> --- a/drivers/eisa/eisa-bus.c
> +++ b/drivers/eisa/eisa-bus.c
> @@ -232,8 +232,10 @@ static int __init eisa_init_device(struct eisa_root_device *root,
>  static int __init eisa_register_device(struct eisa_device *edev)
>  {
>  	int rc = device_register(&edev->dev);
> -	if (rc)
> +	if (rc) {
> +		put_device(&edev->dev);
>  		return rc;
> +	}
>  
>  	rc = device_create_file(&edev->dev, &dev_attr_signature);
>  	if (rc)
> -- 
> 1.8.3.1
> 
