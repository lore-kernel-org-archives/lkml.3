Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab3EOJfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:35:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab3EOJfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:35:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,677,1363104000"; 
   d="scan'208";a="7275575"
Message-ID: <5193564F.9090408@cn.fujitsu.com>
Date: Wed, 15 May 2013 17:33:03 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        jingbai.ma@hp.com, linux-mm@kvack.org, riel@redhat.com,
        walken@google.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 1/8] vmcore: clean up read_vmcore()
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <20130515090545.28109.86085.stgit@localhost6.localdomain6>
In-Reply-To: <20130515090545.28109.86085.stgit@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 17:34:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 17:34:16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月15日 17:05, HATAYAMA Daisuke 写道:
> Rewrite part of read_vmcore() that reads objects in vmcore_list in the
> same way as part reading ELF headers, by which some duplicated and
> redundant codes are removed.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

This cleanup really makes the code more clear.

Just one minor nitpick below.

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
> 
>  fs/proc/vmcore.c |   68 ++++++++++++++++--------------------------------------
>  1 files changed, 20 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 17f7e08..ab0c92e 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -118,27 +118,6 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
>  	return read;
>  }
>  
> -/* Maps vmcore file offset to respective physical address in memroy. */
> -static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
> -					struct vmcore **m_ptr)
> -{
> -	struct vmcore *m;
> -	u64 paddr;
> -
> -	list_for_each_entry(m, vc_list, list) {
> -		u64 start, end;
> -		start = m->offset;
> -		end = m->offset + m->size - 1;
> -		if (offset >= start && offset <= end) {
> -			paddr = m->paddr + offset - start;
> -			*m_ptr = m;
> -			return paddr;
> -		}
> -	}
> -	*m_ptr = NULL;
> -	return 0;
> -}
> -
>  /* Read from the ELF header and then the crash dump. On error, negative value is
>   * returned otherwise number of bytes read are returned.
>   */
> @@ -147,8 +126,8 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  {
>  	ssize_t acc = 0, tmp;
>  	size_t tsz;
> -	u64 start, nr_bytes;
> -	struct vmcore *curr_m = NULL;
> +	u64 start;
> +	struct vmcore *m = NULL;
>  
>  	if (buflen == 0 || *fpos >= vmcore_size)
>  		return 0;
> @@ -174,33 +153,26 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  			return acc;
>  	}
>  
> -	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
> -	if (!curr_m)
> -        	return -EINVAL;
> -
> -	while (buflen) {
> -		tsz = min_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
> -
> -		/* Calculate left bytes in current memory segment. */
> -		nr_bytes = (curr_m->size - (start - curr_m->paddr));
> -		if (tsz > nr_bytes)
> -			tsz = nr_bytes;
> -
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

if (tsz > buflen)
        tsz = buflen;

seems better.

Or you can use a min_t here:

tsz = min_t(size_t, m->offset + m->size - *fpos, buflen);


> +			start = m->paddr + *fpos - m->offset;
> +			tmp = read_from_oldmem(buffer, tsz, &start, 1);
> +			if (tmp < 0)
> +				return tmp;
> +			buflen -= tsz;
> +			*fpos += tsz;
> +			buffer += tsz;
> +			acc += tsz;
> +
> +			/* leave now if filled buffer already */
> +			if (buflen == 0)
> +				return acc;
>  		}
>  	}
> +
>  	return acc;
>  }
>  
> 
> 

