Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3LCSDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:03:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3LCSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:03:23 -0500
Date: Tue, 3 Dec 2013 10:04:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 1/2] kobject: remove kset from sysfs immediately in
 kset_unregister()
Message-ID: <20131203180425.GC15279@kroah.com>
References: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131008202016.19377.17182.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008202016.19377.17182.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:20:16PM -0600, Bjorn Helgaas wrote:
> There's no explicit "unlink from sysfs" interface for ksets, so I think
> callers of kset_unregister() expect the kset to be removed from sysfs
> immediately, without waiting for the last reference to be released.
> 
> This patch makes the sysfs removal happen immediately, so the caller may
> create a new kset with the same name as soon as kset_unregister() returns.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

With the PCI MSI attribute change, this patch is no longer needed,
right?

thanks,

greg k-h

> ---
>  Documentation/kobject.txt |    3 ++-
>  lib/kobject.c             |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
> index c5182bb..8e8b501 100644
> --- a/Documentation/kobject.txt
> +++ b/Documentation/kobject.txt
> @@ -342,7 +342,8 @@ kset use:
>  
>  When you are finished with the kset, call:
>    void kset_unregister(struct kset *kset);
> -to destroy it.
> +to destroy it.  This removes the kset from sysfs and, after the kset
> +reference count goes to zero, releases it.
>  
>  An example of using a kset can be seen in the
>  samples/kobject/kset-example.c file in the kernel tree.
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 9621751..9098992 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -753,6 +753,7 @@ void kset_unregister(struct kset *k)
>  {
>  	if (!k)
>  		return;
> +	kobject_del(&k->kobj);
>  	kobject_put(&k->kobj);
>  }
>  
