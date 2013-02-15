Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114Ab3BOP2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:28:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab3BOP2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:28:38 -0500
Date: Fri, 15 Feb 2013 10:28:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] vmcore: introduce types for objects copied in 2nd
 kernel
Message-ID: <20130215152828.GC27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101205.22466.5909.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101205.22466.5909.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:12:05PM +0900, HATAYAMA Daisuke wrote:
> Some parts of old memory need to be copied in buffers on 2nd kernel to
> be remapped to user-space. To distinguish objects in the buffer on 2nd
> kernel and the ones on old memory, enum vmcore_type is introduced: the
> object in the buffer on 2nd kernel has VMCORE_2ND_KERNEL type, and the
> one on old memory has VMCORE_OLD_MEMORY type.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  include/linux/proc_fs.h |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 32676b3..4b153ed 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -97,11 +97,20 @@ struct kcore_list {
>  	int type;
>  };
>  
> +enum vmcore_type {
> +	VMCORE_OLD_MEMORY,
> +	VMCORE_2ND_KERNEL,

This VMCORE_2ND_KERNEL tag looks bad.

How about introducing a "unsigned int flag" element in "struct vmcore"
and set the flag MEM_TYPE_OLDMEM for any contents which come from oldmem.

If MEM_TYPE_OLDMEM is not set, it is assumed that contents are to be
fetched from current kernel using pointer vmcore->buf.

BTW, which elements you need to copy from first kernel?

> +};
> +
>  struct vmcore {
>  	struct list_head list;
> -	unsigned long long paddr;
> +	union {
> +		unsigned long long paddr;
> +		char *buf;
> +	};
>  	unsigned long long size;
>  	loff_t offset;
> +	enum vmcore_type type;
>  };
>  

Thanks
Vivek

>  #ifdef CONFIG_PROC_FS
