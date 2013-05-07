Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab3EGVkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:40:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab3EGVkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:40:32 -0400
Date: Tue, 7 May 2013 14:40:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gernot Vormayr <gvormayr@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RESEND] [PATCH 1/1] block: Fix id of xsysace with missing
 port-number
Message-Id: <20130507144030.952018c4c71dd6d990a195ea@linux-foundation.org>
In-Reply-To: <1367526465-31886-1-git-send-email-gvormayr@gmail.com>
References: <1367526465-31886-1-git-send-email-gvormayr@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 May 2013 22:27:45 +0200 Gernot Vormayr <gvormayr@gmail.com> wrote:

> If the port number is missing from the device-tree the device gets
> named xs` instead of xsa. This fixes the check for missing ids.
> 
> Tested on ml507 board.
> 
> Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
> ---
>  drivers/block/xsysace.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index 1f38643..6b5807a 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -1161,8 +1161,7 @@ static int ace_probe(struct platform_device *dev)
>  	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
>  
>  	/* device id and bus width */
> -	of_property_read_u32(dev->dev.of_node, "port-number", &id);
> -	if (id < 0)
> +	if (of_property_read_u32(dev->dev.of_node, "port-number", &id))
>  		id = 0;
>  	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
>  		bus_width = ACE_BUS_WIDTH_8;

err, yes.  If of_property_read_u32() fails to locate the property, `id'
remains unaltered.  That code appears to believe that
of_property_read_u32() puts its errno into `id'.

AFAICT, it is always a bug to fail to check the of_property_read()
return value (unless the caller somehow *knows* the property exists?). 
Perhaps these functions should be marked __must_check to locate and
prevent such bugs.


