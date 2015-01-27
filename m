Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbbA0Q5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:57:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:32847 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbbA0Q52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:57:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="518433647"
Message-ID: <1422377842.2912.1.camel@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix suspend/resume paths for TPM 2.0
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: peterhuewe@gmx.de, ashley@ashleylai.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Date: Tue, 27 Jan 2015 18:57:22 +0200
In-Reply-To: <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
References: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 16:52 +0000, Scot Doyle wrote:
> On Tue, 27 Jan 2015, Jarkko Sakkinen wrote:
> > Fixed suspend/resume paths for TPM 2.0 and consolidated all the
> > associated code to the tpm_pm_suspend() and tpm_pm_resume()
> > functions. Resume path should be handled by the firmware, i.e.
> > Startup(CLEAR) for hibernate and Startup(STATE) for suspend.
> > 
> > There might be some non-PC embedded devices in the future where
> > Startup() is not the handled by the FW but fixing the code for
> > those IMHO should be postponed until there is hardware available
> > to test the fixes although extra Startup in the driver code is
> > essentially a NOP.
> > 
> > Reported-by: Peter Hüwe <PeterHuewe@gmx.de>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> 
> ...
> 
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -865,25 +865,23 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
> >  static int tpm_tis_resume(struct device *dev)
> >  {
> 
> ...
> 
> > +	/* TPM 1.2 requires self-test on resume. */
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > +		ret = tpm_do_selftest(chip);
> > +		if (ret < 0)
> > +			return ret;
> 
> Just to note, the return value from tpm_do_selftest() on TPM 1.2 chips was 
> previously ignored. Mine does return 0.

Right. I can update the patch to ignore return value if the majority
wants that.

/Jarkko

