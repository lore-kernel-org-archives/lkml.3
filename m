Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaD3BOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43448 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaD3BOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:14:30 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1398820239-1890-1-git-send-email-behanw@converseincode.com>
References: <1398820239-1890-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] mbcache: LLVMLinux: Remove double calculation from mbcache
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 29 Apr 2014 18:13:29 -0700
To: behanw@converseincode.com, viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>
Message-ID: <a54957c1-4825-4265-8126-4565168fe8c6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suspect this will generate FP instructions on x86 which will corrupt user space state.  This is thus a critical bug!!

On April 29, 2014 6:10:39 PM PDT, behanw@converseincode.com wrote:
>From: Mark Charlebois <charlebm@gmail.com>
>
>The call to __builtin_log2 presumes there is a
>double log2(double x) function defined in the kernel.
>
>The call to hash_log is a call to hash_64 which is
>defined in include/linux/hash.h
>
>static __always_inline u64 hash_64(u64 val, unsigned int bits)
>
>That means that __builtin_log2(NR_BG_LOCKS) is converting
>NR_BG_LOCKS to a double and returning a double and then that
>is converted to an unsigned int.
>
>Using ilog2 is much more appropriate and efficient.
>
>Another side effect of using __builtin_log2 is that is uses
>__aeabi_* functions for ARM that require linking with libgcc.a.
>
>Author: Mark Charlebois <charlebm@gmail.com>
>Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>Signed-off-by: Behan Webster <behanw@converseincode.com>
>---
> fs/mbcache.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/mbcache.c b/fs/mbcache.c
>index bf166e3..2c0752b 100644
>--- a/fs/mbcache.c
>+++ b/fs/mbcache.c
>@@ -93,7 +93,7 @@
> 
> #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
> 
>-#define MB_CACHE_ENTRY_LOCK_BITS	__builtin_log2(NR_BG_LOCKS)
>+#define MB_CACHE_ENTRY_LOCK_BITS	ilog2(NR_BG_LOCKS)
> #define	MB_CACHE_ENTRY_LOCK_INDEX(ce)			\
> 	(hash_long((unsigned long)ce, MB_CACHE_ENTRY_LOCK_BITS))
> 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
