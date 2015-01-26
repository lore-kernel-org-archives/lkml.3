Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbbAZKpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:45:51 -0500
Received: from mx2.parallels.com ([199.115.105.18]:52998 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbbAZKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:45:46 -0500
Date: Mon, 26 Jan 2015 13:45:34 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] slab: update_memcg_params: explicitly check that old
 array != NULL
Message-ID: <20150126104534.GA28978@esperanza>
References: <20150126085638.GA6507@mwanda>
 <1422266479-29098-1-git-send-email-vdavydov@parallels.com>
 <20150126101902.GC6507@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150126101902.GC6507@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:23:05PM +0300, Dan Carpenter wrote:
> On Mon, Jan 26, 2015 at 01:01:19PM +0300, Vladimir Davydov wrote:
> > This warning is false-positive, because @old equals NULL iff
> > @memcg_nr_cache_ids equals 0.
> 
> I don't see how it could be a false positive.  The "old" pointer is
> dereferenced inside the call to memset() so unless memset is a macro the
> compiler isn't going to optimize the dereference away.

old->entries is not dereferenced: memcg_cache_array->entries is not a
pointer - it is embedded to the memcg_cache_array struct.

> 
> 
> //----- test code
> 
> void frob(void *p){}
> 
> struct foo {
> 	int *x, *y, *z;
> };
> 
> int main(void)
> {
> 	struct foo *x = NULL;
> 
> 	frob(x->y);
> 
> 	return 0;
> }
> 
> //---- end
> 
> 
> If we compile with gcc test.c then it segfaults.  With -02 the compiler
> is able to tell that frob() is an empty function and it doesn't
> segfault.  In the kernel code, there is no way for the compiler to
> optimize the memset() away so it will Oops.

Just change

- 	int *x, *y, *z;
+	int *x, *z;
+	int *y[0];

and it won't.

Thanks,
Vladimir
