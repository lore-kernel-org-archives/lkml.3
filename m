Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaDCOI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:08:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43928 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaDCOI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:08:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <533D6B28.6070305@jp.fujitsu.com>
Date: Thu, 03 Apr 2014 23:07:36 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] ipc,shm: disable shmmax and shmall by default
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>	 <20140331170546.3b3e72f0.akpm@linux-foundation.org>	 <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>	 <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>	 <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net>	 <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>	 <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net>	 <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>	 <20140401142947.927642a408d84df27d581e36@linux-foundation.org>	 <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>	 <20140401144801.603c288674ab8f417b42a043@linux-foundation.org>	 <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com>	 <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net>	 <CAHGf_=rH+vfFzRrh35TETxjFU2HM0xnDQFweQ+Bfw20Pm2nL3g@mail.gmail.com> <1396484447.2953.1.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1396484447.2953.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/03 9:20), Davidlohr Bueso wrote:
> The default size for shmmax is, and always has been, 32Mb.
> Today, in the XXI century, it seems that this value is rather small,
> making users have to increase it via sysctl, which can cause
> unnecessary work and userspace application workarounds[1].
>
> Instead of choosing yet another arbitrary value, larger than 32Mb,
> this patch disables the use of both shmmax and shmall by default,
> allowing users to create segments of unlimited sizes. Users and
> applications that already explicitly set these values through sysctl
> are left untouched, and thus does not change any of the behavior.
>
> So a value of 0 bytes or pages, for shmmax and shmall, respectively,
> implies unlimited memory, as opposed to disabling sysv shared memory.
> This is safe as 0 cannot possibly be used previously as SHMMIN is
> hardcoded to 1 and cannot be modified.
>
> This change allows Linux to treat shm just as regular anonymous memory.
> One important difference between them, though, is handling out-of-memory
> conditions: as opposed to regular anon memory, the OOM killer will not
> kill processes that are hogging memory through shm, allowing users to
> potentially abuse this. To overcome this situation, the shm_rmid_forced
> option must be enabled.
>
> Running this patch through LTP, everything passes, except the following,
> which, due to the nature of this change, is quite expected:
>
> shmget02    1  TFAIL  :  call succeeded unexpectedly
>
> [1]: http://rhaas.blogspot.com/2012/06/absurd-shared-memory-limits.html
>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

looks good to me
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When this goes mainline, updating a man page of ipcs may be required.

Thanks,
-Kame

> ---
>   include/linux/shm.h      | 2 +-
>   include/uapi/linux/shm.h | 8 ++++----
>   ipc/shm.c                | 6 ++++--
>   3 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/shm.h b/include/linux/shm.h
> index 1e2cd2e..0ca06a3 100644
> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -4,7 +4,7 @@
>   #include <asm/page.h>
>   #include <uapi/linux/shm.h>
>
> -#define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
> +#define SHMALL 0 /* max shm system wide (pages) */
>   #include <asm/shmparam.h>
>   struct shmid_kernel /* private to the kernel */
>   {	
> diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
> index 78b6941..5f0ef28 100644
> --- a/include/uapi/linux/shm.h
> +++ b/include/uapi/linux/shm.h
> @@ -9,14 +9,14 @@
>
>   /*
>    * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
> - * be increased by sysctl
> + * be increased by sysctl. By default, disable SHMMAX and SHMALL with
> + * 0 bytes, thus allowing processes to have unlimited shared memory.
>    */
> -
> -#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
> +#define SHMMAX 0		         /* max shared seg size (bytes) */
>   #define SHMMIN 1			 /* min shared seg size (bytes) */
>   #define SHMMNI 4096			 /* max num of segs system wide */
>   #ifndef __KERNEL__
> -#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
> +#define SHMALL 0
>   #endif
>   #define SHMSEG SHMMNI			 /* max shared segs per process */
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7645961..ae01ffa 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -490,10 +490,12 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>   	int id;
>   	vm_flags_t acctflag = 0;
>
> -	if (size < SHMMIN || size > ns->shm_ctlmax)
> +	if (ns->shm_ctlmax &&
> +	    (size < SHMMIN || size > ns->shm_ctlmax))
>   		return -EINVAL;
>
> -	if (ns->shm_tot + numpages > ns->shm_ctlall)
> +	if (ns->shm_ctlall &&
> +	    ns->shm_tot + numpages > ns->shm_ctlall)
>   		return -ENOSPC;
>
>   	shp = ipc_rcu_alloc(sizeof(*shp));
>


