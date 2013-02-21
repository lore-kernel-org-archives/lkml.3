Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3BUQgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:36:11 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49286 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3BUQgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:36:10 -0500
Date: Thu, 21 Feb 2013 11:36:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Louis Huemiller <lhuemill@google.com>
Subject: Re: [PATCH] fs: Preserve error code in get_empty_filp()
Message-ID: <20130221163605.GA13379@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Anatol Pomozov <anatol.pomozov@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Louis Huemiller <lhuemill@google.com>
References: <1347505915-27984-1-git-send-email-anatol.pomozov@gmail.com>
 <CAOMFOmWEifGsiq3t93FL6xjPDy1Y0OTJ+h+mek0Q=cn_sb+j2w@mail.gmail.com>
 <20130215022134.GA11376@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215022134.GA11376@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > A little bit of context for this change. We at Google work on a test
> > framework that shows how kernel behaves under memory pressure. In the
> > codepath that I am fixing the syscalls return ENFILE error, but in
> > fact the correct error would be ENOMEM. get_empty_filp() should
> > preserve the original error and not to replace all errors with ENFILE.
> 
> The trouble is, you are introducing previously impossible return values
> for pipe(2).  The rest of it is probably OK (even though I'd prefer to
> split get_empty_filp() part into a separate commit), but this one has
> potential for breaking previously correct userland code.  OTOH, FreeBSD has
> done that a while ago and they apparently had been able to cope with the
> fallout.

Sure, but Posix/SUSv3 has always said that system calls can return
error values that aren't listed in the standard (or the man page).
Given that most applications check for an error, and then use the
errno to log an error which a human can interpret, it would seem to me
to be better to return ENOMEM rather than to return the clearly wrong
ENFILE; after all, we could potentially have only a handful of file
descriptors open at the time when pipe(2) fails due to lack of memory,
and the error code:

       ENFILE The system limit on the total number of open files has
              been reached.

is clearly wrong.

Are you aware of any applications that would blow up if pipe(2)
returned any possible error other than ENFILE?

						- Ted
