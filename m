Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3EBDhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 23:37:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38893 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3EBDhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 23:37:51 -0400
Date: Thu, 2 May 2013 13:37:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Hogan <james.hogan@imgtec.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix
 handling
Message-Id: <20130502133737.c2874e483bdc1380a59786f4@canb.auug.org.au>
In-Reply-To: <878v3yql7r.fsf@rustcorp.com.au>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
	<878v3yql7r.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_May_2013_13_37_37_+1000_CmVB9giijbn4EUeh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_May_2013_13_37_37_+1000_CmVB9giijbn4EUeh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 02 May 2013 09:58:08 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> James Hogan <james.hogan@imgtec.com> writes:
> > Al's commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate
> > cond_syscall and SYSCALL_ALIAS declarations") broke the build on
> > blackfin and metag due to the following code:
> >
> >   #ifndef SYMBOL_NAME
> >   #ifdef CONFIG_SYMBOL_PREFIX
> >   #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
> >   #else
> >   #define SYMBOL_NAME(x) x
> >   #endif
> >   #endif
> >   #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
> >
> > __stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
> > lines like this in kernel/sys_ni.s:
> >
> >   .weak CONFIG_SYMBOL_PREFIXsys_quotactl
> >   .set CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_sysc=
all
> >
> > The patches in Rusty's modules-next tree such as "CONFIG_SYMBOL_PREFIX:
> > cleanup." clean up the whole mess around symbol prefixes, so this patch
> > just attempts to fix the build in the mean time. The intermediate
> > definition of SYMBOL_NAME above isn't used and is incorrect when
> > CONFIG_SYMBOL_PREFIX is defined as CONFIG_SYMBOL_PREFIX is a quoted
> > string literal, so define __SYMBOL_NAME directly depending on
> > CONFIG_SYMBOL_PREFIX.
>=20
> I just pushed my modules-next tree to Linus, so hopefully the nightmare
> is over soon!

This is the merge fix patch I have been carrying in linux-next since
March 14: (this probably does not quite apply any more but, hey ...)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 14 Mar 2013 17:14:41 +1100
Subject: [PATCH] cond_syscall and SYSCALL_ALIAS merge fixup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/linkage.h | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 829d66c..bedcddf 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -2,7 +2,7 @@
 #define _LINUX_LINKAGE_H
=20
 #include <linux/compiler.h>
-#include <linux/stringify.h>
+#include <linux/export.h>
 #include <asm/linkage.h>
=20
 #ifdef __cplusplus
@@ -15,24 +15,16 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
=20
-#ifndef SYMBOL_NAME
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
-#else
-#define SYMBOL_NAME(x) x
-#endif
-#endif
-#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
-
 #ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
-	"\n\t.set\t" __SYMBOL_NAME(x) "," __SYMBOL_NAME(sys_ni_syscall));
+#define cond_syscall(x) asm(".weak\t" VMLINUX_SYMBOL_STR(x) "\n\t"	\
+			    ".set\t" VMLINUX_SYMBOL_STR(x) ","	\
+			    VMLINUX_SYMBOL_STR(sys_ni_syscall))
 #endif
=20
 #ifndef SYSCALL_ALIAS
 #define SYSCALL_ALIAS(alias, name)				\
-	asm ("\t.globl " __SYMBOL_NAME(alias)			\
-	"\n\t.set\t" __SYMBOL_NAME(alias) "," __SYMBOL_NAME(name))
+	asm ("\t.globl " VMLINUX_SYMBOL_STR(alias)			\
+	"\n\t.set\t" VMLINUX_SYMBOL_STR(alias) "," VMLINUX_SYMBOL_STR(name))
 #endif
=20
 #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_=
SIZE)
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__2_May_2013_13_37_37_+1000_CmVB9giijbn4EUeh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgd+BAAoJEECxmPOUX5FEx+8P/3S5jt+3WPnx4QAxz0Fylx9J
GiX2fxKlgEjzQA+gINJMZItWckxPj+bF0OlUIx8UlxsYH7Hvau33GdmYNrrJ9cji
jBW19ESsSh6Mm5AYx8pGrGLD/mFq0A6sBKbzWNsH4j1ttIBtc9Okx37Hhby9ehqB
cVlDeB/ShrbYvkAmKWMnvqzgDzM6Er1lemy+ZSUv23rv/W9Ly++7styTd2MIYhfi
c2ORR2iPltGWTJ1uhhJxdRYVei8wodDbhFgu0OmMpaDZ6XRF39rXKrx8PO0LGr9D
yI6kg9PC+USlm5GKYQcj3dTZwjisKh6GVN1yGHaThRQmhYXIIXxs6XFQy0H8k1Ld
/9z21tyqj3UkTxWEGiQ0l0YDQR1YK8QZF07Y7XpJFWHEaPlTUP4IrmkLEV7rH+lg
NYa7tfI7bligUhyi9OVq4ztJ0YMB8Oc6m0pur7962ZePEb16C6b+aToXQnsqtPOE
056qWNenY8uXHdqe1Lb14rPOK80X52vQsyiegIpIKmg3qDlk20U9kfYC5VLVVFTC
/R6KwX8mkGn0AFqs5v3H9I/gZTq4l9E6sCf9VTuNpanJXP0aXZb5TIJMiTOg8g2T
5196SSt8KNqcelOB8F1XZbOjGiIDi1wBW2OU328kK3L2GFgBj67ulXtPI30lSg+a
qhHSEMjAQDu5aW6gKRjq
=xCvd
-----END PGP SIGNATURE-----

--Signature=_Thu__2_May_2013_13_37_37_+1000_CmVB9giijbn4EUeh--
