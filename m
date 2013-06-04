Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008Ab3FDRyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:54:40 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62889 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3FDRyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:54:38 -0400
Date: Tue, 4 Jun 2013 11:54:34 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus has
 been reset
Message-ID: <20130604175434.GA6548@google.com>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-3-git-send-email-betty.dall@hp.com>
 <20130604075336.GC20448@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604075336.GC20448@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 03:53:36AM -0400, Chen Gong wrote:
> On Thu, May 30, 2013 at 08:39:28AM -0600, Betty Dall wrote:
> > Date:	Thu, 30 May 2013 08:39:28 -0600
> > From: Betty Dall <betty.dall@hp.com>
> > To: rjw@sisk.pl, bhelgaas@google.com
> > Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
> >  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
> >  <betty.dall@hp.com>
> > Subject: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus has
> >  been reset
> > X-Mailer: git-send-email 1.7.7.6
> > 
> > The CPER error record has a reset bit that indicates that the platform
> > has reset the bus. The reset bit can be set for any severity error
> > including recoverable.  From the AER code path's perspective,
> > any error is fatal if the bus has been reset. This patch upgrades the
> > severity of the AER recovery to AER_FATAL whenever the CPER error record
> > indicates that the bus has been reset.
> > 
> > Changes since v1:
> > Fixed a typo in comment.
> > 
> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > ---
> > 
> >  drivers/acpi/apei/ghes.c |   21 ++++++++++++++++++++-
> >  1 files changed, 20 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > index d668a8a..1c67d5a 100644
> > --- a/drivers/acpi/apei/ghes.c
> > +++ b/drivers/acpi/apei/ghes.c
> > @@ -451,7 +451,26 @@ static void ghes_do_proc(struct ghes *ghes,
> >  				int aer_severity;
> >  				devfn = PCI_DEVFN(pcie_err->device_id.device,
> >  						  pcie_err->device_id.function);
> > -				aer_severity = cper_severity_to_aer(sev);
> > +				/*
> > +				 * Some Firmware First implementations
> > +				 * put the device in SBR to contain
> > +				 * the error. This is indicated by the
> > +				 * CPER Section Descriptor Flags reset
> > +				 * bit which means the component must
> > +				 * be re-initialized or re-enabled
> > +				 * prior to use. Promoting the AER
> > +				 * serverity to FATAL will cause the
> > +				 * AER code to link_reset and allow
> > +				 * drivers to reprogram their cards.
> > +				 */
> > +				if (gdata->flags & CPER_SEC_RESET)
> > +					aer_severity = cper_severity_to_aer(
> > +							CPER_SEV_FATAL);
> > +				else
> > +					aer_severity =
> > +						cper_severity_to_aer(sev);
> > +
> > +
> 
> How about this?
>                                 if (gdata->flags & CPER_SEC_RESET)
>                                         sev = CPER_SEV_FATAL;
>                                 cper_severity_to_aer(sev);

No.  If the object is to make the severity AER_FATAL, you should just
do that.  You shouldn't fiddle around with the CPER severity, because
then you depend on the mapping performed by cper_severity_to_aer().

> 
> >  				aer_recover_queue(pcie_err->device_id.segment,
> >  						  pcie_err->device_id.bus,
> >  						  devfn, aer_severity);

In other words, something like the patch below.  I don't really care
if you use the original "if" above that only sets aer_severity once,
or if you overwrite it as below.  I overwrote it because it doesn't
wrap as many lines.  ghes_do_proc() really should just call helpers
so the interesting code doesn't have to be indented three and four
tab stops.


ACPI/APEI: Force fatal AER severity when component has been reset
    
The CPER error record has a reset bit that indicates that the platform has
reset the component.  The reset bit can be set for any severity error
including recoverable.  From the AER code path's perspective, any error is
fatal if the component has been reset. This patch upgrades the severity of
the AER recovery to AER_FATAL in this case.
    
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d668a8a..ab31551 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -449,9 +449,19 @@ static void ghes_do_proc(struct ghes *ghes,
 			    pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO) {
 				unsigned int devfn;
 				int aer_severity;
+
 				devfn = PCI_DEVFN(pcie_err->device_id.device,
 						  pcie_err->device_id.function);
 				aer_severity = cper_severity_to_aer(sev);
+
+				/*
+				 * If firmware reset the component to contain
+				 * the error, we must reinitialize it before
+				 * use, so treat it as a fatal AER error.
+				 */
+				if (gdata->flags & CPER_SEC_RESET)
+					aer_severity = AER_FATAL;
+
 				aer_recover_queue(pcie_err->device_id.segment,
 						  pcie_err->device_id.bus,
 						  devfn, aer_severity);
