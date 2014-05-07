Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaEGEV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaEGEV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:21:26 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
References: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>
	<1399400175-23754-3-git-send-email-pbonzini@redhat.com>
Date: Wed, 07 May 2014 00:21:25 -0400
In-Reply-To: <1399400175-23754-3-git-send-email-pbonzini@redhat.com> (Paolo
	Bonzini's message of "Tue, 6 May 2014 20:16:13 +0200")
Message-ID: <jpgfvkmi5h6.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> do_insn_fetch_bytes will only be called once in a given insn_fetch and
> insn_fetch_arr, because in fact it will only be called at most twice
> for any instruction and the first call is explicit in x86_decode_insn.
> This observation lets us hoist the call out of the memory copying loop.
> It does not buy performance, because most fetches are one byte long
> anyway, but it prepares for the next patch.
>
> The overflow check is tricky, but correct.  Because do_insn_fetch_bytes
> has already been called once, we know that fc->end is at least 15.  So
> it is okay to subtract the number of bytes we want to read.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c7b625bf0b5d..886f9a88010f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -706,7 +706,7 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
>   * Prefetch the remaining bytes of the instruction without crossing page
>   * boundary if they are not in fetch_cache yet.
>   */
> -static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt)
> +static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>  {
>  	struct fetch_cache *fc = &ctxt->fetch;
>  	int rc;
> @@ -718,7 +718,14 @@ static int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt)
>  	cur_size = fc->end - fc->start;
>  	size = min(15UL - cur_size,
>  		   PAGE_SIZE - offset_in_page(fc->end));
> -	if (unlikely(size == 0))
> +
> +	/*
> +	 * One instruction can only straddle two pages,
> +	 * and one has been loaded at the beginning of
> +	 * x86_decode_insn.  So, if not enough bytes
> +	 * still, we must have hit the 15-byte boundary.
> +	 */
> +	if (unlikely(size < op_size))
>  		return X86EMUL_UNHANDLEABLE;
>  	rc = __linearize(ctxt, addr, size, false, true, &linear);
>  	if (unlikely(rc != X86EMUL_CONTINUE))
> @@ -739,12 +746,14 @@ static int do_insn_fetch(struct x86_emulate_ctxt *ctxt,
>  	u8 *dest = __dest;
>  	u8 *src = &fc->data[ctxt->_eip - fc->start];
>  
> +	/* We have to be careful about overflow! */
> +	if (unlikely(ctxt->_eip > fc->end - size)) {
> +		rc != do_insn_fetch_bytes(ctxt, size);
This is a typo I guess ..

> +		if (rc != X86EMUL_CONTINNUE)
> +			goto done;
> +	}
> +
>  	while (size--) {
> -		if (unlikely(ctxt->_eip == fc->end)) {
> -			rc = do_insn_fetch_bytes(ctxt);
> -			if (rc != X86EMUL_CONTINUE)
> -				return rc;
> -		}
>  		*dest++ = *src++;
>  		ctxt->_eip++;
>  		continue;
> @@ -4273,7 +4282,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  	if (insn_len > 0)
>  		memcpy(ctxt->fetch.data, insn, insn_len);
>  	else {
> -		rc = do_insn_fetch_bytes(ctxt);
> +		rc = do_insn_fetch_bytes(ctxt, 1);
Is this saying that if the cache is full, then we fetch one more byte ?

>  		if (rc != X86EMUL_CONTINUE)
>  			return rc;
>  	}
