Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaDIOlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:41:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35756 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbaDIOlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:41:40 -0400
X-IronPort-AV: E=Sophos;i="4.97,826,1389744000"; 
   d="scan'208";a="119517846"
Message-ID: <53455C21.6000408@citrix.com>
Date: Wed, 9 Apr 2014 15:41:37 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 32-bit PV guests's usage of
 kernel_stack
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com> <5345739202000078000073EA@nat28.tlf.novell.com> <53455933.2060406@citrix.com>
In-Reply-To: <53455933.2060406@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.18]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 15:29, David Vrabel wrote:
> On 09/04/14 15:21, Jan Beulich wrote:
>>>>> On 09.04.14 at 16:06, <boris.ostrovsky@oracle.com> wrote:
>>> --- a/arch/x86/xen/xen-asm_32.S
>>> +++ b/arch/x86/xen/xen-asm_32.S
>>> @@ -88,7 +88,11 @@ ENTRY(xen_iret)
>>>  	 * avoid having to reload %fs
>>>  	 */
>>>  #ifdef CONFIG_SMP
>>> +	pushw %fs
>>> +	movl $(__KERNEL_PERCPU), %eax
>>> +	movl %eax, %fs
>>>  	GET_THREAD_INFO(%eax)
>>> +	popw %fs
>> I don't think it's guaranteed that this can't fault.
> If loading %fs faults when it is restored previously, the fixup zeros
> the value.  However, this later load could still fault even if the first
> succeeded.
>
> Suggest copying the fixup section from the RESTORE_REGS macros in
> arch/x86/kernel/entry_32.S
>
> David

If loading __KERNEL_PERCPU info fs faults, the kernel has bigger
problems to worry about.

The latter load however can easy fault; The arguments for %ds in 
XSA-42/ CVE-2013-0228 applies to %{e,f,g}s as well.

Furthermore, I am a little concerned about the performance impact of
this.  I would have thought that in most cases, %fs will already be
correct, at which point reloading it twice is a waste of time.

~Andrew
