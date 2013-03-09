Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3CIWeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 17:34:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38302 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3CIWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 17:34:20 -0500
Date: Sun, 10 Mar 2013 01:34:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Suggestion for fixing the variable length array used in the
 kernel.
Message-ID: <20130309223403.GZ9138@mwanda>
References: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
 <20130308162922.88ad40997d01099949008452@linux-foundation.org>
 <20130309053859.GY9138@mwanda>
 <CANeU7QnhB566ZJqjcaLkn7o701EeVbJcB=8VHW_33nwK=FZRhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeU7QnhB566ZJqjcaLkn7o701EeVbJcB=8VHW_33nwK=FZRhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 10:10:08AM -0800, Christopher Li wrote:
> On Fri, Mar 8, 2013 at 9:39 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Fri, Mar 08, 2013 at 04:29:22PM -0800, Andrew Morton wrote:
> >> Roughly how many instances of this are there kernel-wide?
> >>
> >
> > Around 150 on x86 allmodconfig.  They are pretty well audited.
> 
> I saw 207 on x86-64 allmodconfig. See the list that I attached.
> 

Ah.  Sorry, I'm on my laptop and my sparse output was old.

> Can you elaborate the well audited part? How it was audited?
> 

The problems is if we go over the 8k stack.  So big arrays are bad.
Also if the dynamically sized array is inside a loop then normally
GCC frees it after each iteration, but on some arches it didn't free
it until after the last iteration.

Btw, I've Smatch has cross function analysis, and I'd like to use
it here to figure out if the max size for dynamically sized arrays.
I ran into a problem:

The code looks like this:
	char buf[a];
The size expression should be an EXPR_SYMBOL, but smatch gets:
	char buf[*a];
Where the size expression is an EXPR_PREOP.

In smatch, how I use sparse is that I call sparse_keep_tokens() and
then I parse the resulting symbol list myself.  The problem is in
examine_array_type() we call get_expression_value() which changes
the symbols from normal symbols to dereferences. The call tree is:
examine_array_type()
  -> get_expression_value()
     -> __get_expression_value()
        -> evaluate_expression()
	   -> evaluate_symbol_expression() <- change happens here.

I'm not sure what to do.

regards,
dan carpenter

