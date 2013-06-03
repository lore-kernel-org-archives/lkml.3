Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3FCPVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:21:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41479 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FCPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:21:28 -0400
Date: Mon, 3 Jun 2013 16:21:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Message-ID: <20130603152122.GA21312@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike>
 <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370270282.2910.9.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 07:38:02AM -0700, James Bottomley wrote:
> On Mon, 2013-06-03 at 15:30 +0100, Matthew Garrett wrote:
> > Windows calls SetVirtualAddressMap(), so the only way these systems have 
> > been tested is with SetVirtualAddressMap().
> 
> I know, but that's not what I said.
> 
> If you look at the implementation, SetVirtualAddressMap() does a massive
> pointer chase through the images.  It not only tries to relocate the
> text and data, but it also tries to relocate all the users of the data.
> Some of these sources of data are boot time and some runtime.  Those
> both need to be relocated by a separate pointer chase.  What we saw with
> the QueryVariableInfo() problem was that a boot time pointer wasn't
> relocated.  That's got to mean that windows only calls QueryVariableInfo
> from runtime.

Sure.

> My point is that if we elect to call SetVirtualAddressMap() we'll be
> restricted to only making the calls at boot time that windows does
> otherwise we'll end up with these unrelocated pointers.  That's a huge
> nasty verification burden on us.  Alternatively, if we never call
> SetVirtualAddressMap() it seems to me that we just don't have to worry
> about pointer relocation issues.  Thus, I think it would be better we
> use the 1:1 mapping instead of calling SetVirtualAddressMap().

Some hardware just arbitrarily fails some calls if 
SetVirtualAddressMap() isn't called. As you pointed out, the only 
situation that these systems are ever tested in is the one where calls 
are made in roughly the same order as Windows, ie:

Calls made in boot services:

GetTime()
Getvariable()
ExitBootServices()

Calls made in runtime:

SetVirtualAddressMap()
GetNextVariable()
GetVariable()
SetVariable()

So far I haven't been able to convince Windows to make any other runtime 
calls, which makes me a little unhappy about even calling 
QueryVariableInfo() during runtime, but on the other hand our options 
there are either to call it or to kill Samsungs, so I think we're stuck 
with it. But, overall, refusing to call SetVirtualAddressMap() simply 
isn't an option.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
