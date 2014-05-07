Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaEGEgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:36:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaEGEge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:36:34 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] KVM: emulate: avoid per-byte copying in instruction fetches
References: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>
	<1399400175-23754-4-git-send-email-pbonzini@redhat.com>
Date: Wed, 07 May 2014 00:36:33 -0400
In-Reply-To: <1399400175-23754-4-git-send-email-pbonzini@redhat.com> (Paolo
	Bonzini's message of "Tue, 6 May 2014 20:16:14 +0200")
Message-ID: <jpgbnvai4ry.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> We do not need a memory copying loop anymore in insn_fetch; we
> can use a byte-aligned pointer to access instruction fields directly

Nice approach!

> from the fetch_cache.  This eliminates 40-80 cycles (corresponding to
> a 5-7% improvement in performance) from each instruction.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 47 ++++++++++++++++++++++-------------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 886f9a88010f..245a2d0bfe68 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -706,7 +706,7 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
>   * Prefetch the remaining bytes of the instruction without crossing page
>   * boundary if they are not in fetch_cache yet.
>   */
> -static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
> +static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>  {
>  	struct fetch_cache *fc = &ctxt->fetch;
>  	int rc;
> @@ -738,42 +738,39 @@ static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>  	return X86EMUL_CONTINUE;
>  }
>  
> -static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
> -			 void *__dest, unsigned size)
> +static __always_inline int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt,
> +					       unsigned size)
>  {
> -	int rc;
> -	struct fetch_cache *fc = &ctxt->fetch;
> -	u8 *dest = __dest;
> -	u8 *src = &fc->data[ctxt->_eip - fc->start];
> -
>  	/* We have to be careful about overflow! */
> -	if (unlikely(ctxt->_eip > fc->end - size)) {
> -		rc != do_insn_fetch_bytes(ctxt, size);
> -		if (rc != X86EMUL_CONTINNUE)
> -			goto done;
> -	}
> -
> -	while (size--) {
> -		*dest++ = *src++;
> -		ctxt->_eip++;
> -		continue;
> -	}
> -	return X86EMUL_CONTINUE;
> +	if (unlikely(ctxt->_eip > ctxt->fetch.end - size))
> +		return __do_insn_fetch_bytes(ctxt, size);
> +	else
> +		return X86EMUL_CONTINUE;
>  }
>  
>  /* Fetch next part of the instruction being emulated. */
>  #define insn_fetch(_type, _ctxt)					\
> -({	unsigned long _x;						\
> -	rc = do_insn_fetch(_ctxt, &_x, sizeof(_type));			\
> +({	_type _x;							\
> +	struct fetch_cache *_fc;					\
> +									\
> +	rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));			\
>  	if (rc != X86EMUL_CONTINUE)					\
>  		goto done;						\
> -	(_type)_x;							\
> +	_fc = &ctxt->fetch;						\
> +	_x = *(_type __aligned(1) *) &_fc->data[ctxt->_eip - _fc->start]; \
For my own understanding, how does the __aligned help here ? Wouldn't 
that result in unaligned accesses that will actually impact performance ?

> +	ctxt->_eip += sizeof(_type);					\
> +	_x;								\
>  })
>  
>  #define insn_fetch_arr(_arr, _size, _ctxt)				\
> -({	rc = do_insn_fetch(_ctxt, _arr, (_size));			\
> +({									\
> +	struct fetch_cache *_fc;					\
> +	rc = do_insn_fetch_bytes(_ctxt, _size);				\
>  	if (rc != X86EMUL_CONTINUE)					\
>  		goto done;						\
> +	_fc = &ctxt->fetch;						\
> +	memcpy(_arr, &_fc->data[ctxt->_eip - _fc->start], _size);	\
> +	ctxt->_eip += (_size);						\
>  })
>  
>  /*
> @@ -4282,7 +4279,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  	if (insn_len > 0)
>  		memcpy(ctxt->fetch.data, insn, insn_len);
>  	else {
> -		rc = do_insn_fetch_bytes(ctxt, 1);
> +		rc = __do_insn_fetch_bytes(ctxt, 1);
>  		if (rc != X86EMUL_CONTINUE)
>  			return rc;
>  	}
