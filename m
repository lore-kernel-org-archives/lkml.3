Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3GJOgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:36:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42467 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3GJOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:36:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Horman <horms@verge.net.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1373421296-6112-1-git-send-email-horms@verge.net.au>
Date: Wed, 10 Jul 2013 07:36:33 -0700
In-Reply-To: <1373421296-6112-1-git-send-email-horms@verge.net.au> (Simon
	Horman's message of "Wed, 10 Jul 2013 10:54:56 +0900")
Message-ID: <87obaaiiry.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19yjr71ywA1WaeIErDSZ5LamlAzylzjyhk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Horman <horms@verge.net.au>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kexec: return error of machine_kexec() fails
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman <horms@verge.net.au> writes:

> From: Stephen Warren <swarren@nvidia.com>
>
> Prior to commit 3ab8352 "kexec jump", if machine_kexec() returned,
> sys_reboot() would return -EINVAL. This patch restores this behaviour
> for the non-KEXEC_JUMP case, where machine_kexec() is not expected to
> return.
>
> This situation can occur on ARM, where kexec requires disabling all but
> one CPU using CPU hotplug. However, if hotplug isn't supported by the
> particular HW the kernel is running on, then kexec cannot succeed.

Ugh. This reasoning is nonsense.  Prior to the kexec jump work
machine_kexec could never return and so could never return -EINVAL.

It is not ok to have an image loaded that we can not kexec.  kexec_load
should fail not machine_shutdown or machine_kexec.

The only time that machine_kexec can validly return is in the kexec_jump
case, and that is a successful return.

So formally.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

My apologies for not speaking up sooner the broken ARM mutli-cpu
shutdown architecture hurts my brain to think about

ARM needs to get it's act together and stop modifying the generic code
to deal with it's broken multi-cpu architecture.

Eric

> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Acked-by: Simon Horman <horms@verge.net.au>
> ---
>  kernel/kexec.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> Andrew, could you consider picking up this patch?
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..bde1190 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1702,6 +1702,8 @@ int kernel_kexec(void)
>  		pm_restore_console();
>  		unlock_system_sleep();
>  	}
> +#else
> +	error = -EINVAL;
>  #endif
>  
>   Unlock:
