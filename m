Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaDGXNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaDGXNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:13:15 -0400
Message-ID: <1396912372.4958.41.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
From: Adam Williamson <awilliam@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Mon, 07 Apr 2014 16:12:52 -0700
In-Reply-To: <5343220A.3060007@zytor.com>
References: <20140404064120.GB11877@gmail.com>
			<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
			<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>
			<20140404151359.GB12370@srcf.ucam.org>
		 <20140406184023.1e31412d@alan.etchedpixels.co.uk>
		 <53419F84.2090204@zytor.com> <53425B2A.10001@linux.intel.com>
		 <53431296.10502@zytor.com>
	 <1396908292.4958.24.camel@adam.happyassassin.net>
	 <5343220A.3060007@zytor.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 15:09 -0700, H. Peter Anvin wrote:

> > so, it sounds like...
> > 
> > 1) ACPI
> > 2) KEYBOARD
> > 3) ACPI
> > 4) KEYBOARD
> > 5) EFI
> > possibly 6) CF9
> > 7) TRIPLE *or* BIOS
> > 
> > is what you would say makes sense, right? And really all there is to
> > decide is whether to include CF9, and whether to put TRIPLE or BIOS at
> > the end?
> > 
> 
> Yep.  And it has now been shown again that CF9 just isn't safe.  We do
> TRIPLE as the ultimate fallback now.

OK. So the conservative option here - compared to the state before
Aubrey's patch, not the current state - is to simply add 5) EFI, go back
to TRIPLE instead of BIOS at the end of the list, and leave it at that.
We expect that would fix Baytrails.

But if we look at the message on Aubrey's commit:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/x86/kernel/reboot.c?id=a4f1987e4c5489a3877eaa7451a68d28c5a3f664

it mentions:

"If one method required is in the default list in this patch but the
machine reboot still hangs, that means some methods ahead of the
required method cause the system hangs, then reboot the machine by
passing reboot= arguments and submit the reboot dmidecode table quirk."

basically, we know that we probably can't come up with a standard
fallback chain that will work for *every* system, and the goal instead
is to come up with the approach that requires the *fewest* quirks.

Again just the monkey here, but I think this is right:

'CF9' = 'reboot=p' = 'set_pci_reboot'
'BIOS' = 'reboot=bios' = 'set_bios_reboot'

if so, according to the existing quirk table, we know of 17 cases which
need CF9 and 11 which need BIOS, and are therefore not served by the
previous fallback chain. So far after making the change, AFAIK, we've
heard of one case which does not work with ACPI or KBD, hangs with CF9,
but works with TRIPLE. It would need a quirk for any order which
includes CF9, but that's still 16 quirks fewer than we're currently
carrying for systems which need CF9.

Peter suggested going back and looking at the previous attempt to add
CF9 to the fallback chain. I just did that. Here's the relevant commits:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/x86/kernel/reboot.c?id=b47b92884212008b4bd044ba6b48b93c00b10ec6
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/x86/kernel/reboot.c?id=3889d0cea2b73049bdca062d9ff1e5d33468289c

the relevant text:

"Unfortunately this has been shown to cause lockups on at least two
systems for which REBOOT_KBD worked, both Thinkpads with Intel
chipsets."

those systems would, it seems, be OK with the proposed order:

ACPI
KBD
ACPI
KBD
EFI
CF9
TRIPLE
(rinse and repeat)

because KBD gets hit before CF9. So we at least don't have any prior
evidence that adding CF9 *after* KBD will break systems other than the
one found so far, AFAICS.

The question of whether the 'last resort' should be TRIPLE or BIOS is
presumably similarly data driven - would we wind up with more quirks to
use TRIPLE than we currently have to use BIOS? Always hard to answer
those questions, though.

Do we assume that finding a single system which would need a quirk to
avoid CF9 under the new chain means we'd quickly find another 16 and
hence be in a worse position than we are by leaving CF9 out? Or do we
give it a bit longer to see if more really do show up?
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

