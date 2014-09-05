Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaIERl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:41:28 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32926 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIERl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:41:26 -0400
Date: Fri, 5 Sep 2014 11:41:22 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: mvebu: Fix uninitialized variable in
 mvebu_get_tgt_attr()
Message-ID: <20140905174122.GD8080@google.com>
References: <1407512045-26969-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407512045-26969-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 05:34:05PM +0200, Geert Uytterhoeven wrote:
> drivers/pci/host/pci-mvebu.c: In function 'mvebu_get_tgt_attr':
> drivers/pci/host/pci-mvebu.c:887:39: warning: 'rtype' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    if (slot == PCI_SLOT(devfn) && type == rtype) {
>                                        ^
> 
> If there's ever gonna be a configuration space or 64-bit memory space
> entry in DT, rtype will be uninitialized, and the wrong entry may be
> returned.
> 
> Initialize rtype to 0 (which is an unused IORESOURCE_* type) to fix this.
> 
> Introduced in commit 11be65472a427dcf7a11ab6e3e3628f1c6768b5b ("PCI:
> mvebu: Adapt to the new device tree layout").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Alternatively, should the "else if (DT_FLAGS_TO_TYPE(flags) ==
> DT_TYPE_MEM32)" just be changed to "else", assuming there can never be
> other entries than for I/O or 32-bit memory space?
> ---
>  drivers/pci/host/pci-mvebu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> index ce23e0f076b6..9515f0d13fd4 100644
> --- a/drivers/pci/host/pci-mvebu.c
> +++ b/drivers/pci/host/pci-mvebu.c
> @@ -877,7 +877,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
>  		u32 flags = of_read_number(range, 1);
>  		u32 slot = of_read_number(range + 1, 1);
>  		u64 cpuaddr = of_read_number(range + na, pna);
> -		unsigned long rtype;
> +		unsigned long rtype = 0;
>  
>  		if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
>  			rtype = IORESOURCE_IO;
> -- 
> 1.9.1
> 

This fix looks right to me.  I added a stable tag as follows.  Thomas
and/or Jason, and you ack this?


commit f96f4040d0d01b6eeacda212cf7db105d06a55ba
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Fri Aug 8 17:34:05 2014 +0200

    PCI: mvebu: Fix uninitialized "rtype" in mvebu_get_tgt_attr()
    
    drivers/pci/host/pci-mvebu.c: In function 'mvebu_get_tgt_attr':
    drivers/pci/host/pci-mvebu.c:887:39: warning: 'rtype' may be used uninitialized in this function [-Wmaybe-uninitialized]
       if (slot == PCI_SLOT(devfn) && type == rtype) {
                                           ^
    
    If there's ever a DT entry other than DT_TYPE_IO or DT_TYPE_MEM32,
    e.g., a configuration space or 64-bit memory space entry, rtype will
    be uninitialized, and the wrong entry may be returned.
    
    Initialize rtype to 0 (which is an unused IORESOURCE_* type) to fix this.
    
    Fixes: 11be65472a42 ("PCI: mvebu: Adapt to the new device tree layout")
    Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    CC: stable@vger.kernel.org	# v3.12+

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index a8c6f1a92e0f..081579c0971e 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -877,7 +877,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 		u32 flags = of_read_number(range, 1);
 		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
-		unsigned long rtype;
+		unsigned long rtype = 0;
 
 		if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
 			rtype = IORESOURCE_IO;
