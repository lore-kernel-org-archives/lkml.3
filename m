Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbaD2I6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:58:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27544 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818AbaD2I6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:58:11 -0400
Date: Tue, 29 Apr 2014 09:57:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm64: fixmap: fix missing sub-page offset for
 earlyprintk
Message-ID: <20140429085730.GB17007@arm.com>
References: <1398711006-14943-1-git-send-email-marc.zyngier@arm.com>
 <CAL_JsqLwhkSR42CeOcnAC-C43O9fbrXdcTnNrkov5hq9t3_Usg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLwhkSR42CeOcnAC-C43O9fbrXdcTnNrkov5hq9t3_Usg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 12:51:18AM +0100, Rob Herring wrote:
> On Mon, Apr 28, 2014 at 1:50 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > Commit d57c33c5daa4 (add generic fixmap.h) added (among other
> > similar things) set_fixmap_io to deal with early ioremap of devices.
> >
> > More recently, commit bf4b558eba92 (arm64: add early_ioremap support)
> > converted the arm64 earlyprintk to use set_fixmap_io. A side effect of
> > this conversion is that my virtual machines have stopped booting when
> > I pass "earlyprintk=uart8250-8bit,0x3f8" to the guest kernel.
> >
> > Turns out that the new earlyprintk code doesn't care at all about
> > sub-page offsets, and just assumes that the earlyprintk device will
> > be page-aligned. Obviously, that doesn't play well with the above example.
> >
> > Further investigation shows that set_fixmap_io uses __set_fixmap instead
> > of __set_fixmap_offset. A fix is to introduce a set_fixmap_offset_io that
> > uses the latter, and to remove the superflous call to fix_to_virt
> > (which only returns the value that set_fixmap_io has already given us).
> >
> > With this applied, my VMs are back in business. Tested on a Cortex-A57
> > platform with kvmtool as platform emulation.
> >
> > Cc: Mark Salter <msalter@redhat.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/kernel/early_printk.c | 6 ++----
> >  include/asm-generic/fixmap.h     | 3 +++
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> This will be fixed already in 3.16 with my earlycon series[1] if this
> is not taken for 3.15.

I'd like to take this for 3.15 as it's currently broken. I just need
another ack from Arnd on the generic header change.

-- 
Catalin
