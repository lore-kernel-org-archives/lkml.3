Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaB0Xvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:51:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57956 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaB0Xva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:51:30 -0500
Date: Thu, 27 Feb 2014 17:48:50 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] typecheck: introduce assign_if() and
 assign_if_enabled()
Message-ID: <20140227234850.GC7308@joshc.qualcomm.com>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
 <1393261707-30565-2-git-send-email-joshc@codeaurora.org>
 <20140227190032.GA4421@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227190032.GA4421@kroah.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:00:32AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Feb 24, 2014 at 11:08:25AM -0600, Josh Cartwright wrote:
> > +/*
> > + * Intended for use in static object initializers,
> > + * assign_if(const_expr, function) evaluates to 'function' if 'const_expr',
> > + * otherwise NULL.
> > + *
> > + * The type of the assign_if() expression is typeof(function), and therefore
> > + * can provide typechecking regardless of 'const_expr'.
> > + *
> > + * gcc considers 'function' to be used and will not generate a 'defined but not
> > + * used' warning when not 'const_expr', however, gcc is smart enough to
> > + * eliminate 'function' if assign_if() is the only reference.
> > + */
> 
> What version of gcc started doing this?  Does llvm also do this?

I'll need to dig up some old gcc's to give this a more thorough
testing; testing with clang 3.4, and it appears to have the same
behavior, at least when I throw a trivial usecase at it.

	$ clang --version
	clang version 3.4 (tags/RELEASE_34/final)
	Target: x86_64-unknown-linux-gnu
	Thread model: posix

	$ cat test.c
	static void foo(void)
	{
		extern void BROKEN(void);
		BROKEN();
	}
	void (*callback)(void) = 0 ? foo : 0;

	$ clang -Wall -Werror -c test.c

	$ size test.o
	   text	   data	    bss	    dec	    hex	filename
	      0	      0	      8	      8	      8	/tmp/test.o

	$ nm test.o
	0000000000000000 B callback

Although, given the feedback on the other patches, assign_if() may
become just be a solution in search of a problem :).

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
