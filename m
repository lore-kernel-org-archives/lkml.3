Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3LJIiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:38:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3LJH7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Horia Geanta <horia.geanta@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.4 02/25] crypto: ccm - Fix handling of zero plaintext when computing mac
Date: Tue, 10 Dec 2013 00:00:10 -0800
Message-Id: <20131210075930.986677658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geanta <horia.geanta@freescale.com>

commit 5638cabf3e4883f38dfb246c30980cebf694fbda upstream.

There are cases when cryptlen can be zero in crypto_ccm_auth():
-encryptiom: input scatterlist length is zero (no plaintext)
-decryption: input scatterlist contains only the mac
plus the condition of having different source and destination buffers
(or else scatterlist length = max(plaintext_len, ciphertext_len)).

These are not handled correctly, leading to crashes like:

root@p4080ds:~/crypto# insmod tcrypt.ko mode=45
------------[ cut here ]------------
kernel BUG at crypto/scatterwalk.c:37!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=8 P4080 DS
Modules linked in: tcrypt(+) crc32c xts xcbc vmac pcbc ecb gcm ghash_generic gf128mul ccm ctr seqiv
CPU: 3 PID: 1082 Comm: cryptomgr_test Not tainted 3.11.0 #14
task: ee12c5b0 ti: eecd0000 task.ti: eecd0000
NIP: c0204d98 LR: f9225848 CTR: c0204d80
REGS: eecd1b70 TRAP: 0700   Not tainted  (3.11.0)
MSR: 00029002 <CE,EE,ME>  CR: 22044022  XER: 20000000

GPR00: f9225c94 eecd1c20 ee12c5b0 eecd1c28 ee879400 ee879400 00000000 ee607464
GPR08: 00000001 00000001 00000000 006b0000 c0204d80 00000000 00000002 c0698e20
GPR16: ee987000 ee895000 fffffff4 ee879500 00000100 eecd1d58 00000001 00000000
GPR24: ee879400 00000020 00000000 00000000 ee5b2800 ee607430 00000004 ee607460
NIP [c0204d98] scatterwalk_start+0x18/0x30
LR [f9225848] get_data_to_compute+0x28/0x2f0 [ccm]
Call Trace:
[eecd1c20] [f9225974] get_data_to_compute+0x154/0x2f0 [ccm] (unreliable)
[eecd1c70] [f9225c94] crypto_ccm_auth+0x184/0x1d0 [ccm]
[eecd1cb0] [f9225d40] crypto_ccm_encrypt+0x60/0x2d0 [ccm]
[eecd1cf0] [c020d77c] __test_aead+0x3ec/0xe20
[eecd1e20] [c020f35c] test_aead+0x6c/0xe0
[eecd1e40] [c020f420] alg_test_aead+0x50/0xd0
[eecd1e60] [c020e5e4] alg_test+0x114/0x2e0
[eecd1ee0] [c020bd1c] cryptomgr_test+0x4c/0x60
[eecd1ef0] [c0047058] kthread+0xa8/0xb0
[eecd1f40] [c000eb0c] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
0f080000 81290024 552807fe 0f080000 5529003a 4bffffb4 90830000 39400000
39000001 8124000c 2f890000 7d28579e <0f090000> 81240008 91230004 4e800020
---[ end trace 6d652dfcd1be37bd ]---

Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/ccm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -271,7 +271,8 @@ static int crypto_ccm_auth(struct aead_r
 	}
 
 	/* compute plaintext into mac */
-	get_data_to_compute(cipher, pctx, plain, cryptlen);
+	if (cryptlen)
+		get_data_to_compute(cipher, pctx, plain, cryptlen);
 
 out:
 	return err;


