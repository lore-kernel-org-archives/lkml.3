Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaDCOtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:49:13 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49958 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaDCOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:49:09 -0400
Date: Thu, 3 Apr 2014 10:49:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Loc Ho <lho@apm.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH libata/for-3.15-fixes] libata: drop COMPILE_TEST from
 AHCI_XGENE
Message-ID: <20140403144905.GB24119@htj.dyndns.org>
References: <20140401184916.GA21938@kroah.com>
 <20140402155357.GA16631@htj.dyndns.org>
 <20140402162215.GC16631@htj.dyndns.org>
 <1975949.1ZaeyAUAJz@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1975949.1ZaeyAUAJz@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 03, 2014 at 04:32:24PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > So, apparently, this isn't enough as this would allow enabling
> > PHY_XGENE regardless of HAS_IOMEM or OF.  From kconfig-language.txt,
> 
> PHY_XGENE has the following dependencies:
> 
> 	depends on HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)
> 
> So it should be OK.
...
> Please note that ARM64 implies that HAS_IOMEM and OF are _always_
> selected.  This is the reason why removing "|| COMPILE_TEST" from
> AHCI_XGENE dependencies is sufficient to fix the issue (though
> I have to admit that relying indirectly on ARM64 selects is a bit
> hacky).

This being okay is so not obvious.  Let's either float all
dependencies to the higher level drivers or just use "depends on".  I
really dislike mixing the two and playing games with the subtle
combinations.  For now, I'm making it all "depends on".  Please feel
free to improve on it as necessary.

> Hmmm, the alternative idea is to remove PHY_XGENE reference from
> AHCI_XGENE altogether and add:
> 
> 	default y if AHCI_XGENE
> 
> to PHY_XGENE instead (which seems to be not as hacky as solution
> with "select PHY_XGENE" and also more user-friendly than "depends
> on PHY_XGENE" one).

The config dependencies should be indicative the actual dependency.
AHCI_XGENE is useless without PHY_XGENE; then, the config dependency
*must* represent that.  That's the priority.

It is true that users probably won't care about PHY_XGENE or any PHY
drivers probably, but, again, let's please not mix depends and selects
in contrived manner to hit the just right mixture of the two.  Let's
please do it systematically.  Float all actual deps to the surface to
the options that the users configuring care about and propagate down
to phy drivers using select.  Our config system *really* doesn't work
with mixed depends and selects.  I mean, think about the suggested
solution.  It works only because there's no actual linkage dependency
between the two, ARM64 implies HAS_IOMEM && OF, AND we omitted
COMPILE_TEST for a completely obscure reason.  I don't think that's
acceptable.

Thanks.

-- 
tejun
