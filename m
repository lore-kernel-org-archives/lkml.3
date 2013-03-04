Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3CDQ26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:28:58 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:44537 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab3CDQ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:28:57 -0500
Date: Mon, 4 Mar 2013 17:28:50 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20130304172850.5e18fbfb@skate>
In-Reply-To: <201302122236.37491.arnd@arndb.de>
References: <1360686546-24277-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<201302121800.48723.arnd@arndb.de>
	<20130212195816.6e34b3ce@skate>
	<201302122236.37491.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Tue, 12 Feb 2013 22:36:37 +0000, Arnd Bergmann wrote:

> > I have the feeling that the problem is more complex than that. My
> > understanding is that the pcim_iomap_regions() function used by
> > drivers/ata/libata-sff.c can perfectly be used to map memory BARs, and
> > not necessarily I/O BARs. Therefore, this driver can perfectly be used
> > in an architecture where CONFIG_NO_IOPORT is selected.
> 
> That is correct.
> 
> > The thing is that pcim_iomap_regions() transparently allows to remap an
> > I/O BAR is such a BAR is passed as argument, or a memory BAR if such a
> > BAR is passed as argument.
> > 
> > Therefore, I continue to believe that the pcim_*() functions are useful
> > even if the platform doesn't have CONFIG_HAS_IOPORT.
> 
> Yes, the pcim_ functions are useful in principle, but it falls back
> to the __pci_ioport_map() for IORESOURCE_IO, and that needs to
> return an error if CONFIG_HAS_IOPORT is not set.
> I think it would be correct if you add this hunk:
> 
> diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
> index 0d83ea8..f9b6387 100644
> --- a/lib/pci_iomap.c
> +++ b/lib/pci_iomap.c
> @@ -33,7 +33,7 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
>                 return NULL;
>         if (maxlen && len > maxlen)
>                 len = maxlen;
> -       if (flags & IORESOURCE_IO)
> +       if (IS_ENABLED(CONFIG_HAS_IOPORT) && (flags & IORESOURCE_IO))
>                 return __pci_ioport_map(dev, start, len);
>         if (flags & IORESOURCE_MEM) {
>                 if (flags & IORESOURCE_CACHEABLE)
> 
> in order to prevent a link error when CONFIG_HAS_IOPORT is unset.

FWIW, a patch that is doing what I was initially proposing has been
merged for 3.9, and it doesn't contain the
IS_ENABLED(CONFIG_HAS_IOPORT) test you were proposing (and which I
think was correct). See:

commit 9ed8a30f3471347c1b763bd062fa78ae80f18eae
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Wed Feb 27 17:02:42 2013 -0800

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
