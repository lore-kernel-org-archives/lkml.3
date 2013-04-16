Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080Ab3DPSSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:18:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56664 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3DPSSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:18:06 -0400
Date: Tue, 16 Apr 2013 20:18:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind <aravind.gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v3] edac: Handle EDAC ECC errors for Family 16h
Message-ID: <20130416181802.GI5332@pd.tnic>
References: <1366052160-3091-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130416142432.GF5332@pd.tnic>
 <516D8743.4080206@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516D8743.4080206@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 12:15:47PM -0500, Aravind wrote:
> >This one case in point, please redo it against tip/master.
> 
>     I had based off bp.git's master... and it misses an additional
> 'PCI_DEVICE' line (Hence the conflict)
>     I shall redo it against Linus's tree..

No, against tip/master, please.

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git, the master branch.

> >>@@ -133,6 +134,15 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
> >>  	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
> >>  }
> >>+static int f16_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
> >>+				const char *func)
> >>+{
> >>+	if (addr >= 0x100)
> >>+		return -EINVAL;
> >I'm very sceptical F16h doesn't have F2 extended PCI config addresses.
> >Please check the BKDG.
> >
> >If it does have, use f10_read_dct_pci_cfg, if it doesn't, use
> >k8_read_dct_pci_cfg without introducing a new accessor while the other
> >ones can be used.
> >
> >Whichever one you take, please add a comment somewhere explaining why it
> >is ok to use it on F16h.
> 
>     Here, What I really wanted to do was to restrict the access to
> only 1 DCT (as fam16 does not have a DCT1 and hence not allow any
> addr > =0x100).

What are you talking about?

I'm sure it has, say, D18F2x110 DRAM Controller Select Low, for example.
And this address is > 0x100.

So for F16h you can simply take the F10h methods and ignore DctCfgSel
because it always will be 0.

> Yes, for this I can modify the code to just use f10_read_dct_pci_cfg
> or k8_read_dct_pci_cfg.

Yes, please do that.

> >>+		u64 base_bits_low, base_bits_high;
> >>+		u64 mask_bits_low, mask_bits_high;
> >>+		u8 addr_shift_low, addr_shift_high;
> >>+
> >>+		csbase          = pvt->csels[dct].csbases[csrow];
> >>+		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
> >>+		base_bits_low = mask_bits_low = GENMASK(5 , 15);
> >>+		base_bits_high = mask_bits_high = GENMASK(19 , 30);
> >>+		addr_shift_low = 6;
> >>+		addr_shift_high = 8;
> >Hold on, are you saying "D18F2x[5C:40]_dct[1:0] DRAM CS Base Address"
> >register definitions in the F16h BKDG has this:
> >
> >30:19 -> BaseAddr[38:27]: normalized physical base address bits [38:27]
> >
> >and
> >
> >15:5  -> BaseAddr[21:11]: normalized physical base address bits [21:11]
> >
> >?
> >
> >Please verify with BKDG authors whether those numbers are correct
> >because the diff of 8 address bits has always been this up until now.
> 
>     That is correct. (I have verified it internally too..)

Ok, then do the following:

Read the low bits, shift them by 2 so that they're at the right position
to be shifted by 8 like the high bits:

	*base =  (csbase & GENMASK(5, 15)) << 2;
	*mask =  (csmask & GENMASK(5, 15)) << 2;

	*base |= (csbase & GENMASK(19, 30)) << 8;
	*mask |= (csmask & GENMASK(19, 30)) << 8;

	return;

AFAICT, this looks much simpler. Also, add a small comment why the
special handling for F16h.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
