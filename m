Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422665Ab3BOPdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:33:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab3BOPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:33:00 -0500
Date: Fri, 15 Feb 2013 10:32:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] vmcore: modify vmcore clean-up function to free
 buffer on 2nd kernel
Message-ID: <20130215153253.GE27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101216.22466.52389.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101216.22466.52389.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:12:16PM +0900, HATAYAMA Daisuke wrote:
> Vmcore object has buffer on 2nd kernel if it has VMCORE_2ND_KERNEL
> type, which needs to be freed.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 7e3f922..77e0a0e 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -735,6 +735,15 @@ void vmcore_cleanup(void)
>  		struct vmcore *m;
>  
>  		m = list_entry(pos, struct vmcore, list);
> +
> +		switch (m->type) {
> +		case VMCORE_OLD_MEMORY:
> +			break;
> +		case VMCORE_2ND_KERNEL:
> +			free_pages((unsigned long)m->buf, get_order(m->size));
> +			break;

I think order of patches is little wrong. None of the patches so far has
done any memory allocation for VMCORE_2ND_KERNEL, and we are already
freeing the memory which will be allocated in future patches. May be just
merge this patch with the patch which does memory allocation. No need
to separate it out.

Thanks
Vivek
