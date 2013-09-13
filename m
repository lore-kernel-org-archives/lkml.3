Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3IMFge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:36:34 -0400
Received: from mail.eperm.de ([89.247.134.16]:39199 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3IMFgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:36:32 -0400
From: Stephan Mueller <smueller@chronox.de>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: John Stultz <john.stultz@linaro.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Fri, 13 Sep 2013 07:36:20 +0200
Message-ID: <1974157.PE35U8AyTG@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130912213148.GE3809@logfs.org>
References: <10005394.BRCyBMYWy3@tauon> <522F984C.2070909@linaro.org> <20130912213148.GE3809@logfs.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. September 2013, 17:31:48 schrieb Jörn Engel:

Hi Jörn,

>On Tue, 10 September 2013 15:08:12 -0700, John Stultz wrote:
>> Though
>> I probably should be hesitant with my suggestions, as I'm not well
>> versed in RNG theory.
>
>The basic principle of Ted's RNG is very simple and quite sane:
>- You collect as much data as possible, some of which is (hopefully)
>  unpredictable.
>- All the data gets dumped into a small buffer.
>- When reading from the buffer, you create a crypto-hash of the entire
>  buffer.  Even if most of the buffer is predictable, the few
>  unpredictable bits will randomly flip every output bit.

And here the RNG theory breaks: a whitening function (crypto function) 
like the used SHA1 does not add entropy. Thus, the SHA1 just spreads out 
the entropy evenly over the output buffer. As entropy can be considered 
as a kind of percentage value, if you have, say, 10% of your input 
buffer holding entropy, applying a whitening function, you output buffer 
still holds 10% of entropy only.

That said, simply using a whitening function on a buffer with poor 
entropy is NOT going to cut it.

>- Half of the hash gets returned to the reader, the other half gets
>  added back into the pool.
>
>It doesn't matter if you collect predictable data - it neither helps

Oh yes, it hurts, if you update the entropy estimator on those 
predictable bits. Because then you get a deterministic RNG like 
/dev/urandom in the worst case. Thus you degrade the quality of 
/dev/random which relies on the blocking nature.

>nor hurts.  But you should collect as much unpredictable data as
>possible and do it as cheaply as possible.  If you want to improve the
>RNG, you either collect more data, collect better (less predictable)
>data or make the collection cheaper.
>
>Jörn
>
>--
>People really ought to be forced to read their code aloud over the
>phone. That would rapidly improve the choice of identifiers.
>-- Al Viro


Ciao
Stephan
