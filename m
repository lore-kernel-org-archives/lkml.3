Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaKSJmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:42:20 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:55828 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaKSJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:41:55 -0500
X-IronPort-AV: E=Sophos;i="5.07,415,1413237600"; 
   d="scan'208";a="108135279"
Date: Wed, 19 Nov 2014 10:41:37 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>, Michal Marek <mmarek@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2 v2] scripts/coccinelle: catch freeing cryptographic
 structures via kfree
In-Reply-To: <20141118114920.13498.73584.stgit@buzz>
Message-ID: <alpine.DEB.2.10.1411191040020.2363@hadrien>
References: <20141117151420.10739.16342.stgit@buzz> <20141118114920.13498.73584.stgit@buzz>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +// Comments: There are false positives in crypto/ where they are
> actually freed.

I didn't really understand this comment.  I ran the semantic patch and got
around 10 results, but it wasn't clear to me how to see which were false
positives.

I would suggest to extend the rule a little bit to include information
about where the allocation call is:

///
/// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
/// This finds freeing them by kfree.
///
// Confidence: Moderate
// Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
// Comments: There are false positives in crypto/ where they are actually freed.
// Keywords: crypto, kfree
// Options: --no-includes --include-headers

virtual org
virtual report
virtual context

@r depends on context || org || report@
expression x;
position p1;
@@

(
 x = crypto_alloc_base@p1(...)
|
 x = crypto_alloc_cipher@p1(...)
|
 x = crypto_alloc_ablkcipher@p1(...)
|
 x = crypto_alloc_aead@p1(...)
|
 x = crypto_alloc_instance@p1(...)
|
 x = crypto_alloc_instance2@p1(...)
|
 x = crypto_alloc_comp@p1(...)
|
 x = crypto_alloc_pcomp@p1(...)
|
 x = crypto_alloc_hash@p1(...)
|
 x = crypto_alloc_ahash@p1(...)
|
 x = crypto_alloc_shash@p1(...)
|
 x = crypto_alloc_rng@p1(...)
)

@pb@
expression r.x;
position p;
@@

* kfree@p(x)

@script:python depends on org@
p << pb.p;
p1 << r.p1;
@@

msg="WARNING: invalid free of crypto_alloc_* allocated data"
coccilib.org.print_todo(p[0], msg)
coccilib.org.print_link(p1[0], "allocation")

@script:python depends on report@
p << pb.p;
p1 << r.p1;
@@

msg="WARNING: invalid free of crypto_alloc_* allocated data, allocated on line %s" % (p1[0].line)
coccilib.report.print_report(p[0], msg)
