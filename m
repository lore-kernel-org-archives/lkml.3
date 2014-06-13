Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaFMFF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:05:59 -0400
Received: from ozlabs.org ([103.22.144.67]:33472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaFMFF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:05:57 -0400
Date: Fri, 13 Jun 2014 15:05:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140613150550.7b2e2c4c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//9tE.7nrX3cRPAfk9D_Ce_y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//9tE.7nrX3cRPAfk9D_Ce_y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc ppc6=
4_defconfig)
failed like this:

fs/proc/task_mmu.c: In function 'smaps_pmd':
include/linux/compiler.h:363:38: error: call to '__compiletime_assert_505' =
declared with attribute error: BUILD_BUG failed
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
include/linux/compiler.h:346:4: note: in definition of macro '__compiletime=
_assert'
    prefix ## suffix();    \
    ^
include/linux/compiler.h:363:2: note: in expansion of macro '_compiletime_a=
ssert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^
include/linux/bug.h:50:37: note: in expansion of macro 'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
include/linux/bug.h:84:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
 #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                     ^
include/linux/huge_mm.h:167:27: note: in expansion of macro 'BUILD_BUG'
 #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
                           ^
fs/proc/task_mmu.c:505:39: note: in expansion of macro 'HPAGE_PMD_SIZE'
  smaps_pte((pte_t *)pmd, addr, addr + HPAGE_PMD_SIZE, walk);
                                       ^

Caused by commit b0e08c526179 ("mm/pagewalk: move pmd_trans_huge_lock()
from callbacks to common code").

The reference to HPAGE_PMD_SIZE (which contains a BUILD_BUG() when
CONFIG_TRANSPARENT_HUGEPAGE is not defined) used to be protected by a
call to pmd_trans_huge_lock() (a static inline function that was
contact 0 when CONFIG_TRANSPARENT_HUGEPAGE is not defined) so gcc did
not see the reference and the BUG_ON.  That protection has been
removed ...

I have reverted that commit and commit 2dc554765dd1
("mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkp=
atch-fixes")
that depend on it for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_//9tE.7nrX3cRPAfk9D_Ce_y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmoazAAoJEMDTa8Ir7ZwVmKUP+wdKLyKvb5SWKGktBgL4EHV+
eLIfOazdrKirriEdVBdJ5abd8kMC4slplFyk1I86+z2zTd72OA1r1yJY7X/9yujc
CFNlOZeximBqp0YZiRPlTuDEDE81xc8No365zYIGyXSMvFNPdbkr5AxixOSsB7Ts
ECfWzBal+3dv21Lih3x9eYi7k47QNGi6shKd+NZWWgaZsS5Hd90GDqDr42u9osqV
eoWu71Z8qAISHJIXAk+6GDgl2Z/+Kn/w/uunHWYXHtCwYGjQtK2dzCTnu8OWIhnW
W9lknAaasU8+fj6SvuKxlb3ze/j9Cf4NKmnQ4xTPJiG2n/4W6bGRmOD9HFRsT21d
Mhtthu5HrIEO9EiuaQ9yGCrBmRBd+nyUD6/n8XLo1poTjyVIpz8rysTcSKe01o8p
1mLpyAlB9S9iAdDhKeMZkSKKQe/TaxFbhBzSnhrj+ZxSpc4fAVP697G28i9HkCiz
ep7jrt2Z+mChI20H4yqI/drNNhEdF2Qmel6tcrzXJDadOCCX/GLyUw3dy0VVJq7Y
kri/JUCEGz8AWJLuHERIhTLZ7EOA3wz7NSrcNGhB65CnmdpmzEOqtXa2VyyWF3CU
gAQIEXvUy7FAXSU+tr3N+074WLYBvXUOMtxLSNJ6Q0SfV2Gu5OzbM+XTTwLxBW+9
bH45v5a0Bkb/fZigsz3P
=NLx9
-----END PGP SIGNATURE-----

--Sig_//9tE.7nrX3cRPAfk9D_Ce_y--
