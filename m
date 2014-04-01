Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaDAHX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:23:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60828 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaDAHX4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 1 Apr 2014 03:23:56 -0400
Message-Id: <533A85A70200007800003F59@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Tue, 01 Apr 2014 08:23:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daeseok Youn" <daeseok.youn@gmail.com>, <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: fix memory leak in
 __xen_pcibk_add_pci_dev()
References: <2186395.ZOncrV6nFS@daeseok-laptop.cloud.net>
In-Reply-To: <2186395.ZOncrV6nFS@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.03.14 at 12:08, <daeseok.youn@gmail.com> wrote:

> It need to free dev_entry when it failed to assign to a new
> slot on the virtual PCI bus.
> 
> smatch says:
>  drivers/xen/xen-pciback/vpci.c:142 __xen_pcibk_add_pci_dev() warn:
> possible memory leak of 'dev_entry'
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

albeit the solution is not ideal:

> --- a/drivers/xen/xen-pciback/vpci.c
> +++ b/drivers/xen/xen-pciback/vpci.c
> @@ -130,6 +130,7 @@ static int __xen_pcibk_add_pci_dev(struct 
> xen_pcibk_device *pdev,
>  	err = -ENOMEM;
>  	xenbus_dev_fatal(pdev->xdev, err,
>  			 "No more space on root virtual PCI bus");
> +	kfree(dev_entry);
>  
>  unlock:
>  	mutex_unlock(&vpci_dev->lock);

The kfree() invocation would better be placed outside the locked
region (e.g. in an else to the "if (!err)" a little further down).

Jan

