Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab3GLPsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:48:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36516 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab3GLPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:48:35 -0400
Date: Fri, 12 Jul 2013 16:48:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git part 2
Message-ID: <20130712154833.GA4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
 <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
 <20130712054817.GY4165@ZenIV.linux.org.uk>
 <8738rk9eai.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738rk9eai.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:02:45PM +0000, Rasmus Villemoes wrote:

> But isn't the problem the case where dirname does not exist? I.e., the
> application has to make sure that "/some/where" exists and is a directory
> before open("/some/where", O_CREAT | O_TMPFILE | O_RDWR, 0666) can be
> relied upon to fail on kernels not recognizing O_TMPFILE, instead of
> just creating "where" in "/some".
> 
> Just thinking out loud, and please tell me to shut up if it doesn't make
> sense: The documentation for O_DIRECTORY seems to imply that one could
> require O_DIRECTORY to be given when using O_TMPFILE. The "If pathname
> is not a directory, cause the open to fail" certainly seems to make
> sense when O_TMPFILE is used, and older kernels should complain when
> seeing the O_CREAT|O_DIRECTORY combination. It is a hack, though.

They should, but they won't ;-/  It's the same problem - we do *not*
validate the flags argument.  We'll get to do_last(), hit lookup_open(),
which will create the sucker and go to finish_open_created.  Which is
past the logics checking for LOOKUP_DIRECTORY trying to return a non-directory
and it would've been too late to fail anyway - the file has already been
created.  IOW, O_DIRECTORY is ignored when O_CREAT is present *and* file
didn't exist already.  In that case we almost certainly can treat that as a
bug (i.e. start failing open() on O_CREAT | O_DIRECTORY in all cases -
I'd be _very_ surprised if somebody called open() with such combination of
flags), but that doesn't help with older kernels...
