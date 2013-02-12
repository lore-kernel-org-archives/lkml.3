Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab3BLWhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:37:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3BLWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:37:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Tue, 12 Feb 2013 22:36:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
References: <1360686546-24277-1-git-send-email-thomas.petazzoni@free-electrons.com> <201302121800.48723.arnd@arndb.de> <20130212195816.6e34b3ce@skate>
In-Reply-To: <20130212195816.6e34b3ce@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302122236.37491.arnd@arndb.de>
X-Provags-ID: V02:K0:aslKurT/qRFQNCS7W5z4e5AhVribPkbDd8tw1jkijWQ
 eSTj0egBz/c/aDw15FEJKxr9WuFIBAJuv+uPB6VYDtxUiyEsos
 3W3BorZP9AlYXdkZkz3l5I2qLOJJ65Txsq0xm6IyyDZnGtGlV0
 zRHeK8GY3cVBE1kUdL+EndJEz/0yOD9Nv5RHiJDBdoCxza8YQT
 YVW+xJxa9Fs4HUeqyeM9sMTMrKLp5xen/UuS8KSJrglsLG4grQ
 ojRcVz3yHjvtA4gCkYfVe4ZdRCNfczetsCIQnWaVNQPcHSstU5
 rGNX5HFRN1EyPvokpp9UwGlJgxiNdU2NbW8lcOwQ0bprM5feFY
 9rQiD27FeD6NCIHVP4fY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Thomas Petazzoni wrote:
> > Any driver that requires a
> > linear mapping of I/O ports to __iomem pointers must depend
> > CONFIG_HAS_IOPORT with the current definition of that symbol (as
> > mentioned before, we should really rename that to
> > CONFIG_HAS_IOPORT_MAP). Having these functions not defined is a
> > compile time check that is necessary to ensure that all drivers have
> > the correct annotation.
> 
> I have the feeling that the problem is more complex than that. My
> understanding is that the pcim_iomap_regions() function used by
> drivers/ata/libata-sff.c can perfectly be used to map memory BARs, and
> not necessarily I/O BARs. Therefore, this driver can perfectly be used
> in an architecture where CONFIG_NO_IOPORT is selected.

That is correct.

> The thing is that pcim_iomap_regions() transparently allows to remap an
> I/O BAR is such a BAR is passed as argument, or a memory BAR if such a
> BAR is passed as argument.
> 
> Therefore, I continue to believe that the pcim_*() functions are useful
> even if the platform doesn't have CONFIG_HAS_IOPORT.

Yes, the pcim_ functions are useful in principle, but it falls back
to the __pci_ioport_map() for IORESOURCE_IO, and that needs to
return an error if CONFIG_HAS_IOPORT is not set.
I think it would be correct if you add this hunk:

diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index 0d83ea8..f9b6387 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -33,7 +33,7 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
                return NULL;
        if (maxlen && len > maxlen)
                len = maxlen;
-       if (flags & IORESOURCE_IO)
+       if (IS_ENABLED(CONFIG_HAS_IOPORT) && (flags & IORESOURCE_IO))
                return __pci_ioport_map(dev, start, len);
        if (flags & IORESOURCE_MEM) {
                if (flags & IORESOURCE_CACHEABLE)

in order to prevent a link error when CONFIG_HAS_IOPORT is unset.

	Arnd
