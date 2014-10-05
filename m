Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaJEThX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:37:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55008 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbaJEThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:37:16 -0400
X-Sasl-enc: cLt2QrvfgFUyivJiu6Rajm1fmYQMXmI3EKgjT43D3C4V 1412537835
Date: Sun, 5 Oct 2014 16:37:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20141005193703.GB24081@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-2-git-send-email-hmh@hmh.eng.br>
 <20141005173453.GC9377@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005173453.GC9377@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Oct 2014, Borislav Petkov wrote:
> On Mon, Sep 08, 2014 at 02:37:47PM -0300, Henrique de Moraes Holschuh wrote:
> > -	if (data_size + MC_HEADER_SIZE > total_size) {
> > +	if ((data_size % DWSIZE) || (total_size % 1024) ||
> > +	    (data_size + MC_HEADER_SIZE > total_size)) {
> >  		if (print_err)
> > -			pr_err("error! Bad data size in microcode data file\n");
> > +			pr_err("error: bad data size or total size in microcode data file\n");
> 
> Shorten:
> 
> 	pr_err("error: bad data/total size in microcode data file\n");

will do.

> > +	/*
> > +	 * A version 1 loader cannot differentiate failure from success when
> > +	 * attempting a microcode update to the same revision as the one
> > +	 * currently installed.  The loader is supposed to never attempt a
> > +	 * same-version update (or a microcode downgrade, for that matter).
> > +	 *
> > +	 * This will always cause issues for microcode updates to revision zero
> > +	 * in the UEFI/BIOS microcode loader: the processor reports a revision
> > +	 * of zero when it is running without any microcode updates installed,
> > +	 * such as after a reset/power up.
> > +	 *
> > +	 * Intel will never issue a microcode update with a revision of zero
> > +	 * for the version 1 loader.  Reject it.
> > +	 */
> 
> This comment is too long. How about this instead:
> 
> 	/*
> 	 * 0 is not a valid microcode revision as it is used to denote the
> 	 * failure of a microcode update, see MSR 0x8b (IA32_BIOS_SIGN_ID):
> 	 *
> 	 * "It is required that this register field be pre-loaded with zero
> 	 * prior to executing the CPUID, function 1. If the field remains
> 	 * equal to zero, then there is no microcode update loaded. Another
> 	 * non-zero value will be the signature."
> 	 */
> 
> This is one of those seldom times where the documentation is actually clear. :-)

Not realy, because it got you confused! :-)

Zero does not denote a failure to update microcode.  What zero means, *when
you did the pre-load and issued a cpuid(1)*, is that the processor microcode
has not been updated since power-on/reset.

What flags a *sucessful* microcode update is a change on IA32_BIOS_SIGN_ID
(which must be read with the zero preload and cpuid(1) protocol).

If IA32_BIOS_SIGN_ID didn't change, the microcode update was rejected...
obviously, this only holds when you never attempt to update the microcode to
the same version the processor already had running.

And that's why we cannot detect whether a same-version update worked or not.

The reason Intel will never issue a microcode with revision zero is because
it cannot be safely applied by UEFI or BIOS at system power up: it would
look like a same-version update (IA32_BIOS_SIGN_ID would return zero before
the update, and would return zero after the update, whether it was applied
sucessfully or not).

And since Intel will never issue such microcode, we don't want to deal with
anything that claims to be a microcode update to revision zero.


IOW, this is a failure:

IA32_BIOS_SIGN_ID before the update is the same as IA32_BIOS_SIGN_ID after
the update attempt.

this is a sucessful update:

IA32_BIOS_SIGN_ID before the update is different from IA32_BIOS_SIGN_ID
after the update attempt.

In any case, you always need to do the zero-preload and cpuid(1) to read
IA32_BIOS_SIGN_ID.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
