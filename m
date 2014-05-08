Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaEHO4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:56:45 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49660 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaEHO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH] mpilib: use 'static inline' for mpi-inline.h
Date: Thu,  8 May 2014 16:56:20 +0200
Message-Id: <1399560990-1402858-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5mAD5cyp6eNnt6lN5a4JO4DaCI0vnz09NlbFZhTRSEv
 ageZfEvuw3Cdqmw7/Ck2o4RXE0sXPiv3UAFBImpbAWdwmvW7Rw
 P5L3pakCWdrmknpoXUlpChd9GhZjWW/L8CLIlF0fEStO7ZldSJ
 Qn07ghEliueV+xJf8S5DCoM1mB7e54XH2dGe9/MjAyQtuSpF3+
 WMJCdh0u4TQDwG9e1MlqDRlf+q1dJZXMlli5Iyv0xkqTmzv+Mi
 Z7L3Yte3EqvlGtEaPdcFZXH8jB5yfsjNJPwEKN89URuHOA4rUr
 WKLQU+4BKtesgQAMrLgBQkZJGlxYQkOlJvAw7M8BA1FZJNjAj+
 z90xV/SOPBWJDdG2lW1Yx9H5L/5mO17i86sJ35SVr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four functions of mpilib are defined as 'extern inline' at the
moment, which is generally not the correct way to do inline functions
using gcc.

While this is usually harmless, it shows up as a warning in combination
with the CONFIG_PROFILE_ALL_BRANCHES, resulting in very many lines
like:

/git/arm-soc/lib/mpi/mpi-inline.h:70:182: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]

Using static inline makes the code behave as expected and gets
rid of the warning

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 lib/mpi/mpi-inline.h   | 2 +-
 lib/mpi/mpi-internal.h | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

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
index 60cf765..54c1e97 100644
--- a/lib/mpi/mpi-internal.h
+++ b/lib/mpi/mpi-internal.h
@@ -168,20 +168,12 @@ void mpi_rshift_limbs(MPI a, unsigned int count);
 int mpi_lshift_limbs(MPI a, unsigned int count);
 
 /*-- mpihelp-add.c --*/
-mpi_limb_t mpihelp_add_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
-			 mpi_size_t s1_size, mpi_limb_t s2_limb);
 mpi_limb_t mpihelp_add_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_ptr_t s2_ptr, mpi_size_t size);
-mpi_limb_t mpihelp_add(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
-		       mpi_ptr_t s2_ptr, mpi_size_t s2_size);
 
 /*-- mpihelp-sub.c --*/
-mpi_limb_t mpihelp_sub_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
-			 mpi_size_t s1_size, mpi_limb_t s2_limb);
 mpi_limb_t mpihelp_sub_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_ptr_t s2_ptr, mpi_size_t size);
-mpi_limb_t mpihelp_sub(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
-		       mpi_ptr_t s2_ptr, mpi_size_t s2_size);
 
 /*-- mpihelp-cmp.c --*/
 int mpihelp_cmp(mpi_ptr_t op1_ptr, mpi_ptr_t op2_ptr, mpi_size_t size);
-- 
1.8.3.2

