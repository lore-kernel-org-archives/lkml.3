Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaDIO3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:29:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36166 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbaDIO3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:29:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,826,1389744000"; 
   d="scan'208";a="118323633"
Message-ID: <53455933.2060406@citrix.com>
Date: Wed, 9 Apr 2014 15:29:07 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 32-bit PV guests's usage of
 kernel_stack
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com> <5345739202000078000073EA@nat28.tlf.novell.com>
In-Reply-To: <5345739202000078000073EA@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 15:21, Jan Beulich wrote:
>>>> On 09.04.14 at 16:06, <boris.ostrovsky@oracle.com> wrote:
>> --- a/arch/x86/xen/xen-asm_32.S
>> +++ b/arch/x86/xen/xen-asm_32.S
>> @@ -88,7 +88,11 @@ ENTRY(xen_iret)
>>  	 * avoid having to reload %fs
>>  	 */
>>  #ifdef CONFIG_SMP
>> +	pushw %fs
>> +	movl $(__KERNEL_PERCPU), %eax
>> +	movl %eax, %fs
>>  	GET_THREAD_INFO(%eax)
>> +	popw %fs
> 
> I don't think it's guaranteed that this can't fault.

If loading %fs faults when it is restored previously, the fixup zeros
the value.  However, this later load could still fault even if the first
succeeded.

Suggest copying the fixup section from the RESTORE_REGS macros in
arch/x86/kernel/entry_32.S

David
