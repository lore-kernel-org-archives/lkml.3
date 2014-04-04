Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaDDUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:25:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56306 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753472AbaDDUZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:25:27 -0400
Date: Fri, 4 Apr 2014 16:25:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: konrad@kernel.org
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH] xen/spinlock: Don't enable them unconditionally.
Message-ID: <20140404162524.31c823a9@gandalf.local.home>
In-Reply-To: <1396637284-6312-1-git-send-email-konrad@kernel.org>
References: <1396637284-6312-1-git-send-email-konrad@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Apr 2014 14:48:04 -0400
konrad@kernel.org wrote:

> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> The git commit a945928ea2709bc0e8e8165d33aed855a0110279
> ('xen: Do not enable spinlocks before jump_label_init() has executed')
> was added to deal with the jump machinery. Earlier the code
> that turned on the jump label was only called by Xen specific
> functions. But now that it had been moved to the initcall machinery
> it gets called on Xen, KVM, and baremetal - ouch!. And the detection
> machinery to only call it on Xen wasn't remembered in the heat
> of merge window excitement.
> 
> This means that the slowpath is enabled on baremetal while it should
> not be.
> 
> Reported-by: Waiman Long <waiman.long@hp.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> CC: stable@vger.kernel.org
> CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> CC: David Vrabel <david.vrabel@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/spinlock.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 581521c..c570fea 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -274,7 +274,7 @@ void __init xen_init_spinlocks(void)
>  		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
>  		return;
>  	}
> -
> +	printk(KERN_DEBUG "xen: PV spinlocks enabled\n");
>  	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
>  	pv_lock_ops.unlock_kick = xen_unlock_kick;
>  }
> @@ -290,6 +290,9 @@ static __init int xen_init_spinlocks_jump(void)
>  	if (!xen_pvspin)
>  		return 0;
>  
> +	if (!xen_domain())
> +		return 0;
> +
>  	static_key_slow_inc(&paravirt_ticketlocks_enabled);
>  	return 0;
>  }

