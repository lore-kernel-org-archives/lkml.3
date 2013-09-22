Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3IVVlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:41:03 -0400
Received: from imap.thunk.org ([74.207.234.97]:36070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab3IVVlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:41:02 -0400
Date: Sun, 22 Sep 2013 17:40:39 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH, RFC 10/12] random: cap the rate which the /dev/urandom
 pool gets reseeded
Message-ID: <20130922214039.GC7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
	dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
	smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
 <1379882338-7209-11-git-send-email-tytso@mit.edu>
 <e665f20c-9154-4dbd-bb93-cf144922bf29@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e665f20c-9154-4dbd-bb93-cf144922bf29@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 02:21:48PM -0700, H. Peter Anvin wrote:
> Is this really an improvement on a system with plenty of entropy? Would it not make more sense to modulate this bad on entropy production rates?
> 
> Also, the urandom pool is only reseeded once per read, no matter how large...

I added this after observing using the random driver's tracepoints to
measure how the entropy pool behaves on a desktop system.  It turns
outs the Chrome browser requests a truly amazing amount of entropy
using /dev/urandom.  Enough so that while you are reading GMail or
using G+, the available entropy in the input pool is always running at
minimum levels.  (i.e., it never gets above 192 bits before we do a
catatrophic reseed and it drops down to 128 bits.)

I'm not sure what the heck it is doing --- maybe it is using
/dev/urandom to generate random padding values?  I can't believe it is
opening new SSL connetions that quickly.  So this might be a Chrome
bug, and I can talk to some Chrome developers when I get into work
tomorrow.  But in the case of badly behaved applications, this is
useful.

It results in more entropy building up in the input pool before we do
a reseed, so it should result in better "catastrophic reseeding", and
it means that there is more entropy available in the input pool for
use by the /dev/random pool, even if /dev/urandom is being used in
what might be arguably considered an abusive fashion.

You can test this by applying the patch, and observing the value of
/proc/sys/kernel/random/entropy_avail over time while running a Chrome
browser (and there may be other userspace applications which are as
aggressive in the use of /dev/urandom).  The compare it after running
the command "echo 0 > /proc/sys/kernel/random/urandom_min_reseed_secs",
which will restore the original pre-patch behaviour.

						- Ted
