Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaG2JeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:34:01 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:33300
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbaG2Jd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:33:57 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 0/2] Add TLS record layer encryption module
Date: Tue, 29 Jul 2014 12:32:31 +0300
Message-ID: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199002)(189002)(53754006)(50986999)(6806004)(64706001)(106466001)(21056001)(77982001)(97736001)(47776003)(20776003)(80022001)(88136002)(92566001)(50226001)(87936001)(99396002)(4396001)(76482001)(229853001)(92726001)(48376002)(105606002)(84676001)(68736004)(107046002)(83322001)(104166001)(79102001)(74502001)(31966008)(85852003)(102836001)(87286001)(26826002)(62966002)(44976005)(74662001)(50466002)(46102001)(36756003)(95666004)(89996001)(81542001)(77156001)(81342001)(33646002)(85306003)(83072002)(93916002)(104016003)(86362001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0609;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This set of patches introduces support for TLS 1.0 record layer
encryption/decryption with a corresponding algorithm called
tls10(hmac(<hash>),cbc(<cipher>)).

Similarly to authenc.c on which it is based, this module mixes the base
algorithms in software to produce an algorithm that does record layer
encryption and decryption for TLS1.0.
Any combination of hw and sw base algorithms is possible, but the purpose
is to take advantage of hardware acceleration for TLS record layer offloading
when hardware acceleration is present.

This is a software alternative to forthcoming Freescale caam patches that
will add support for one-pass hardware-only TLS record layer offloading.

Performance figures depend largely on several factors including hardware
support and record layer size. For user-space applications the
kernel/user-space interface is also important. That said, we have done several
performance tests using openssl and cryptodev on Freescale QorIQ platforms.
On P4080, for a single stream of records larger than 512 bytes, the performance
improved from about 22Mbytes/s to 64Mbytes/s while also reducing CPU load.

The purpose of this module is to enable TLS kernel offloading on hw platforms
that have acceleration for AES/SHA1 but do not have direct support for TLS
record layer.

(minor dependency on pending patch
  crypto: testmgr.c: white space fix-ups on test_aead)

Cristian Stoica (2):
  crypto: add support for TLS 1.0 record encryption
  crypto: add TLS 1.0 test vectors for AES-CBC-HMAC-SHA1

 crypto/Kconfig           |  20 ++
 crypto/Makefile          |   1 +
 crypto/authenc.c         |   5 +-
 crypto/tcrypt.c          |   5 +
 crypto/testmgr.c         |  41 +++-
 crypto/testmgr.h         | 217 +++++++++++++++++++
 crypto/tls.c             | 528 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/authenc.h |   3 +
 8 files changed, 808 insertions(+), 12 deletions(-)
 create mode 100644 crypto/tls.c

-- 
1.8.3.1

