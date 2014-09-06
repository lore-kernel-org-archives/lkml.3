Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaIFASp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:18:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:35582 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaIFASm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:18:42 -0400
Date: Sat, 6 Sep 2014 02:18:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Behan Webster <behanw@converseincode.com>
cc: zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        =?ISO-8859-15?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from
 ima_crypto.c
In-Reply-To: <1409958360-8061-1-git-send-email-behanw@converseincode.com>
Message-ID: <alpine.DEB.2.10.1409060131260.5472@nanos>
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-461290147-1409962708=:5472"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-461290147-1409962708=:5472
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 5 Sep 2014, behanw@converseincode.com wrote:

> From: Behan Webster <behanw@converseincode.com>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This patch allocates the appropriate amount of memory
> using an char array.
> 
> The new code can be compiled with both gcc and clang.
> 
> struct shash_desc contains a flexible array member member ctx declared with
> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
> of the array declared after struct shash_desc with long long.
> 
> No trailing padding is required because it is not a struct type that can
> be used in an array.
> 
> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
> as would be the case for a struct containing a member with
> CRYPTO_MINALIGN_ATTR.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

This SOB chain is completely ass backwards. See Documentation/...

> ---
>  security/integrity/ima/ima_crypto.c | 53 +++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 0bd7328..a6aa2b0 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -380,17 +380,16 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  	loff_t i_size, offset = 0;
>  	char *rbuf;
>  	int rc, read = 0;
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(tfm)];
> -	} desc;
> +	char desc[sizeof(struct shash_desc) +
> +		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *shash = (struct shash_desc *)desc;

That anon struct should have never happened in the first place. Not
your problem, but you are not making it any better. You replace open
coded crap with even more unreadable crap.

Whats wrong with 

      SHASH_DESC_ON_STACK(shash, tfm);

or something along that line and hide all the stack allocation, type
conversion crap and make my favourite compiler happy in a single
place?

Nothing wrong as far as I can tell, it just would add the benefit that
you can halfways ensure that nobody fatfingers the magic allocation
and conversion conventions.

Brainlessly replacing crap by more crap just to make it compile with
your favourite compiler is obviously convers to the goals of proper
written code, but considering your mail domain ....

Thanks,

	tglx

--8323329-461290147-1409962708=:5472--
