Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaFMNaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:30:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29808 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaFMNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:30:04 -0400
Message-ID: <539AFD29.6060401@oracle.com>
Date: Fri, 13 Jun 2014 09:31:21 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] xenpv: don't BUG when failing to setup NMI callback
References: <1402658788-24477-1-git-send-email-vkuznets@redhat.com> <20140613124534.GA21873@laptop.dumpdata.com>
In-Reply-To: <20140613124534.GA21873@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 08:45 AM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 13, 2014 at 01:26:28PM +0200, Vitaly Kuznetsov wrote:
>> some old Xen hypervisors (prior to 3.2) forbid DomUs to register
>> NMI callbacks. E.g. we have the following code in xen-3.1:
>>
>>      if ( (d->domain_id != 0) || (v->vcpu_id != 0) )
>>          return -EINVAL;
>>
>> Commit 6efa20e49b9cb1db1ab66870cc37323474a75a13 introduced kernel
>> crash in case PV guest fails to register NMI callback. All x86_64
>> PV guests will fail to boot on top of such hypervisors (RHEL5
>> example):
>>
>> (XEN) traps.c:405:d7 Unhandled invalid opcode fault/trap [#6] in domain 7 on VCPU 0 [ec=0000]
>> (XEN) domain_crash_sync called from entry.S
>> (XEN) Domain 7 (vcpu#0) crashed on cpu#3:
>> (XEN) ----[ Xen-3.1.2-389.el5  x86_64  debug=n  Not tainted ]----
>> (XEN) CPU:    3
>> (XEN) RIP:    e033:[<ffffffff81004d96>]
>> (XEN) RFLAGS: 0000000000000282   CONTEXT: guest
>> (XEN) rax: ffffffffffffffea   rbx: 0000000000000000   rcx: 0000000000000002
>> (XEN) rdx: 0000000000000001   rsi: ffffffff81b0fe28   rdi: 0000000000000000
>> (XEN) rbp: ffffffff81b0fe40   rsp: ffffffff81b0fde8   r8:  0000000000000000
>> (XEN) r9:  ffffffff81b0fdd0   r10: 0000000000007ff0   r11: 00000000ffffffff
>> (XEN) r12: ffffffff81d65900   r13: 0000000000000000   r14: 0000000000000000
>> (XEN) r15: 0000000000000000   cr0: 0000000080050033   cr4: 00000000000026b0
>> (XEN) cr3: 000000013a263000   cr2: 0000000000000000
>> (XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
>> ...
>>
>> However it is possible to proceed without NMI callback registered.
>> Change BUG() with warning in case of -EINVAL.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Oh, we had a similar patch - somebody reported it earlier - and we
> just checked the version of Xen:
>
> http://lists.xenproject.org/archives/html/xen-devel/2014-05/msg01474.html
>
> But I can't remember why I didn't post it.
>
> However I do like your path of checking the 'ret'.


Should we be checking both ret and version? NMI callback registration 
can return -EINVAL for other reasons (non-canonical address, for example).

-boris


>
> Vitaly, could expand your patch to also do a check in cvt_gate_to_trap
> so that it won't enable the NMI handler and then lets pick your
> patch?
>
>> ---
>>   arch/x86/xen/setup.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index 821a11a..5b8b180 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -593,8 +593,17 @@ void xen_enable_syscall(void)
>>   void xen_enable_nmi(void)
>>   {
>>   #ifdef CONFIG_X86_64
>> -	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
>> +	int ret;
>> +
>> +	ret = register_callback(CALLBACKTYPE_nmi, (char *)nmi);
>> +	if (ret == -EINVAL) {
>> +		/* Hypervisor probably forbids us to register NMI callback,
>> +		   that is expected when running on top of Xen-3.1 and older */
>> +		pr_warn("xen: failed to register NMI callback\n");
>> +	} else if (ret != 0) {
>> +		/* Other hypervisor failure */
>>   		BUG();
>> +	}
>>   #endif
>>   }
>>   void __init xen_pvmmu_arch_setup(void)
>> -- 
>> 1.9.3
>>

