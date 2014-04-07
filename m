Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaDGWFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbaDGWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:05:16 -0400
Message-ID: <1396908292.4958.24.camel@adam.happyassassin.net>
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
Date: Mon, 07 Apr 2014 15:04:52 -0700
In-Reply-To: <53431296.10502@zytor.com>
References: <20140404064120.GB11877@gmail.com>
		<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
		<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>
		<20140404151359.GB12370@srcf.ucam.org>
	 <20140406184023.1e31412d@alan.etchedpixels.co.uk>
	 <53419F84.2090204@zytor.com> <53425B2A.10001@linux.intel.com>
	 <53431296.10502@zytor.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 14:03 -0700, H. Peter Anvin wrote:
> On 04/07/2014 01:00 AM, Li, Aubrey wrote:
> > 
> > EFI is no question. So, Is everybody okay with the following sequence?
> > (1) ACPI
> > (2) KEYBOARD
> > (3) ACPI
> > (4) KEYBOARD
> > (ADD_1) EFI
> > (5) TRIPLE
> > (ADD_2) CF9
> > (ADD_3) BIOS
> > 
> 
> No.  Because after "triple" there is NOTHING.  Putting anything after it
> is a joke.
> 
> How many times do I have to explain this to how many people?  If
> "triple" or "BIOS" doesn't work, there is no trying again... the machine
> is dead.

So if I'm following correctly, we should be able to sort the methods
into three buckets:

1) known to (almost) always be 'safe'
2) may cause system freeze if they fail
3) definitely cause system freeze if they fail

We put the methods from bucket 1) first, in whichever order makes the
most sense. Then we put any methods from bucket 2), in an order derived
from some kind of likelihood of success / likelihood of hang on fail
calculation. And at the end we can put precisely *one* method from
bucket 3, which should obviously be the one most likely to succeed on
the most systems which haven't already worked with one of the other
methods. We can't have more than one bucket 3) method, it just doesn't
make sense.

It sounds like at least TRIPLE and BIOS are 'bucket 3' methods, so it
seems like we have to pick which of the two we think is most useful, put
it last, and not have the other one. Of the new methods it sounds like
EFI is 'bucket 1', BIOS is 'bucket 3', and CF9 is 'bucket 2'.

so, it sounds like...

1) ACPI
2) KEYBOARD
3) ACPI
4) KEYBOARD
5) EFI
possibly 6) CF9
7) TRIPLE *or* BIOS

is what you would say makes sense, right? And really all there is to
decide is whether to include CF9, and whether to put TRIPLE or BIOS at
the end?

Again if I'm following correctly, this ought to be fine for Baytrail
devices - the ones we were trying to fix in the first place - because
they'll succeed with EFI. The justification for adding CF9 in the first
place wasn't very strong - it was just thrown in as a 'bonus extra',
more or less:

"These platforms [Baytrail] don't support ACPI reboot, we expect to call
EFI runtime service to handle this case, and CF9 is an alternate after
EFI."

so it doesn't seem unreasonable to remove it. The machine we're
currently trying to 'fix' needed TRIPLE in order to reboot correctly, it
seems. So again if I'm following correctly, that would suggest we should
have:

1) ACPI
2) KEYBOARD
3) ACPI
4) KEYBOARD
5) EFI
6) TRIPLE

I can patch that into reboot.c and confirm baytrails still work, if
that's desired.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

