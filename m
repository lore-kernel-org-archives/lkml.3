Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaGGSA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:00:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3003 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaGGSAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:00:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Jul 2014 10:50:12 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "nagananda.chumbalkar@hp.com" <nagananda.chumbalkar@hp.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matthew Garrett" <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Date: Mon, 7 Jul 2014 23:30:34 +0530
Subject: RE: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Thread-Topic: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE
 mode
Thread-Index: Ac+Yg7eFI7Gvgo/EQDOf+vHw0NHgNABhTEug
Message-ID: <113ACA888B71994BB56E5CF3704953486D8E9DFE3C@BGMAIL02.nvidia.com>
References: <1404198978-26593-1-git-send-email-vidyas@nvidia.com>
 <20140705185736.GD28871@google.com> <20140705190203.GE28871@google.com>
In-Reply-To: <20140705190203.GE28871@google.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Sunday, July 06, 2014 12:32 AM
> To: Vidya Sagar
> Cc: nagananda.chumbalkar@hp.com; thierry.reding@gmail.com; Stephen
> Warren; Krishna Thota; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Matthew Garrett; Rafael J. Wysocki
> Subject: Re: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE
> mode
> 
> [+cc Rafael]
> 
> On Sat, Jul 05, 2014 at 12:57:36PM -0600, Bjorn Helgaas wrote:
> > [+cc Matthew]
> >
> > On Tue, Jul 01, 2014 at 12:46:18PM +0530, Vidya Sagar wrote:
> > > commit 1a680b7c moved pcie_aspm_powersave_config_link() out of
> > > pci_raw_set_power_state() to pci_set_power_state() which would
> > > enable ASPM. But, with commit db288c9c, which re-introduced the
> > > following check
> > > ./drivers/pci/pci.c: pci_set_power_state()
> > > +   /* Check if we're already there */
> > > +   if (dev->current_state == state)
> > > +       return 0;
> > > in pci_set_power_state(), call to pcie_aspm_powersave_config_link()
> > > is never made leaving ASPM broken.
> > > Fix it by not returning from when the above condition is true,
> > > rather, jump to ASPM configuration code and exit from there eventually.
> >
> > Rafael, Matthew, any comments?  We have vacillated on this before and
> > the web is already pretty tangled.
> >
> > Vidya, can you give more details about the bug fixed by this change?
> > What's the scenario?  Are we resuming and the device is powered up but
> > ASPM isn't enabled?  Maybe you could collect more details in a
> > http://bugzilla.kernel.org report?

I've raised a bugzilla bug  https://bugzilla.kernel.org/show_bug.cgi?id=79621 for the same.
Scenario here is, when the driver of a particular PCIe device is loaded and when CONFIG_PCIEASPM_POWERSAVE=y, ASPM is expected to get configured by the sub system which is not happening as of today.
The reason for this behavior is the 'if' condition that checks for the device's power state and returns if it is already in D0. Ideally, it shouldn't return from there, rather proceed to configure ASPM.

> >
> > > Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
> > > ---
> > >  drivers/pci/pci.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c index
> > > 1c8592b..ded24c4 100644
> > > --- a/drivers/pci/pci.c
> > > +++ b/drivers/pci/pci.c
> > > @@ -804,7 +804,7 @@
> EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
> > >   */
> > >  int pci_set_power_state(struct pci_dev *dev, pci_power_t state)  {
> > > -	int error;
> > > +	int error = 0;
> > >
> > >  	/* bound the state we're entering */
> > >  	if (state > PCI_D3cold)
> > > @@ -821,7 +821,7 @@ int pci_set_power_state(struct pci_dev *dev,
> > > pci_power_t state)
> > >
> > >  	/* Check if we're already there */
> > >  	if (dev->current_state == state)
> > > -		return 0;
> > > +		goto config_aspm;
> > >
> > >  	__pci_start_power_transition(dev, state);
> > >
> > > @@ -839,6 +839,8 @@ int pci_set_power_state(struct pci_dev *dev,
> > > pci_power_t state)
> > >
> > >  	if (!__pci_complete_power_transition(dev, state))
> > >  		error = 0;
> > > +
> > > +config_aspm:
> > >  	/*
> > >  	 * When aspm_policy is "powersave" this call ensures
> > >  	 * that ASPM is configured.
> > > --
> > > 1.8.1.5
> > >
