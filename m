Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161734Ab3DEKHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:07:21 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52314 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab3DEKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:07:19 -0400
Message-ID: <1365156435.1970.31.camel@dabdike>
Subject: Re: [PATCH] Add non-zero module sections to sysfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>, linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de, linux-parisc@vger.kernel.org
Date: Fri, 05 Apr 2013 12:07:15 +0200
In-Reply-To: <87vc81lj7x.fsf@rustcorp.com.au>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de>
	 <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de>
	 <87vc81lj7x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 14:30 +1030, Rusty Russell wrote:
> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
> > On 04/04/13 03:00, Rusty Russell wrote:
> >> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
> >>> Add non-zero module sections to sysfs on architectures unequal to PARISC.
> >>> KGDB needs all module sections for proper module debugging. Therefore, commit 
> >>> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
> >>> architecture.

Thanks for actually cc'ing us.

> >> #ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
> >> wrong.
> >
> > I don't see why this is wrong. It used to load all sections to sysfs
> > until the patch mentioned. Actually, it is the PARISC build chain which
> > is broken.
> 
> Exactly.  Don't workaround it here, revert it and put the
> duplicate-section-name fixup in parisc where it belongs.
> 
> Assuming parisc still produces these dup sections: that patch is 4 years
> old now.

Just so you know: this isn't a parisc specific problem.  Gcc produces
duplicate section names under various circumstances, but the one that
bites us is -ffunction-sections.  Note that there are proposals to use
-ffunction-sections on all architectures (so we can garbage collect
unused functions) in which case you'll induce the bug identified in
35dead4235e2b67da7275b4122fed37099c2f462 on every architecture

The problem is our assumption that section names be unique.  This
assumption is wrong.  The ELF spec says (version 1.1 page 1-15): "An
object file may have more than one section with the same name."  We need
to fix the kernel not to rely on a bogus assumption ... but we had no
idea how to do that in a way that preserved the backwards compatibility
of sections subdirectory.

I admit that 35dead4235e2b67da7275b4122fed37099c2f462 is a hack, but now
the problem has got attention, can we fix it properly?

James


