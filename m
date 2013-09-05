Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3IENE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:04:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45388 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab3IENE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:04:26 -0400
Date: Thu, 5 Sep 2013 14:03:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130905130359.GA22351@mudshark.cambridge.arm.com>
References: <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
 <20130904093335.GA8007@mudshark.cambridge.arm.com>
 <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com>
 <20130904142324.GD3643@mudshark.cambridge.arm.com>
 <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com>
 <20130904174624.GB5599@mudshark.cambridge.arm.com>
 <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com>
 <20130904182113.GD5599@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1309041324530.26497@gentwo.org>
 <00000140eac4f5fc-9f8c86db-05dd-496f-abf8-63ca3667574f-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140eac4f5fc-9f8c86db-05dd-496f-abf8-63ca3667574f-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Christoph,

On Wed, Sep 04, 2013 at 09:58:31PM +0100, Christoph Lameter wrote:
> Here is a patch to be applied after the earlier one to convert the local_t
> use to this_cpu. Not sure if I got the local_dec_and_test conversion
> right.

[...]

> @@ -118,11 +117,11 @@ void disable_debug_monitors(enum debug_e
> 
>  	WARN_ON(preemptible());
> 
> -	if (local_dec_and_test(this_cpu_ptr(&mde_ref_count)))
> +	if (this_cpu_dec_return(mde_ref_count))
>  		disable = ~DBG_MDSCR_MDE;
> 
>  	if (el == DBG_ACTIVE_EL1 &&
> -	    local_dec_and_test(this_cpu_ptr(&kde_ref_count)))
> +	    this_cpu_dec_return(kde_ref_count))
>  		disable &= ~DBG_MDSCR_KDE;

Almost! I think we just need an '== 0' check on the result from the
decrement, since local_dec_and_test is simply a way to check that we've
decremented to zero, so this patch would otherwise invert the meaning.

Will
