Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3DWC4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:56:21 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3DWC4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130422165629.bae79e6c5251bf148a3bae73@linux-foundation.org>
References: <5171d93a.0NZAGYYKNj8hjsAs%fengguang.wu@intel.com>
	<20130422165629.bae79e6c5251bf148a3bae73@linux-foundation.org>
Date: Mon, 22 Apr 2013 19:56:19 -0700
X-Google-Sender-Auth: j1k9dBSMX_-N4lIX9QvwTOWFoj0
Message-ID: <CANeU7QmDXRj-rNWvb0qhXCmzyJBFv=1URzzjEZN6ARaAf15-hw@mail.gmail.com>
Subject: Re: [next:akpm 798/1000] drivers/rtc/rtc-ds1286.c:343:24: sparse:
 incorrect type in argument 1 (different address spaces)
From: Christopher Li <sparse@chrisli.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Jingoo Han <jg1.han@samsung.com>, kbuild-all@01.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 4:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I think doing IS_ERR() and PTR_ERR() on __iomem pointers is a natural
> thing, and we should be able to do this without adding call-site
> trickery to make sparse happy.
>
> Is there some sort of annotation which we can add to the
> IS_ERR()/PTR_ERR() definitions so that sparse will stop warning about
> this usage?

Yes, the force attribute should silent the address check on conversion.

Can some one try this patch (totally untested).

Chris


diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..d226a3c 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -26,17 +26,17 @@ static inline void * __must_check ERR_PTR(long error)

 static inline long __must_check PTR_ERR(const void *ptr)
 {
-       return (long) ptr;
+       return (__force long) ptr;
 }

 static inline long __must_check IS_ERR(const void *ptr)
 {
-       return IS_ERR_VALUE((unsigned long)ptr);
+       return IS_ERR_VALUE((__force unsigned long)ptr);
 }

 static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
 {
-       return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+       return !ptr || IS_ERR_VALUE((__force unsigned long)ptr);
 }

 /**
