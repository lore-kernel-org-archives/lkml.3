Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3IWEda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:33:30 -0400
Received: from imap.thunk.org ([74.207.234.97]:36253 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3IWEd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:33:29 -0400
Date: Mon, 23 Sep 2013 00:33:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH, RFC 08/12] random: mix in architectural randomness
 earlier in extract_buf()
Message-ID: <20130923043312.GH7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
	dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
	smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
 <1379882338-7209-9-git-send-email-tytso@mit.edu>
 <523FBF8E.3000600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523FBF8E.3000600@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 09:11:58PM -0700, H. Peter Anvin wrote:
> 
> This doesn't mix in across the entire width of the hash (my original
> motivation for putting this at the end was to do it after the hash is
> folded in half -- which is still believe is cryptographically dubious,
> but please don't take my word for it, as I'm not a professional
> cryptographer.)  As such, this change should *probably* have
> EXTRACT_SIZE changed to 2*EXTRACT_SIZE (or simply "20") both in the for
> loop and in the declaration of the union.

Agreed, I'll make the change to "20" instead of EXTRACT_SIZE.

As far as whether or not folding the hash is cryptographically
dubious, we're not using the hash as part of a digital signature,
which is normally where cryptographers get antsy about truncating a
cryptographic hash value (since it effectively halves the length of
the hash, which thanks to the birthday paradox, makes it much easier
to find collisions).

However, in this case, we are reducing the amount of information which
is available to an attacker to infer the state of the pool.  The
"Linux Random Pool Revisited" paper had the following to say about it
in section 4.3:

    "In addition, the folding operation helps in avoiding recognizable
    patterns: the output of the hash function is not directly
    recognizable from the output data.  For an optimal hash function,
    this step would not be necessary and could be replaced by a simple
    truncation."

If they had thought it was cryptographically dubious, they could have
said so --- but they didn't.

It's true that if we know for sure that SHA-1 is a perfect one-way
hash function (which is believed to be true, although there is no
proof of this, and the recent work by Xiaoyun Wang, Yiquin Lisa Yin,
and Hungbo Yu does not lead to any evidence for or against SHA-1's
status as a one-way function), the folding operation wouldn't be
necessary.  But the folding operation shouldn't hurt (except for
reducing the speed of generating random numbers, and it's currently
not a bottleneck), and in the case where it might not be a perfect
one-way function, it could help.

					- Ted
