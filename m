Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaFIHf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:35:58 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46335 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaFIHf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:35:56 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2014 03:35:56 EDT
Date: Mon, 9 Jun 2014 09:29:42 +0200
From: Andreas Mohr <andi@lisas.de>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: make nr_requests tunable for loop
Message-ID: <20140609072942.GA30728@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

having had a look at current mainline sources,
frankly I've (well, initially...) got trouble understanding
what this patch is doing.

It's replacing an aggressive error-type bail-out (-EINVAL) for NULL request_fn
with an inoccuous-looking "return ret;", yet that ret content currently
*implicitly* is a >= 0 value (resulting from processing by earlier code
which may or may not get incomprehensibly rewritten in future).
I don't understand the reasons for this huge change in return value handling
(since it's now not assigning a specific return value
for this modified bail-out case).

OK, well... you could say that since all this function ever was
interested in is the result value of queue_var_store()
(except for error bail-out cases), doing an interim "return ret;"
(which is exactly what the function tail is also doing)
is exactly right.

But still simple textual appearance of the resulting patch hunks
seems strangely asymmetric
which may easily be a canary for structurally wrong layering of this function.
Not to mention the now required extra spin_unlock_irq()
in interim return handler...


Well, after further analysis I would come to the conclusion
that in general queue_requests_store() does a LOT more than it should -
since blk-sysfs.c's only (expected!) purpose is
to do parameterization of request_queue behaviour as gathered
from sysfs attribute space,
all that function should ever be concerned with is parsing that sysfs value
and then calling a blk helper for configuration of that very attribute value
which would *internally* do all the strange internal queue magic
that is currently being updated *open-coded*
at this supposedly *sysfs*-specific place. Ugh.
Main question here: what would one do if one decided to rip out sysfs
and use something entirely different for parameterization?
Yeah indeed - thought so...


So yeah, I'd definitely say that that function is lacking some cleanup
which would possibly then even lead (or: would have led ;)
to a much more nicely symmetric textual appearance
of the patch hunk of the small but quite likely useful change
that you currently intend to have here.

Thanks,

Andreas Mohr
