Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3IMBf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:35:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38545 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3IMBfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:35:55 -0400
Date: Fri, 13 Sep 2013 02:35:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130913013548.GR13318@ZenIV.linux.org.uk>
References: <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
 <20130910222924.GB13318@ZenIV.linux.org.uk>
 <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
 <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
 <20130910225934.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
 <CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
 <CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 06:12:24PM -0700, Linus Torvalds wrote:
> On Thu, Sep 12, 2013 at 5:56 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'll walk through the code, it looked suspicious. Maybe there's
> > something subtle that makes it work, but I don't see it.
> 
> Btw, it's not just the DCACHE_LRU_LIST bit. The games with
> "nr_dentry_unused" look totally broken too. It's decremented in
> dentry_lru_isolate_shrink() for each dentry we remove, and then it is
> decremented *again* in shrink_dcache_sb() by the number of dentries we
> removed.
> 
> Maybe I'm confused, but the code sure looks more confused than I feel.
> 
> I would suggest keeping the same semantics for 'nr_dentry_unused'.
> Dentries are unused whether they are on the "real" LRU list or have
> been tagged with DCACHE_SHRINK_LIST. So moving from one list to the
> other does nothing. It's the "list_del_init()" that should trigger
> both 'nr_dentry_unused' and DCACHE_LRU_LIST bit-clearing.
> 
> In fact, maybe a helper function for _actually_ removing the thing
> from all lists, and adding them back. Right now there are
> "list_del_init()" and "list_add[_tail]()" calls sprinkled around in
> random places, mixed up with the new "list_lru_add()".
> 
> Damn, the code is too confused. I have to go to a highschool parent
> back-to-school meeting, so I won't get to this until maybe on a plane
> tomorrow. Al, can you please give this a look?

Will do...
