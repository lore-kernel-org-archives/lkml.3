Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3DWGVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:21:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28470 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3DWGVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:21:15 -0400
Date: Tue, 23 Apr 2013 09:16:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        Jingoo Han <jg1.han@samsung.com>, kbuild-all@01.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [next:akpm 798/1000] drivers/rtc/rtc-ds1286.c:343:24: sparse:
 incorrect type in argument 1 (different address spaces)
Message-ID: <20130423061600.GN6638@mwanda>
References: <5171d93a.0NZAGYYKNj8hjsAs%fengguang.wu@intel.com>
 <20130422165629.bae79e6c5251bf148a3bae73@linux-foundation.org>
 <CANeU7QmDXRj-rNWvb0qhXCmzyJBFv=1URzzjEZN6ARaAf15-hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeU7QmDXRj-rNWvb0qhXCmzyJBFv=1URzzjEZN6ARaAf15-hw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 07:56:19PM -0700, Christopher Li wrote:
> On Mon, Apr 22, 2013 at 4:56 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > I think doing IS_ERR() and PTR_ERR() on __iomem pointers is a natural
> > thing, and we should be able to do this without adding call-site
> > trickery to make sparse happy.
> >
> > Is there some sort of annotation which we can add to the
> > IS_ERR()/PTR_ERR() definitions so that sparse will stop warning about
> > this usage?
> 
> Yes, the force attribute should silent the address check on conversion.
> 
> Can some one try this patch (totally untested).
> 

That didn't work.  It's the the void * in the parameter list that's
the problem.  We'd need to do something like the patch below:

Otherwise we could add "__ok_to_cast" thing to Sparse maybe?

regards,
dan carpenter

diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..2cbe8fb 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -24,20 +24,23 @@ static inline void * __must_check ERR_PTR(long error)
 	return (void *) error;
 }
 
-static inline long __must_check PTR_ERR(const void *ptr)
+static inline long __must_check _PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
 }
+#define PTR_ERR(x) _PTR_ERR((const void __force *)(x))
 
-static inline long __must_check IS_ERR(const void *ptr)
+static inline long __must_check _IS_ERR(const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
+#define IS_ERR(x) _IS_ERR((const void __force *)(x))
 
-static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
+static inline long __must_check _IS_ERR_OR_NULL(const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
+#define IS_ERR_OR_NULL(x) _IS_ERR_OR_NULL((const void __force *)(x))
 
 /**
  * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
@@ -46,19 +49,21 @@ static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(const void *ptr)
+static inline void * __must_check _ERR_CAST(const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
 }
+#define ERR_CAST(x) _ERR_CAST((const void __force *)(x))
 
-static inline int __must_check PTR_RET(const void *ptr)
+static inline int __must_check _PTR_RET(const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 	else
 		return 0;
 }
+#define PTR_RET(x) _PTR_RET((const void __force *)(x))
 
 #endif
 
