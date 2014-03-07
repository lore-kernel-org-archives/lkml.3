Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaCGUSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:18:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50298 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCGUSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:18:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Artem Fetishev <artem_fetishev@epam.com>
Cc: <akpm@linux-foundation.org>, containers@lists.linux-foundation.org,
        alexandr_terekhov@epam.com, linux-kernel@vger.kernel.org,
        xemul@parallels.com
References: <20140308022033.GC5690@owamsq.epam.com>
Date: Fri, 07 Mar 2014 12:17:56 -0800
In-Reply-To: <20140308022033.GC5690@owamsq.epam.com> (Artem Fetishev's message
	of "Sat, 8 Mar 2014 05:20:33 +0300")
Message-ID: <87r46dvk3v.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19b8/Kx707GRVXkCyC5yOQKZ1zYWToBYhQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4993]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Artem Fetishev <artem_fetishev@epam.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: #68991 Fix GPF in /proc/$PID/map_files
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Fetishev <artem_fetishev@epam.com> writes:

> https://bugzilla.kernel.org/show_bug.cgi?id=68991
>
> The expected logic of proc_map_files_get_link() is either to return 0 and
> initialize 'path' or return an error and leave 'path' uninitialized. By the time
> dname_to_vma_addr() returns 0 the corresponding vma may have already be gone. In
> this case the path is not initialized but the return value is still 0. This
> results in 'general protection fault' inside d_path().
>
> Steps to reproduce:
> CONFIG_CHECKPOINT_RESTORE=y
>
> fd = open(...);
> while (1) {
> 	mmap(fd, ...);
> 	munmap(fd, ...);
> }
>
> ls -la /proc/$PID/map_files
>
> Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
> Signed-off-by: Aleksandr Terekhov <aleksandr_terekhov@epam.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 5150706..b976062 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1824,6 +1824,7 @@ static int proc_map_files_get_link(struct dentry *dentry, struct path *path)
>  	if (rc)
>  		goto out_mmput;
>  
> +	rc = -ENOENT;
>  	down_read(&mm->mmap_sem);
>  	vma = find_exact_vma(mm, vm_start, vm_end);
>  	if (vma && vma->vm_file) {
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
