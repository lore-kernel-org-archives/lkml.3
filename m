Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3DZUzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:55:00 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51254 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3DZUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:54:58 -0400
Date: Fri, 26 Apr 2013 13:54:54 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, James.Bottomley@hansenpartnership.com,
        snitzer@redhat.com
Subject: Re: Bcache v. whatever
Message-ID: <20130426205454.GG9931@google.com>
References: <20130114223202.GV26407@google.com>
 <20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
 <20130426194642.GC9931@google.com>
 <20130426132438.4e48e0688fc3c3c298e71d7e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426132438.4e48e0688fc3c3c298e71d7e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 01:24:38PM -0700, Andrew Morton wrote:
> > As far as I can tell the only real improvement would be to add a %p
> > format string to vsnprintf, but adding a global extension would obviously be
> > inappropriate for this. It'd be really nice to have a mechanism for
> > adding file/module private format strings to vsnprintf, but I haven't
> > cared enough yet to implement it myself.
> > 
> > Of course if you know a better solution I'm all ears.
> > 
> > Uhm, as for the actual bug - that is a fairly ancient gcc, I wasn't
> > aware we were supporting compilers that old but I'm sure you wouldn't be
> > bugging me about it if we weren't...
> 
> Why are those things macros anyway?  urgh, it's because we want to jam
> a string into the caller's stack frame without declaring any of it.

Well, it also _used_ to be the case that if DEBUG and
CONFIG_DYNAMIC_DEBUG weren't defined then pr_debug() was defined as an
empty macro, so btree_to_text() wouldn't be called.

But, I just checked and it's been converted to an empty inline
function, and some of this debug code is called from fast paths where
the overhead really does matter :/ argh

> Really I do think it would be better to do away with the C party tricks
> and have callers do
> 
> 	char btree_buf[BTREE_BUF_SIZE];
> 
> 	btree_to_text(btree_buf, b);
> 	pr_debug("%s\n", btree_buf);
> 
> Nice, simple, explicit, direct and stupid.  It might generate
> unused-var warnings if DEBUG is undefined but from my reading of
> pr_debug() things will be OK.
> 
> Then we can poke around at btree_to_text() until gcc-3.4.5 is happy
> with it.

Well, since pr_debug() isn't an empty macro anymore there goes my main
reason for keeping these macros around.

seems like pr_debug() could still have the no_printk() call inside an
if (0) though...

argh. If there was some way to tell gcc "this function only modifies
this argument so you don't have to call it if the output is never used"
then I'd just convert it to the explicit bufs now. But I really can't
have btree_to_text()/bkey_to_text() getting called in non debug
kernels...

I'm going to mull it over a bit for now, and try and decide what's least
ugly.
