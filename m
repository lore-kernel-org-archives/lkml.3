Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaC0Pho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:37:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46147 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaC0Phn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:37:43 -0400
Date: Thu, 27 Mar 2014 08:36:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Subject: Re: mm: BUG: Bad page state in process ksmd
In-Reply-To: <5333492D.2030300@oracle.com>
Message-ID: <alpine.LSU.2.11.1403270821450.4269@eggly.anvils>
References: <5332EE97.4050604@oracle.com> <20140326125525.4e8090096f647f654eb7329d@linux-foundation.org> <5333492D.2030300@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, Sasha Levin wrote:
> On 03/26/2014 03:55 PM, Andrew Morton wrote:
> > On Wed, 26 Mar 2014 11:13:27 -0400 Sasha Levin <sasha.levin@oracle.com>
> > wrote:
> > > Out of curiosity, is there a reason not to do bad flag checks when
> > > actually
> > > setting flag? Obviously it'll be slower but it'll be easier catching these
> > > issues.
> > 
> > Tricky.  Each code site must determine what are and are not valid page
> > states depending upon the current context.  The one place where we've
> > made that effort is at the point where a page is returned to the free
> > page pool.  Any other sites would require similar amounts of effort and
> > each one would be different from all the others.
> > 
> > We do this in a small way all over the place, against individual page
> > flags.  grep PageLocked */*.c.
> 
> What if we define generic page types and group page flags under them?
> It would be easier to put these checks in key sites around the code
> and no need to fully customize them to each site.
> 
> For exmaple, swap_readpage() is doing this:
> 
>         VM_BUG_ON_PAGE(!PageLocked(page), page);
>         VM_BUG_ON_PAGE(PageUptodate(page), page);
> 
> But what if instead of that we'd do:
> 
> 	VM_BUG_ON_PAGE(!PageSwap(page), page);
> 
> Where PageSwap would test "not locked", "uptodate", and in addition
> a set of "sanity" flags which it didn't make sense to test individually
> everywhere (PageError()? PageReclaim()?).
> 
> I can add the infrastructure if that sounds good (and people promise to
> work with me on defining page types). I'd be happy to do all the testing
> involved in getting this to work right.

Sorry, I don't understand how you see that as a good idea.  I wonder
if you have cleverly put that suggestion into the thread, to push me
into a more timely response to the BUG than you usually get ?-)

It seems a bad idea to me in at least three ways: expending more
developer time on establishing what set of page flags to test at
each site; expending more developer time on fixing all the false
positives that would result; and spoiling the greppability of the
source tree by hiding flag checks in obscure combinations.

Page flags are separate flags because they are largely
independent.

Developers have inserted the VM_BUG_ONs they think are needed,
please leave them at that.  There may be a good case for removing
some of the older ones that have served their purpose (we rather
overused PageLocked checks in 2.4 for example), but not for
putting effort into adding more to what's there.

Hugh
