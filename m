Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaANIso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:48:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaANIsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:48:42 -0500
Date: Tue, 14 Jan 2014 09:50:40 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/7] ahci: Use new interfaces for MSI/MSI-X enablement
Message-ID: <20140114085040.GA6873@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <7fe2a5563efac19c87213a48b58cae6b4d76c91d.1389103215.git.agordeev@redhat.com>
 <20140113191220.GA6525@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113191220.GA6525@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 12:12:20PM -0700, Bjorn Helgaas wrote:
> > -	nvec = rc;
> > -	rc = pci_enable_msi_block(pdev, nvec);
> > -	if (rc)
> > +	if (pci_enable_msi_range(pdev, nvec, nvec) < 0)
> >  		goto intx;
> >  
> >  	return nvec;
> >  
> >  single_msi:
> > -	rc = pci_enable_msi(pdev);
> > -	if (rc)
> > +	if (pci_enable_msi_range(pdev, 1, 1) < 0)
> 
> This part doesn't seem like an improvement.  There are a hundred or so
> callers of pci_enable_msi() that only want a single MSI.  Is there any
> benefit in changing them to use pci_enable_msi_range()?

In this particular case it reads better to me as one sees on the screen
pci_enable_msi_range(pdev, nvec, nvec) and pci_enable_msi_range(pdev, 1, 1)
calls. That allows to avoid switching in mind between negative-or-positive
return in the former call and negative-or-zero return from pci_enable_msi()
if we had it.

But in most cases when single MSI is enabled we do cause complication
with the patterns below (which I expect I am going be hated for ;) ):


-	rc = pci_enable_msi(pdev);
-	if (rc)
+	rc = pci_enable_msi_range(pdev, 1, 1);
+	if (rc < 0)
		...


-	rc = pci_enable_msi(pdev);
-	if (!rc)
+	rc = pci_enable_msi_range(pdev, 1, 1);
+	if (rc > 0)
		...

 
I think we have a tradeoff between the interface simplicity and code clarity.
What if we try to address both goals by making pci_enable_msi() a helper over
pci_enable_msi_range(pdev, 1, 1)? In this case the return value will match
negative-or-positive binary semantics while reads almost as good as it used to:


-	rc = pci_enable_msi(pdev);
-	if (rc)
+	rc = pci_enable_msi(pdev);
+	if (rc < 0)
		...


-	rc = pci_enable_msi(pdev);
-	if (!rc)
+	rc = pci_enable_msi(pdev);
+	if (rc > 0)
		...


The whole interface would not be inflated as well, with just:

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a8d0100..fa0b27d 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -158,6 +158,9 @@ static int foo_driver_enable_single_msi(struct pci_dev *pdev)
 	return pci_enable_msi_range(pdev, 1, 1);
 }
 
+A helper function pci_enable_msi() could be used instead. Note, as just
+one MSI is requested it could return either a negative errno or 1.
+
 4.2.2 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
