Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaDMMvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 08:51:17 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37494 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaDMMvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:51:16 -0400
Message-ID: <534A8837.8010308@redhat.com>
Date: Sun, 13 Apr 2014 08:51:03 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/6] KVM: emulate: cleanup decode_rm
References: <1397174612-17373-1-git-send-email-bsd@redhat.com> <1397174612-17373-4-git-send-email-bsd@redhat.com>
In-Reply-To: <1397174612-17373-4-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/04/2014 20:03, Bandan Das ha scritto:
> -	if (ctxt->rex_prefix) {
> -		ctxt->modrm_reg = (ctxt->rex_prefix & 4) << 1;	/* REX.R */
> -		index_reg = (ctxt->rex_prefix & 2) << 2; /* REX.X */
> -		ctxt->modrm_rm = base_reg = (ctxt->rex_prefix & 1) << 3; /* REG.B */
> -	}
> +	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
> +	base_reg = (ctxt->rex_prefix << 3) & 8; /* REG.B */

This is REX.B (preexisting typo), and please leave REX.R here too for 
clarity.

Also, the function is "decode_modrm", not "decode_rm" (in the commit 
message).

Otherwise the series seems okay from a somewhat cursory review.

Paolo

>
> -	ctxt->modrm_mod |= (ctxt->modrm & 0xc0) >> 6;
> -	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
> -	ctxt->modrm_rm |= (ctxt->modrm & 0x07);
> +	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
> +	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8) | /* REX.R */
> +		((ctxt->modrm & 0x38) >> 3);
> +	ctxt->modrm_rm = base_reg | (ctxt->modrm & 0x07);
>  	ctxt->modrm_seg = VCPU_SREG_DS;
>

