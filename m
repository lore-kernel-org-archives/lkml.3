Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3HZKTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:19:17 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:59918 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3HZKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:19:15 -0400
Subject: Re: [PATCH 02/18] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20130825155309.GA5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-3-git-send-email-jlee@suse.com>
	 <20130825155309.GA5171@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Aug 2013 18:17:49 +0800
Message-ID: <1377512269.27967.29.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, 

First, thanks for your review!

於 日，2013-08-25 於 17:53 +0200，Pavel Machek 提到：
> On Thu 2013-08-22 19:01:41, Lee, Chun-Yi wrote:
> > Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
> > first step of signature generation operation
> > (RSASSA-PKCS1-v1_5-SIGN).
> 
> Is this your own code, or did you copy it from somewhere?
> 

It's my own code, development base on RSA PKCS#1 spec. So the naming of
variables are match with PKCS#1 spec.

> > +	if (!T)
> > +		goto error_T;
> > +
> > +	memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[hash_algo].size);
> > +	memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->digest_size);
> > +
> > +	/* 3) check If emLen < tLen + 11, output "intended encoded message length too short" */
> > +	if (emLen < tLen + 11) {
> > +		ret = EINVAL;
> > +		goto error_emLen;
> > +	}
> 
> Normal kernel calling convention is 0 / -EINVAL.

Yes, here is my mistake, I will modify it.

> 
> > +	memcpy(EM + 2, PS, emLen - tLen - 3);
> > +	EM[2 + emLen - tLen - 3] = 0x00;
> > +	memcpy(EM + 2 + emLen - tLen - 3 + 1, T, tLen);
> 
> ThisDoesNotLookLikeKernelCode, NoCamelCase, please.
> 

Thanks for you point out, I will change it.

> > +	*_EM = EM;
> 
> And we don't usually use _ prefix like this.
> 

Thanks! I will change it.

> 
> > --- a/include/crypto/public_key.h
> > +++ b/include/crypto/public_key.h
> > @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
> >  struct public_key_signature {
> >  	u8 *digest;
> >  	u8 digest_size;			/* Number of bytes in digest */
> > +	u8 *S;				/* signature S of length k octets */
> 
> u8 *signature?

Yes, this 'S' is signature. I put the naming full match with spec for
development, I will change it to match kernel rule. e.g. signature_S

> 
> > +	size_t k;			/* length k of signature S */
> 
> u8 *signature_length.
> 

I will use signature_leng_k to also match with PKCS#1 spec, I think it's
better for review source code with the spec for debugging.


Thanks a lot!
Joey Lee

