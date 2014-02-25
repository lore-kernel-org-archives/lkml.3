Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBYRPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:15:42 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:33137 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaBYRPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:15:41 -0500
Date: Tue, 25 Feb 2014 12:15:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexander Graf <agraf@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
Message-ID: <20140225171528.GJ4407@cmpxchg.org>
References: <1393284484-27637-1-git-send-email-agraf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393284484-27637-1-git-send-email-agraf@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 12:28:04AM +0100, Alexander Graf wrote:
> Configuration of tunables and Linux virtual memory settings has traditionally
> happened via sysctl. Thanks to that there are well established ways to make
> sysctl configuration bits persistent (sysctl.conf).
> 
> KSM introduced a sysfs based configuration path which is not covered by user
> space persistent configuration frameworks.
> 
> In order to make life easy for sysadmins, this patch adds all access to all
> KSM tunables via sysctl as well. That way sysctl.conf works for KSM as well,
> giving us a streamlined way to make KSM configuration persistent.
> 
> Reported-by: Sasche Peilicke <speilicke@suse.com>
> Signed-off-by: Alexander Graf <agraf@suse.de>
> ---
>  kernel/sysctl.c |   10 +++++++
>  mm/ksm.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 332cefc..2169a00 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -217,6 +217,9 @@ extern struct ctl_table random_table[];
>  #ifdef CONFIG_EPOLL
>  extern struct ctl_table epoll_table[];
>  #endif
> +#ifdef CONFIG_KSM
> +extern struct ctl_table ksm_table[];
> +#endif
>  
>  #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
>  int sysctl_legacy_va_layout;
> @@ -1279,6 +1282,13 @@ static struct ctl_table vm_table[] = {
>  	},
>  
>  #endif /* CONFIG_COMPACTION */
> +#ifdef CONFIG_KSM
> +	{
> +		.procname	= "ksm",
> +		.mode		= 0555,
> +		.child		= ksm_table,
> +	},
> +#endif

ksm can be a module, so this won't work.

Can we make those controls proper module parameters instead?
