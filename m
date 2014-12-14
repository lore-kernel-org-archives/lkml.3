Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaLNXNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:13:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:52662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaLNXNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:13:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,576,1413270000"; 
   d="scan'208";a="637490601"
Date: Mon, 15 Dec 2014 01:13:02 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Scot Doyle <lkml14@scotdoyle.com>, Peter Huewe <peterhuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v10 8/8] tpm: TPM 2.0 FIFO Interface
Message-ID: <20141214231302.GA4539@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com>
 <548DA33A.4010300@linux.vnet.ibm.com>
 <20141214154003.GA13338@intel.com>
 <548DB62E.7060504@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1412141817550.1716@localhost.localdomain>
 <548DF5A5.2080500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548DF5A5.2080500@linux.vnet.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 03:40:05PM -0500, Stefan Berger wrote:
> On 12/14/2014 01:27 PM, Scot Doyle wrote:
> >On Sun, 14 Dec 2014, Stefan Berger wrote:
> >>On 12/14/2014 10:40 AM, Jarkko Sakkinen wrote:
> >>>On Sun, Dec 14, 2014 at 09:48:26AM -0500, Stefan Berger wrote:
> >>>>On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> >>>>>Detect TPM 2.0 by sending idempotent TPM 2.x command. Ordinals for
> >>>>>TPM 2.0 are higher than TPM 1.x commands so this should be fail-safe.
> >>>>>Using STS3 is unreliable because some chips just report 0xff and not
> >>>>>what the spec says.
> >>>>TPM TIS 1.2 can report either 0xff or 0x00 for sts3 since that part of
> >>>>register was not defined for this version but only for a later version.
> >>>>So,
> >>>>unless the TIS 1.3 for TPM 2.0 is broken, it should report a bit _pattern_
> >>>>(not plain 0x00 or 0xff) that you could apply the suggested mask to and
> >>>>check then.
> >>>I propose this: lets keep the bit ugly but approach for now and when
> >>>there are TPM2 FIFOs available in the market move to your workaround.
> >>>I think that would be the most reasonable middle road here.
> >>You are now calling tpm2_gen_interrupt and are looking at the rc, which is the
> >>rc from tpm_transmit_cmd, which seems to make sure that the sending of the
> >>command went alright and the reception of the response. Is this good enough to
> >>distinguish between a TPM 2 and a TPM 1.2? If you send a valid TPM 2 command
> >>to a TPM 1.2 this will at least transmit the data ok, but the TPM will respond
> >>with a TPM 1.2 tag in the response. The way I understand the code, the rc does
> >>not include whether the response packet is a valid TPM 2 response packet and
> >>lets you conclude to a TPM2. I do something similar in upcoming QEMU patches
> >>where I send a valid TPM2 command for probing and if the tag(!) in the
> >>response is a TPM2 tag (0x8001 = TPM_ST_NO_SESSIONS), then it's a TPM 2,
> >>otherwise a TPM 1.2.
> >>
> >>Did you test this with a TPM 1.2 ?
> >>
> >>    Stefan
> >One system's output, with a dev_info call to show the value of rc:
> >[ 0.223837] tpm_tis 00:08: tpm2_gen_interrupt(chip, true) -> 0xa
> >[ 0.223847] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
> >[ 0.280468] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead
> >
> 
> Ok, good.
> 
> [We won't be able to use STS3 if the TIS of Jarkko's TPM2 is broken...]

Yes, the prototype module that I had to use had the same problem as TPM
1.2 chips.

I think your idea of using tag is much cleaner than using the error
code. I'll probably submit a separate patch for that later on but since
this code is now verified to work on two TPM 1.2 chips (my own and
Scots) and one dTPM2 module, lets keep it that way until this patch
set is pulled at least...

/Jarkko
