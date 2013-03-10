Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3CJWKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:10:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35973 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3CJWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:10:52 -0400
Date: Sun, 10 Mar 2013 22:10:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130310221047.GA21522@ZenIV.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 10:30:01AM -0800, Linus Torvalds wrote:

> I must be missing something, and I wonder if the thing I'm missing is
> that with OPEN_PATH we may now have open calls that don't actually
> have FMODE_READ or FMODE_WRITE set at all.

With OPEN_PATH we don't call ->open() (or anything in the driver, for that
matter) at all.  I really don't see how that could trigger...

> So suddenly we end up with these pipe openers that don't update the
> counts, and I could imagine that really confusing us...
> 
> So I'm wondering if you could apply this patch, and see if that
> triggers. In fact, please un-apply the other changes to fs/pipe.c too,
> to see if it also obviates the need for checking i_pipe for NULL. You
> should get the new warning (once), but you should not get any oopses..
> 
> Anyway, this would explain why the actual read/write paths don't need
> to check for i_pipe - if FMODE_READ/WRITE aren't set, we'll never get
> that far. But the release() and the fasync functions do get called
> even for non-readable and non-writable files...
> 
> And Al, please get your email fixed. Is somebody usually on irc with
> him or something?

Back and looking through all that fun...
