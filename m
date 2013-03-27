Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3C0Tu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:50:56 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53054 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3C0Tuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:50:54 -0400
Date: Wed, 27 Mar 2013 12:50:50 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Message-ID: <20130327195050.GB22232@google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
 <20130327182150.GB25906@google.com>
 <51533A2E.2000501@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51533A2E.2000501@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:27:58AM -0700, Randy Dunlap wrote:
> On 03/27/13 11:21, Kent Overstreet wrote:
> > On Wed, Mar 27, 2013 at 06:56:28PM +0100, Geert Uytterhoeven wrote:
> >> m68k/allmodconfig:
> >>
> >> drivers/md/bcache/bset.c: In function ‘bset_search_tree’:
> >> drivers/md/bcache/bset.c:727: error: implicit declaration of function ‘prefetch’
> >>
> >> drivers/md/bcache/btree.c: In function ‘bch_btree_node_get’:
> >> drivers/md/bcache/btree.c:933: error: implicit declaration of function ‘prefetch’
> > 
> > Thanks, applied! The other two I already have a patch queued up for.
> 
> 
> On i386 and x86_64, I also see this build problem:
> 
> drivers/md/bcache/bset.c:885:4: error: implicit declaration of function '__WARN' [-Werror=implicit-function-declaration]
> 
> 
> Do you also have a patch for it?

Nope - looks like __WARN() doesn't exist if CONFIG_BUG=n, whoops.

Adding this to the queue:

commit 796c213186b850b3e6e8d5fd5799b0fd74721ea3
Author: Kent Overstreet <koverstreet@google.com>
Date:   Wed Mar 27 12:47:45 2013 -0700

    bcache: Use WARN_ONCE() instead of __WARN()
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index d4f2164..cb4578a 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -883,7 +883,7 @@ struct bkey *bch_btree_iter_next(struct btree_iter *iter)
 		iter->data->k = bkey_next(iter->data->k);
 
 		if (iter->data->k > iter->data->end) {
-			__WARN();
+			WARN_ONCE(1, "bset was corrupt!\n");
 			iter->data->k = iter->data->end;
 		}
 
