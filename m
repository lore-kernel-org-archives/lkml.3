Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaDYVeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:34:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60211 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaDYVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:34:16 -0400
Date: Fri, 25 Apr 2014 22:34:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Clarification needed on use of put_user inside a loop
Message-ID: <20140425213414.GC18016@ZenIV.linux.org.uk>
References: <535A88D5.3030008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A88D5.3030008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:39:57PM +0530, Kumar Gaurav wrote:

> I have  found some codes in the driver which use put_user() in loop.
> Can we avoid the overhead of checking the same memory area( where
> put_user() writes) again n again using __put_user() in side loop and
> checking permission using access_ok before entering the loop?

>                         if (put_user(type, dst) ||
>                             put_user(chs_bytes, dst + 1))
>                                 return -EFAULT;
>                         dst += 2;
			  ^^^^^^^^^
Note that increment.  It's *not* "the same memory area" next time
around.  Sure, you can check the whole range once before the loop
and switch the stuff inside to __put_user()/__copy_to_user(), but
it's not guaranteed to buy you any speedup.

BTW, you might be a bit confused about the work done by access_ok() - e.g.
on an architectures with separate kernel and userland MMU contexts it might
very well be a no-op (always return true).  It's *not* checking if user has
permissions of some sort.
