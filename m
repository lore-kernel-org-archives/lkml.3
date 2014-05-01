Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaEACGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:06:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:43026 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaEACGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:06:38 -0400
Date: Wed, 30 Apr 2014 22:06:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, Kees Cook <kees@outflux.net>
Subject: Re: [PATCH] random: Add "initialized" variable to proc
Message-ID: <20140501020627.GA25248@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org,
	hpa@zytor.com, Kees Cook <kees@outflux.net>
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
 <20140428214112.GC7857@thunk.org>
 <535FE68C.8060002@redhat.com>
 <20140429182610.GA19325@thunk.org>
 <53616293.3080308@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53616293.3080308@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 01:52:35PM -0700, Andy Lutomirski wrote:
> 
> 1. It simply doesn't work on my system.  In particular, it never returns
> entropy.  It just blocks forever.

Why?  Is this a bug in qemu?  The host OS?  The guest OS?  It is qemu
trying to use /dev/random instead of /dev/urandom?  Any thing else?

> 3. There should be a way to provide some entropy-free cryptographically
> secure data, too.  Regardless of the speed of the hosts's /dev/random,
> the guest should start with at least 256 bits of cryptographically
> secure seed material IMO.

Well, the simplest way to do this is to pass it in via the command
line, and then have the the kernel make sure it gets obscured so it's
not exposed via /proc/cmdline.

Otherwise we would have to define an extension where we pass 32 bytes
or so after the boot command line.  But the downside of doing that is
we would have to modify every single architecture to define where
those 32 bytes could be found.

Aside from passing it on the command line as being a bit grotty, the
other big problem this is that some architectures only have 256 bytes
of command line, and if we use a base 64 encoding, 256 bits will take
43 characters.  Not a problem on x86, and it seems rather unlikely
that people would want to virtualize a m68k or avr32 CPU.  It just
feels really unclean.

I've cc'ed Peter Anvin for his opinion about extending Linux boot
parameter protocol.  I agree it would be a lot simpler and easier to
enable things like Kernel ASLR with real randomness on guest OS's if
we didn't have to erect the whole virtio-pci infrastructure during
early boot.  :-)

						 -Ted
