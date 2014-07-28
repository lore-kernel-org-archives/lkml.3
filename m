Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaG1Thq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:37:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38398 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbaG1Tho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:37:44 -0400
X-Sasl-enc: +OWGirm6uH2hqTLmg0vdjuYDom7n18ZlITF32VXPjBee 1406576261
Date: Mon, 28 Jul 2014 16:37:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140728193734.GC9752@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728153157.GC5350@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Borislav Petkov wrote:
> On Wed, Jul 23, 2014 at 05:10:50PM -0300, Henrique de Moraes Holschuh wrote:
> > Ensure that both the microcode data_size and total_size fields are a
> > multiple of the dword size (4 bytes).  The Intel SDM vol 3A (order code
> > 253668-051US, June 2014) requires this to be true, and the driver code
> > assumes it will be true.
> > 
> > Add a comment to the code stating that it is best if we continue to
> > refrain from ensuring that total_size is a multiple of 1024 bytes.  The
> > reason to never add that check is non-obvious.
> > 
> > Refuse a microcode with a revision of zero, we reserve that for the
> > factory-provided microcode.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > ---
> >  arch/x86/kernel/cpu/microcode/intel_lib.c |   21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
> > index 95c2d19..050cd4f 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel_lib.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
> > @@ -61,12 +61,22 @@ int microcode_sanity_check(void *mc, int print_err)
> >  	total_size = get_totalsize(mc_header);
> >  	data_size = get_datasize(mc_header);
> >  
> > -	if (data_size + MC_HEADER_SIZE > total_size) {
> > +	if ((data_size % DWSIZE) || (total_size % DWSIZE) ||
> > +	    (data_size + MC_HEADER_SIZE > total_size)) {
> >  		if (print_err)
> > -			pr_err("error! Bad data size in microcode data file\n");
> > +			pr_err("error! Bad data size or total size in microcode data file\n");
> >  		return -EINVAL;
> >  	}
> >  
> > +	/*
> > +	 * DO NOT add a check for total_size to be a multiple of 1024.
> > +	 *
> > +	 * While there is a requirement that total_size be a multiple of 1024
> > +	 * (Intel SDM vol 3A, section 9.11.1, table 9-6, page 9-29), it clashes
> > +	 * with the "delete extended signature table" procedure described for
> > +	 * the Checksum[n] field in the same table 9-6, at page 9-30).
> 
> Why? I don't see anything wrong with doing
> 
> ->total_size % 1024
> 
> as an additional sanity check. It's a whole another question how much it
> would catch but it doesn't hurt to do it as part of us being defensive.

Well, it might actually hurt.

Keep in mind that the test is not required as far as the Linux kernel driver
is concerned.  We really don't care, it would be just an additional test.

What we do care about is that data_size and total_size are multiples of 4
(dword size), and that total_size is exactly large enough for the header,
the data payload, and the optional extended signature table, if any.

Anyway, a "total_size % 1024" test makes it impossible for an userspace tool
to split a microcode data file with multiple signatures into several
microcodes with a single signature and no extended signature table.

That kind of split seems to be the whole point of adding per-entry checksums
to the extended signatures (hinted at by the Intel SDM, vol3A, page 9-30,
last row of table 9-6).

It seems safer to just not test for it:

* FreeBSD seems to just WRMSR directly to the processor whatever crap you
  feed it, no checks done whatsoever.  Userspace has to do everything.

* Intel BITS (r.1084) seems to have broken code. FWIW, it doesn't test for
  total_size % 1024.

* Microsoft Windows distributes the driver and the microcode data in the
  same DLL, so one will be updated to match the other.  I have no idea what
  it does inside the DLL.

* TianoCore UDK2014 doesn't test for total_size % 1024.

* OpenSolaris doesn't check for total_size % 1024 either.

Given that mess, I'd rather we don't be the only ones that will refuse a
microcode that is not a multiple of 1024 bytes in size.

> > +	/* check some of the metadata */
> > +	if (mc_header->rev == 0) { /* reserved for silicon microcode */
> > +		if (print_err)
> > +			pr_err("error! Restricted revision 0 in microcode data file\n");
> > +		return -EINVAL;
> > +	}
> 
> What is "factory-provided" microcode? What is this check supposed to
> accomplish?

Factory-provided is whatever microcode is hardwired in silicon and active
after processor power up/hard reset.

The procedure to check whether a microcode update was installed is this:

Load MSR 0x8B (IA32_BIOS_SIGN_ID) with a zero.
cpuid(1)
Check value in MSR 0x8B (IA32_BIOS_SIGN_ID).

The documentation says that the contents of the IA32_BIOS_SIGN_ID MSR will
be changed by the cpuid instruction when a microcode update is installed in
the processor, and left unchanged otherwise.  If it is changed, it will be
set to the revision of the microcode running in the processor.

Since we write a zero to the MSR before the cpuid(1), we use zero to detect
the lack of change on the MSR.  AFAIK, we *must* do it this way:  Intel SDM
vol 3A, section 9.11.7.

The result is that we cannot detect whether a microcode with a revision of
zero has been installed succesfully or not.  This alone is already grounds
for rejecting such a microcode update IMHO.

Note that currently we cannot even *attempt* to install such a microcode,
anyway.  But we will be silent about it without this patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
