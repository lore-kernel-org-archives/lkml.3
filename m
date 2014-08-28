Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaH1QyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:54:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:43261 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaH1QyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:54:04 -0400
Date: Thu, 28 Aug 2014 10:53:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] tpm_tis: verify interrupt during init
Message-ID: <20140828165348.GE11183@obsidianresearch.com>
References: <20140822160626.GA8477@obsidianresearch.com>
 <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain>
 <20140822203241.GB1733@obsidianresearch.com>
 <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com>
 <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
 <20140827173142.GA11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
 <20140827214743.GC11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:35:16AM +0000, Scot Doyle wrote:

> > To move it means we have to understand why you are getting timeouts:
> >
> > [   33.247720] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
> > [   33.247731] tpm_tis 00:08: [Hardware Error]: TPM command timed out during continue self test
> >
> > I had thought based on your other patch that these should not happen
> > since the raw register is polled after the timer expires?
> 
> It is polled after the timer expires in tpm_tis_send_data, but not in 
> tpm_tis_send, and the return value is used in tpm_tis_send...

tpm_tis_send does:

             wait_for_tpm_stat
		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
		     tpm_calc_ordinal_duration(chip, ordinal),
		     &chip->vendor.read_queue, false)

Which is:
		rc = wait_event_interruptible_timeout(*queue,
			wait_for_tpm_stat_cond(chip, mask, check_cancel,
					       &canceled),

And we know that wait_event_interruptible_timeout returns 1 if 
the condition is true when the timeout expires.

So, all calls to wait_for_tpm_stat should succeed if the register has
the requested bits set at the end of the timer - thus if interrupts
are broken we should never see ETIME from wait_for_tpm_stat as the
chip does actually complete its work. (and this is the correct,
desired, behavior)

Is this analysis wrong somehow?

Lets simplify, instead of wrapping the whole command let us target
only the first part, tpm_tis_send, and let us do that for
get_timeouts.

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -367,6 +367,12 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
                        rc = -ETIME;
                        goto out_err;
                }
+
+               if (!chip->vendor.int_received) {
+                       msleep(1);
+                       if (!chip->vendor.int_received)
+                               disable_interrupts();
+               }
        }
        return len;
 out_err:

Jason
