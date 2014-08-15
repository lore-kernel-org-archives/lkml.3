Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaHONmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaHONmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:42:37 -0400
Date: Fri, 15 Aug 2014 10:42:23 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, 1vier1@web.de
Subject: Re: [PATCH 2/3] ipc/sem.c: increase SEMMSL, SEMMNI, SEMOPM
Message-ID: <20140815134223.GB9918@optiplex.redhat.com>
References: <1407828557-31995-1-git-send-email-manfred@colorfullife.com>
 <1407828557-31995-2-git-send-email-manfred@colorfullife.com>
 <1407828557-31995-3-git-send-email-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407828557-31995-3-git-send-email-manfred@colorfullife.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 09:29:16AM +0200, Manfred Spraul wrote:
> a)
> SysV can be abused to allocate locked kernel memory.  For most systems, a
> small limit doesn't make sense, see the discussion with regards to SHMMAX.
> 
> Therefore: Increase the sysv sem limits so that all known applications
> will work with these defaults.
> 
> b)
> With regards to the maximum supported:
> Some of the specified hard limits are not correct anymore, therefore the
> patch updates the documentation.
> 
> - SEMMNI must stay below IPCMNI, which is 32768.
>   As for SHMMAX: Stay a bit below this limit.
> 
> - SEMMSL was limited to 8k, to ensure that the kmalloc for the kernel array
>   was limited to 16 kB (order=2)
> 
>   This doesn't apply anymore:
>    - the allocation size isn't sizeof(short)*nsems anymore.
>    - ipc_alloc falls back to vmalloc
> 
> - SEMOPM should stay below 1000, to limit the kmalloc in semtimedop() to an
>   order=1 allocation.
>   Therefore: Leave it at 500 (order=0 allocation).
> 
> Note:
> If an administrator must limit the memory allocations, then he can set the
> values as necessary.
> 
> Or he can disable sysv entirely (as e.g. done by Android).
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---

Acked-by: Rafael Aquini <aquini@redhat.com>


>  include/uapi/linux/sem.h | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
> index 541fce0..dd73b90 100644
> --- a/include/uapi/linux/sem.h
> +++ b/include/uapi/linux/sem.h
> @@ -63,10 +63,22 @@ struct  seminfo {
>  	int semaem;
>  };
>  
> -#define SEMMNI  128             /* <= IPCMNI  max # of semaphore identifiers */
> -#define SEMMSL  250             /* <= 8 000 max num of semaphores per id */
> +/*
> + * SEMMNI, SEMMSL and SEMMNS are default values which can be
> + * modified by sysctl.
> + * The values has been chosen to be larger than necessary for any
> + * known configuration.
> + *
> + * SEMOPM should not be increased beyond 1000, otherwise there is the
> + * risk that semop()/semtimedop() fails due to kernel memory fragmentation when
> + * allocating the sop array.
> + */
> +
> +
> +#define SEMMNI  32000           /* <= IPCMNI  max # of semaphore identifiers */
> +#define SEMMSL  32000           /* <= INT_MAX max num of semaphores per id */
>  #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
> -#define SEMOPM  32	        /* <= 1 000 max num of ops per semop call */
> +#define SEMOPM  500	        /* <= 1 000 max num of ops per semop call */
>  #define SEMVMX  32767           /* <= 32767 semaphore maximum value */
>  #define SEMAEM  SEMVMX          /* adjust on exit max value */
>  
> -- 
> 1.9.3
> 
