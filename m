Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3E2QRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:17:01 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38643 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727Ab3E2QQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:16:28 -0400
Message-ID: <1369844170.12792.2.camel@ejdallLaptop>
Subject: Re: [PATCH 2/3] ACPI/APEI: Force fatal AER severity when bus has
 been reset
From: Betty Dall <betty.dall@hp.com>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "bhelgaas@google.com" <bhelgaas@google.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Wed, 29 May 2013 10:16:10 -0600
In-Reply-To: <51A621E0.9030307@hp.com>
References: <1369766929-4386-1-git-send-email-betty.dall@hp.com>
	 <1369766929-4386-3-git-send-email-betty.dall@hp.com>
	 <51A621E0.9030307@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 09:42 -0600, Pearson, Greg wrote:
> On 05/28/2013 12:48 PM, Betty Dall wrote:
> > The CPER error record has a reset bit that indicates that the platform
> > has reset the bus. The reset bit can be set for any severity error
> > including recoverable.  From the AER code path's perspective,
> > any error is fatal if the bus has been reset. This patch upgrades the
> > severity of the AER recovery to AER_FATAL whenever the CPER error record
> > indicates that the bus has been reset.
> >
> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > ---
> >
> >   drivers/acpi/apei/ghes.c |   21 ++++++++++++++++++++-
> >   1 files changed, 20 insertions(+), 1 deletions(-)
> >
> >
> > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > index d668a8a..4a42afc 100644
> > --- a/drivers/acpi/apei/ghes.c
> > +++ b/drivers/acpi/apei/ghes.c
> > @@ -451,7 +451,26 @@ static void ghes_do_proc(struct ghes *ghes,
> >   				int aer_severity;
> >   				devfn = PCI_DEVFN(pcie_err->device_id.device,
> >   						  pcie_err->device_id.function);
> > -				aer_severity = cper_severity_to_aer(sev);
> > +				/*
> > +				 * Some Firmware First implementations
> > +				 * put the device in SBR to contain
> > +				 * the error. This is indicated by the
> > +				 * CPER Section Decriptor Flags reset
> 
> Nit Pick, change "Decriptor" to "Descriptor".
> 
> --
> Greg

I will fix that. Thanks.

-Betty
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
> >   				aer_recover_queue(pcie_err->device_id.segment,
> >   						  pcie_err->device_id.bus,
> >   						  devfn, aer_severity);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >


