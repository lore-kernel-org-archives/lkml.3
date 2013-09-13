Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3IMUbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:31:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab3IMUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:31:53 -0400
Date: Fri, 13 Sep 2013 21:31:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130913203149.GW13318@ZenIV.linux.org.uk>
References: <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
 <20130910225934.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
 <CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
 <CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
 <CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
 <20130913200000.GT13318@ZenIV.linux.org.uk>
 <CA+55aFxizbVmQE2Y94BRj3kDFdf6hzNHuy-O0qBFw3jnT_mMLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxizbVmQE2Y94BRj3kDFdf6hzNHuy-O0qBFw3jnT_mMLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 04:25:48PM -0400, Linus Torvalds wrote:
> On Fri, Sep 13, 2013 at 4:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> \>
> > It is right - for one thing, we are holding the lock on that LRU list,
> > so list_lru_del() would deadlock right there.  For another, the same
> > list_lru_walk (OK, list_lru_walk_node()) will do ->nr_items decrement
> > when we return LRU_REMOVED to it, so we don't want to do it twice.
> > Plain list_del_init() is correct here.
> 
> Yes. And I found the opposite bug in one place: when we are collecting
> dentries by walking the parents etc, we do *not* hold the global RCU
> lock,

???  LRU list lock, presumably? 

 so we cannot use the "d_lru_shrink_list()" thing after all. It's
> correct as far as the internal logic of fs/dcache.c goes, but it
> violates the global LRU list rules. So I replaced that with a
> dentry_lru_del() followed by a d_shrink_add() instead.
