Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3LDOyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:54:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab3LDOye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:54:34 -0500
Date: Wed, 4 Dec 2013 09:54:16 -0500
From: Dave Jones <davej@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Benjamin <bcrl@kvack.org>, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kent <kmo@daterainc.com>,
        Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: Re: [PATCH] aio: clean up aio ring in the fail path
Message-ID: <20131204145416.GA22438@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Gu Zheng <guz.fnst@cn.fujitsu.com>, Benjamin <bcrl@kvack.org>,
	linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Kent <kmo@daterainc.com>,
	Kristian Nielsen <knielsen@knielsen-hq.org>
References: <529F019A.2040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529F019A.2040401@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:19:06PM +0800, Gu Zheng wrote:
 > Clean up the aio ring file in the fail path of aio_setup_ring
 > and ioctx_alloc. And maybe it can fix the GPF issue reported by
 > Dave Jones:
 > https://lkml.org/lkml/2013/11/25/898
 > 
 > 
 > Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
 > ---
 >  fs/aio.c |    8 ++++++--
 >  1 files changed, 6 insertions(+), 2 deletions(-)
 > 
 > diff --git a/fs/aio.c b/fs/aio.c
 > index 08159ed..6efb7f6 100644
 > --- a/fs/aio.c
 > +++ b/fs/aio.c
 > @@ -367,8 +367,10 @@ static int aio_setup_ring(struct kioctx *ctx)
 >  	if (nr_pages > AIO_RING_PAGES) {
 >  		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
 >  					  GFP_KERNEL);
 > -		if (!ctx->ring_pages)
 > +		if (!ctx->ring_pages) {
 > +			put_aio_ring_file(ctx);
 >  			return -ENOMEM;
 > +		}
 >  	}
 >  

  CC      fs/aio.o
fs/aio.c: In function ‘aio_setup_ring’:
fs/aio.c:363:4: error: implicit declaration of function ‘put_aio_ring_file’ [-Werror=implicit-function-declaration]
    put_aio_ring_file(ctx);


Is this dependant on another patch ?

	Dave

