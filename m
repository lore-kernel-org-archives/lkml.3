Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbbAVRnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:43:19 -0500
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:58107
	"EHLO know-smtprelay-omc-3.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbbAVRnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:43:17 -0500
X-Originating-IP: [82.33.62.46]
X-Spam: 0
X-Authority: v=2.1 cv=N7qnFgNB c=1 sm=1 tr=0 a=43HWeVr0mW5rhQls5iFsjw==:117
 a=43HWeVr0mW5rhQls5iFsjw==:17 a=5IRWAbXhAAAA:8 a=M1kyBYkWWGkA:10
 a=kj9zAlcOel0A:10 a=YNv0rlydsVwA:10 a=P8IAXAFlsoDwY6_0u5UA:9 a=CjuIK1q_8ugA:10
Date: Thu, 22 Jan 2015 17:43:15 +0000
From: James Dingwall <james@dingwall.me.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
Message-ID: <20150122174315.GA32051@dingwall.me.uk>
References: <20150122055242.GA11089@dingwall.me.uk>
 <20150122082003.GA3441@pd.tnic>
 <54C10DB6.2050708@oracle.com>
 <54C10ED0.1010302@oracle.com>
 <20150122153002.GA3554@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122153002.GA3554@pd.tnic>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:30:02PM +0100, Borislav Petkov wrote:
> On Thu, Jan 22, 2015 at 09:53:04AM -0500, Boris Ostrovsky wrote:
> > Alternatively, we could return an error (-EINVAL?) from
> > microcode_init() when either of these two conditions is true.
> 
> Yeah, this should be the right fix.
> 
> James, does that fix your issue? (It should.)
> 
> ---
> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index 15c29096136b..36a83617eb21 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -552,7 +552,7 @@ static int __init microcode_init(void)
>  	int error;
>  
>  	if (paravirt_enabled() || dis_ucode_ldr)
> -		return 0;
> +		return -EINVAL;
>  
>  	if (c->x86_vendor == X86_VENDOR_INTEL)
>  		microcode_ops = init_intel_microcode();
> 
> -- 

This patch solves it for me on my dom0 with 3.18.3, now there is nothing printed at all from the microcode 
driver which doesn't seem surprising given where the return is.  I'll check it on bare metal at the next 
opportunity but from my understanding of what is happening there I don't see that it should have any impact at 
all.

Thanks,
James
