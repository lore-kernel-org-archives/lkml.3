Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3LPPqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:46:25 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:18161 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754101Ab3LPPqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:46:21 -0500
Date: Mon, 16 Dec 2013 15:46:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Message-ID: <20131216154601.GH17713@arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-2-git-send-email-msalter@redhat.com>
 <20131205141853.GA974@darko.cambridge.arm.com>
 <1386341754.1861.188.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386341754.1861.188.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:55:54PM +0000, Mark Salter wrote:
> On Thu, 2013-12-05 at 14:18 +0000, Catalin Marinas wrote:
> > On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> > > +       add     x2, sp, 16
> > > +       str     x8, [x2]
> > > +       bl      efi_entry
> > > +       cmn     x0, #1
> > > +       b.eq    efi_load_fail
> > > +
> > > +       /*
> > > +        * efi_entry() will have relocated the kernel image if necessary
> > > +        * and we return here with device tree address in x0 and the kernel
> > > +        * entry point stored at *image_addr. Save those values in registers
> > > +        * which are preserved by __flush_dcache_all.
> > > +        */
> > > +       ldr     x1, [sp, #16]
> > > +       mov     x20, x0
> > > +       mov     x21, x1
> > > +
> > > +       bl      __flush_dcache_all
> > 
> > Regarding __flush_dcache_all, I plan to remove it for all cases apart
> > from power management with the MMU disabled. With MMU enabled, there is
> > no guarantee that this function does the right thing. It's even worse in
> > the guest context.
> 
> According to booting.txt, the dcache needs to be invalidated. Is there
> something existing I can use or do I need to write it?

The function will stay for a few cases where needed. But here the
D-cache and MMU are still on at this point and there is a slight chance
of speculative loads after the flush (though only clean lines). You
could move this after he MMU disabling (but still keep the I-cache on
for performance).

-- 
Catalin
