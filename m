Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3KYQIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:08:10 -0500
Received: from mail.yonan.net ([54.244.116.145]:49823 "EHLO mail.yonan.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3KYQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:08:07 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 11:08:07 EST
Message-ID: <529373C7.10201@openvpn.net>
Date: Mon, 25 Nov 2013 08:59:03 -0700
From: James Yonan <james@openvpn.net>
Organization: OpenVPN Technologies, Inc.
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.eti.br>, linux-crypto@vger.kernel.org
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: more robust crypto_memneq
References: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br>
In-Reply-To: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/2013 14:12, Cesar Eduardo Barros wrote:
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
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

This approach using __asm__ ("" : "=r" (var) : "0" (var)) to try to 
prevent compiler optimizations of var is interesting.

I like the fact that it's finer-grained than -Os and doesn't preclude 
inlining.

One concern would be that __asm__ could be optimized out unless 
__volatile__ is present.

James
