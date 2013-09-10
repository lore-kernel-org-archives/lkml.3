Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3IJUuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:50:39 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51207 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3IJUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
	<CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
Date: Tue, 10 Sep 2013 13:50:37 -0700
X-Google-Sender-Auth: YAtm0M8p5CL2vLV78Vgdl9R-sVo
Message-ID: <CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Bird <tbird20d@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:40 AM, Tim Bird <tbird20d@gmail.com> wrote:
> How much time does it add to boot to feed the device tree into the
> random number pool.
>
> Some of the device trees are expected to get pretty big.  If it's over
> a millisecond, IMHO, it should be configurable (but this is not).

It's detinitely not a very fast operation. "add_device_randomness()"
does four full "mix_pool_bytes()" operations, and those each iterate
over the input set one byte at a time.

It was kind of designed for things like mixing in ethernet MAC
addresses etc, so at the time that was written, the thinking was that
it would be just a few bytes, maybe tens of bytes.

I don't know how big flattened device trees can be, but I guess we're
talking a couple of kB?

So it might even be a better idea to feed the device tree to a hashing
function (eg SHA1 or even just MD5), and then just mix in the hash. At
least most block hash functions do things a word at a time. It does
*not* need to be cryptographically secure, so MD5 would be plenty good
enough - the only point of the hash would be to give a meaningful
number of result bits from the source array.

Of course, maybe even the stupid add_device_randomness() is fast
enough. I just wanted to point out that it definitely isn't some
optimized thing.

                Linus
