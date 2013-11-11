Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab3KKAnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 19:43:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40958 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3KKAnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 19:43:11 -0500
Date: Mon, 11 Nov 2013 00:43:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shahbaz Youssefi <shabbyx@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Partially Privileged Applications
Message-ID: <20131111004309.GU13318@ZenIV.linux.org.uk>
References: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 04:03:36PM +0100, Shahbaz Youssefi wrote:
> Dear all,
> 
> First, please CC replies to myself. Second, this is an RFC.
> 
> I've been tampering with an idea for some time now and I've done some
> research. Finally, I wrote it down here (a terrible place as it turned
> out):
> 
> http://shahbaz-youssefi.blogspot.it/2013/11/partially-privileged-applications.html
> 
> and would like to know what you think.

That it's javashit-infested and bloody hard to read without the damn thing,
for starters...

You *can't* allow userland to call an arbitrary kernel function with
arbitrary arguments.  Consider e.g. a syscall that validates the
arguments and, if they are OK, calls a function that sends given
signal to given process.  Allow to call that function directly and
you've got a nice, shiny roothole.  The same goes for anything that
modifies kernel data structures - you either have to keep validating the
arguments again and again on each function call (which will cost *much*
more than what we currently have and will depend on being unable to
call the address other than the entry point and skip the validation) or
you lose all protection of kernel data structures, with obvious nasty
results.  And that is not to mention the lovely issues with stack
switching (you really don't want to see what happens if stack page
gets swapped out under you in the kernel), the fun with being able to
call a function without locks it expects grabbed by callers, etc.

You can define a bunch of "safe to call" addresses.  You will have to
do stack switching, arguments validation, etc. on each of them and it
won't be any prettier than what we do on syscall entry.  That's what
the call gates are; it had been tried, the machinery is still there
on x86 and nobody sane uses it for a lot of very good reasons.

Again, flat "allow function call to any address with any arguments and
any stack pointer value" is a non-starter - you have shared data structures
to deal with, quite a few of those being security sensitive and the thing
you seem to be suggesting will fuck up immediately under such conditions.
