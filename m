Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaJBJY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:24:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46836 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBJYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:24:55 -0400
Date: Thu, 2 Oct 2014 02:23:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, hughd@google.com, mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
In-Reply-To: <542C749B.1040103@oracle.com>
Message-ID: <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org> <542C749B.1040103@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Sasha Levin wrote:
> On 10/01/2014 05:07 PM, Andrew Morton wrote:
> > On Mon, 29 Sep 2014 21:47:14 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> > 
> >> Currently we're seeing a few issues which are unexplainable by looking at the
> >> data we see and are most likely caused by a memory corruption caused
> >> elsewhere.
> >>
> >> This is wasting time for folks who are trying to figure out an issue provided
> >> a stack trace that can't really point out the real issue.
> >>
> >> This patch introduces poisoning on struct page, vm_area_struct, and mm_struct,
> >> and places checks in busy paths to catch corruption early.
> >>
> >> This series was tested, and it detects corruption in vm_area_struct. Right now
> >> I'm working on figuring out the source of the corruption, (which is a long
> >> standing bug) using KASan, but the current code is useful as it is.
> > 
> > Is this still useful if/when kasan is in place?
> 
> Yes, the corruption we're seeing happens inside the struct rather than around it.
> kasan doesn't look there.
> 
> When kasan is merged, we could complement this patchset by making kasan trap on
> when the poison is getting written, rather than triggering a BUG in some place
> else after we saw the corruption.
> 
> > It looks fairly cheap - I wonder if it should simply fall under
> > CONFIG_DEBUG_VM rather than the new CONFIG_DEBUG_VM_POISON.
> 
> Config options are cheap as well :)
> 
> I'd rather expand it further and add poison/kasan trapping into other places such
> as the vma interval tree rather than having to keep it "cheap".

I like to run with CONFIG_DEBUG_VM, and would not want this stuff
turned on in my builds (especially not the struct page enlargement);
so I'm certainly with you in preferring a separate option.

But it all seems very ad hoc to me.  Are people going to be adding
more and more mm structures into it, ad infinitum?  And adding
CONFIG_DEBUG_SCHED_POISON one day when someone notices corruption
of a scheduler structure? etc etc.

What does this add on top of slab poisoning?  Some checks in some
mm places while the object is active, I guess: why not base those
on slab poisoning?  And add them in as appropriate to the problem
at hand, when a problem is seen.

I think these patches are fine for investigating whatever is the
problem currently afflicting you and mm under trinity; but we all
have our temporary debugging patches, I don't think all deserve
preservation in everyone else's kernel, that amounts to far more
clutter than any are worth.

I'm glad to hear they've confirmed some vm_area_struct corruption:
any ideas on where that's coming from?

Hugh
