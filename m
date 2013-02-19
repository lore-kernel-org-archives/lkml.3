Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab3BSSMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:12:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7390 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227Ab3BSSMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:12:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,696,1355097600"; 
   d="scan'208";a="7830505"
Date: Tue, 19 Feb 2013 18:12:35 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH LINUX v4] xen: event channel arrays are xen_ulong_t and
 not unsigned long
In-Reply-To: <1361294951-28633-1-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.02.1302191808110.4654@kaball.uk.xensource.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com> <1361294951-28633-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Ian Campbell wrote:
> On ARM we want these to be the same size on 32- and 64-bit.
> 
> This is an ABI change on ARM. X86 does not change.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jan Beulich <JBeulich@suse.com>
> Cc: Keir (Xen.org) <keir@xen.org>
> Cc: Tim Deegan <tim@xen.org>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> Changes since V3
>   s/read_evtchn_pending_sel/xchg_xen_ulong/ in a comment.
> Changes since V2
>   Add comments about the correct bitops to use, and on the ordering/barrier
>   requirements on xchg_xen_ulong.
> Changes since V1
>   use find_first_set not __ffs
>   fix some more unsigned long -> xen_ulong_t
>   use more generic xchg_xen_ulong instead of ...read_evtchn...

still doesn't apply to 3.8


>         do {
> -               unsigned long pending_words;
> +               xen_ulong_t pending_words;
> 
>                 vcpu_info->evtchn_upcall_pending = 0;
> 
>                 if (__this_cpu_inc_return(xed_nesting_count) - 1)
>                         goto out;
> 
> -#ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
> -               /* Clear master flag /before/ clearing selector flag. */
> -               wmb();
> -#endif
> -               pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
> +               /*
> +                * Master flag must be /before/ clearing selector
> +                * flag. xchg_xen_ulong must contain an appropriate
> +                * barrier.
> +                */

Master flag must be *cleared* ...

> +               pending_words = xchg_xen_ulong(&vcpu_info->evtchn_pending_sel, 0);
> 
>                 start_word_idx = __this_cpu_read(current_word_idx);
>                 start_bit_idx = __this_cpu_read(current_bit_idx);
