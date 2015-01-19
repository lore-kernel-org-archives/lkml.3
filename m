Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbbASFFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 00:05:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbbASFFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 00:05:30 -0500
Message-ID: <54BC9095.9080506@suse.com>
Date: Mon, 19 Jan 2015 06:05:25 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org
CC: akataria@vmware.com, jongman.heo@samsung.com
Subject: Re: [Patch RESEND] x86: don't rely on VMWare emulating PAT MSR correctly
References: <1421039745-14335-1-git-send-email-jgross@suse.com>
In-Reply-To: <1421039745-14335-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING!

The patch repairs a bug with VMWARE, which has been reported by several
users. All of them have confirmed the patch is working. And VMWARE has
acked the patch. What else do you need to take it? It is available for
over a month now!

Juergen

On 01/12/2015 06:15 AM, Juergen Gross wrote:
> VMWare seems not to emulate the PAT MSR correctly: reaeding
> MSR_IA32_CR_PAT returns 0 even after writing another value to it.
>
> Detect this bug and don't use the read value if it is 0.
>
> Commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 ("x86: Enable PAT to
> use cache mode translation tables") triggers this VMWare bug when the
> kernel is booted as a VMWare guest.
>
> Reported-by: Jongman Heo <jongman.heo@samsung.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Tested-by: Jongman Heo <jongman.heo@samsung.com>
> Acked-by: Alok N Kataria <akataria@vmware.com>
> ---
>   arch/x86/mm/pat.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index edf299c..7ac6869 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -234,8 +234,13 @@ void pat_init(void)
>   	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
>
>   	/* Boot CPU check */
> -	if (!boot_pat_state)
> +	if (!boot_pat_state) {
>   		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> +		if (!boot_pat_state) {
> +			pat_disable("PAT read returns always zero, disabled.");
> +			return;
> +		}
> +	}
>
>   	wrmsrl(MSR_IA32_CR_PAT, pat);
>
>

