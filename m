Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3FKH3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:29:10 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52295 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FKH3I convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 11 Jun 2013 03:29:08 -0400
Message-Id: <51B6EDDF02000078000DCFB7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 11 Jun 2013 08:29:03 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <george.dunlap@eu.citrix.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/pci: Deal with toolstack missing
 an 'XenbusStateClosing'.
References: <20130610202456.GA17822@phenom.dumpdata.com>
 <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com>
 <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.06.13 at 23:06, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> There are two tool-stack that can instruct the Xen PCI frontend
> and backend to change states: 'xm' (Python code with a daemon),
> and 'xl' (C library - does not keep state changes).
> 
> With the 'xm', the path to disconnect a PCI device (xm pci-detach
> <guest> <BDF>)is:
> 
> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)->5(Closing*).
> 
> The * is for states that the tool-stack sets. For 'xl', it is similar:
> 
> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)
> 
> Both of them also tear down the XenBus structure, so the backend
> state ends up going in the 3(Initialised) and calls pcifront_xenbus_remove.
> 
> When a PCI device is plugged in (xm pci-attach <guest> <BDF>)
> both of them follow the same pattern:
> 2(InitWait*), 3(Initialized*), 4(Connected*)->4(Connected).
> 
> [xen-pcifront ignores the 2,3 state changes and only acts when
> 4 (Connected) has been reached]
> 
> The problem is that git commit 3d925320e9e2de162bd138bf97816bda8c3f71be
> ("xen/pcifront: Use Xen-SWIOTLB when initting if required") introduced
> a mechanism to initialize the SWIOTLB when the Xen PCI front moves to
> Connected state. It also had some aggressive seatbelt code check that
> would warn the user if one tried to change to Connected state without
> hitting first the Closing state:
> 
>  pcifront pci-0: PCI frontend already installed!
> 
> However, that code can be relaxed and we can continue on working
> even if the frontend is instructed to be the 'Connected' state with
> no devices and then gets tickled to be in 'Connected' state again.
> 
> In other words, this 4(Connected)->5(Closing)->4(Connected) state
> was expected, while 4(Connected)->.... anything but 5(Closing)->4(Connected)
> was not. This patch removes that aggressive check and allows
> Xen pcifront to work with the 'xl' toolstack.

I actually think this shouldn't be worked around here, but fixed in
xl. Any device removed from a guest should be driven towards
the "Closed" state.

Jan

> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org 
> Cc: stable@vger.kernel.org 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/pci/xen-pcifront.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index ac99515..cc46e253 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -675,10 +675,9 @@ static int pcifront_connect_and_init_dma(struct 
> pcifront_device *pdev)
>  	if (!pcifront_dev) {
>  		dev_info(&pdev->xdev->dev, "Installing PCI frontend\n");
>  		pcifront_dev = pdev;
> -	} else {
> -		dev_err(&pdev->xdev->dev, "PCI frontend already installed!\n");
> +	} else
>  		err = -EEXIST;
> -	}
> +
>  	spin_unlock(&pcifront_dev_lock);
>  
>  	if (!err && !swiotlb_nr_tbl()) {
> @@ -846,7 +845,7 @@ static int pcifront_try_connect(struct pcifront_device 
> *pdev)
>  		goto out;
>  
>  	err = pcifront_connect_and_init_dma(pdev);
> -	if (err) {
> +	if (err && err != -EEXIST) {
>  		xenbus_dev_fatal(pdev->xdev, err,
>  				 "Error setting up PCI Frontend");
>  		goto out;
> -- 
> 1.8.1.4
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



