Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbaGAPNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:13:34 -0400
Received: from mail.eperm.de ([89.247.134.16]:52690 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaGAPNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:13:33 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] DRBG: fix memory corruption for AES192
Date: Tue, 01 Jul 2014 17:08:48 +0200
Message-ID: <3083657.SRQmeelhqi@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <36957559.tbJt1gJF6I@myon.chronox.de>
References: <36957559.tbJt1gJF6I@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the CTR DRBG, the drbg_state->scratchpad temp buffer (i.e. the
memory location immediately before the drbg_state->tfm variable
is the buffer that the BCC function operates on. BCC operates
blockwise. Making the temp buffer drbg_statelen(drbg) in size is
sufficient when the DRBG state length is a multiple of the block
size. For AES192 this is not the case and the length for temp is
insufficient (yes, that also means for such ciphers, the final
output of all BCC rounds are truncated before used to update the
state of the DRBG!!).

The patch enlarges the temp buffer from drbg_statelen to
drbg_statelen + drbg_blocklen to have sufficient space.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 86d483f..c2f02b7 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -441,8 +441,16 @@ static int drbg_ctr_bcc(struct drbg_state *drbg,
  *		length: drbg_blocklen(drbg)
  *	temp
  *		start: iv + drbg_blocklen(drbg)
- *		length: (drbg_keylen(drbg) + drbg_blocklen(drbg) ==
- *				drbg_statelen(drbg))
+ *		length: drbg_satelen(drbg) + drbg_blocklen(drbg)
+ *			note: temp is the buffer that the BCC function 
operates
+ *			on. BCC operates blockwise. drbg_statelen(drbg)
+ *			is sufficient when the DRBG state length is a multiple
+ *			of the block size. For AES192 (and maybe other 
ciphers)
+ *			this is not correct and the length for temp is
+ *			insufficient (yes, that also means for such ciphers,
+ *			the final output of all BCC rounds are truncated).
+ *			Therefore, add drbg_blocklen(drbg) to cover all
+ *			possibilities.
  */
 
 /* Derivation Function for CTR DRBG as defined in 10.4.2 */
@@ -1214,7 +1222,7 @@ static inline int drbg_alloc_state(struct drbg_state 
*drbg)
 			  drbg_statelen(drbg) +	/* df_data */
 			  drbg_blocklen(drbg) +	/* pad */
 			  drbg_blocklen(drbg) +	/* iv */
-			  drbg_statelen(drbg);	/* temp */
+			  drbg_statelen(drbg) + drbg_blocklen(drbg); /* temp 
*/
 	else
 		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg);
 
-- 
1.9.3


