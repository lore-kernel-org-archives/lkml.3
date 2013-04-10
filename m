Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936525Ab3DJL1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:27:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33870 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761641Ab3DJL1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:27:53 -0400
Message-ID: <1365593271.27174.35.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Wed, 10 Apr 2013 04:27:51 -0700
In-Reply-To: <20130410093346.GO7511@dm>
References: <1365563834.27174.12.camel@joe-AO722> <20130410093346.GO7511@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 10:33 +0100, Andy Whitcroft wrote:
> On Tue, Apr 09, 2013 at 08:17:14PM -0700, Joe Perches wrote:
> > Comparisons of A to true and false are better written
> > as A and !A.
[]
> In a complex case such as  a + b == false  will this do the right thing?

Very sensible question.  No it won't.

checkpatch doesn't understand expressions
very well nor does it understand precedence
operations between expressions and tests.

I did run it against the kernel tree and there
weren't any I noticed like that though.

> Not that I am sure that adding bools makes sense but assuming there is
> some valid complex lval.

$Lval in this case is a single variable and
is neither a function nor an expression.

It doesn't match on:

	if (func(x, y) == true)
or
	if ((x | y) == true)

because of the ) before the ==

It will falsely match on expressions like:

	if (x + y == true)

but as far as I can tell there aren't any
uses like that in the kernel tree.

$ git grep -E  "(==|\!=)\s*(true|false)\b" | \
  cut -f2- -d":" |grep -P "\b(\+|\-)\b"

nor are there any and/or bit operator.

When I tried adding a test for:

	"$Constant == $Lval"
instead of
	"$Lval == $Constant"

like
	0 == foo
instead of
	foo == 0

there were _way_ too many false positives of
the $Expression sort that I didn't add that test.

cheers, Joe

