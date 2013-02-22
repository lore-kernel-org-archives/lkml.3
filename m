Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3BVBzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:55:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59482 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3BVBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:55:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <1361496375-30994-1-git-send-email-sasha.levin@oracle.com>
Date: Thu, 21 Feb 2013 17:55:27 -0800
In-Reply-To: <1361496375-30994-1-git-send-email-sasha.levin@oracle.com> (Sasha
	Levin's message of "Thu, 21 Feb 2013 20:26:15 -0500")
Message-ID: <87vc9l5cz4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+S/LWjpsPIZsQUFGGIkfdcsiT+2Ij3dYQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0019]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sasha.levin@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kexec: prevent double free on image allocation failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> If kimage_normal_alloc() fails to initialize an allocated kimage, it will free
> the image but would still set 'rimage', as a result kexec_load will try
> to free it again.
>
> This would explode as part of the freeing process is accessing internal
> members which point to uninitialized memory.

Agreed.

I don't think that failure path has ever actually been exercised.

The code is wrong, and it is worth fixing.

Andrew I do you think you could queue this up?  I don't have a handy tree.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/kexec.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2348bd6..855bfbb 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -242,8 +242,6 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>  	if (result)
>  		goto out;
>  
> -	*rimage = image;
> -
>  	/*
>  	 * Find a location for the control code buffer, and add it
>  	 * the vector of segments so that it's pages will also be
