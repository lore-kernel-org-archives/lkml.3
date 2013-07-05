Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3GEHGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:06:21 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42008 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3GEHGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:06:20 -0400
Message-ID: <51D67066.9070105@gmail.com>
Date: Fri, 05 Jul 2013 17:06:14 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rapidio: use after free in unregister function
References: <20130705060231.GA14443@elgon.mountain>
In-Reply-To: <20130705060231.GA14443@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/13 16:02, Dan Carpenter wrote:
> We need to use the _safe version of list_for_each_entry() because we
> are freeing the iterator.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
> index f4f30af..84ac64a 100644
> --- a/drivers/rapidio/rio.c
> +++ b/drivers/rapidio/rio.c
> @@ -1701,7 +1701,7 @@ EXPORT_SYMBOL_GPL(rio_register_scan);
>  int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
>  {
>  	struct rio_mport *port;
> -	struct rio_scan_node *scan;
> +	struct rio_scan_node *scan, *tmp;
>  
>  	pr_debug("RIO: %s for mport_id=%d\n", __func__, mport_id);
>  
> @@ -1715,7 +1715,7 @@ int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
>  		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
>  			port->nscan = NULL;
>  
> -	list_for_each_entry(scan, &rio_scans, node)
> +	list_for_each_entry_safe(scan, tmp, &rio_scans, node)
>  		if (scan->mport_id == mport_id) {
>  			list_del(&scan->node);
>  			kfree(scan);

It looks like an mport_id can only be assigned to one scan entry (see
rio_register_scan), so you can use list_for_each_entry and break; after
the kfree(scan); instead.

~Ryan

