Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab3ANRrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:47:43 -0500
Received: from mail.andrep.de ([217.160.17.100]:57363 "EHLO mail.andrep.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab3ANRrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:47:37 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 12:47:36 EST
Date: Mon, 14 Jan 2013 18:40:37 +0100
From: =?ISO-8859-1?Q?Andr=E9?= Przywara <andre@andrep.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [Xen-devel] kernel 3.7+ cpufreq regression on AMD system
 running as dom0
Message-ID: <20130114184037.21c49b8c@hydra>
In-Reply-To: <50F43B9D.8030300@canonical.com>
References: <50F42B3E.7090602@canonical.com>
	<20130114163445.GA4867@liondog.tnic>
	<50F43B9D.8030300@canonical.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 18:08:45 +0100
Stefan Bader <stefan.bader@canonical.com> wrote:

> On 14.01.2013 17:34, Borislav Petkov wrote:
> > On Mon, Jan 14, 2013 at 04:58:54PM +0100, Stefan Bader wrote:
> >> Starting with kernel v3.7 the following commit added a quirk
> >> to obtain the real frequencies of certain AMD systems:
> >>
> >> commit f594065faf4f9067c2283a34619fc0714e79a98d
> >> Author: Matthew Garrett <mjg@redhat.com>
> >> Date:   Tue Sep 4 08:28:06 2012 +0000
> >>
> >>     ACPI: Add fixups for AMD P-state figures
> >>
> >> When running bare-metal, on my Opteron 6128 test box results
> >> in the frequencies remaining effectively unchanged:
> >> [    5.475735] P0: MSR(hi,lo): 8000015c-50004004
> >> [    5.479049] P0: fid=0x4, did=0x0, freq: 2000 -> 2000
> >> [    5.484001] P1: MSR(hi,lo): 8000014c-50004a4e
> >> [    5.487314] P1: fid=0xe, did=0x1, freq: 1500 -> 1500
> >> [    5.492272] P2: MSR(hi,lo): 80000141-50005048
> >> [    5.495584] P2: fid=0x8, did=0x1, freq: 1200 -> 1200
> >> [    5.500540] P3: MSR(hi,lo): 80000138-50005844
> >> [    5.503853] P3: fid=0x4, did=0x1, freq: 1000 -> 1000
> >> [    5.508812] P4: MSR(hi,lo): 80000131-50005c40
> >> [    5.512125] P4: fid=0x0, did=0x1, freq: 800 -> 800
> >>
> >> However running as dom0 under Xen 4.2, reading this MSR returns
> >> null:
> >> [   11.613068] P0: MSR(hi,lo): 00000000-00000000
> >> [   11.613074] P0: fid=0x0, did=0x0, freq: 2000 -> 1600
> >> [   11.613078] P1: MSR(hi,lo): 00000000-00000000
> >> [   11.613081] P1: fid=0x0, did=0x0, freq: 1500 -> 1600
> >> [   11.613085] P2: MSR(hi,lo): 00000000-00000000
> >> [   11.613088] P2: fid=0x0, did=0x0, freq: 1200 -> 1600
> >> [   11.613091] P3: MSR(hi,lo): 00000000-00000000
> >> [   11.613094] P3: fid=0x0, did=0x0, freq: 1000 -> 1600
> >> [   11.613098] P4: MSR(hi,lo): 00000000-00000000
> >> [   11.613101] P4: fid=0x0, did=0x0, freq: 800 -> 1600
> >>
> >> And this results in Xen failing to change the governor:
> >>   "(XEN) Fail change to ondemand governor"
> >>
> >> I suppose this ultimately requires some support in the hypervisor
> >> to pass through the real values. But since this is at least on my
> >> combination of Xen 4.2 + kernel v3.7+ and AMD family 0x10 CPU a
> >> regression compared to older kernels, I wonder whether the
> >> following change might be something that should go into mainline:
> >>
> >> --- a/drivers/acpi/processor_perflib.c
> >> +++ b/drivers/acpi/processor_perflib.c
> >> @@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct
> >> acpi_processor_px *px if ((boot_cpu_data.x86 == 0x10 &&
> >> boot_cpu_data.x86_model < 10) || boot_cpu_data.x86 == 0x11) {
> >>                 rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
> >> +               /* Bit 63 indicates whether contents are valid */
> >> +               if (!(hi & 0x8000000))
> >> +                       return;
> > 
> > I don't think that's the right change - this is fixing baremetal so
> > that it works on xen. And besides, this code was in powernow-k8
> > before so I'm wondering why did it work then.
> 
> This actually only started to work when the xen-processor module got
> introduced to provide acpi information to the hypervisor. If I
> remember correctly powernow-k8 did fail.
> For the way I did the fix: the AMD BIOS docs seemed to indicate that
> even for bare metal bit 63 would say whether the values are valid. So
> I thought this is a nice coincidence that under Xen with all 0 this
> matches that special case... ;)

>From a first glance I think this fix is a valid approach. There are
BIOSes which disable P-states via this bit, so we have to observe this
for bare-metal, too. Let me think a bit more about this, however, and
see whether there is a better solution to do the right thing (tm) under
Xen. Getting back to you then.

Thanks,
Andre.

