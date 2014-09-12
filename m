Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaILP7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:59:13 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38978 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaILP7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:59:12 -0400
Date: Fri, 12 Sep 2014 09:59:05 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm: use tpm_pcr_read_dev() in
 tpm_do_selftest()
Message-ID: <20140912155905.GA14805@obsidianresearch.com>
References: <1410527201-32428-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410527201-32428-1-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:06:41PM +0300, Jarkko Sakkinen wrote:
> It does not make sense to construct the PCR read command in
> tpm_do_selftest() when there is already a function that does
> the job.

This would seem to undo an older patch, I don't think things have
changed enough for that to make sense.. Can you comment?

It looks to me like the aim was to not print a warning on faliure
while looping, tpm_pcr_read_dev will print an error.

Though, it would be better to use transmit_cmd with a null desc than
tpm_transmit.

Also:

-               if (rc < TPM_HEADER_SIZE)
+               if (rc < 0)
                        return -EFAULT;

Should be return rc;

commit 24ebe6670de3d1f0dca11c9eb372134c7ab05503
Author: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Date:   Tue Apr 24 17:38:17 2012 -0300

    TPM: chip disabled state erronously being reported as error
    
    tpm_do_selftest() attempts to read a PCR in order to
    decide if one can rely on the TPM being used or not.
    The function that's used by __tpm_pcr_read() does not
    expect the TPM to be disabled or deactivated, and if so,
    reports an error.
    
    It's fine if the TPM returns this error when trying to
    use it for the first time after a power cycle, but it's
    definitely not if it already returned success for a
    previous attempt to read one of its PCRs.
    
    The tpm_do_selftest() was modified so that the driver only
    reports this return code as an error when it really is.
    
    Reported-and-tested-by: Paul Bolle <pebolle@tiscali.nl>
    Cc: Stable <stable@vger.kernel.org>
    Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c7320dd1b..08427abf5fa5 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -827,10 +827,10 @@ EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 int tpm_do_selftest(struct tpm_chip *chip)
 {
        int rc;
-       u8 digest[TPM_DIGEST_SIZE];
        unsigned int loops;
        unsigned int delay_msec = 1000;
        unsigned long duration;
+       struct tpm_cmd_t cmd;
 
        duration = tpm_calc_ordinal_duration(chip,
                                             TPM_ORD_CONTINUE_SELFTEST);
@@ -845,7 +845,15 @@ int tpm_do_selftest(struct tpm_chip *chip)
                return rc;
 
        do {
-               rc = __tpm_pcr_read(chip, 0, digest);
+               /* Attempt to read a PCR value */
+               cmd.header.in = pcrread_header;
+               cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
+               rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+
+               if (rc < TPM_HEADER_SIZE)
+                       return -EFAULT;
+
+               rc = be32_to_cpu(cmd.header.out.return_code);
                if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
                        dev_info(chip->dev,
                                 "TPM is disabled/deactivated (0x%X)\n", rc);

