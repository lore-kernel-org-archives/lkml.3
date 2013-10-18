Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3JRGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:09:28 -0400
Received: from ozlabs.org ([203.10.76.45]:47185 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3JRGJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:09:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Krzysztof Mazur <krzysiek@podlesie.net>, Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
In-Reply-To: <20131014125001.GA6015@shrek.podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net> <1381750442.3247.48.camel@hornet> <20131014125001.GA6015@shrek.podlesie.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 18 Oct 2013 14:20:38 +1030
Message-ID: <87wqlbjkz5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Mazur <krzysiek@podlesie.net> writes:
> On Mon, Oct 14, 2013 at 12:34:02PM +0100, Pawel Moll wrote:
>> So, assuming that it is actually legal to modify static_command_line in
>> __setup()-s (and I must say I have rather mixed feelings about it ;-),
>
> I also have mixed feelings about that, but the parse_args() already
> does that, because some characters are replaced with '\0' to split
> command line into separate strings. The ubd driver does the same
> to split parameter into two strings.

Back when there was almost no parameter parsing support, everyone got
used to keeping pointers into the original.  Making everyone kstrdup()
seems like gratuitous churn which is likely to make more bugs.

Your fix means __setup() gets treated specially, in that only it can
mangle the command line.  That makes sense.  But it introduces another
regression: normal parsing functions can't keep pointers, since that's
now __initdata.

There are two possible solutions:
(1) Audit all __setup to make sure they copy if they want to mangle.
    There are about 750 of them, but many are trivial.
(2) alloc_bootmem() a third commandline for parsing.

Now, many functions of form __setup("XXX=") should be turned into
module_param anyway.

I suggest we do (2) for the moment, and start sweeping through cleaning
up __setup() in the longer term.

Cheers,
Rusty.
