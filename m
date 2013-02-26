Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3BZNMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:12:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab3BZNMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:12:13 -0500
Date: Tue, 26 Feb 2013 14:12:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        Nitin Gupta <nitingupta910@gmail.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 1/4] decompressor: Add LZ4 decompressor module
Message-ID: <20130226131206.GW27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@arm.linux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, x86@kernel.org,
	celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
	Nitin Gupta <nitingupta910@gmail.com>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Albin Tonnerre <albin.tonnerre@free-electrons.com>,
	Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com,
	chan.jeong@lge.com, raphael.andy.lee@gmail.com
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <1361859870-15751-2-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361859870-15751-2-git-send-email-kyungsik.lee@lge.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:24:27PM +0900, Kyungsik Lee wrote:
> This patch adds support for LZ4 decompression in the Linux Kernel.
> LZ4 Decompression APIs for kernel are based on LZ4 implementation
> by Yann Collet.
> 
> LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
> LZ4 source repository : http://code.google.com/p/lz4/

What SVN version did you use?

> --- /dev/null
> +++ b/include/linux/lz4.h
> @@ -0,0 +1,48 @@
> +#ifndef __LZ4_H__
> +#define __LZ4_H__
> +/*
> + * LZ4 Kernel Interface
> + *
> + * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/*
> + * LZ4_COMPRESSBOUND()
> + * Provides the maximum size that LZ4 may output in a "worst case" scenario
> + * (input data not compressible)
> + */
> +#define LZ4_COMPRESSBOUND(isize) (isize + ((isize)/255) + 16)

For safety reasons I suggest to add a temporary variable to avoid double
evaluation of isize.

> --- /dev/null
> +++ b/lib/lz4/lz4_decompress.c
> +	}
> +	cpy = op + length - (STEPSIZE - 4);
> +	if (cpy > oend - COPYLENGTH) {
> +
> +		/* Error: request to write beyond destination buffer */
> +		if (cpy > oend)
> +			goto _output_error;
> +		LZ4_SECURECOPY(ref, op, (oend - COPYLENGTH));
> +		while (op < cpy)
> +			*op++ = *ref++;
> +		op = cpy;
> +		/*
> +		 * Check EOF (should never happen, since last 5 bytes
> +		 * are supposed to be literals)
> +		 */
> +		if (op == oend)
> +			goto _output_error;
> +		continue;
> +	}
> +		LZ4_SECURECOPY(ref, op, cpy);
> +		op = cpy; /* correction */
> +	}

Does this compile? The } is an extra one, and does not match the
original sources.

> +	/* end of decoding */
> +	return (int) (((char *)ip) - source);
> +
> +	/* write overflow error detected */
> +_output_error:
> +	return (int) (-(((char *)ip) - source));
> +}
> +
> --- /dev/null
> +++ b/lib/lz4/lz4defs.h
> @@ -0,0 +1,93 @@
> +#define LZ4_COPYSTEP(s, d)	\
> +	do {	\
> +		PUT8(s, d);	\
> +		d += 8;	\
> +		s += 8;	\
> +	} while (0)
> +
> +#define LZ4_COPYPACKET(s, d)	LZ4_COPYSTEP(s, d)
> +
> +#define LZ4_SECURECOPY(s, d, e)	\
> +	do {				\
> +		if (d < e) {		\
> +			LZ4_WILDCOPY(s, d, e);	\
> +		}	\
> +	} while (0)
> +
> +#else	/* 32-bit */
> +#define STEPSIZE 4
> +
> +#define LZ4_COPYSTEP(s, d)	\
> +	do {	\
> +		PUT4(s, d);	\
> +		d += 4;	\
> +		s += 4;	\
> +	} while (0)
> +
> +#define LZ4_COPYPACKET(s, d)	\
> +	do {			\
> +		LZ4_COPYSTEP(s, d);	\
> +		LZ4_COPYSTEP(s, d);	\
> +	} while (0)
> +
> +#define LZ4_SECURECOPY	LZ4_WILDCOPY
> +#endif
> +
> +#define LZ4_READ_LITTLEENDIAN_16(d, s, p) \
> +	(d = s - get_unaligned_le16(p))
> +#define LZ4_WILDCOPY(s, d, e)	\
> +	do {				\
> +		LZ4_COPYPACKET(s, d);	\
> +	} while (d < e)

All the \ at the ends of lines would look better aligned in one column.

david
