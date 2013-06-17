Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3FQUSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:18:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48188 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3FQUSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:18:07 -0400
Date: Mon, 17 Jun 2013 14:18:02 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3, part2 15/20] PCI, EDAC: use hotplug-safe PCI bus
 iterators to walk PCI buses
Message-ID: <20130617201802.GB7877@google.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
 <1369583597-3801-16-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369583597-3801-16-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 11:53:12PM +0800, Jiang Liu wrote:
> Enhance EDAC drviers to use hotplug-safe iterators to walk PCI buses.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: linux-edac@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/edac/i7core_edac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 0ec3e95..7146e10 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -1296,7 +1296,7 @@ static unsigned i7core_pci_lastbus(void)
>  	int last_bus = 0, bus;
>  	struct pci_bus *b = NULL;
>  
> -	while ((b = pci_find_next_bus(b)) != NULL) {
> +	for_each_pci_root_bus(b) {

This doesn't look equivalent.  Previously, we iterated over all PCI
buses, so we returned the highest bus number seen anywhere.  Now we
only look at root buses, so we return the highest bus number of any
root bus.  But if that root bus has a bridge on it, obviously the
bus on the other side has a higher number.

Even with that fix, a hot-add at the same time i7core_probe() runs
could mean an incorrect result.  This is all very i7 topology-dependent,
so I don't think the PCI core can do anything more than avoid oopses
from traversing lists incorrectly.

Bjorn

>  		bus = b->number;
>  		edac_dbg(0, "Found bus %d\n", bus);
>  		if (bus > last_bus)
> -- 
> 1.8.1.2
> 
