Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaCCX3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:29:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36655 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbaCCX3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:29:00 -0500
Date: Mon, 3 Mar 2014 23:28:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303232858.GO18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
 <20140303212642.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
 <20140303220106.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 02:17:55PM -0800, Linus Torvalds wrote:

> Something like the attached untested patch. This gets rid of
> "fget_light()", and instead makes "fdget()" the native interface (same
> for the "raw" version).

Umm...   I would be very surprised if that worked well.  You have just
forced fdget() to comply to the ABI.  And unless that has such structs
returned in register pairs, there's no way for compiler to do about
that.

The current variant lets the optimizer see what's going on and decide
that since it doesn't need struct fd local variable kept as a single
object, so it can turn it into a pair of locals, independently assigned
(in the inlined fdget() body) and independently used.  If those can
be put into registers, it happens separately for both, etc.

Try your variant on e.g. ppc or alpha.  Both will pass that struct on
stack.  So will mips.  So will s390.  So will 32bit sparc, not that there
had been much use of sparc32 kernels...

It will work on amd64, sparc64.  On i386 we explicitly pass it
-freg-struct-return, so it passes in a pair of registers there as well.

We could start usinmg -freg-struct-return on other architectures, but
I'm not sure if it would actually work - e.g. on ppc it still returns
such a struct on stack.
