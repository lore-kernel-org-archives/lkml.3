Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbaCSOLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:11:20 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33112 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933817AbaCSOLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:11:18 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'behanw@converseincode.com'" <behanw@converseincode.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "pageexec@freemail.hu" <pageexec@freemail.hu>,
        =?utf-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        =?utf-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: RE: [PATCH v3] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
Thread-Topic: [PATCH v3] mac80211: LLVMLinux: Remove VLAIS usage from
 mac80211
Thread-Index: AQHPQyP1BdxfMatc8UinElujgntqEZrocldQ
Date: Wed, 19 Mar 2014 14:09:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E11D1@AcuExch.aculab.com>
References: <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>
 <1395199933-4686-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1395199933-4686-1-git-send-email-behanw@converseincode.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2JEBZj4013671

From: behanw@converseincode.com
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
> 
> struct {
> 	struct aead_request     req;
> 	u8                      priv[crypto_aead_reqsize(tfm)];
> } aead_req;
> 
> This patch instead allocates the appropriate amount of memory using an char
> array.
> 
> The new code can be compiled with both gcc and clang.
> 
> Signed-off-by: Jan-Simon Mller <dl9pf@gmx.de>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Vincius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> ---
>  net/mac80211/aes_ccm.c | 40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
> index 7c7df47..20521f9 100644
> --- a/net/mac80211/aes_ccm.c
> +++ b/net/mac80211/aes_ccm.c
> @@ -23,12 +23,14 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>  			       u8 *data, size_t data_len, u8 *mic)
>  {
>  	struct scatterlist assoc, pt, ct[2];
> -	struct {
> -		struct aead_request	req;
> -		u8			priv[crypto_aead_reqsize(tfm)];
> -	} aead_req;
> 
> -	memset(&aead_req, 0, sizeof(aead_req));
> +	char aead_req_data[sizeof(struct aead_request) +
> +		crypto_aead_reqsize(tfm)]
> +		__aligned(__alignof__(struct aead_request));
> +
> +	struct aead_request *aead_req = (void *) aead_req_data;
> +
> +	memset(aead_req, 0, sizeof(aead_req_data));

It seems to me that the underlying function(s) ought to be changed so that
this isn't needed.
Passing an extra parameter would probably cost very little.

	David
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
