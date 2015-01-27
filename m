Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbbA0QyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:54:07 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:48409 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbbA0QyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:54:05 -0500
Date: Tue, 27 Jan 2015 16:52:05 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc: peterhuewe@gmx.de, ashley@ashleylai.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix suspend/resume paths for TPM
 2.0
In-Reply-To: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
References: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-554240536-1422375754=:1725"
Content-ID: <alpine.DEB.2.11.1501271622490.1725@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-554240536-1422375754=:1725
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.11.1501271622491.1725@localhost.localdomain>

On Tue, 27 Jan 2015, Jarkko Sakkinen wrote:
> Fixed suspend/resume paths for TPM 2.0 and consolidated all the
> associated code to the tpm_pm_suspend() and tpm_pm_resume()
> functions. Resume path should be handled by the firmware, i.e.
> Startup(CLEAR) for hibernate and Startup(STATE) for suspend.
> 
> There might be some non-PC embedded devices in the future where
> Startup() is not the handled by the FW but fixing the code for
> those IMHO should be postponed until there is hardware available
> to test the fixes although extra Startup in the driver code is
> essentially a NOP.
> 
> Reported-by: Peter Hüwe <PeterHuewe@gmx.de>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---

...

> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -865,25 +865,23 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
>  static int tpm_tis_resume(struct device *dev)
>  {

...

> +	/* TPM 1.2 requires self-test on resume. */
> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> +		ret = tpm_do_selftest(chip);
> +		if (ret < 0)
> +			return ret;

Just to note, the return value from tpm_do_selftest() on TPM 1.2 chips was 
previously ignored. Mine does return 0.

--8323328-554240536-1422375754=:1725--
