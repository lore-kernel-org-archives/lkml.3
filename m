Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3CFQnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:43:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3CFQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:43:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
To: torvalds@linux-foundation.org, sfr@canb.auug.org.au,
        Joakim.Tjernlund@transmode.se, akpm@linux-foundation.org
cc: dhowells@redhat.com, linux-arch@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Byteorder conditional compilation problems
From: David Howells <dhowells@redhat.com>
Date: Wed, 06 Mar 2013 16:43:09 +0000
Message-ID: <31680.1362588189@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Looking at commit 13da9e200fe4740b02cd51e07ab454627e228920, I suspect the
answer will be no, but can we please revisit the use of __BYTE_ORDER in the
kernel?


The reason for this is that I've noticed a number of places in the UAPI
headers where __LITTLE_ENDIAN and __BIG_ENDIAN are assumed to act as in the
main kernel: they are tested for definedness, which is incorrect in UAPI
headers unless guarded by __KERNEL__.  In UAPI headers, they _must_ be
compared to __BYTE_ORDER in !__KERNEL__ conditions and <endian.h> should
perhaps be #included as well.

The following headers are all incorrect in their usage in this manner:

	include/uapi/linux/aio_abi.h - definition of PADDED()
	include/uapi/linux/acct.h - definition of ACCT_BYTEORDER
	include/uapi/linux/raid/md_p.h - order of members in mdp_superblock_s
	arch/m32r/include/uapi/asm/stat.h - order of members in stat64

The last two are the most worrying as these are visible from userspace.  Both
cases will likely use the __BIG_ENDIAN version in userspace (depending on
header inclusion ordering) - and it wouldn't surprise me if there's a nasty
bug in the RAID API that no one has spotted yet.  M32R will likely have a
problem too if anyone uses that in LE mode (the default is "no" on that one,
though).

And then there are:

	arch/arc/include/uapi/asm/byteorder.h - uses CONFIG_CPU_BIG_ENDIAN
	arch/c6x/include/uapi/asm/byteorder.h - uses _BIG_ENDIAN
	arch/c6x/include/uapi/asm/ptrace.h - uses _BIG_ENDIAN
	arch/mips/include/uapi/asm/msgbuf.h - uses CONFIG_CPU_LITTLE_ENDIAN

which all look like they might be wrong.

And finally, there are:

	include/{uapi/,}linux/patchkey.h - macro _PATCHKEY
	include/{uapi/,}linux/soundcard.h - macro AFMT_S16_NE

which have two separate bits (one UAPI, one KAPI) defining the same macro in
the same way because the macro is endianness-dependent, but the logic to
select the variant cannot be shared between UAPI and KAPI.

The following:

	include/uapi/sound/asound.h
	include/uapi/sound/sfnt_info.h

seem to dodge the problem by using SNDRV_{LITTLE,BIG}_ENDIAN instead - though
this doesn't seem to be defined in any headers under /usr/include, so I
presume it is required to be set manually by anyone using those headers.


Whilst the following opinion:

	The kernel has never had that crazy "__BYTE_ORDER == __LITTLE_ENDIAN"
	model.  It's not how we do things, and it isn't how we _should_ do
	things.  So don't go there.

may be a valid, it is incompatible with userspace.  We cannot change how
userspace works, but we could change how the kernel works to match it, thus
reducing the confusion.


Looking at commit b3b77c8caef1750ebeea1054e39e358550ea9f55, I think the
problems with it are simple to resolve:

 (1) linux/byteorder/big_endian.h didn't define __LITTLE_ENDIAN and
     .../little_endian.h didn't define __BIG_ENDIAN.  These should be placed
     in a common header, and only __BYTE_ORDER defined in the separate
     headers.

 (2) Tests for the definedness of __BIG_ENDIAN and __LITTLE_ENDIAN must be
     replaced en mass with comparisons against __BYTE_ORDER.

Sadly, (1) and (2) would have to be done in the same commit to avoid problems
since __BIG_ENDIAN and __LITTLE_ENDIAN must both be defined to for (1):-/


Throughout the whole kernel:

 - There are 703 instances of "defined(__XXX_ENDIAN)" scattered over 68
   files.  None of these appear to be in comments.

 - There are 6 instances of "def __XXX_ENDIAN[^_]" scattered over 4 files and
   these are all in comments.

 - There are a lot of "__XXX_ENDIAN__" - but these are not a problem.
   Possibly these should be converted to "__XXX_ENDIAN" and the relevant -D
   preprocessor flags removed.

 - There are a lot of "__XXX_ENDIAN_BITFIELD" - which aren't a problem either.


Scripting a change from "defined(__XXX_ENDIAN)" to "(__XXX_ENDIAN==__BYTEORDER)"
should be easy to script.

David
