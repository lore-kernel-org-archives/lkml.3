Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3FJU2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3FJU2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:28:49 -0400
Date: Mon, 10 Jun 2013 17:19:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, eabatalov89@gmail.com
Subject: Re: [PATCH] x86: kvmclock: zero initialize pvclock shared memory area
Message-ID: <20130610201933.GA31409@amt.cnet>
References: <bug-59521-28872@https.bugzilla.kernel.org/>
 <1370881871-13130-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370881871-13130-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 06:31:11PM +0200, Igor Mammedov wrote:
> ===
> Could be the following an acceptable fix?
> ===

Read of kvmclock should return proper value from hypervisor: system
timestamp + tsc delta.

Should find the offender site and have it register MSR_KVM_SYSTEM_TIME 
before reading the area.

> kernel might hung in pvclock_clocksource_read() due to
> uninitialized memory might contain odd version value in
> following cycle:
> 
>         do {
>                 version = __pvclock_read_cycles(src, &ret, &flags);
>         } while ((src->version & 1) || version != src->version);
> 
> if secondary kvmclock is accessed before it's registered with kvm.
> 
> Clear garbage in pvclock shared memory area right after it's
> allocated to avoid this issue.
> 
> Ref: https://bugzilla.kernel.org/show_bug.cgi?id=59521
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/kernel/kvmclock.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index d2c3812..3dd37eb 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -242,6 +242,7 @@ void __init kvmclock_init(void)
>  	if (!mem)
>  		return;
>  	hv_clock = __va(mem);
> +	memset(hv_clock, 0, size);
>  
>  	if (kvm_register_clock("boot clock")) {
>  		hv_clock = NULL;
> -- 
> 1.7.1
