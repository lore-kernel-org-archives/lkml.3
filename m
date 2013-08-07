Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3HGAwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:52:09 -0400
Received: from kanga.kvack.org ([205.233.56.17]:55157 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3HGAwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:52:08 -0400
Date: Tue, 6 Aug 2013 20:52:04 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>, axboe@kernel.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-aio@kvack.org, trinity@vger.kernel.org
Subject: Re: [PATCH aio-next] aio: fix error handling and rcu usage in "convert the ioctx list to table lookup v3"
Message-ID: <20130807005204.GF8043@kvack.org>
References: <51FFAF34.20200@oracle.com> <20130805160828.GH31864@kvack.org> <20130805172032.GI31864@kvack.org> <5201714C.8000100@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201714C.8000100@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:57:32PM -0400, Sasha Levin wrote:
> Old error is gone, but now seeing this, which seems related.
> 
>         ctx = table->table[id];
>         if (ctx->user_id == ctx_id) { <--- here
>                 percpu_ref_get(&ctx->users);
>                 ret = ctx;
>         }
...

Why am I not surprised.  That should be fixed with the patch below.  I'll 
post some patches for the libaio test suite tomorrow to check these cases 
explicitly and scan for any others that need to be added.  Thanks again, 
Sasha.

		-ben
-- 
"Thought is the essence of where you are now."

diff --git a/fs/aio.c b/fs/aio.c
index 3bc068c..c3f005d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -812,7 +812,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 		goto out;
 
 	ctx = table->table[id];
-	if (ctx->user_id == ctx_id) {
+	if (ctx && ctx->user_id == ctx_id) {
 		percpu_ref_get(&ctx->users);
 		ret = ctx;
 	}
