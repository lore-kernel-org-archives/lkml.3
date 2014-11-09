Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaKII6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 03:58:06 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63381 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKII6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 03:58:04 -0500
Message-ID: <545F2C99.4080607@gmail.com>
Date: Sun, 09 Nov 2014 16:58:01 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: dmitry.kasatkin@intel.com
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib: mpi: Use "static inline" instead of "extern inline"
 in header file for __GNUC__
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In header file, "extern inline" may cause multiple definition, so need
change it to "static inline". And also need be quoted  by __GNUC__ for
they are as inline functions only for __GNUC__.

The related error (with allmodconfig under tile):

    LD      lib/mpi/mpi.o
  lib/mpi/generic_mpih-mul1.o: In function `mpihelp_add_1':
  generic_mpih-mul1.c:(.text+0x0): multiple definition of `mpihelp_add_1'
  lib/mpi/generic_mpih-lshift.o:generic_mpih-lshift.c:(.text+0x0): first defined here
  lib/mpi/generic_mpih-mul1.o: In function `mpihelp_add':
  generic_mpih-mul1.c:(.text+0xe8): multiple definition of `mpihelp_add'
  lib/mpi/generic_mpih-lshift.o:generic_mpih-lshift.c:(.text+0xe8): first defined here
  lib/mpi/generic_mpih-mul1.o: In function `mpihelp_sub_1':
  generic_mpih-mul1.c:(.text+0x278): multiple definition of `mpihelp_sub_1'
  lib/mpi/generic_mpih-lshift.o:generic_mpih-lshift.c:(.text+0x278): first defined here
  lib/mpi/generic_mpih-mul1.o: In function `mpihelp_sub':
  generic_mpih-mul1.c:(.text+0x368): multiple definition of `mpihelp_sub'
  lib/mpi/generic_mpih-lshift.o:generic_mpih-lshift.c:(.text+0x368): first defined here
  ...

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 lib/mpi/mpi-inline.h   |  2 +-
 lib/mpi/mpi-internal.h | 12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/lib/mpi/mpi-inline.h b/lib/mpi/mpi-inline.h
index e2b3985..c245ea3 100644
--- a/lib/mpi/mpi-inline.h
+++ b/lib/mpi/mpi-inline.h
@@ -30,7 +30,7 @@
 #define G10_MPI_INLINE_H
 
 #ifndef G10_MPI_INLINE_DECL
-#define G10_MPI_INLINE_DECL  extern inline
+#define G10_MPI_INLINE_DECL  static inline
 #endif
 
 G10_MPI_INLINE_DECL mpi_limb_t
diff --git a/lib/mpi/mpi-internal.h b/lib/mpi/mpi-internal.h
index 60cf765..91ef8ac 100644
--- a/lib/mpi/mpi-internal.h
+++ b/lib/mpi/mpi-internal.h
@@ -168,20 +168,24 @@ void mpi_rshift_limbs(MPI a, unsigned int count);
 int mpi_lshift_limbs(MPI a, unsigned int count);
 
 /*-- mpihelp-add.c --*/
+#ifndef __GNUC__
 mpi_limb_t mpihelp_add_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_size_t s1_size, mpi_limb_t s2_limb);
-mpi_limb_t mpihelp_add_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
-			 mpi_ptr_t s2_ptr, mpi_size_t size);
 mpi_limb_t mpihelp_add(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
 		       mpi_ptr_t s2_ptr, mpi_size_t s2_size);
+#endif
+mpi_limb_t mpihelp_add_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
+			 mpi_ptr_t s2_ptr, mpi_size_t size);
 
 /*-- mpihelp-sub.c --*/
+#ifndef __GNUC__
 mpi_limb_t mpihelp_sub_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_size_t s1_size, mpi_limb_t s2_limb);
-mpi_limb_t mpihelp_sub_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
-			 mpi_ptr_t s2_ptr, mpi_size_t size);
 mpi_limb_t mpihelp_sub(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
 		       mpi_ptr_t s2_ptr, mpi_size_t s2_size);
+#endif
+mpi_limb_t mpihelp_sub_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
+			 mpi_ptr_t s2_ptr, mpi_size_t size);
 
 /*-- mpihelp-cmp.c --*/
 int mpihelp_cmp(mpi_ptr_t op1_ptr, mpi_ptr_t op2_ptr, mpi_size_t size);
-- 
1.9.3
