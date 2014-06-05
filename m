Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaFEHSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:18:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaFEHSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:18:40 -0400
Date: Thu, 5 Jun 2014 09:18:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, ricardo.neri-calderon@linux.intel.com,
        tglx@linutronix.de, matt.fleming@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140605071805.GA16647@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com>
 <20140604224920.GB4126@pd.tnic>
 <538FB775.8070405@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <538FB775.8070405@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 05:19:01PM -0700, Andy Lutomirski wrote:
> On 06/04/2014 03:49 PM, Borislav Petkov wrote:
> > On Wed, Jun 04, 2014 at 03:17:30PM -0700, H. Peter Anvin wrote:
> >> I seem to have lost track of this... does this actually solve
> >> anything, or does it just mean we'll explode hard?
> > 
> > Not that hard - it'll warn once only.
> > 
> > AFAIR, the discussion stalled but we were going in the direction of not
> > calling into efi from pstore in irq context.
> 
> The kernel_fpu_begin thing has annoyed me in the past.  How bad would it
> be to allocate some percpu space and just do a full save/restore when
> kernel_fpu_begin happens in a context where it currently doesn't work?
> 
> I don't know how large the state is these days, but there must be some
> limit to how deeply interrupts and exceptions can nest.  For each IST
> entry, there is a hard limit to how deeply they can nest (once for all
> but debug and four times for debug IIRC), plus one NMI (nested ones
> don't touch FPU).  The most non-IST entries we can have must be bounded,
> too.
> 
> Let's say there are at most 16 levels of nesting.  16 * state size *
> cpus isn't that much.
> 
> Of course, code in interrupts that nests kernel_fpu_begin itself could
> have a problem.  But this can be solved with a little bit of trickery in
> the entry code or something.
> 
> If we did this, then I think the x86 crypto code could get rid of all of
> its ridiculous async code.

How are you going to detect when to save/restore state? Do it
unconditionally would probably be a no-no. Even with all that optimized
XSAVE* fun.

On demand would mean you allow FPU exceptions which probably gravitates
towards a no-no too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
