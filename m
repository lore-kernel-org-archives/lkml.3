Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbaGCXHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:07:36 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49813 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740AbaGCXHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:07:35 -0400
Message-ID: <53B5E2AF.5030208@gmail.com>
Date: Thu, 03 Jul 2014 19:09:35 -0400
From: Boris Ostrovsky <ostr.lkml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86-64: fix vDSO build
References: <53B5861E02000078000204D1@mail.emea.novell.com>
In-Reply-To: <53B5861E02000078000204D1@mail.emea.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 10:34 AM, Jan Beulich wrote:
> Certain ld versions (observed with 2.20.0) put an empty .rela.dyn
> section into shared object files, breaking the assumption on the number
> of sections to be copied to the final output. Simply discard any empty
> SHT_REL and SHT_RELA sections to address this.

Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> ---
>   arch/x86/vdso/vdso2c.h |    3 +++
>   1 file changed, 3 insertions(+)
>
> --- 3.16-rc3/arch/x86/vdso/vdso2c.h
> +++ 3.16-rc3-x86-vdso-build/arch/x86/vdso/vdso2c.h
> @@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struc
>   	uint64_t flags = GET_LE(&in->sh_flags);
>   
>   	bool copy = flags & SHF_ALLOC &&
> +		(GET_LE(&in->sh_size) ||
> +		 (GET_LE(&in->sh_type) != SHT_RELA &&
> +		  GET_LE(&in->sh_type) != SHT_REL)) &&
>   		strcmp(name, ".altinstructions") &&
>   		strcmp(name, ".altinstr_replacement");
>   
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

