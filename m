Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaEOVIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:08:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56749 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaEOVIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:08:38 -0400
Date: Thu, 15 May 2014 22:07:17 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Message-ID: <20140515220717.1ced0f1a@alan.etchedpixels.co.uk>
In-Reply-To: <9176609.NChAu49t7f@wuerfel>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<8468354.y2kUZdOz9e@wuerfel>
	<1400168823.7862.9.camel@dabdike>
	<9176609.NChAu49t7f@wuerfel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > could do intelligent interpolation about what the epoch is, so in 2039
> > if we get a low 32 bit time_t value, we assume epoch == 1, conversely if
> > we see a high one, we assume epoch == 0.  We could add epoch on the end
> > of the syscalls and detect if it's not present and fill in an
> > interpolated value.  Interfaces which truly want 64 bit time_t would get
> > it from epoch + 32 bit time_t.

True sort of for the kernel (except you've got problems with file system
compatibility and I believe stuff like NFS and that fact some file
systems just break).

> The main advantage that I see with 64-bit time_t is that a lot of user
> space already works with it, because NetBSD and OpenBSD use this, and
> all 64-bit Linux systems already work with this without changing the ABI.
> If we want a POSIX extension to cover a new ABI, this would be the most
> likely candidate.

The main advantage IMHO of just using 64bit on 32bit boxes is getting it
right. I'd go so far as to consider changing userspace time_t to be a
struct. Yes it'll break lots of code but at least you'll know about it.

(and for some other systems like 2BSD it's probably the least of evils
because there isn't a 64bit type in the compiler!)

> As mentioned earlier, between kernel and user space it's probably best
> to avoid time_t and timeval completely and just use timespec64 or some
> other safe type, but there has to be a way to port user space that relies
> on time_t or timespec.

This I think is bang on. We've already got lots of cases where we can't
shoehorn useful info into syscalls due to time_t, including stuff like
exposing accurate stamps in stat(). On an 8MHz 68000 not much happened in
the same second, on a 32 core x86 it's a bit different.

Alan
