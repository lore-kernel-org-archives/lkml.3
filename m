Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaJFV1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:27:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46024 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaJFV1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:27:12 -0400
Date: Mon, 6 Oct 2014 23:27:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, MCE, AMD: move invariant code out from loop body
Message-ID: <20141006212707.GH20739@pd.tnic>
References: <1411377812.1917.112.camel@cyc>
 <20140922191100.GC4709@pd.tnic>
 <20141002143819.GE16452@pd.tnic>
 <1412263212.8085.6.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412263212.8085.6.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:20:12PM +0800, Chen Yucong wrote:
> From: Chen Yucong <slaoub@gmail.com>
> Subject: [PATCH] x86, MCE, AMD: move invariant code out from loop body
> 
> "mce_threshold_vector = amd_threshold_interrupt;" is loop invariant code
> in mce_amd_feature_init(). So it should be moved out from loop body.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 5d4999f..f727701 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -253,9 +253,10 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  			}
>  
>  			mce_threshold_block_init(&b, offset);
> -			mce_threshold_vector = amd_threshold_interrupt;
>  		}
>  	}
> +
> +	mce_threshold_vector = amd_threshold_interrupt;

Looking at this more, it is theoretically possible that we break out
of the both loops without *any* thresholding registers detected and to
still assign a thresholding interrupt vector which would be clearly
wrong.

Thus I think something like below should be much safer (I tried it with
a label and goto already but it is uglier):

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 9ce64955559d..9af7bd74828b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -253,7 +253,9 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			}
 
 			mce_threshold_block_init(&b, offset);
-			mce_threshold_vector = amd_threshold_interrupt;
+
+			if (mce_threshold_vector != amd_threshold_interrupt)
+				mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
 }

Looking at the asm, we still go and fetch those addresses so not really
a win:

	cmpq	$amd_threshold_interrupt, mce_threshold_vector(%rip)	#, mce_threshold_vector
	je	.L235	#,
	incl	%r13d	# block
	movq	$amd_threshold_interrupt, mce_threshold_vector(%rip)	#, mce_threshold_vector
	cmpl	$9, %r13d	#, block

but this way the code is relatively clean. Unless you can come up with
a nicer, cleaner version to handle the breaking out in the success and
failure case...

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
