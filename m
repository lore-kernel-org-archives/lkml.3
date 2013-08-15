Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab3HOSlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:41:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52564 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab3HOSlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:41:52 -0400
Date: Thu, 15 Aug 2013 20:41:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815184149.GJ27616@pd.tnic>
References: <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan>
 <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com>
 <20130814211504.393cf138@concha.lan>
 <20130815100132.GC27616@pd.tnic>
 <20130815103421.178a5224@samsung.com>
 <20130815135106.GG27616@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CBCE72@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CBCE72@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 06:16:48PM +0000, Luck, Tony wrote:
> > * We parse some APEI table and disable those MCA banks which the BIOS
> > wants to handle first.
>
> We have no idea which errors the BIOS has chosen for itself. We just
> know which bank numbers ...

Well, those which BIOS hasn't chosen for itself get simply handled up
through, HEST it is, I think. So it all goes out in APEI anyway...

> and Intel processors change mappings of which errors are logged in
> which banks in every new processor tock (and sometimes tick). Some
> banks are documented in processor datasheet. most are not. Most common
> case might well be memory ... but it could be cache, or I/O, or ...
>
> So this doesn't help Mauro figure out whether to allow loading of an
> EDAC driver that will peek and poke at chipset specific registers in
> possibly racy ways with BIOS code doing the same thing.

That doesn't matter - the only thing that matters is if an EDAC driver
has anything additional to bring to the table. If it does, then it gets
to see the errors before they're dumped to userspace. If not, then APEI
should report them directly.

Mind you, if we've disabled an MCA bank for the kernel then no EDAC
driver gets to see errors from it either because APEI has taken
responsibility. Unless said driver is poking around MCA registers -
which it shouldn't.

So I'd guess the decision to load an EDAC driver should be a platform
one. A platform which gives *sufficient* information in APEI tables for
an error doesn't need an EDAC driver. Older platforms or platforms which
cannot supply sufficient information for, say, properly pinpointing the
DIMM, should use the additional help of an EDAC driver for that, if
possible.

Which begs the most important question: do we even have a platform that
can give us sufficient information without the need for an EDAC driver?

Because if not, we should stop wasting energy pointlessly and simply
drop this discussion: we basically load an EDAC driver and do not do the
APEI tracepoint because it simply doesn't make any sense and there's no
actual platform giving us that info.

So, which is it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
