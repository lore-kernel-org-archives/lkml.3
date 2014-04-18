Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaDRJ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:38 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57048 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaDRJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:26:07 -0400
Message-ID: <5350EFAA.2030607@colorfullife.com>
Date: Fri, 18 Apr 2014 11:26:02 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 04/18/2014 03:25 AM, Davidlohr Bueso wrote:
> So a value of 0 bytes or pages, for shmmax and shmall, respectively,
> implies unlimited memory, as opposed to disabling sysv shared memory.
That might be a second risk:
Right now, a sysadmin can prevent sysv memory allocations with

     # sysctl kernel.shmall=0

After your patch is applied, this line allows unlimited allocations.

Obviously my patch has the opposite problem: 64-bit wrap-arounds.

> --- a/include/uapi/linux/shm.h
> +++ b/include/uapi/linux/shm.h
> @@ -9,14 +9,14 @@
>   
>   /*
>    * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
> - * be increased by sysctl
> + * be modified by sysctl. By default, disable SHMMAX and SHMALL with
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
The "#ifndef __KERNEL__" is not required:
As there is no reference to PAGE_SIZE anymore, one definition for SHMALL 
is sufficient.


--
     Manfred
