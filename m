Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3EQSaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:30:06 -0400
Received: from kanga.kvack.org ([205.233.56.17]:57907 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab3EQSaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:30:04 -0400
Date: Fri, 17 May 2013 14:30:03 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zab@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, jmoyer@redhat.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [WiP]: aio support for migrating pages (Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable())
Message-ID: <20130517183003.GL1008@kvack.org>
References: <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <5191B5B3.7080406@cn.fujitsu.com> <20130515132453.GB11497@suse.de> <5194748A.5070700@cn.fujitsu.com> <20130517002349.GI1008@kvack.org> <20130517181708.GG318@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517181708.GG318@lenny.home.zabbo.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 11:17:08AM -0700, Zach Brown wrote:
> > I ended up working on this a bit today, and managed to cobble together 
> > something that somewhat works -- please see the patch below.
> 
> Just some quick observations:
> 
> > +	ctx->ctx_file = anon_inode_getfile("[aio]", &aio_ctx_fops, ctx, O_RDWR);
> > +	if (IS_ERR(ctx->ctx_file)) {
> > +		ctx->ctx_file = NULL;
> > +		return -EAGAIN;
> > +	}
> 
> It's too bad that aio contexts will now be accounted against the filp
> limits (get_empty_filp -> files_stat.max_files, etc). 

Yeah, that is a downside of this approach.  It would be possible to to 
do it with only an inode/address_space, but that would mean bypassing 
do_mmap(), which is not worth considering.  If it is really an issue, we 
could add a flag to bypass that limit since aio has its own.  
anon_inode_getfile() as it stands is a major problem.

> > +	for (i=0; i<nr_pages; i++) {
> > +		struct page *page;
> > +		void *ptr;
> > +		page = find_or_create_page(ctx->ctx_file->f_inode->i_mapping,
> > +					   i, GFP_KERNEL);
> > +		if (!page) {
> > +			break;
> > +		}
> > +		ptr = kmap(page);
> > +		clear_page(ptr);
> > +		kunmap(page);
> > +		SetPageUptodate(page);
> > +		SetPageDirty(page);
> > +		unlock_page(page);
> > +	}
> 
> If they're GFP_KERNEL then you don't need to kmap them.  But we probably
> want to allocate with GFP_HIGHUSER and then use clear_user_highpage() to
> zero them?

Adding __GFP_ZERO would fix that too. The next respin will include that 
change.  I also have to properly handle the mremap() case as well.

		-ben
-- 
"Thought is the essence of where you are now."
