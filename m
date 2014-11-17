Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKQPkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:40:47 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61357 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaKQPkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:40:45 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-42-546a16fa4fe7
Message-id: <546A16F8.4000604@samsung.com>
Date: Mon, 17 Nov 2014 18:40:40 +0300
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.2.0
MIME-version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>, Michal Marek <mmarek@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] scripts/coccinelle: catch freeing cryptographic
 structures via kfree
References: <20141117151420.10739.16342.stgit@buzz>
 <alpine.DEB.2.10.1411171628230.2532@hadrien>
In-reply-to: <alpine.DEB.2.10.1411171628230.2532@hadrien>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7q/xLJCDBZcYbaYc76FxeL/thZ2
	i9k/LzFZdL+SsVj24DSjxe7TX5ks7t/7yWRxedccNouWfReYLI69XM7kwOWxZeVNJo9tB1Q9
	jh1rZfbYuyXLY/OSeo8zC46we3zeJOcx5VA7SwBHFJdNSmpOZllqkb5dAldG0+4NTAWPhCom
	fp7O2MA4i7+LkZNDQsBE4sLtaewQtpjEhXvr2boYuTiEBJYySuzccpoRwvnEKPH1SgdrFyMH
	B6+AlsTPRjOQBhYBVYlJ2/6CNbMJmEls23ebEcQWFQiRmPP0NhOIzSsgKPFj8j0WkFYRAXWJ
	3g+5IGFmgZNMEleOCIPYwgLxEvO3HgYrFxJIklh94RcLiM0pYClx9eBNVoh6W4kF79exQNjy
	EpvXvGWewCgwC8mGWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJC6+7GBc
	fMzqEKMAB6MSD68AS1aIEGtiWXFl7iFGCQ5mJRHemIuZIUK8KYmVValF+fFFpTmpxYcYmTg4
	pRoYJ/BLSXwIu7r4TW/PYsk334zKDrz8+Hxfz2Qxq4m6cgudT8rZfq3QnlP967yZIXdsei7n
	9/8r0xv8pj+cFOiQF3SoJFRRZdPXzmbTJTejZrArMa0t+fecc9WE5yLWelaHz9//GLQmtd5+
	qWCzR1aP7ealIrHntryo4tgz8cpRvkdTRC2i/jMbKbEUZyQaajEXFScCACcE8p5pAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014-11-17 18:30, Julia Lawall wrote:
>
> On Mon, 17 Nov 2014, Konstantin Khlebnikov wrote:
>
>> Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
>>
>> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
>> ---
>>   scripts/coccinelle/free/crypto_free.cocci |   45 +++++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>   create mode 100644 scripts/coccinelle/free/crypto_free.cocci
>>
>> diff --git a/scripts/coccinelle/free/crypto_free.cocci b/scripts/coccinelle/free/crypto_free.cocci
>> new file mode 100644
>> index 0000000..0799b70
>> --- /dev/null
>> +++ b/scripts/coccinelle/free/crypto_free.cocci
>> @@ -0,0 +1,45 @@
>> +///
>> +/// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
>> +/// This finds freeing them by kfree.
>> +///
>> +// Confidence: Moderate
>> +// Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
>> +// Comments: There are false positives in crypto/ where they are actually freed.
>> +// Keywords: crypto, kfree
>> +// Options: --no-includes --include-headers
>> +
>> +virtual org
>> +virtual report
>> +virtual context
>> +
>> +@r depends on context || org || report@
>> +expression x;
>> +identifier crypto_alloc =~ "^crypto_alloc_";
>> +@@
>> +
>> +(
>> + x = crypto_alloc(...)
>> +)
> You can drop the outer parentheses, in this case and in the kfree case.
>
> Are there many of these crypto_alloc_ functions?  It would be nicer to
> avoid the regular expression.  For one thing, you don't have much control
> over what it matches, and for another thing Coccinelle will not be able to
> optimize the selection of files.  With the regular expression it will have
> to parse every file and analyze every function, which will be slow.

As I see here is eight .. ten candidates, maybe some of them are internal.
Ok, I'll resend patch without regex.

>
> julia
>
>> +
>> +@pb@
>> +expression r.x;
>> +position p;
>> +@@
>> +
>> +(
>> +* kfree@p(x)
>> +)
>> +
>> +@script:python depends on org@
>> +p << pb.p;
>> +@@
>> +
>> +msg="WARNING: invalid free of crypto_alloc_* allocated data"
>> +coccilib.org.print_todo(p[0], msg)
>> +
>> +@script:python depends on report@
>> +p << pb.p;
>> +@@
>> +
>> +msg="WARNING: invalid free of crypto_alloc_* allocated data"
>> +coccilib.report.print_report(p[0], msg)
>>
>>

