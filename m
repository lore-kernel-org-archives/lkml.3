Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697Ab3BOPvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:51:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab3BOPve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:51:34 -0500
Date: Fri, 15 Feb 2013 10:51:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/13] vmcore: modify read_vmcore() to read buffer on 2nd
 kernel
Message-ID: <20130215155124.GF27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101221.22466.97636.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101221.22466.97636.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:12:21PM +0900, HATAYAMA Daisuke wrote:
> If a given vmcore object has VMCORE_2ND_KERNEL type, target data is in
> the buffer on 2nd kernel.
> 

Looks like this patch is doing two things.

- Cleanup how read is performed. Get rid of map_offset_to_paddr() and
  open code it and use list_for_each_entry(). 

- Read some memory from current kernel if VMCORE_2ND_KERNEL is set.

Can you break it down in two patches.

Thanks
Vivek

> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |   64 ++++++++++++++++++++++++++----------------------------
>  1 files changed, 31 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 77e0a0e..4125a65 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -146,8 +146,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  {
>  	ssize_t acc = 0, tmp;
>  	size_t tsz;
> -	u64 start, nr_bytes;
> -	struct vmcore *curr_m = NULL;
> +	struct vmcore *m;
>  
>  	if (buflen == 0 || *fpos >= vmcore_size)
>  		return 0;
> @@ -173,39 +172,38 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  			return acc;
>  	}
>  
> -	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
> -	if (!curr_m)
> -        	return -EINVAL;
> -	if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> -		tsz = buflen;
> -
> -	/* Calculate left bytes in current memory segment. */
> -	nr_bytes = (curr_m->size - (start - curr_m->paddr));
> -	if (tsz > nr_bytes)
> -		tsz = nr_bytes;
> -
> -	while (buflen) {
> -		tmp = read_from_oldmem(buffer, tsz, &start, 1);
> -		if (tmp < 0)
> -			return tmp;
> -		buflen -= tsz;
> -		*fpos += tsz;
> -		buffer += tsz;
> -		acc += tsz;
> -		if (start >= (curr_m->paddr + curr_m->size)) {
> -			if (curr_m->list.next == &vmcore_list)
> -				return acc;	/*EOF*/
> -			curr_m = list_entry(curr_m->list.next,
> -						struct vmcore, list);
> -			start = curr_m->paddr;
> +	list_for_each_entry(m, &vmcore_list, list) {
> +		if (*fpos < m->offset + m->size) {
> +			tsz = m->offset + m->size - *fpos;
> +			if (buflen < tsz)
> +				tsz = buflen;
> +			switch (m->type) {
> +			case VMCORE_OLD_MEMORY: {
> +				u64 paddr = m->paddr + *fpos - m->offset;
> +
> +				tmp = read_from_oldmem(buffer, tsz, &paddr, 1);
> +				if (tmp < 0)
> +					return tmp;
> +				break;
> +			}
> +			case VMCORE_2ND_KERNEL:
> +				if (copy_to_user(buffer,
> +						 m->buf + (*fpos - m->offset),
> +						 tsz))
> +					return -EFAULT;
> +				break;
> +			}
> +			buflen -= tsz;
> +			*fpos += tsz;
> +			buffer += tsz;
> +			acc += tsz;
> +
> +			/* leave now if filled buffer already */
> +			if (buflen == 0)
> +				return acc;
>  		}
> -		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> -			tsz = buflen;
> -		/* Calculate left bytes in current memory segment. */
> -		nr_bytes = (curr_m->size - (start - curr_m->paddr));
> -		if (tsz > nr_bytes)
> -			tsz = nr_bytes;
>  	}
> +
>  	return acc;
>  }
>  
