Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbaJ1GBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:01:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:16641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbaJ1GBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:01:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,801,1406617200"; 
   d="scan'208";a="621854610"
Date: Tue, 28 Oct 2014 08:01:04 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        jason.gunthorpe@obsidianresearch.com, christophe.ricard@gmail.com,
        tpmdd-devel@lists.sourceforge.net, josh.triplett@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v3 0/3] prepare for TPM 2.0
Message-ID: <20141028060104.GA4554@intel.com>
References: <1414314837-19722-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141027095529.GA2922@intel.com>
 <alpine.DEB.2.11.1410271620001.2601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410271620001.2601@localhost.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:30:48PM +0000, Scot Doyle wrote:
> Hi Jarkko, will you explain why the free_irq call was removed in 
> tpm_tis_init around line 693?

Because irq is reserved with a devm_request_irq() call.

> I'm wondering if the free_irq call in disable_irq in 
> https://lkml.org/lkml/2014/9/24/1179 should be removed since it's also 
> invoked during tpm_tis_init.

Please, read

https://www.kernel.org/doc/Documentation/driver-model/devres.txt

/Jarkko

> On Mon, 27 Oct 2014, Jarkko Sakkinen wrote:
> 
> > Hey,
> > 
> > Any comments about this? In v2 I fixed issues reported by Jason
> > and in v3 fixed rather embarrasing one regression. Changes have
> > been now also tested to work just fine with the TIS driver.
> > 
> > /Jarkko
> > 
> > On Sun, Oct 26, 2014 at 11:13:54AM +0200, Jarkko Sakkinen wrote:
> > > This patch set fixes two race conditions in the TPM subsystem:
> > > 
> > > * Two-phase initialization for struct tpm_chip so that device can
> > >   initialize fully initialize before exposing itself to the user
> > >   space. Also, in future TPM2 devices must be flagged before they
> > >   can be registered.
> > > * Machines where there are two TPM devices exposed by ACPI have
> > >   a racy lookup for the PPI interface. This patch set fixes this
> > >   issues
> > > 
> > > In addition, transmit_cmd() is renamed as tpm_transmit_cmd() and
> > > made opaque so that separate command structure can be introduced
> > > for TPM2.
> > > 
> > > Comments about v1:
> > > * I think this could be pulled to 3.18 because this clearly fixes
> > >   bugs in the current implementation.
> > > 
> > > Changes since v1:
> > > * Removed dev_dbgs from tpm-chip.c
> > > * Use driver_lock for dev_mask (the problem was existing also in
> > >   tpm-interface.c when the code was moved).
> > > * Check for bios_dir nullity when removed (the problem was existing
> > >   also in tpm-interface.c when the code was moved).
> > > * Cleaned up the control flow in tpm_i2c_stm_st33.c and tpm_atmel.c.
> > > * Cleaned up the control flow in tpm_ppi.c.
> > > 
> > > Comments about v2:
> > > * Thanks to Jason Gunthorpe for reviewing v1.
> > > * I'm at T2 infosec conference right now so I wasn't able to test the
> > >   force paths in tpm_atmel.c and tpm_tis.c.
> > > 
> > > Changes since v2:
> > > * Regression in tpm-dev.c, must use tpm_transmit() instead of
> > >   tpm_transmit_cmd().
> > > 
> > > Jarkko Sakkinen (3):
> > >   tpm: merge duplicate transmit_cmd() functions
> > >   tpm: two-phase chip management functions
> > >   tpm: fix multiple race conditions in tpm_ppi.c
> > > 
> > >  drivers/char/tpm/Makefile           |   2 +-
> > >  drivers/char/tpm/tpm-chip.c         | 196 +++++++++++++++++++++++++++++++++++
> > >  drivers/char/tpm/tpm-interface.c    | 197 +++++-------------------------------
> > >  drivers/char/tpm/tpm-sysfs.c        |  23 +----
> > >  drivers/char/tpm/tpm.h              |  30 ++++--
> > >  drivers/char/tpm/tpm_atmel.c        |  12 ++-
> > >  drivers/char/tpm/tpm_i2c_atmel.c    |  33 ++----
> > >  drivers/char/tpm/tpm_i2c_infineon.c |  37 ++-----
> > >  drivers/char/tpm/tpm_i2c_nuvoton.c  |  44 +++-----
> > >  drivers/char/tpm/tpm_i2c_stm_st33.c |  38 +++----
> > >  drivers/char/tpm/tpm_ibmvtpm.c      |  17 ++--
> > >  drivers/char/tpm/tpm_infineon.c     |  29 +++---
> > >  drivers/char/tpm/tpm_nsc.c          |  14 ++-
> > >  drivers/char/tpm/tpm_ppi.c          | 136 +++++++++++++++----------
> > >  drivers/char/tpm/tpm_tis.c          |  94 ++++++++---------
> > >  drivers/char/tpm/xen-tpmfront.c     |  14 +--
> > >  16 files changed, 467 insertions(+), 449 deletions(-)
> > >  create mode 100644 drivers/char/tpm/tpm-chip.c
> > > 
> > > -- 
> > > 2.1.0
> > > 
> > 
> > ------------------------------------------------------------------------------
> > _______________________________________________
> > tpmdd-devel mailing list
> > tpmdd-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> > 
