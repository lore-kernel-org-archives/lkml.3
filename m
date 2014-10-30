Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbaJ3Hyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:54:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:55183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758277AbaJ3Hyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:54:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="623313711"
Message-ID: <1414655671.2918.2.camel@jrissane-mobl.ger.corp.intel.com>
Subject: Re: [patch] Bluetooth: 6lowpan: use after free in
 disconnect_devices()
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 30 Oct 2014 09:54:31 +0200
In-Reply-To: <20141029161057.GF5290@mwanda>
References: <20141029161057.GF5290@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On ke, 2014-10-29 at 19:10 +0300, Dan Carpenter wrote:
> This was accidentally changed from list_for_each_entry_safe() to
> list_for_each_entry() so now it has a use after free bug.  I've changed
> it back.

Good catch! Thanks for the patch.

Acked-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>

> 
> Fixes: 90305829635d ('Bluetooth: 6lowpan: Converting rwlocks to use RCU')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 7254bdd..eef298d 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -1383,7 +1383,7 @@ static const struct file_operations lowpan_control_fops = {
>  
>  static void disconnect_devices(void)
>  {
> -	struct lowpan_dev *entry, *new_dev;
> +	struct lowpan_dev *entry, *tmp, *new_dev;
>  	struct list_head devices;
>  
>  	INIT_LIST_HEAD(&devices);
> @@ -1408,7 +1408,7 @@ static void disconnect_devices(void)
>  
>  	rcu_read_unlock();
>  
> -	list_for_each_entry(entry, &devices, list) {
> +	list_for_each_entry_safe(entry, tmp, &devices, list) {
>  		ifdown(entry->netdev);
>  		BT_DBG("Unregistering netdev %s %p",
>  		       entry->netdev->name, entry->netdev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers,
Jukka


