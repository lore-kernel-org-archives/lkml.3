Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbbAZKXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:23:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29202 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbbAZKXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:23:30 -0500
Date: Mon, 26 Jan 2015 13:23:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] slab: update_memcg_params: explicitly check that old
 array != NULL
Message-ID: <20150126101902.GC6507@mwanda>
References: <20150126085638.GA6507@mwanda>
 <1422266479-29098-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422266479-29098-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:01:19PM +0300, Vladimir Davydov wrote:
> This warning is false-positive, because @old equals NULL iff
> @memcg_nr_cache_ids equals 0.

I don't see how it could be a false positive.  The "old" pointer is
dereferenced inside the call to memset() so unless memset is a macro the
compiler isn't going to optimize the dereference away.


//----- test code

void frob(void *p){}

struct foo {
	int *x, *y, *z;
};

int main(void)
{
	struct foo *x = NULL;

	frob(x->y);

	return 0;
}

//---- end


If we compile with gcc test.c then it segfaults.  With -02 the compiler
is able to tell that frob() is an empty function and it doesn't
segfault.  In the kernel code, there is no way for the compiler to
optimize the memset() away so it will Oops.

regards,
dan carpenter

