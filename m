Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaIOPI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:08:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54560 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaIOPI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:08:26 -0400
Date: Mon, 15 Sep 2014 17:08:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] edac, amd64_edac: Modify usage of
 amd64_read_dct_pci_cfg()
Message-ID: <20140915150823.GH3340@nazgul.tnic>
References: <1410292346-3352-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140915120925.GD3340@nazgul.tnic>
 <5416FDDA.2070208@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5416FDDA.2070208@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:55:22AM -0500, Aravind Gopalakrishnan wrote:
> >>+		 * Note: If ganging is enabled, barring the regs
> >>+		 * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx
> >Why aren't we dealing with those registers here then?
> 
> According to BKDG, these registers are used to control DRAM electrical
> parameters..
> Afaict, we have never had to use these regs here..

... until someone decides to access them and copies the code here, which
would be wrong. Oh well, I guess someone will hopefully read the note
too, while copying...

> >>  	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
> >>-	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
> >>-	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
> >>-
> >>-	if (!dct_ganging_enabled(pvt)) {
> >>-		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
> >>-		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
> >>-	}
> >>+	amd64_read_dct_pci_cfg(pvt, 0, DCLR0, &pvt->dclr0);
> >>+	amd64_read_dct_pci_cfg(pvt, 0, DCHR0, &pvt->dchr0);
> >>  	pvt->ecc_sym_sz = 4;
> >>  	if (pvt->fam >= 0x10) {
> >>+		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
> >>+		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);
> >This doesn't look equivalent - above we're checking whether we're ganged
> >now you're doing it for >= F10h. Why?
> >
> >Because only F10h supports ganging?
> 
> That's right.
> If ganging is enabled (which is a condition we check for in
> amd64_read_dct_pci_cfg();
> Then we return 0.

Right, but you're reading them now even if you don't have to. So why are
you even changing this? What's wrong with doing:

	if (!dct_ganging_enabled(pvt)) {
		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);
	}

which is much clearer than doing the family check.

-- 
Regards/Gruss,
    Boris.
--
