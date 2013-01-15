Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3AOSSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:18:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44935 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3AOSSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:18:42 -0500
Date: Tue, 15 Jan 2013 19:18:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
Subject: Re: kernel 3.7+ cpufreq regression on AMD system running as dom0
Message-ID: <20130115181839.GC8101@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	Andre Przywara <andre@andrep.de>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
References: <50F42B3E.7090602@canonical.com>
 <20130114163445.GA4867@liondog.tnic>
 <20130115175305.GA12449@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130115175305.GA12449@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 12:53:05PM -0500, Konrad Rzeszutek Wilk wrote:
> > I don't think that's the right change - this is fixing baremetal so that
> > it works on xen. And besides, this code was in powernow-k8 before so I'm
> > wondering why did it work then.
> 
> Powernow-k8 only populated the cpufreq policy information. This library
> (processor_perflib) is the generic library used for ACPI P-states parsing.
> This specific function (acpi_processor_get_performance_states) is just
> used to fetch and parse the P-states.
> 
> Xen-acpi-processor (which we use to upload the P and C-states to the
> hypervisor) ends up calling this library to parse the P-states
> and this unfortunate quirk clamps the P-states based on the MSRS.

Huh? This is a fix for _PSS frequency values which are rounded and thus
imprecise. The _PSS objects are the unfortunate ones, as most of the
other crap BIOS produces.

> It is odd that this CPU specific quirk got added in this generic
> library. Is there no ACPI quirk system similar to how DMI quirks are
> handled?

Even if there were, do you know all the boards and BIOS revisions which
have those rounded values? The fix addresses the hardware which has
those 50MHz multiples and simply ignores the _PSS data but reads out the
P-states directly from the hardware.

> Anyhow, I think this patch makes sense - it makes sure that the MSR
> value is sane.

I agree to a certain degree. Testing the Valid bit is something we
should do for P-state MSRs - and for all MSRs containing a Valid bit,
for that matter - and the original code didn't do it.

However, you need to push down the *correct* frequencies *after* the
quirk to the hypervisor (I'm looking at push_pxx_to_hypervisor()) so
that it is aware of the exact P-state frequencies this CPU supports and
not some rounded values.

AFAICT for the xen part, of course. But the baseline stands: you need to
tell the thing that switches P-states the exact P-state frequencies of
the CPU. :-).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
