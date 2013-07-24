Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3GXIIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:08:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44395 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3GXIIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:08:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20130723181606.GA6342@sergelap> <20130723181853.GA7005@sergelap>
Date: Wed, 24 Jul 2013 01:07:53 -0700
In-Reply-To: <20130723181853.GA7005@sergelap> (Serge Hallyn's message of "Tue,
	23 Jul 2013 13:18:53 -0500")
Message-ID: <87bo5snzxi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+X9fb/BPhdP9H8NbVGG2yfSqdmdPVB5tQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0019]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 2/2] capabilities: allow nice if we are privileged
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> We allow task A to change B's nice level if it has a supserset of
> B's privileges, or of it has CAP_SYS_NICE.  Also allow it if A has
> CAP_SYS_NICE with respect to B - meaning it is root in the same
> namespace, or it created B's namespace.

This patch looks good to me.

We already have this logic elsewhere in the kernel so I don't expect
this will make things worse.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> ---
>  security/commoncap.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/security/commoncap.c b/security/commoncap.c
> index d78b003..ef98b56 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -768,16 +768,16 @@ int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
>   */
>  static int cap_safe_nice(struct task_struct *p)
>  {
> -	int is_subset;
> +	int is_subset, ret = 0;
>  
>  	rcu_read_lock();
>  	is_subset = cap_issubset(__task_cred(p)->cap_permitted,
>  				 current_cred()->cap_permitted);
> +	if (!is_subset && !ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE))
> +		ret = -EPERM;
>  	rcu_read_unlock();
>  
> -	if (!is_subset && !capable(CAP_SYS_NICE))
> -		return -EPERM;
> -	return 0;
> +	return ret;
>  }
>  
>  /**
