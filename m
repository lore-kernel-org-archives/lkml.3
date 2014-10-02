Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaJBOwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:52:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbaJBOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:52:09 -0400
Date: Thu, 2 Oct 2014 16:52:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141002145201.GF16452@pd.tnic>
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic>
 <542C5995.7050803@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <542C5995.7050803@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 02:44:21PM -0500, Aravind Gopalakrishnan wrote:
> The more I think about this, I'm finding it's hard to do this cleanly.
> I initially thought I'd just cache this in pvt->dram_type the first time I'm
> doing this.
> But, the pvt->ops->dbam_to_cs() mappers get called first before
> determine_memory_type().
> 
> So, If I look for dram_type in f15_m60h_dbam_to_chip_select() it's ugly as
> that's really the point of
> having a determine_memory_type().
> 
> Also, there's just a lot of if-else statements in determine_memory_type()
> now.
> This could benefit from having a per-family low_ops function.
> And, we can call this early... somewhere in read_mc_regs() so that we have
> information ready to use in
> f15_m60h_dbam_to_chip_select() and in init_csrows() which needs dram_type
> too.

Right, this is what I was thinking too: somewhere in read_mc_regs(),
after having collected ->dclr0, you call determine_memory_type() and
store it into pvt->dram_type.

> Oh, btw- We can do away with a pvt->dram_ctrl as
> f15_m60h_dbam_to_chip_select() really just needs the dram_type.

Yes, you make the read of DRAM_CONTROL inside determine_memory_type() as
we don't need it anywhere else.

If we do, all of a sudden, we'll move it up to read_mc_regs(). IOW, I'm
trying to centralize all reg reads in read_mc_regs() and use locally
cached info later so I don't have to access the hardware each time
needlessly, if it can be helped.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
