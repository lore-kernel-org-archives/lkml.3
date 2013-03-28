Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3C1NQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:16:27 -0400
Received: from mail.ultra-3eti.com ([173.13.207.162]:36437 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3C1NQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:16:25 -0400
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 09:16:25 EDT
X-ASG-Debug-ID: 1364475917-054299727d370b20001-xx1T2L
X-Barracuda-Envelope-From: Chaoxing.Lin@ultra-3eti.com
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
X-Barracuda-Apparent-Source-IP: ::1
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: Crypto Fixes for 3.9
Thread-Topic: Crypto Fixes for 3.9
X-ASG-Orig-Subj: RE: Crypto Fixes for 3.9
Thread-Index: AQHOK45Upp2OMmbgjUKuA1uh6F7keJi7Eevw
Date: Thu, 28 Mar 2013 13:05:16 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C59259@RockMX01.rock.corp>
References: <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
In-Reply-To: <20130328082841.GA7425@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.101]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: rockmx01.rock.corp[192.168.200.4]
X-Barracuda-Start-Time: 1364475917
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://192.168.200.200:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.34
X-Barracuda-Spam-Status: No, SCORE=0.34 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=CN_BODY_332, SH_BIG5_05413_BODY_104
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.126482
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.21 SH_BIG5_05413_BODY_104 BODY: Body: contain "UNSUBSCRIBE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you be able to incorporate the GMAC ESN bug fix in 3.9?

Thanks,

Chaoxing


--------------------------------
Thanks Jussi, the patch fixes the problem.

You may commit it officially.

Chaoxing

-----Original Message-----
From: Jussi Kivilinna [mailto:jussi.kivilinna@iki.fi]
Sent: Tuesday, March 26, 2013 4:16 PM
To: Chaoxing Lin
Cc: linux-crypto@vger.kernel.org
Subject: Re: potential bug in GMAC implementation. not work in ESN mode

On 25.03.2013 18:12, Chaoxing Lin wrote:
> 2nd ping....
> 
> Nobody is maintaining crypto/gcm.c?
> 
> 
> 
> -----Original Message-----
> From: Chaoxing Lin
> Sent: Friday, March 08, 2013 11:38 AM
> To: 'linux-crypto@vger.kernel.org'
> Subject: potential bug in GMAC implementation. not work in ESN mode
> 
> I was testing ipsec with GMAC and found that the rfc4543 GMAC implementation in kernel software crypto work in "esp=aes256gmac-noesn!" mode.
> It does not work in in "esp=aes256gmac-esn!" mode. The tunnel was established but no data traffic is possible.
> 
> Looking at source code, I found this piece of code is suspicious.
> Line 1146~1147 tries to put req->assoc to assoc[1]. But I think this way only works when req->assoc has only one segment. In ESN mode, req->assoc contains 3 segments (SPI, SN-hi, SN-low). Line 1146~1147 will only attach SPI segment(with total length) in assoc.
> 
> Please let me know whether I understand it right.

Your analysis seems correct. Does attached the patch fix the problem? (I've only compile tested it.)

-Jussi

> Thanks,
> 
> Chaoxing
> 
> 
> Source from kernel 3.8.2
> path: root/crypto/gcm.c
> 
> 1136: /* construct the aad */
> 1137:	dstp = sg_page(dst);
> 	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
> 
> 	sg_init_table(payload, 2);
> 	sg_set_buf(payload, req->iv, 8);
> 	scatterwalk_crypto_chain(payload, dst, vdst == req->iv + 8, 2);
> 	assoclen += 8 + req->cryptlen - (enc ? 0 : authsize);
> 
> 	sg_init_table(assoc, 2);
> 1146:	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
> 1147:		    req->assoc->offset);
> 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
> 
> 	aead_request_set_tfm(subreq, ctx->child);
> 	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
> 				  req->base.data);
> 	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv);
> 1154:	aead_request_set_assoc(subreq, assoc, assoclen);
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-crypto" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Thursday, March 28, 2013 4:29 AM
To: Linus Torvalds; David S. Miller; Linux Kernel Mailing List; Linux Crypto Mailing List
Subject: Crypto Fixes for 3.9

Hi Linus:

This push removes IPsec ESN support from the talitos/caam drivers since they were implemented incorrectly, causing interoperability problems if ESN is used with them.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Horia Geanta (2):
      Revert "crypto: talitos - add IPsec ESN support"
      Revert "crypto: caam - add IPsec ESN support"

 drivers/crypto/caam/caamalg.c |   27 ++-------------------------
 drivers/crypto/caam/compat.h  |    1 -
 drivers/crypto/talitos.c      |   30 ++----------------------------
 3 files changed, 4 insertions(+), 54 deletions(-)

Thanks,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
