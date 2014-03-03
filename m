Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaCCWBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:01:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36148 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaCCWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:01:08 -0500
Date: Mon, 3 Mar 2014 22:01:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303220106.GL18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
 <20140303212642.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 01:52:13PM -0800, Linus Torvalds wrote:
> On Mon, Mar 3, 2014 at 1:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Mon, Mar 03, 2014 at 04:03:59PM -0500, George Spelvin wrote:
> >>
> >> (If you want to use bits, why not use the two lsbits of the file pointer
> >> for the purpose?  That would save a lot of space.)
> >
> > Most of the cases have it kept separately in registers, actually - there's
> > a reason why fdget() and friends are inlined.
> 
> Yes. And bit test and set ops on registers are actually cheaper than
> playing around with bytes.
> 
> That said, the "fget_light()" interface sucks - exactly because it
> doesn't do the "return structure in two registers" thing. We should
> get rid of it - there's just one remaining user in networking code,
> and it should be rewritten in terms of fdget().
> 
> That's a separate issue, though.

The thing is, the callers in there do *not* keep struct file * at all -
they keep struct socket * and use sock->file to get struct file * back
when they need it.

So struct fd is the wrong thing to use there - it only adds to register
pressure.  A similar pair of struct socket * and "need to fput that"
flag would probably be needed, with sockfd_lookup_light() returning
that.
