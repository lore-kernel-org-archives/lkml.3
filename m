Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaLCXLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:11:39 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39437 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCXLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:11:38 -0500
Message-ID: <1417648292.5634.6.camel@vserver>
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if
 driver_data is bad
From: "Hon Ching (Vicky) Lo" <honclo@linux.vnet.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2014 18:11:32 -0500
In-Reply-To: <20141203082008.6c7ed94b@kryten>
References: <20140920072942.27c28768@kryten>
	 <201412022139.58754.PeterHuewe@gmx.de> <20141203082008.6c7ed94b@kryten>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120323-0017-0000-0000-000006CBA0BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,


vio_bus_probe now calls vio_cmo_bus_probe before calling probe.
This results in calling get_desired_dma to get rtce buf size 
before we have called probe which initializes vtpm driver and 
sets up the tpm data, i.e. rtce buf size.

ibmvtpm_get_data returns NULL in get_desired_dma is a special 
case where the device is not initialized.


Regards,
Vicky

On Wed, 2014-12-03 at 08:20 +1100, Anton Blanchard wrote:
> Hi,
> 
> > is this patchset still needed after Vicky's patch 
> > "[tpmdd-devel] Fix NULL return in tpm_ibmvtpm_get_desired_dma"
> > https://patchwork.ozlabs.org/patch/402315/
> > 
> > Ashley raised some concerns.
> > 
> > Since merge window is coming up, a fast reply is appreciated.
> 
> We definitely need a way to catch an invalid driver data pointer, but it
> looks like that needs to be reworked after Vicky's patch.
> 
> Vicky could you look at all uses of ibmvtpm_get_data and make
> sure we don't blindly dereference it? eg:
> 
> static int tpm_ibmvtpm_resume(struct device *dev)
> {
>         struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
> ...
> 
>                 rc = plpar_hcall_norets(H_ENABLE_CRQ,
>                                         ibmvtpm->vdev->unit_address);
> 
> Anton
> 


