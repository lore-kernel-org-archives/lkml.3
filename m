Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaFVTNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 15:13:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56639 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaFVTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 15:12:58 -0400
Date: Sun, 22 Jun 2014 20:12:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Krause <xerofoify@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, akpm@linux-foundation.org,
        fabf@skynet.be, kirill.shutemov@linux.intel.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check for Null return of function of affs_bread in
 function affs_truncate
Message-ID: <20140622191248.GU18016@ZenIV.linux.org.uk>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
 <20140619052128.GV5015@mwanda>
 <CAPDOMVgwT2=iWAHOhgHSBY1B+KoWHQgCdK4idD2miwB=_eMs5Q@mail.gmail.com>
 <alpine.DEB.2.10.1406210143030.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406210143030.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 01:59:15AM +0200, Thomas Gleixner wrote:
> > > The problem is that we don't know if we should return here or break
> > > here.  If you don't understand the code, then it's best to just leave it
> > > alone.
> 
> Dan, what kind of attitude is that?
>
> Nick certainly found an issue where a possible NULL return from
> affs_bread() can cause havoc.

Yes.  No arguments here.

> Do YOU understand that code?
> 
> If yes, you better explain, WHY Nicks finding is a false positive
> instead of just telling him off in a very inpolite way.

It's not a false positive at all.

> If not, you better refrain from telling a reporter that he does not
> understand the code and should stay away.

Tone aside, he does have a point - namely, that patch in question doesn't
contain any analysis of the bug and recovery strategy, turning a bug into
something that is much harder to spot on inspection.

If nothing else, such patches should contain a loud printk added on
the b0rken codepath, along with a big fat warning in the source.

I'm not saying that "fuck off unless you understand the code" is a sane
policy - it's not.  But "anything's better than an oops" is also wrong.

> > > The problem is that we don't know if we should return here or break
> > > here.
> 
> The problem here is that proceeding with a known NULL pointer is wrong
> to begin with. It does not matter at all whether break or return is
> the proper thing to do. What matters is that proceeding with a NULL
> pointer is wrong to begin with, no matter what.
> 
> So either explain why this is a non issue and the NULL pointer return
> cannot happen or shut up and try to find a proper solution for that
> "return" vs. "break" issue.

return vs. break here is the difference between discarding preallocated blocks
and leaking them as well.  The thing is, it's either severe OOM or a corrupted
image.  I'd *probably* go for "affs_error() and return" here, but that's
not the only question - we probably ought to make it return an error, instead
of having it void.  And callers tend to do that affs_free_prealloc(), so
much that I'm not sure if we actually want to keep it in affs_truncate() at
all.
