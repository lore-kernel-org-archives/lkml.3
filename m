Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966398Ab3DQSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:20:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:51833 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966138Ab3DQSUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,495,1363158000"; 
   d="scan'208";a="319858470"
Subject: Re: [PATCH 2/4] Accelerated CRC T10 DIF computation with PCLMULQDQ
 instruction
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <516EE2C6.6010901@iki.fi>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
	 <5227e0b295142e1fbb3c7e0241646eb65319b18a.1366120266.git.tim.c.chen@linux.intel.com>
	 <516EE2C6.6010901@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Apr 2013 11:20:06 -0700
Message-ID: <1366222806.27102.107.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 20:58 +0300, Jussi Kivilinna wrote:
> On 16.04.2013 19:20, Tim Chen wrote:
> > This is the x86_64 CRC T10 DIF transform accelerated with the PCLMULQDQ
> > instructions.  Details discussing the implementation can be found in the
> > paper:
> > 
> > "Fast CRC Computation for Generic Polynomials Using PCLMULQDQ Instruction"
> > URL: http://download.intel.com/design/intarch/papers/323102.pdf
> 
> URL does not work.

Thanks for catching this. Will update.

> 
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Tested-by: Keith Busch <keith.busch@intel.com>
> > ---
> >  arch/x86/crypto/crct10dif-pcl-asm_64.S | 659 +++++++++++++++++++++++++++++++++
> >  1 file changed, 659 insertions(+)
> >  create mode 100644 arch/x86/crypto/crct10dif-pcl-asm_64.S
> <snip>
> > +
> > +	# Allocate Stack Space
> > +	mov     %rsp, %rcx
> > +	sub	$16*10, %rsp
> > +	and     $~(0x20 - 1), %rsp
> > +
> > +	# push the xmm registers into the stack to maintain
> > +	movdqa %xmm10, 16*2(%rsp)
> > +	movdqa %xmm11, 16*3(%rsp)
> > +	movdqa %xmm8 , 16*4(%rsp)
> > +	movdqa %xmm12, 16*5(%rsp)
> > +	movdqa %xmm13, 16*6(%rsp)
> > +	movdqa %xmm6,  16*7(%rsp)
> > +	movdqa %xmm7,  16*8(%rsp)
> > +	movdqa %xmm9,  16*9(%rsp)
> 
> You don't need to store (and restore) these, as 'crc_t10dif_pcl' is called between kernel_fpu_begin/_end.

That's true.  Will skip the xmm save/restore in update to the patch.

> 
> > +
> > +
> > +	# check if smaller than 256
> > +	cmp	$256, arg3
> > +
> <snip>
> > +_cleanup:
> > +	# scale the result back to 16 bits
> > +	shr	$16, %eax
> > +	movdqa	16*2(%rsp), %xmm10
> > +	movdqa	16*3(%rsp), %xmm11
> > +	movdqa	16*4(%rsp), %xmm8
> > +	movdqa	16*5(%rsp), %xmm12
> > +	movdqa	16*6(%rsp), %xmm13
> > +	movdqa	16*7(%rsp), %xmm6
> > +	movdqa	16*8(%rsp), %xmm7
> > +	movdqa	16*9(%rsp), %xmm9
> 
> Registers are overwritten by kernel_fpu_end.
> 
> > +	mov     %rcx, %rsp
> > +	ret
> > +ENDPROC(crc_t10dif_pcl)
> > +
> 
> You should move ENDPROC at end of the full function.
> 
> > +########################################################################
> > +
> > +.align 16
> > +_less_than_128:
> > +
> > +	# check if there is enough buffer to be able to fold 16B at a time
> > +	cmp	$32, arg3
> <snip>
> > +	movdqa	(%rsp), %xmm7
> > +	pshufb	%xmm11, %xmm7
> > +	pxor	%xmm0 , %xmm7   # xor the initial crc value
> > +
> > +	psrldq	$7, %xmm7
> > +
> > +	jmp	_barrett
> 
> Move ENDPROC here.
> 

Will do.

Tim



