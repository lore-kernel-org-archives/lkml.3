Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaG2Kp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:45:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55459 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaG2Kp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:45:26 -0400
Date: Tue, 29 Jul 2014 12:45:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140729104520.GF11179@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140728193734.GC9752@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 04:37:35PM -0300, Henrique de Moraes Holschuh wrote:
> Keep in mind that the test is not required as far as the Linux kernel driver
> is concerned.  We really don't care, it would be just an additional test.

This is what I mean.

> What we do care about is that data_size and total_size are multiples of 4
> (dword size), and that total_size is exactly large enough for the header,
> the data payload, and the optional extended signature table, if any.

I'm with you so far.

> Anyway, a "total_size % 1024" test makes it impossible for an userspace tool
> to split a microcode data file with multiple signatures into several
> microcodes with a single signature and no extended signature table.

So on Intel a userspace tool is splitting the blob into chunks and
correcting total_size too?

> That kind of split seems to be the whole point of adding per-entry checksums
> to the extended signatures (hinted at by the Intel SDM, vol3A, page 9-30,
> last row of table 9-6).
> 
> It seems safer to just not test for it:
> 
> * FreeBSD seems to just WRMSR directly to the processor whatever crap you
>   feed it, no checks done whatsoever.  Userspace has to do everything.

CPU wouldn't load corrupted microcode anyway, you know that.

> * Intel BITS (r.1084) seems to have broken code. FWIW, it doesn't test for
>   total_size % 1024.
> 
> * Microsoft Windows distributes the driver and the microcode data in the
>   same DLL, so one will be updated to match the other.  I have no idea what
>   it does inside the DLL.

Who cares.

> * TianoCore UDK2014 doesn't test for total_size % 1024.
> 
> * OpenSolaris doesn't check for total_size % 1024 either.
> 
> Given that mess, I'd rather we don't be the only ones that will refuse a
> microcode that is not a multiple of 1024 bytes in size.

So is the recommendation in the just for fun?

And AFAICT, the only reason why we don't check it is the split, correct?
So why do we need that split again? Is Intel microcode so big so that we
can't keep it in a single blob, the exact same way it comes from them?

The microcode blob I get there is this:

https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=23984&lang=eng

which is 0.75Mb.

We're perfectly fine handling such a blob as a whole AFAICT.

> > > +	/* check some of the metadata */
> > > +	if (mc_header->rev == 0) { /* reserved for silicon microcode */
> > > +		if (print_err)
> > > +			pr_err("error! Restricted revision 0 in microcode data file\n");
> > > +		return -EINVAL;
> > > +	}
> > 
> > What is "factory-provided" microcode? What is this check supposed to
> > accomplish?
> 
> Factory-provided is whatever microcode is hardwired in silicon and active
> after processor power up/hard reset.

I think you mean the microcode that's in the BIOS. There's no "hardwired"
microcode AFAIK.

> The procedure to check whether a microcode update was installed is this:
> 
> Load MSR 0x8B (IA32_BIOS_SIGN_ID) with a zero.
> cpuid(1)
> Check value in MSR 0x8B (IA32_BIOS_SIGN_ID).
> 
> The documentation says that the contents of the IA32_BIOS_SIGN_ID MSR will
> be changed by the cpuid instruction when a microcode update is installed in
> the processor, and left unchanged otherwise.  If it is changed, it will be
> set to the revision of the microcode running in the processor.
> 
> Since we write a zero to the MSR before the cpuid(1), we use zero to detect
> the lack of change on the MSR.  AFAIK, we *must* do it this way:  Intel SDM
> vol 3A, section 9.11.7.
> 
> The result is that we cannot detect whether a microcode with a revision of
> zero has been installed succesfully or not.  This alone is already grounds
> for rejecting such a microcode update IMHO.

I don't think there will ever be a valid distributed microcode with a
revision of 0. We probably should ask someone from Intel to confirm but
I think this is a non-issue: you will have some microcode revision > 0
always loaded from the BIOS.

And even if you manipulated the headers, I think the correct revision is
contained in the encrypted part too so it'll come out in MSR 0x8B after
a successful update even with a corrupted header.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
