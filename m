Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3HOKBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:01:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47430 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3HOKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:01:35 -0400
Date: Thu, 15 Aug 2013 12:01:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815100132.GC27616@pd.tnic>
References: <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com>
 <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan>
 <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com>
 <20130814211504.393cf138@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130814211504.393cf138@concha.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:15:04PM -0300, Mauro Carvalho Chehab wrote:
> > - Two, if ghes_edac is enabled, it prevents other edac drivers
> > from being loaded. It looks like the assumption here is that if
> > ghes/firmware first is enabled, then *all* memory errors are
> > reported through ghes which is not true. We could have (a subset
> > of) corrected errors reported through ghes, some through CMCI
> > and uncorrected errors through MCE. So, if I'm not mistaken, if
> > ghes_edac is enabled, we will only receive ghes error events through
> > mc_event and not the others. Mauro, is this accurate?
> 
> Yes, that's the current assumption. It prevents to have both BIOS and a
> direct-hardware-access-EDAC-driver to race, as this is known to have
> serious issues.

Ok, this is getting confusing so let's shed some more light.

* First of all, Naveen is asking whether other *edac* drivers can
be loaded. And no, they cannot once the ghes thing is loaded which
potentially is a problem.

For example, if the chipset-specific driver has additional functionality
from ghes_edac, then that functionality is gone when ghes_edac loads
first. This might be a problem in some cases, we probably need to think
about this more in depth.

* Then, there's the trace_mce_record() TP which comes straight
from mce.c This one is always enabled unless the mce_disable_bank
functionality kicks in which you, Naveen, added :-).

* The CMCI stuff should be synchronized with the MCE TP so that should
be ok.

I think those are our current error reporting paths...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
