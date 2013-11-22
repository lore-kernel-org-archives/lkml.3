Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3KVUm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:42:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab3KVUm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:42:56 -0500
Date: Fri, 22 Nov 2013 21:42:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
In-Reply-To: <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
Message-ID: <alpine.LRH.2.00.1311222136030.9932@twin.jikos.cz>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Vivek Goyal wrote:

> This patch implements the in kernel kexec functionality. It implements a
> new system call kexec_file_load. I think parameter list of this system
> call will change as I have not done the kernel image signature handling
> yet. I have been told that I might have to pass the detached signature
> and size as part of system call.
> 
> Previously segment list was prepared in user space. Now user space just
> passes kernel fd, initrd fd and command line and kernel will create a
> segment list internally.
> 
> This patch contains generic part of the code. Actual segment preparation
> and loading is done by arch and image specific loader. Which comes in
> next patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
[ ... snip ... ]
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 6238927..50bcaa8 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
[ ... snip ... ]
> @@ -843,7 +1075,11 @@ static int kimage_load_normal_segment(struct kimage *image,
>  				PAGE_SIZE - (maddr & ~PAGE_MASK));
>  		uchunk = min(ubytes, mchunk);
>  
> -		result = copy_from_user(ptr, buf, uchunk);
> +		/* For file based kexec, source pages are in kernel memory */
> +		if (image->file_mode)
> +			memcpy(ptr, buf, uchunk);

Very minor nit I came across when going through the patchset -- can't we 
use some different buffer for the file-based kexec that's not marked 
__user here? This really causes some eye-pain when looking at the code.

Thanks a lot for pushing this patchset forward,

-- 
Jiri Kosina
SUSE Labs
