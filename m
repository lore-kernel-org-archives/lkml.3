Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaEUEfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:35:21 -0400
Received: from mail.eperm.de ([89.247.134.16]:48371 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaEUEfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:35:19 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com, joe@perches.com
Subject: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Date: Wed, 21 May 2014 06:18:11 +0200
Message-ID: <16102625.1uoi9eJz6k@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following set of patches implements the deterministic random bit generator
(DRBG) specified by SP800-90A.

The DRBG implementation offers the following:

	* All three DRBG types are implemented with a derivation function.
	* All DRBG types are available with and without prediction resistance.
	* All SHA types of SHA-1, SHA-256, SHA-384, SHA-512 are available
	  for the HMAC and Hash DRBGs.
	* All AES types of AES-128, AES-192 and AES-256 are available for the
	  CTR DRBG.
	* A self test is implemented with drbg_healthcheck().
	* The FIPS 140-2 continuous self test is implemented.
	* Additional cipher primitives, such as Serpent or Twofish, can be
	  added to the DRBG without changing the implementation. The only
	  change necessary is to the DRBG definition given in the cores[]
	  array.

As defined in SP800-131A, the ANSI X9.31 DRNG is to be sunset by the end of
this year for official uses, including FIPS 140-2 compliance.

Additional tests including the CAVS test framework are available at [1].

[1] http://www.chronox.de/drbg.html

Stephan Mueller (6):
  SP800-90A Deterministic Random Bit Generator
  header file for DRBG
  DRBG kernel configuration options
  compile the DRBG code
  DRBG testmgr test vectors
  Add DRBG test code to testmgr

 crypto/Kconfig        |   36 +-
 crypto/Makefile       |    1 +
 crypto/drbg.c         | 2005 
+++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c      |  248 +++++++
 crypto/testmgr.h      |  843 +++++++++++++++++++++
 include/crypto/drbg.h |  291 +++++++
 6 files changed, 3442 insertions(+), 1 deletion(-)
 create mode 100644 crypto/drbg.c
 create mode 100644 include/crypto/drbg.h

Changes v2:

 * Overhauling code structure for simpler code as suggested by Rafael
   Aquini:
     - each DRBG type exports only two crypto functions,
     - the individual DRBG implementations structure closely according
       to
       SP 800-90A,
     - using struct drbg_string to refer to buffers to avoid too many
       function parameters and prevent multiple data structure
       conversions
     - use inline more thoroughly
     - replace macros with small inline functions
     - remove unnecessary indirections
     - replace of large stack variables with a scratch buffer allocated
       at
       the beginning of DRBG operation -- see comments about scratchpad
       throughout the code
 * Revamping DRBG flags usage: flags are only intended to select the
   appropriate DRBG type and DRBG strength. Flags are not intended to be
   visible to external callers.
 * Adding comments throughout the code to refer to the appropriate steps
   documented in SP 800-90A.
 * Fix invocation of kernel crypto API hash
 * Fix coding style and apply scripts/checkpatch.pl
 * Change locking approach: only very small code sections are guarded by
   a lock. This implies that the entire DRBG operates on a shadow copy
   of the original DRBG state -- see comments for drbg_copy_drbg
 * Perform thorough testing:
   - Performing of a full scale CAVS test with CAVS interface available
     at http://www.chronox.de/drbg.html
   - Performing tests by obtaining data which is not a multiple of
     cipher block size and check it with the ent tool to ensure that the
     generation loop does not reuse stale buffers to avoid errors like
     CVE-2013-4345.

Changes v3:

 * fix invocation of drbg_sec_strength to determine the amount of seed
   needed for the DRBG. The function returns information as a byte
   value, but the invoker assumed a bit value.
 * change default value returned by drbg_sec_strength to be the maximum
   entropy defined by SP800-90A to catch erroneous invocations of the 
function.
 * Fix invocaction of d_ops in drbg_generate: drbg->d_ops ==>
   shadow->d_ops
 * Make return of drbg_fips_continuous_test cleaner as suggested by
   Clemens Ladisch
 * Fix comments on how to invoke the DRBG at the beginning of the file
   drbg_ctr_df: replace the for loop for calculation of padlen that used
   to call up to 16 modulo operations with one modulo operation
 * drbg_ctr_df: replace plain integer values with sizeof() to make code
   clearer
 * drbg_hash_hashgen: replace memset() on drbg->scratchpad with memset()
   on src/dst pointers to make code clearer
 * as recommended by Peter Waltenberg: add re-invocation of self tests
   as required by 11.3.3 -- the tests are commented out because they make
   no mathematical sense. However, if a FIPS 140-2 validation requires
   these tests, the code just needs to be activated.
 * as recommended by Peter Waltenberg: add error path tests as required
   by 11.3.2 -- see new function of drbg_healthcheck_sanity
 * add debug printk
 * perform testing in FIPS 140-2 mode
 * as recommended by Peter Waltenberg: add drbg_generate_long to
   generate arbitrary long strings

Changes v4:
 * change return codes of generate functions to signed int to convey
   error codes and to match the kernel crypto API expecations on the
   generate function.
 * add BUG_ON throughout drbg_healthcheck_sanity() since any failure
   should be caught to prevent the DRBG from operating
 * change layout of debugging printk

Changes v5:
 * make numerous character buffer pointers and drbg_string pointers
   const as suggested by Joe Perches

Changes v6:
 * change name of array cores to drbg_cores as suggested by Joe Perches
 * make drbg_cores static as suggested by Joe Perches
 * catch programming error regarding array overflow in drbg_algs
   gracefully

Changes v7:
 * editorial changes: cleanup comments and make them KNF-conformant as
   requested by Rafael Aquini
 * rebase patch to 3.15-rc5

-- 
1.9.0

