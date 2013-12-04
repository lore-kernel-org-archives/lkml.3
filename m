Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3LDVsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:48:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3LDVsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:48:39 -0500
Date: Wed, 4 Dec 2013 13:48:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of
 empty numa node
Message-Id: <20131204134838.a048880a1db9e9acd14a39e4@linux-foundation.org>
In-Reply-To: <529EF0FB.2050808@linux.vnet.ibm.com>
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org>
	<529EE811.5050306@linux.vnet.ibm.com>
	<20131204004125.a06f7dfc.akpm@linux-foundation.org>
	<529EF0FB.2050808@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013 14:38:11 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> On 12/04/2013 02:11 PM, Andrew Morton wrote:
> > On Wed, 04 Dec 2013 14:00:09 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
> >
> >> Unfaortunately, from my search, I saw that the code belonged to pre git
> >> time, so could not get much information on that.
> >
> > Here: https://lkml.org/lkml/2004/8/20/242
> >
> > It seems it was done as a rather thoughtless performance optimisation.
> > I'd say it's time to reimplement max_sane_readahead() from scratch.
> >
> 
> Ok. Thanks for the link. I think after that,
> Here it was changed to pernode:
> https://lkml.org/lkml/2004/8/21/9 to avoid iteration all over.
> 
> do you think above patch (+comments) with some sanitized nr (thus
> avoiding iteration over nodes in remote numa readahead case) does look
> better?
> or should we iterate all memory.

I dunno, the whole thing smells of arbitrary woolly thinking to me. 
Going back further in time..

: commit f76d03dc9fcff7ac88e2d23c5814fd0f50c59bb6
: Author:     akpm <akpm>
: AuthorDate: Sun Dec 15 03:18:58 2002 +0000
: Commit:     akpm <akpm>
: CommitDate: Sun Dec 15 03:18:58 2002 +0000
: 
:     [PATCH] madvise_willneed() maximum readahead checking
:     
:     madvise_willneed() currently has a very strange check on how much readahead
:     it is prepared to do.
:     
:       It is based on the user's rss limit.  But this is usually enormous, and
:       the user isn't necessarily going to map all that memory at the same time
:       anyway.
:     
:       And the logic is wrong - it is comparing rss (which is in bytes) with
:       `end - start', which is in pages.
:     
:       And it returns -EIO on error, which is not mentioned in the Open Group
:       spec and doesn't make sense.
:     
:     
:     This patch takes it all out and applies the same upper limit as is used in
:     sys_readahead() - half the inactive list.
: 
: +/*
: + * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
: + * sensible upper limit.
: + */
: +unsigned long max_sane_readahead(unsigned long nr)
: +{
: +       unsigned long active;
: +       unsigned long inactive;
: +
: +       get_zone_counts(&active, &inactive);
: +       return min(nr, inactive / 2);
: +}

And one would need to go back further still to understand the rationale
for the sys_readahead() decision and that even predates the BK repo.

iirc the thinking was that we need _some_ limit on readahead size so
the user can't go and do ridiculously large amounts of readahead via
sys_readahead().  But that doesn't make a lot of sense because the user
could do the same thing with plain old read().

So for argument's sake I'm thinking we just kill it altogether and
permit arbitrarily large readahead:

--- a/mm/readahead.c~a
+++ a/mm/readahead.c
@@ -238,13 +238,12 @@ int force_page_cache_readahead(struct ad
 }
 
 /*
- * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
- * sensible upper limit.
+ * max_sane_readahead() is disabled.  It can later be removed altogether, but
+ * let's keep a skeleton in place for now, in case disabling was the wrong call.
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	return nr;
 }
 
 /*

Can anyone see a problem with this?
