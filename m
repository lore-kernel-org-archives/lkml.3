Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3BZOA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:00:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab3BZOA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:00:56 -0500
Date: Tue, 26 Feb 2013 15:00:51 +0100
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
Subject: Re: [RFC PATCH v2 2/4] lib: Add support for LZ4-compressed kernel
Message-ID: <20130226140051.GX27541@twin.jikos.cz>
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
 <1361859870-15751-3-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361859870-15751-3-git-send-email-kyungsik.lee@lge.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:24:28PM +0900, Kyungsik Lee wrote:
> +config KERNEL_LZ4
> +	bool "LZ4"
> +	depends on HAVE_KERNEL_LZ4
> +	help
> +	  Its compression ratio is worse than LZO. The size of the kernel
> +	  is about 8% bigger than LZO. But the decompression speed is
> +	  faster than LZO.
> +

Can you please add a sentence what lz4 actually is before you start
comparing it with the current competitor(s)?

> --- /dev/null
> +++ b/lib/decompress_unlz4.c
> @@ -0,0 +1,190 @@
> +#define LZ4_CHUNK_SIZE (8<<20)

Please use a less cryptic way of representing a value of 8 MB. Also,
this is a hardcoded value that must be used on the compressor side. It's
an upper limit, so anything below 8MB does not break decompresssion, but
this must be somehow checked or saved along in the binary stream. You
seem to use the lz4demo.c on the userspace side for compression, but
this is not a standard tool nor the output format is well-defined or
stabilized.

For proper use I would like to see a commandline tool similar to
gzip/bzip2/lzop that can be packaged and shipped by distros, and the
output format defintion.

Yann has some ideas for the format
http://fastcompression.blogspot.cz/2012/04/file-container-format-for-lz4.html

For kernel, the minimum of meta information is total compressed length,
total uncompressed length and chunk size. I don't know if the first two
aren't stored elsewhere in the generic kernel image headers, but chunk
size must be specified.


david
