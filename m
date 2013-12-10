Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3LJOq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:46:56 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:27781
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab3LJOqx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:46:53 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz9371I542I4015Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h177df4h8275eh17326ah8275bh8275dh1de097h186068ha1495iz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h1155h)
X-WSS-ID: 0MXLI8V-08-6NB-02
X-M-MSG: 
From: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: [PATCH 3.4 01/25] crypto: scatterwalk - Set the chain pointer
 indication bit
Thread-Topic: [PATCH 3.4 01/25] crypto: scatterwalk - Set the chain pointer
 indication bit
Thread-Index: AQHO9X2/YVDWOCezZE+LI2xCsPt3fJpNgatA
Date: Tue, 10 Dec 2013 14:46:46 +0000
Message-ID: <986457BC66A4884EBFFDEFEBEB20F84C0B1EBBAA@satlexdag04.amd.com>
References: <20131210075930.808460227@linuxfoundation.org>
 <20131210075930.917877325@linuxfoundation.org>
In-Reply-To: <20131210075930.917877325@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch is probably not needed in any of the stable branches, but if
you do add it you'll need to also include a patch that changes the use
of an sg_page to an sg_chain_ptr to prevent a BUG_ON when CONFIG_DEBUG_SG
is enabled (http://marc.info/?l=linux-crypto-vger&m=138627061905651&w=2).

Thanks,
Tom


-----Original Message-----
From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, December 10, 2013 2:00 AM
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman; stable@vger.kernel.org; Lendacky, Thomas; Herbert Xu
Subject: [PATCH 3.4 01/25] crypto: scatterwalk - Set the chain pointer indication bit

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 41da8b5adba77e22584f8b45f9641504fa885308 upstream.

The scatterwalk_crypto_chain function invokes the scatterwalk_sg_chain function to chain two scatterlists, but the chain pointer indication bit is not set.  When the resulting scatterlist is used, for example, by sg_nents to count the number of scatterlist entries, a segfault occurs because sg_nents does not follow the chain pointer to the chained scatterlist.

Update scatterwalk_sg_chain to set the chain pointer indication bit as is done by the sg_chain function.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/crypto/scatterwalk.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -36,6 +36,7 @@ static inline void scatterwalk_sg_chain(  {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
 	sg1[num - 1].page_link &= ~0x02;
+	sg1[num - 1].page_link |= 0x01;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)




