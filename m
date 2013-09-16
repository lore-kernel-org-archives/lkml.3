Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3IPIUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:20:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36533 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3IPIUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:20:14 -0400
MIME-Version: 1.0
In-Reply-To: <87ioy11k8s.fsf@rustcorp.com.au>
References: <87ioy11k8s.fsf@rustcorp.com.au>
Date: Mon, 16 Sep 2013 10:20:13 +0200
X-Google-Sender-Auth: _IzDheY1W2mb2-jcv01jr0ABOc8
Message-ID: <CAMuHMdWRVGW5xKoY7bE8XRCxuZxr4hQkHah=3PrvDAUH_FnPxw@mail.gmail.com>
Subject: Re: Why does test_bit() take a volatile addr?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 6:08 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Predates git, does anyone remember the rationale?
>
> ie:
>         int test_bit(int nr, const volatile unsigned long *addr)

That's why we have full-history-linux ;-)

Unfortunately it doesn't show the rationale, as this change also predates
bitkeeper.

Since 2.1.30, volatile is used unconditionally:

commit 84d59b7dda1092a22663f4e2da77a6ce581b539e
Author: linus1 <torvalds@linuxfoundation.org>
Date:   Mon Mar 10 12:00:00 1997 -0600

    Import 2.1.30

 #ifdef __SMP__
 #define LOCK_PREFIX "lock ; "
-#define SMPVOL volatile
 #else
 #define LOCK_PREFIX ""
-#define SMPVOL
 #endif

 /*
  * This routine doesn't need to be atomic.
  */
-extern __inline__ int test_bit(int nr, const SMPVOL void * addr)
+extern __inline__ int __constant_test_bit(int nr, const volatile void * addr)
 {
-       return ((1UL << (nr & 31)) & (((const unsigned int *) addr)[nr >> 5])) !
+       return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr
 }

+extern __inline__ int __test_bit(int nr, volatile void * addr)
+{
+       int oldbit;
+
+       __asm__ __volatile__(
+               "btl %2,%1\n\tsbbl %0,%0"
+               :"=r" (oldbit)
+               :"m" (ADDR),"ir" (nr));
+       return oldbit;
+}
+
+#define test_bit(nr,addr) \
+(__builtin_constant_p(nr) ? \
+ __constant_test_bit((nr),(addr)) : \
+ __test_bit((nr),(addr)))
+
 /*


Between 1.3.75 and 2.1.30, volatile was used on SMP only:

commit 08c5b9d698e6ca2233aec0f7d7f0fdd6eb3ad235
Author: linus1 <torvalds@linuxfoundation.org>
Date:   Thu Mar 7 12:00:00 1996 -0600

    Import 1.3.75


 #ifdef __SMP__
 #define LOCK_PREFIX "lock ; "
+#define SMPVOL volatile
 #else
 #define LOCK_PREFIX ""
+#define SMPVOL
 #endif


 /*
  * This routine doesn't need to be atomic.
  */
-extern __inline__ int test_bit(int nr, const void * addr)
+extern __inline__ int test_bit(int nr, const SMPVOL void * addr)
 {
        return 1UL & (((const unsigned int *) addr)[nr >> 5] >> (nr & 31));
 }


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
