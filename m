Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbbAHNLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:11:40 -0500
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:59471 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbbAHNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:11:38 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 08:11:38 EST
Message-ID: <54AE7D4F.2040300@cantab.net>
Date: Thu, 08 Jan 2015 12:51:27 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>
In-Reply-To: <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: dvrabel@cantab.net
Subject: Re: [Xen-devel] [RFC 2/2] x86, vdso, pvclock: Simplify and speed
 up the vdso pvclock reader
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on pear.davidvrabel.org.uk)
X-Originating-smarthost01b-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/12/2014 00:39, Andy Lutomirski wrote:
> The pvclock vdso code was too abstracted to understand easily and
> excessively paranoid.  Simplify it for a huge speedup.
>
> This opens the door for additional simplifications, as the vdso no
> longer accesses the pvti for any vcpu other than vcpu 0.
>
> Before, vclock_gettime using kvm-clock took about 64ns on my machine.
> With this change, it takes 19ns, which is almost as fast as the pure TSC
> implementation.

Xen guests don't use any of this at the moment, and I don't think this 
change would prevent us from using it in the future, so:

Acked-by: David Vrabel <david.vrabel@citrix.com>

But see some additional comments below.

> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -78,47 +78,59 @@ static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
>
>   static notrace cycle_t vread_pvclock(int *mode)
>   {
> -	const struct pvclock_vsyscall_time_info *pvti;
> +	const struct pvclock_vcpu_time_info *pvti = &get_pvti(0)->pvti;

Xen updates pvti when scheduling a VCPU.  Using 0 here requires that 
VCPU 0 has been recently scheduled by Xen.  Perhaps using the current 
CPU here would be better?  It doesn't matter if the task is subsequently 
moved to a different CPU before using pvti.

> +	 * Note: The kernel and hypervisor must guarantee that cpu ID
> +	 * number maps 1:1 to per-CPU pvclock time info.
> +	 *
> +	 * Because the hypervisor is entirely unaware of guest userspace
> +	 * preemption, it cannot guarantee that per-CPU pvclock time
> +	 * info is updated if the underlying CPU changes or that that
> +	 * version is increased whenever underlying CPU changes.
> +	 *
> +	 * On KVM, we are guaranteed that pvti updates for any vCPU are
> +	 * atomic as seen by *all* vCPUs.  This is an even stronger
> +	 * guarantee than we get with a normal seqlock.
>   	 *
> +	 * On Xen, we don't appear to have that guarantee, but Xen still
> +	 * supplies a valid seqlock using the version field.
> +
> +	 * We only do pvclock vdso timing at all if
> +	 * PVCLOCK_TSC_STABLE_BIT is set, and we interpret that bit to
> +	 * mean that all vCPUs have matching pvti and that the TSC is
> +	 * synced, so we can just look at vCPU 0's pvti.

I think this is a much stronger requirement than you actually need.

You only require:

- the system time (pvti->system_time) for all pvti's is synchronized; and
- TSC is synchronized; and
- the pvti has been updated sufficiently recently (so the error in the 
result is within acceptable margins).

Can you add documentation to arch/x86/include/asm/pvclock-abi.h to 
describe what properties PVCLOCK_TSC_STABLE_BIT guarantees?

David
