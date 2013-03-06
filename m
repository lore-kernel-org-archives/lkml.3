Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3CFRuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:50:02 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:47685 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3CFRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:50:00 -0500
Message-ID: <1362591539.12845.124.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] ia64: iosapic: fix kexec oops when iosapic was
 removed
From: Toshi Kani <toshi.kani@hp.com>
To: Hanjun Guo <guohanjun@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Jianguo Wu <wujianguo@huawei.com>
Date: Wed, 06 Mar 2013 10:38:59 -0700
In-Reply-To: <1362368824-29640-1-git-send-email-guohanjun@huawei.com>
References: <1362368824-29640-1-git-send-email-guohanjun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 11:47 +0800, Hanjun Guo wrote:
> Ioapic hotplug was supported in IA64 code, but will lead to kexec oops
> when iosapic was removed. here is the code logic:
> 
> iosapic_remove
>   iosapic_free
>     memset(&iosapic_lists[index], 0, sizeof(iosapic_lists[0]))
>       iosapic_lists[index].addr was set to 0;
> 
> and then kexec a new kernel
> kexec_disable_iosapic
>   iosapic_write(rte->iosapic,..)
>     __iosapic_write(iosapic->addr, reg, val);
>       addr was set to 0 when iosapic_remove, and oops happened
> 
 :
> 
> With Tony and Toshi's advice, the patch removes the "rte" from rte_list
> when the iosapic was removed.
> 
> Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> ---
>  arch/ia64/kernel/iosapic.c |   32 +++++++++++++++++++++++++++++++-
>  1 files changed, 31 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
> index a6e2f75..bc4a0f8 100644
> --- a/arch/ia64/kernel/iosapic.c
> +++ b/arch/ia64/kernel/iosapic.c
> @@ -1010,6 +1010,26 @@ iosapic_check_gsi_range (unsigned int gsi_base, unsigned int ver)
>  	return 0;
>  }
>  
> +static int
> +delete_rte_from_list(unsigned int irq, unsigned int gsi)

I'd prefer to have "iosapic" prefix to the func name, something like
iosapic_delete_rte(), but this is just my preference.  Other than that,
the change looks good to me.

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



