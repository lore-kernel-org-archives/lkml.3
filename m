Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbbAMJfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:35:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbbAMJft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:35:49 -0500
Date: Tue, 13 Jan 2015 11:35:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 22/40] tile: fix put_user sparse errors
Message-ID: <20150113093535.GA4434@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-23-git-send-email-mst@redhat.com>
 <54B44326.6010501@ezchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B44326.6010501@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:56:54PM -0500, Chris Metcalf wrote:
> Nack for this patch as-is.
> 
> On 1/6/2015 10:44 AM, Michael S. Tsirkin wrote:
> >virtio wants to write bitwise types to userspace using put_user.
> >At the moment this triggers sparse errors, since the value is passed
> >through an integer.
> >
> >For example:
> >
> >	__le32 __user *p;
> >	__le32 x;
> >	put_user(x, p);
> >
> >is safe, but currently triggers a sparse warning on tile.
> >
> >The reason has to do with this code:
> >	__typeof((x)-(x))
> >which seems to be a way to force check for an integer type.
> 
> No, it's purely a way to avoid
> 
>   warning: cast from pointer to integer of different size
> 
> at every place we invoke put_user() with a pointer - which is
> in fact pretty frequent throughout the kernel.
>
>  The idiom of
> casting to the difference of the type converts it to a type
> of the same size as the input (whether integral or pointer),
> but guaranteed to be an integral type.  Then from there it's safe
> to cast it on to a u64 without generating a warning.

Thanks for the comments.  OK, I see, though I wonder why didn't
kbuild notify me about new warnings. Doesn't it build tile?

So if you want to merge your patch, please let me know.

But I think the fix can be much simpler: unsigned long has the same property
without any of the complexity, or problems with sparse.  So how about this:

--->

tile: fix put_user sparse errors

virtio wants to write bitwise types to userspace using put_user.
At the moment this triggers sparse errors, since the value is passed
through an integer.

For example:

__le32 __user *p;
__le32 x;
put_user(x, p);

is safe, but currently triggers a sparse warning on tile.

The reason has to do with this code:
__typeof((x)-(x))
which is a way to avoid cast from pointer to integer of different size
warnings.

Fix that up using __force unsigned long cast instead:
this is similar to what many other architectures do.

Note: this does not suppress any useful sparse checks since
the original merely casted x to typeof(x-x).

Tile currently does not trigger sparse warnings when get_user
causes an illegal assignment across bitwise types.
This patch does not attempt to fix this.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---->

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index b6cde32..9fcbe6f 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -246,7 +246,7 @@ extern int __get_user_bad(void)
 #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
 #define __put_user_8(x, ptr, ret)					\
 	({								\
-		u64 __x = (__typeof((x)-(x)))(x);			\
+		u64 __x = (u64)(__force unsigned long)(x);		\
 		int __lo = (int) __x, __hi = (int) (__x >> 32);		\
 		asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"	\
 			     "2: { sw %0, %3; movei %0, 0 }\n"		\





