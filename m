Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaLQE5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:57:06 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:45244 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbaLQE5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:57:05 -0500
From: Alok Kataria <akataria@vmware.com>
To: "jgross@suse.com" <jgross@suse.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dunn <ddunn@vmware.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jongman.heo@samsung.com" <jongman.heo@samsung.com>
Subject: Re: [PATCH] x86: don't rely on VMWare emulating PAT MSR correctly
Thread-Topic: [PATCH] x86: don't rely on VMWare emulating PAT MSR correctly
Thread-Index: AQHQGRbhTAZtrjsHHkS6foiR7t7eE5yTwBCA
Date: Wed, 17 Dec 2014 04:57:02 +0000
Message-ID: <1418792295.4473.70.camel@akataria-dtop.eng.vmware.com>
References: <1418723914-9736-1-git-send-email-jgross@suse.com>
In-Reply-To: <1418723914-9736-1-git-send-email-jgross@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.113.160.246]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E28A836677B72418B08A53036DFB98C@pa-exch1.vmware.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBH4vYwE009405

Hi,

On Tue, 2014-12-16 at 10:58 +0100, Juergen Gross wrote:
> VMWare seems not to emulate the PAT MSR correctly: reaeding
> MSR_IA32_CR_PAT returns 0 even after writing another value to it.
> 
> Detect this bug and don't use the read value if it is 0.
> 
> Commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 ("x86: Enable PAT to
> use cache mode translation tables") triggers this VMWare bug when the
> kernel is booted as a VMWare guest.

Thanks for taking care of this, we are fine with this workaround. On
newer version of our product, where PAT is virtualized correctly on our
platform we will go back to using PAT, I will give it a spin sometime
later to verify it.

Acked-by: Alok N Kataria <akataria@vmware.com>

> Reported-by: Jongman Heo <jongman.heo@samsung.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Tested-by: Jongman Heo <jongman.heo@samsung.com>
> ---
>  arch/x86/mm/pat.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index edf299c..7ac6869 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -234,8 +234,13 @@ void pat_init(void)
>  	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
>  
>  	/* Boot CPU check */
> -	if (!boot_pat_state)
> +	if (!boot_pat_state) {
>  		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> +		if (!boot_pat_state) {
> +			pat_disable("PAT read returns always zero, disabled.");
> +			return;
> +		}
> +	}
>  
>  	wrmsrl(MSR_IA32_CR_PAT, pat);
>  

Alok
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
