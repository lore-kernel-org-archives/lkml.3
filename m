Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3JNJrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:47:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64960 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3JNJri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:47:38 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-c2-525bbdb827b5
Message-id: <1381744054.24685.35.camel@AMDC1943>
Subject: Re: [PATCH] swap: fix set_blocksize race during swapon/swapoff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Weijie Yang <weijie.yang.kh@gmail.com>, Bob Liu <bob.liu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>
Date: Mon, 14 Oct 2013 11:47:34 +0200
In-reply-to: <20131011120226.1f4bb32569f370b57b841e79@linux-foundation.org>
References: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
 <20131011120226.1f4bb32569f370b57b841e79@linux-foundation.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7o79kYHGUx+rWExZ/0aNouuU1NZ
	LJ5+6mOxWLb4KaPF5V1z2CzurfnParHs63t2i1PLOSyenPjP4sDp8aTpJ7PHzll32T0WbCr1
	2LSqk81j06dJ7B4nZvxm8fj49BaLx+dNcgEcUVw2Kak5mWWpRfp2CVwZz28+ZC9oFKxo/P+R
	vYFxMW8XIyeHhICJxOIjG5ggbDGJC/fWs3UxcnEICSxllDjR+pMdwvnMKNGwbzY7SBWvgIHE
	saPnwGxhAXeJvb0vWEFsNgFjic3Ll7CB2CICuhKrnu9iBmlmFpjKJLHuwyKwBhYBVYlPs/vB
	1nEKeEu0NNxkhNjQwSjxfO52FpAEs4C6xKR5i5ghblKS2N3eyQ4Rl5fYvOYtM8QVghI/Jt9j
	mcAoMAtJyywkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERIZX3cwLj1mdYhR
	gINRiYdXwCk6SIg1say4MvcQowQHs5IIr+A8oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGw6dE
	10XaRFZ9Xz5zv2JVPNPl80Kqx40+vlZ+cG1ZQtuT2hNRJgv41/1bunTtAda71haXEx0Z2E6d
	2uSt0PlvKY9wkW/rj+LbxhvO6jNMFlrG0x2cI3V1bsN/e0tup77wXt3HLKpyV1ZPMLJhaHVb
	bugdYFLLGPI6jN1BMyv1YTKXqE7LvCIlluKMREMt5qLiRACc3/CeagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 12:02 -0700, Andrew Morton wrote:
> (cc Hugh)
> 
> On Fri, 11 Oct 2013 11:54:22 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> 
> > Swapoff used old_block_size from swap_info which could be overwritten by
> > concurrent swapon.
> > 
> > Reported-by: Weijie Yang <weijie.yang.kh@gmail.com>
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  mm/swapfile.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 3963fc2..de7c904 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1824,6 +1824,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >  	struct filename *pathname;
> >  	int i, type, prev;
> >  	int err;
> > +	unsigned int old_block_size;
> >  
> >  	if (!capable(CAP_SYS_ADMIN))
> >  		return -EPERM;
> > @@ -1914,6 +1915,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >  	}
> >  
> >  	swap_file = p->swap_file;
> > +	old_block_size = p->old_block_size;
> >  	p->swap_file = NULL;
> >  	p->max = 0;
> >  	swap_map = p->swap_map;
> > @@ -1938,7 +1940,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >  	inode = mapping->host;
> >  	if (S_ISBLK(inode->i_mode)) {
> >  		struct block_device *bdev = I_BDEV(inode);
> > -		set_blocksize(bdev, p->old_block_size);
> > +		set_blocksize(bdev, old_block_size);
> >  		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
> >  	} else {
> >  		mutex_lock(&inode->i_mutex);
> 
> I find it worrying that a swapon can run concurrently with any of this
> swapoff code.  It just seem to be asking for trouble and the code
> really isn't set up for this and races here will be poorly tested for
> 
> I'm wondering if we should just extend swapon_mutex a lot and eliminate
> the concurrency?

It seems there are even more races here between swapoff & swapon (and
swapon with swapon). Simple script:
	for i in `seq 1000`
	do
		swapoff -a &
		swapon -a &
	done
causes frequent switches of block size of devices (jumping from 512 to 4096).


Best regards,
Krzysztof



