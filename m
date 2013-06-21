Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423548Ab3FUSDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:03:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34280 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FUSDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:03:32 -0400
Date: Fri, 21 Jun 2013 14:00:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: tpmdd-devel@lists.sourceforge.net, Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, leosilva@linux.vnet.ibm.com,
        shpedoikal@gmail.com, xen-devel@lists.xen.org, mail@srajiv.net,
        adlai@linux.vnet.ibm.com, tpmdd@sirrix.com, PeterHuewe@gmx.de
Subject: Re: [tpmdd-devel] [PATCH v3] drivers/tpm: add xen tpmfront interface
Message-ID: <20130621180040.GA15960@phenom.dumpdata.com>
References: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov>
 <201306050014.29162.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201306050014.29162.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 03:14:28PM -0700, Peter Hüwe wrote:
> Hi Daniel,
> 
> thanks for this v3.
> It's really nice to see the progress and I really like that 
> sparse/smatch/clang/coccicheck do not complain at all - nice job!
> 
> Konrad already did an excellent job at reviewing the driver (thanks for that), 
> and all previously pointed out issues are fixed.
> 
> Unfortunately I haven't had the opportunity to test it yet, but 
> the driver looks clean from the TPM perspective.
> 
> 
> However I do have some minor comments from a general perspective - see below.
> 
> 
> From the TPM point of view I'd say it is fine.
> (I'm currently _not_ the (official) maintainer of the tpm subsystem but at least 
> take care of the incoming stuff as an interim)
> 
> 
> So if the comments are addressed you can add:
> Acked-by: Peter Huewe <peterhuewe@gmx.de>
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
> 
> @Konrad: I can stage the driver and push it to James or you can take it.
> As it lives in drivers/tpm maybe it should go through the tpm (interim ;) 
> maintainer and james' tree.

Daniel??

ping?
> 
> 
> So here are my comments:
> 
> Am Dienstag, 28. Mai 2013, 17:40:32 schrieb Daniel De Graaf:
> > This is a complete rewrite of the Xen TPM frontend driver, taking
> > advantage of a simplified frontend/backend interface and adding support
> > for cancellation and timeouts.  The backend for this driver is provided
> > by a vTPM stub domain using the interface in Xen 4.3.
> > 
> > Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> > Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
> 
> > diff --git a/Documentation/xen-tpmfront.txt
> > b/Documentation/xen-tpmfront.txt new file mode 100644
> > index 0000000..8a61d6f
> > --- /dev/null
> > +++ b/Documentation/xen-tpmfront.txt
> > @@ -0,0 +1,116 @@
> > +Copyright (c) 2010-2012 United States Government, as represented by
> > +the Secretary of Defense.  All rights reserved.
> 
> I'm not 100% sure if this can stay this way, as it doesn't permit any changes 
> to the documentation itself.
> 
> 
> > + * Linux DomU: The Linux based guest that wants to use a vTPM. There many
> > be +	       more than one of these.
> -* Linux DomU: The Linux based guest that wants to use a vTPM. There many
> +* Linux DomU: The Linux based guest that wants to use a vTPM. There may
> Just a minor typo
> 
> 
> > diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> > index dbfd564..205ed35 100644
> > --- a/drivers/char/tpm/Kconfig
> > +++ b/drivers/char/tpm/Kconfig
> > @@ -91,4 +91,15 @@ config TCG_ST33_I2C
> >          To compile this driver as a module, choose M here; the module will
> > be called tpm_stm_st33_i2c.
> > 
> > +config TCG_XEN
> Maybe TCG_XEN_TPM would be better, but TCG_XEN is okay for me.
> 
> 
> > +static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
> > +{
> > +	struct tpm_private *priv = TPM_VPRIV(chip);
> > +	struct vtpm_shared_page *shr = priv->shr;
> > +	unsigned int offset = shr_data_offset(shr);
> > +
> > +	u32 ordinal;
> > +	unsigned long duration;
> > +
> > +	if (offset > PAGE_SIZE)
> > +		return -EIO;
> Maybe -EINVAL?
> > +
> > +	if (offset + count > PAGE_SIZE)
> > +		return -EIO;
> Maybe -EINVAL?
> > +
> 
> 
> > +/*************************************************************************
> > ***** + * tpmif.h
> > + *
> > + * TPM I/O interface for Xen guest OSes, v2
> > + *
> > + * Permission is hereby granted, free of charge, to any person obtaining a
> > copy + * of this software and associated documentation files (the
> > "Software"), to + * deal in the Software without restriction, including
> > without limitation the + * rights to use, copy, modify, merge, publish,
> > distribute, sublicense, and/or + * sell copies of the Software, and to
> > permit persons to whom the Software is + * furnished to do so, subject to
> > the following conditions:
> > + *
> > + * The above copyright notice and this permission notice shall be included
> > in + * all copies or substantial portions of the Software.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
> > OR + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > MERCHANTABILITY, + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> > IN NO EVENT SHALL THE + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
> > CLAIM, DAMAGES OR OTHER + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
> > TORT OR OTHERWISE, ARISING + * FROM, OUT OF OR IN CONNECTION WITH THE
> > SOFTWARE OR THE USE OR OTHER + * DEALINGS IN THE SOFTWARE.
> > + *
> > + */
> 
> Also not sure if this license is correct/compliant with the kernel as it 
> indicates no clear license to me.
> 
> Peter
