Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaCGO3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:29:18 -0500
Received: from relay.parallels.com ([195.214.232.42]:33224 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaCGO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:29:16 -0500
Message-ID: <5319D7B9.6050000@parallels.com>
Date: Fri, 7 Mar 2014 18:29:13 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Artem Fetishev <artem_fetishev@epam.com>, <akpm@linux-foundation.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <wiebittewas@googlemail.com>, <alexandr_terekhov@epam.com>
Subject: Re: [PATCH] proc: #68991 Fix GPF in /proc/$PID/map_files
References: <20140308022033.GC5690@owamsq.epam.com>
In-Reply-To: <20140308022033.GC5690@owamsq.epam.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 06:20 AM, Artem Fetishev wrote:
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

Acked-by: Pavel Emelyanov <xemul@parallels.com>


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
> .
> 


