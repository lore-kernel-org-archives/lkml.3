Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaJGGKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:10:49 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52443 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaJGGKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:10:47 -0400
Message-ID: <1412662128.28440.18.camel@debian>
Subject: Re: [PATCH] x86, MCE, AMD: move invariant code out from loop body
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20141006212707.GH20739@pd.tnic>
References: <1411377812.1917.112.camel@cyc> <20140922191100.GC4709@pd.tnic>
	 <20141002143819.GE16452@pd.tnic> <1412263212.8085.6.camel@debian>
	 <20141006212707.GH20739@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Oct 2014 14:08:48 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 23:27 +0200, Borislav Petkov wrote:
> On Thu, Oct 02, 2014 at 11:20:12PM +0800, Chen Yucong wrote:
> > From: Chen Yucong <slaoub@gmail.com>
> > Subject: [PATCH] x86, MCE, AMD: move invariant code out from loop body
> > 
> > "mce_threshold_vector = amd_threshold_interrupt;" is loop invariant code
> > in mce_amd_feature_init(). So it should be moved out from loop body.
> > 
> > Signed-off-by: Chen Yucong <slaoub@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce_amd.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > index 5d4999f..f727701 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > @@ -253,9 +253,10 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
> >  			}
> >  
> >  			mce_threshold_block_init(&b, offset);
> > -			mce_threshold_vector = amd_threshold_interrupt;
> >  		}
> >  	}
> > +
> > +	mce_threshold_vector = amd_threshold_interrupt;
> 
> Looking at this more, it is theoretically possible that we break out
> of the both loops without *any* thresholding registers detected and to
> still assign a thresholding interrupt vector which would be clearly
> wrong.
Yes! In this case, mce_threshold_vector should be `default_threshold_interrupt' rather than
amd_threshold_interrupt.
 
> Thus I think something like below should be much safer (I tried it with
> a label and goto already but it is uglier):
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 9ce64955559d..9af7bd74828b 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -253,7 +253,9 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  			}
>  
>  			mce_threshold_block_init(&b, offset);
> -			mce_threshold_vector = amd_threshold_interrupt;
> +
> +			if (mce_threshold_vector != amd_threshold_interrupt)
> +				mce_threshold_vector = amd_threshold_interrupt;
Perhaps the above assignment operation should be put into 

    if (b.interrupt_capable) {
            ... ...

            if (mce_threshold_vector != amd_threshold_interrupt)
                    mce_threshold_vector = amd_threshold_interrupt;
    }

If IntP (Thresholding Interrupt Supported) bit is zero, this indicates that the reporting
of threshold overflow via interrupt isn't supported. So there's no need to execute the
above assignment operation. 

>  		}
>  	}
>  }
> 
> Looking at the asm, we still go and fetch those addresses so not really
> a win:
> 
> 	cmpq	$amd_threshold_interrupt, mce_threshold_vector(%rip)	#, mce_threshold_vector
> 	je	.L235	#,
> 	incl	%r13d	# block
> 	movq	$amd_threshold_interrupt, mce_threshold_vector(%rip)	#, mce_threshold_vector
> 	cmpl	$9, %r13d	#, block
> 
> but this way the code is relatively clean. Unless you can come up with
> a nicer, cleaner version to handle the breaking out in the success and
> failure case...
Seems like I don't have any better idea than this.

thx!
cyc


From: Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE, AMD: avoid inappropriate assignment operation in
 mce_amd_feature_init

Before executing "mce_threshold_vector = amd_threshold_interrupt;", a few
conditions should be checked for avoiding inappropriate assignment operations,
for example, IntP (Thresholding Interrupt Supported) bit of MCx_MISCi.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5d4999f..31bf792 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -250,10 +250,13 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (b.interrupt_capable) {
 				int new = (high & MASK_LVTOFF_HI) >> 20;
 				offset  = setup_APIC_mce(offset, new);
+
+				if (offset == new &&
+				     mce_threshold_vector != amd_threshold_interrupt)
+					mce_threshold_vector = amd_threshold_interrupt;
 			}
 
 			mce_threshold_block_init(&b, offset);
-			mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
 }
-- 
1.7.10.4



