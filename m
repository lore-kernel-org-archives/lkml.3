Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaENWg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:36:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35017 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaENWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:36:53 -0400
Date: Wed, 14 May 2014 15:35:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tony Battersby <tonyb@cybernetics.com>
cc: Hugh Dickins <hughd@google.com>, David Herrmann <dh.herrmann@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Kristian Hogsberg <krh@bitplanet.net>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v2 0/3] File Sealing & memfd_create()
In-Reply-To: <537396A2.9090609@cybernetics.com>
Message-ID: <alpine.LSU.2.11.1405141456420.2268@eggly.anvils>
References: <1397587118-1214-1-git-send-email-dh.herrmann@gmail.com> <alpine.LSU.2.11.1405132118330.4401@eggly.anvils> <537396A2.9090609@cybernetics.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Tony Battersby wrote:
> Hugh Dickins wrote:
> > Checking page counts in a GB file prior to sealing does not appeal at
> > all: we'd be lucky ever to find them all accounted for.
> 
> Here is a refinement of that idea: during a seal operation, iterate over
> all the pages in the file and check their refcounts.  On any page that
> has an unexpected extra reference, allocate a new page, copy the data
> over to the new page, and then replace the page having the extra
> reference with the newly-allocated page in the file.  That way you still
> get zero-copy on pages that don't have extra references, and you don't
> have to fail the seal operation if some of the pages are still being
> referenced by something else.

That does seem a more promising idea than any that I'd had: thank you.

But whether it can actually be made to work (safely) is not yet clear
to me.

It would be rather like page migration; but whereas page migration
backs off whenever the page count cannot be fully accounted for
(as does KSM), that is precisely when this would have to act.

Taking action in the case of ignorance does not make me feel very
comfortable.  Page lock and radix tree lock would guard against
many surprises, but not necessarily all.

> 
> The downside of course is the extra memory usage and memcpy overhead if
> something is holding extra references to the pages.  So whether this is
> a good approach depends on:
> 
> *) Whether extra page references would happen frequently or infrequently
> under various kernel configurations and usage scenarios.  I don't know
> enough about the mm system to answer this myself.
> 
> *) Whether or not the extra memory usage and memcpy overhead could be
> considered a DoS attack vector by someone who has found a way to add
> extra references to the pages intentionally.

I may just be too naive on such issues, but neither of those worries
me particularly.  If something can already add an extra pin to many
pages, that is already a concern for memory usage.  The sealing case
would double its scale, but I don't see that as a new issue.

The aspect which really worries me is this: the maintenance burden.
This approach would add some peculiar new code, introducing a rare
special case: which we might get right today, but will very easily
forget tomorrow when making some other changes to mm.  If we compile
a list of danger areas in mm, this would surely belong on that list.

Hugh
