Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3AVNsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:48:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49879 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3AVNsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:48:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: kernel 3.7+ cpufreq regression on AMD system running as dom0
Date: Tue, 22 Jan 2013 14:54:07 +0100
Message-ID: <5170158.Y3daIptmyO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130121153105.GE4445@pd.tnic>
References: <50F42B3E.7090602@canonical.com> <50FD58CF.8080101@canonical.com> <20130121153105.GE4445@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 04:31:05 PM Borislav Petkov wrote:
> On Mon, Jan 21, 2013 at 03:03:43PM +0000, Stefan Bader wrote:
> > From 9870926d4a847e36c0f61921762fd50f1c92f75d Mon Sep 17 00:00:00 2001
> > From: Stefan Bader <stefan.bader@canonical.com>
> > Date: Mon, 14 Jan 2013 16:17:00 +0100
> > Subject: [PATCH] ACPI: Check MSR valid bit before using P-state frequencies
> > 
> > To fix incorrect P-state frequencies which can happen on
> > some AMD systems f594065faf4f9067c2283a34619fc0714e79a98d
> >   "ACPI: Add fixups for AMD P-state figures"
> > introduced a quirk to obtain the correct values by reading
> > from AMD specific MSRs.
> > 
> > This did cause a regression when running a kernel using that
> > quirk under Xen which does (currently) not pass through MSR
> > reads to the HW. Instead the guest gets a 0 in return.
> > And this seems to cause a failure to initialize the ondemand
> > governour (hard to say for sure as all P-states appear to run
> > at the same frequency).
> > 
> > While this should also be fixed in the hypervisor (to allow
> > a guest to read that MSR), this patch is intended to work
> > around the issue in the meantime. In discussion it turned out
> > that indeed real HW/BIOSes may choose to not set the valid bit
> > and thus mark the P-state as invalid. So this could be considered
> > a fix for broken BIOSes that also works around the issue on Xen.
> > 
> > [v2] Reword description text and use helper for bit index.
> > Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> > Cc: stable@vger.kernel.org # v3.7..
> > ---
> >  drivers/acpi/processor_perflib.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> > index 836bfe0..caa042e 100644
> > --- a/drivers/acpi/processor_perflib.c
> > +++ b/drivers/acpi/processor_perflib.c
> > @@ -340,6 +340,17 @@ static void amd_fixup_frequency(struct
> > acpi_processor_px *px, int i)
> >  	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
> >  	    || boot_cpu_data.x86 == 0x11) {
> >  		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
> > +		/*
> > +		 * MSR C001_0064+:
> > +		 * Bit 63: PstateEn. Read-write. 1=The P-state specified by
> > +		 * this MSR is valid. 0=The P-state specified by this MSR is
> > +		 * not valid. The purpose of this register is to indicate if
> > +		 * the rest of the P-state information in the register is
> > +		 * valid after a reset; it controls no hardware.
> > +		 */
> 
> Maybe this comment is a but too long and it contains that idiotic
> processor manual speak :-). It should've contained only the first
> sentence: "PstateEn. If set, the P-state is valid."
> 
> But maybe Rafael could correct it while committing, no reason to resend
> for that only.
> 
> Acked-by: Borislav Petkov <bp@suse.de>

Applied, the comment fixed up.

It's in my bleeding-edge branch for now and I'll move it to the linux-next
branch after build testing.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
