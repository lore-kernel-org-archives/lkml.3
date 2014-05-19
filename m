Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaESA6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:58:33 -0400
Received: from chicago.guarana.org ([192.210.136.102]:51238 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaESA6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:58:32 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 May 2014 20:58:32 EDT
Date: Mon, 19 May 2014 11:51:38 +1000
From: Kevin Easton <kevin@guarana.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Manuel Sch?lling <manuel.schoelling@gmx.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Cleanup string initializations (char[] instead of
 char *)
Message-ID: <20140519015138.GA5639@chicago.guarana.org>
References: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
 <20140517165345.GG18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517165345.GG18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 05:53:45PM +0100, Al Viro wrote:
> On Sat, May 17, 2014 at 05:00:18PM +0200, Manuel Sch?lling wrote:
> > Initializations like 'char *foo = "bar"' will create two variables: a static
> > string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> > will declare a single variable and will end up in shorter
> > assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
> 
> The hell it will.  Compare assembler generated e.g. for 32bit x86 before
> and after.
> 
> >  {
> >  	char *dp;
> >  	char *status = "disabled";
> > -	const char * flags = "flags: ";
> > +	const char flags[] = "flags: ";
> 
> The first variant puts address of constant array into local variable
> (on stack or in a register).  The second one fills local _array_ - the
> string itself goes on stack.

Right - if you're going to do this, you ireally want to make the array
static as well:

	static const char flags[] = "flags: ";

(it's very unlikely that you would want a const array that isn't static).

As Al showed though, usually the optimiser will figure things out on its
own, and the pointer variable in the original variant gets optimised away.
There's also optimisations that apply to string literals but don't apply to
arrays, like string literal merging, which mean that the original could
well still be preferred.

    - Kevin


