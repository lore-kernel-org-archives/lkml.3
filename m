Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3EGNd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:33:56 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:55117 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab3EGNdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:33:53 -0400
Date: Tue, 7 May 2013 15:33:49 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Lance Ortiz <lance.ortiz@hp.com>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: WARNING at drivers/pci/search.c:214 for 3.9
Message-ID: <20130507153349.4d03040a@pluto.restena.lu>
In-Reply-To: <20130507103830.GA7633@pd.tnic>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
	<20130506150757.GC22041@pd.tnic>
	<20130507085205.5a41b5ca@pluto.restena.lu>
	<20130507103830.GA7633@pd.tnic>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013 12:38:30 +0200 Borislav Petkov wrote:
> On Tue, May 07, 2013 at 08:52:05AM +0200, Bruno Prémont wrote:
> > Better that way (log_buf_len=10M)!
> > 
> > The full boot log is available at:
> >   http://pastebin.com/hVVne14C
> > (the Hardware Error message is there right before the series of
> > WARNINGs)
> 
> Yep, thanks.
> 
> So your error doesn't happen straight after the box has booted but
> later, ~70 seconds within the boot. I'm guessing that's reproducible?
> Are you doing something specific right after the machine is booted? It
> doesn't look so to me because you're in cpu_idle when the timer IRQ
> happens.
> 
> It looks like this is the polling interval that comes from the GHES
> gunk.
> 
> I guess what I'm trying to say is, are you doing something special to
> cause the PCIe error or it just happens while the machine is idle?

No, not doing anything special (except maybe boot a vanilla Linux kernel
compiled myself).
That happens even when booting into init=/bin/bash and just starring
at the monitor.

> What about a BIOS update?

Last time I checked (update-DVD) there was none (some-when past winter)

Checking online now there is one, though release information does not
include details...

  BIOS V4.6.5.3 R2.21.0 for RX200 S7
  ==================================
  included components:
   VGA: MATROX/MGA-G200 VGA/VBE BIOS (V3.8SQ) b33
   LAN: PXE OPROM: Intel(R) Boot Agent GE v1.3.72 PXE 2.1 Build 089
   LAN: iSCSI OPROM: iSCSI Remote Boot version 2.7.97
   Intel Reference Code Package for Romley v1.0.023
   Intel SAS OPROM v3.1.0.2101
   Patsburg SCU: LSI SAS OPROM SCU.11.08021201P

  Added Changes/Fixed Issues in from Rev 2.19.0 to Rev. R2.21.0:
  ==============================================================
  - fix for VIOM

  Added Changes/Fixed Issues in from Rev 2.16.0 to Rev. R2.19.0:
  ==============================================================
  - new Intel Reference Code
  - some minor bug fixes

  Added Changes/Fixed Issues in from Rev 2.4.0 to Rev. R2.16.0:
  ==============================================================
  - Update LSI SCU option ROM to version 11.08021201P
  - some minor bug fixes
  - fix for LRDIMM
  - Correct the settings for BIOS Setup SATA configuration
  - fixes for WHEA
  - fixes for TPM

Original BIOS revision was 2.4.0.
>From download page 2.4.0 was released in August 2012,
                   2.16.0 was released in January 2013
                   2.21.0 was released in April 2013

With the BIOS updated, the error message is gone (both the Hardware
error, and the WARNINGs triggered by attempting to lookup the source
PCIe device)
Not sure which of the two public updates did the fix...

> > > > For older kernels (3.8.x and older) I only have:
> > > > [   65.741777] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
> > > > [   65.763335] {1}[Hardware Error]: APEI generic hardware error status
> > > > [   65.782650] {1}[Hardware Error]: severity: 2, corrected
> > > > [   65.782652] {1}[Hardware Error]: section: 0, severity: 2, corrected
> > > > [   65.782653] {1}[Hardware Error]: flags: 0x01
> > > > [   65.782655] {1}[Hardware Error]: primary
> > > > [   65.782656] {1}[Hardware Error]: fru_text: CorrectedErr
> > > > [   65.782658] {1}[Hardware Error]: section_type: PCIe error
> > > > [   65.782659] {1}[Hardware Error]: port_type: 0, PCIe end point
> > > > [   65.782660] {1}[Hardware Error]: version: 0.0
> > > > [   65.782662] {1}[Hardware Error]: command: 0xffff, status: 0xffff
> > > > [   65.782664] {1}[Hardware Error]: device_id: 0000:00:02.3
> > > 
> > > Interesting. AFAICT, you don't have such device in lspci below.
> > 
> > Yes it has been that way from the start and under BIOS settings I've
> > found nothing that would make mentioned device visible.
> 
> Hmm, so it could be some hidden device or maybe the error info is
> corrupted. Btw, it also says:
> 
> [   72.948961] PCI AER Cannot get PCI device 0000:00:00.3
> 
> which is also a device you *don't* find in lspci.
> 
> This is fun - detecting PCIe devices by the errors they generate.
> Hahahaha.
> 
> To tell you the truth, nothing will surprise me anymore. :-)

Hidden device, but not hidden well enough :)

> > > > [   65.782665] {1}[Hardware Error]: slot: 0
> > > > [   65.782666] {1}[Hardware Error]: secondary_bus: 0x00
> > > > [   65.782667] {1}[Hardware Error]: vendor_id: 0xffff, device_id: 0xffff
> > > > [   65.782668] {1}[Hardware Error]: class_code: ffffff
> > > > 
> > > > which was being "triggered" by
> > > >  commit 3c076351c4027a56d5005a39a0b518a4ba393ce2
> > > >  Author: Matthew Garrett <mjg@redhat.com>
> > > >  Date:   Thu Nov 10 16:38:33 2011 -0500
> > > > 
> > > >     PCI: Rework ASPM disable code
> > > 
> > > And if you revert it, the error above disappears? Adding Matthew.
> > 
> > Correct (at least on 3.0.y stable series).
> > 
> > 
> > Toggling the "ASPM support" BIOS option makes no difference.
> > 
> > I've even contacted Fujitsu but unfortunately got no useful result as
> > they only support SLES kernels,
> 
> You gotta love hw vendors' excuses. I can translate this message into
> what it actually means :)

Something like "There is no BUG on our side" (while thinking: a bug,
need to fix it silently)?

> > which have Matthew's patch reverted with
> > commit message:
> >   This reverts commit 6cac12dfab9c57a4f76821412224b226a9b08dff,
> >   upstream commit 3c076351c4027a56d5005a39a0b518a4ba393ce2.
> 
> Yeah, they got reverted for SP2 but are back in SP3:
> 
> http://kernel.opensuse.org/cgit/kernel-source/commit/?h=SLE11-SP3&id=cd825d98ec79f777c14531f402d13a66598f3179
> 
> >   My PS/2 keyboard and touchpad are not detected with this patch.
> > 
> >   This turn 3.0.20 in a noop as there is no other patch. Except
> >   numbering is correct for further patches...
> 
> I don't understand: are you saying this patch breaks detection of your
> keyboard and touchpad and if you revert it, it works again? But 3.9 works?

No, that was the commit message of the SUSE guy who performed
the revert for SUSE kernel!

