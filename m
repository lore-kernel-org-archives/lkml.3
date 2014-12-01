Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaLAPUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:20:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbaLAPUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:20:49 -0500
Date: Mon, 1 Dec 2014 16:20:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>, dborkman@redhat.com,
        herbert@gondor.apana.org.au, kernel-janitors@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/8] purgatory/sha256: replace memset by memzero_explicit
Message-ID: <20141201152047.GG12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Julia Lawall <Julia.Lawall@lip6.fr>,
	Thomas Gleixner <tglx@linutronix.de>, dborkman@redhat.com,
	herbert@gondor.apana.org.au, kernel-janitors@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Julia Lawall <julia@diku.dk>
References: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417366774-32412-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417366774-32412-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 05:59:27PM +0100, Julia Lawall wrote:
> @@ -205,7 +205,7 @@ static void sha256_transform(u32 *state, const u8 *input)
>  
>  	/* clear any sensitive info... */
>  	a = b = c = d = e = f = g = h = t1 = t2 = 0;

All of these get optimized away.

How to clear them effectively is another question.  Setting them one by
one casting to volatile would generate 10 instructions. Although this
might be quick as there are no dependencies, the function
sha256_transform is called repeatedly and the small overhead may add up.

Other attempts to fix it require restructuring the code so all the
variables are eg. stored in an array that gets cleared in one go. Here
the indirect access could be hidden into the macros (e0, e1, s0, s1).

> -	memset(W, 0, 64 * sizeof(u32));
> +	memzero_explicit(W, 64 * sizeof(u32));
