Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbaELVQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:16:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaELVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:16:44 -0400
Date: Mon, 12 May 2014 14:16:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in
 __compiletime_assert()
Message-Id: <20140512141642.5eb526deed5ea32ad5bced72@linux-foundation.org>
In-Reply-To: <5370CFAC.40705@imgtec.com>
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
	<5370CFAC.40705@imgtec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 14:42:04 +0100 James Hogan <james.hogan@imgtec.com> wrote:

> > --- a/include/linux/compiler.h
> > +++ b/include/linux/compiler.h
> > @@ -324,11 +324,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
> >  
> >  #define __compiletime_assert(condition, msg, prefix, suffix)		\
> >  	do {								\
> > -		bool __cond = !(condition);				\
> >  		extern void prefix ## suffix(void) __compiletime_error(msg); \
> > -		if (__cond)						\
> > +		if (!(condition))					\
> >  			prefix ## suffix();				\
> > -		__compiletime_error_fallback(__cond);			\
> > +		__compiletime_error_fallback(!(condition));		\
> >  	} while (0)
> >  
> >  #define _compiletime_assert(condition, msg, prefix, suffix) \
> > 
> 
> Unfortunately this breaks the build of today's linux-next for the Meta
> architecture (arch/metag), which happens to use a fairly old compiler
> (based on gcc 4.2.4) which I presume is the reason why.
> 
> A bunch of compile time asserts fail, even in code which should be
> optimised out. E.g. here's one which I analysed:
> 
> mm/gup.c: In function ___follow_page_mask___:
> mm/gup.c:208: error: size of array ___type name___ is negative
> 
> Line 208 uses HPAGE_PMD_NR which expands to a HPAGE_PMD_SHIFT, which
> expands to a BUILD_BUG(). However that line is inside an if block
> conditioned on pmd_trans_huge(*pmd) which include/asm-generic/pgtable.h
> defines inline to return 0, so the whole block should already be being
> optimised out.
> 
> I don't understand why your patch should break things, I suspect it's
> related to the sparse behaviour you're trying to work around, but can we
> please drop this patch until a more portable workaround can be found?

Older gcc's often have this problem.

I suppose that build bustage is more serious than sparse false
positives so yes, let's please try to find an alternative.

