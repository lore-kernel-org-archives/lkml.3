Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3DRJuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:50:14 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57995 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3DRJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
Date: Thu, 18 Apr 2013 11:50:08 +0200
X-Google-Sender-Auth: DuYFNBFJbH0IThuD7LhaYQCPt-0
Message-ID: <CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Chanho Min <chanho0207@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:48 AM, Chanho Min <chanho.min@lge.com> wrote:
> +#ifdef __BIG_ENDIAN
> +#define LZ4_NBCOMMONBYTES(val) (__builtin_clzll(val) >> 3)
> +#else
> +#define LZ4_NBCOMMONBYTES(val) (__builtin_ctzll(val) >> 3)
> +#endif
>
>  #else  /* 32-bit */
>  #define STEPSIZE 4
> @@ -83,6 +130,14 @@ typedef struct _U64_S { u64 v; } U64_S;
>         } while (0)
>
>  #define LZ4_SECURECOPY LZ4_WILDCOPY
> +#define HTYPE const u8*
> +
> +#ifdef __BIG_ENDIAN
> +#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
> +#else
> +#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
> +#endif

It seems at least m68k and sparc don't have the __builtin_clz() functions:

m68k-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572593/):

ERROR: "__clzsi2" [lib/lz4/lz4hc_compress.ko] undefined!
ERROR: "__clzsi2" [lib/lz4/lz4_compress.ko] undefined!

sparc64-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572790/):

ERROR: "__clzdi2" [lib/lz4/lz4hc_compress.ko] undefined!
ERROR: "__clzdi2" [lib/lz4/lz4_compress.ko] undefined!

sparc-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572795/):

ERROR: "__clzdi2" [lib/lz4/lz4hc_compress.ko] undefined!
ERROR: "__clzdi2" [lib/lz4/lz4_compress.ko] undefined!

There may be more, hidden by build errors before reaching the link or modpost
phases.

The gmail-whitespace-damaged patch below fixes the m68k and sparc builds
for me, does this look acceptable?

diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
index abcecdc..81d3251 100644
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -107,12 +107,6 @@ typedef struct _U64_S { u64 v; } U64_S;
  } while (0)
 #define HTYPE u32

-#ifdef __BIG_ENDIAN
-#define LZ4_NBCOMMONBYTES(val) (__builtin_clzll(val) >> 3)
-#else
-#define LZ4_NBCOMMONBYTES(val) (__builtin_ctzll(val) >> 3)
-#endif
-
 #else /* 32-bit */
 #define STEPSIZE 4

@@ -132,12 +126,12 @@ typedef struct _U64_S { u64 v; } U64_S;
 #define LZ4_SECURECOPY LZ4_WILDCOPY
 #define HTYPE const u8*

-#ifdef __BIG_ENDIAN
-#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
-#else
-#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
 #endif

+#ifdef __BIG_ENDIAN
+#define LZ4_NBCOMMONBYTES(val) (((STEPSIZE * 8) - 1 - __fls(val)) >> 3)
+#else
+#define LZ4_NBCOMMONBYTES(val) (__ffs(val) >> 3)
 #endif

 #define LZ4_READ_LITTLEENDIAN_16(d, s, p) \

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
