Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaCXNVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:21:12 -0400
Received: from kanga.kvack.org ([205.233.56.17]:33223 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaCXNVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:21:09 -0400
Date: Mon, 24 Mar 2014 09:20:58 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        miaox@cn.fujitsu.com, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V2 PATCH 1/2] aio: clean up aio_migratepage() and related code much
Message-ID: <20140324132058.GH4173@kvack.org>
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com> <20140321183509.GC23173@kvack.org> <53301012.7040306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53301012.7040306@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 06:59:30PM +0800, Gu Zheng wrote:
> As the page migration framework holds lock_page() to protect the pages
> (both old and new) while migrating, so while the page migrating, both
> of old page and new page are locked. And the aio context teardown
> routine will call *truncate*(in put_aio_ring_file()) to truncate
> pagecache which needs to acquire page_lock() for each page one by one.
> So there is a native mutual exclusion between *migrate page* v.s. truncate().
> 
> If put_aio_ring_file() is called at first of the context teardown flow
> (aio_free_ring). Then, page migration and ctx freeing will have mutual
> execution guarded by lock_page() v.s. truncate(). Once a page is removed
> from radix-tree, it will not be migrated. On the other hand, the context
> can not be freed while the page migraiton are ongoing.

Sorry, but your change to remove the taking of ->private_lock in 
put_aio_ring_file() is not safe.  If a malicious user reinstantiates 
any pages in the ring buffer's mmaping, there is nothing protecting 
the system against incoherent accesses of ->ring_pages.  One possible 
way of making this occur would be to use mremap() to expand the size 
of the mapping or move it to a different location in the user process' 
address space.  Yes, it's a tiny race, but it's possible.  There is 
absolutely no reason to remove this locking -- ring teardown is 
hardly a performance sensitive code path.  I'm going to stick with my 
approach instead.

		-ben
-- 
"Thought is the essence of where you are now."
