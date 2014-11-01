Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbaKANiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 09:38:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:56233 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758475AbaKANiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 09:38:07 -0400
Date: Sat, 1 Nov 2014 09:38:02 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 3.18
Message-ID: <20141101133802.GA31245@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20141031214949.GA644@thunk.org>
 <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:26:16PM -0700, Linus Torvalds wrote:
> On Fri, Oct 31, 2014 at 2:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Theodore Ts'o (1):
> >       jbd2: use a better hash function for the revoke table
> 
> Does it really make sense to use hash_u64()? It can be quite expensive
> (mainly on 32-bit targets), and since the low bits are where all the
> information is anyway, I'd suggest using hash_32() here even if the
> block number in theory can have a few bits above the 32-bit mark.

Hmm... the problem is that since the block group size is normally
32768 blocks, and most metadata blocks (which is what needs to be
revoked) is located at the beginning of the block groups, if we drop
the high 32-bits, then there would be some hash aliasing going on.

What we could do is use hash_32() unless we have a file system large
enough that it matters, and then if we still wanted to avoid using
hash_u64(), we could do something like this:

	hash_32(__swab32(blk >> 32) | (blk & 0xFFFFFFFF))

That way we get the information from the block group number as well,
and in a way where it doesn't interfere with the information in the
low bits of the block number.

I didn't think hash_64 was *that* slow, so it's not clear the above
would be faster, though.  And if someone is using a > 16TB file system
on a 32-bit platform, I suspect they might be having other problems.  :-)

					- Ted
