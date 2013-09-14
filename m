Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3INDFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 23:05:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3INDFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 23:05:33 -0400
Date: Sat, 14 Sep 2013 04:05:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, joe@perches.com, linux@horizon.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        davem@davemloft.net, eldad@fogrefinery.com, jbeulich@suse.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Message-ID: <20130914030521.GZ13318@ZenIV.linux.org.uk>
References: <20130913195335.18955.qmail@science.horizon.com>
 <1379111268.2066.22.camel@joe-AO722>
 <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
 <201309141149.HGF39054.QLJVHFtMFOSOOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309141149.HGF39054.QLJVHFtMFOSOOF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 11:49:51AM +0900, Tetsuo Handa wrote:

> Even bad code which has never tested failure case, the authors should already
> know that "seq_printf() returns 0 on success case".

It is designed so that not testing failure case is normal approach for the
majority of users.

>   -	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
>   +	seq_puts(s, "DMA engine status\n");
>   +	seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
>    
>   - 	return pos;
>   +	return seq_overflow(s) : -1 : 0;
> 
> for keeping the functionality.

ITYM "for keeping the bug".  Read seq_read(), please.  Any negative value
returned by ->show() is a hard error.  It won't be retried with bigger
buffer; read(2) will *fail*.  With -EINVAL, in your case.

We really, really should not return non-zero on overflow.  Moreover, returning
a _positive_ value (SEQ_SKIP, normally, but any positive will do the same thing)
means "silently discard everything ->show() might have produced"

Again, the normal return value of ->show() is 0 and that includes the case of
overflow.  THE ONLY reason to check for overflow early is when subsequent
output of ->show() takes long to generate and we want to skip that and
have seq_read() do realloc-and-call-show-again immediately.  And in that
case the right fix is often to get saner iterator and stop shoving everything
into a single ->show() call...
