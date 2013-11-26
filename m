Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3KZT21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:28:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab3KZT2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:28:24 -0500
Message-ID: <5294F625.5040506@redhat.com>
Date: Tue, 26 Nov 2013 20:27:33 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
CC: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        James Yonan <james@openvpn.net>, Florian Weimer <fw@deneb.enyo.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: more robust crypto_memneq
References: <1385424041-18064-1-git-send-email-cesarb@cesarb.eti.br>
In-Reply-To: <1385424041-18064-1-git-send-email-cesarb@cesarb.eti.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 01:00 AM, Cesar Eduardo Barros wrote:
> Disabling compiler optimizations can be fragile, since a new
> optimization could be added to -O0 or -Os that breaks the assumptions
> the code is making.
>
> Instead of disabling compiler optimizations, use a dummy inline assembly
> (based on RELOC_HIDE) to block the problematic kinds of optimization,
> while still allowing other optimizations to be applied to the code.
>
> The dummy inline assembly is added after every OR, and has the
> accumulator variable as its input and output. The compiler is forced to
> assume that the dummy inline assembly could both depend on the
> accumulator variable and change the accumulator variable, so it is
> forced to compute the value correctly before the inline assembly, and
> cannot assume anything about its value after the inline assembly.
>
> This change should be enough to make crypto_memneq work correctly (with
> data-independent timing) even if it is inlined at its call sites. That
> can be done later in a followup patch.
>
> Compile-tested on x86_64.

Actually with yet another version, I hoped that the "compile-tested"-only
statement would eventually disappear, ohh well. ;)

> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

Resolving the OPTIMIZER_HIDE_VAR() macro for others than GCC jnto a
barrier() seems a bit suboptimal, but assuming 99% of people will use
GCC anyway, then for the minority of the remaining, they will worst case
have a clever compiler and eventually mimic memcmp() in some situations,
or have a not-so-clever compiler and execute the full code as is.

Anyway, I think still better than the rather ugly Makefile workaround
imho, so I'm generally fine with this.
