Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664AbaEFJqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:46:13 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36293 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaEFJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:46:07 -0400
Message-ID: <5368AF5A.2090905@redhat.com>
Date: Tue, 06 May 2014 11:46:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] KVM: x86: use memory_prepare in fetch helper
 function
References: <1399336859-7227-1-git-send-email-bsd@redhat.com> <1399336859-7227-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1399336859-7227-3-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/05/2014 02:40, Bandan Das ha scritto:
> +		ret = ctxt->ops->memory_prepare(ctxt, addr, toread,
> +						exception, false,
> +						NULL, &uaddr);
> +		if (ret != X86EMUL_CONTINUE)
> +			return ret;
> +
> +		if (unlikely(kvm_is_error_hva(uaddr))) {
> +			r = X86EMUL_PROPAGATE_FAULT;
> +			return r;
> +		}

What you are doing here is basically optimizing 
kvm_read_guest_virt_helper because you know that all reads will be 
single-page and you do not need the "next_segment" in kvm_read_guest.
Good catch, but you can use kvm_read_guest_page instead of going through 
ctxt->ops->memory_prepare. :)

Paolo

> +		ret = __copy_from_user(data, (void __user *)uaddr, toread);

