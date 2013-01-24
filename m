Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3AXMNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:13:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56873 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3AXMN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:13:28 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130124092821.GA13463@pd.tnic>
References: <1358992569-22826-1-git-send-email-kys@microsoft.com> <20130124092821.GA13463@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 24 Jan 2013 06:11:32 -0600
To: Borislav Petkov <bp@alien8.de>, "K. Y. Srinivasan" <kys@microsoft.com>
CC: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com
Message-ID: <04854149-91a3-4834-b2bb-de301c8241c9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds great in theory at least, as long as it doesn't mean pushing a bunch of #ifdefs into other code.

Borislav Petkov <bp@alien8.de> wrote:

>On Wed, Jan 23, 2013 at 05:56:09PM -0800, K. Y. Srinivasan wrote:
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index 1975122..803ca69 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -1446,11 +1446,16 @@ ENTRY(xen_failsafe_callback)
>>  	CFI_ENDPROC
>>  END(xen_failsafe_callback)
>>  
>> -apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
>> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
>>  	xen_hvm_callback_vector xen_evtchn_do_upcall
>>  
>>  #endif /* CONFIG_XEN */
>>  
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
>> +	hyperv_callback_vector hyperv_vector_handler
>> +#endif /* CONFIG_HYPERV */
>
>arch/x86/built-in.o: In function `_set_gate':
>/w/kernel/linux-2.6/arch/x86/include/asm/desc.h:328: undefined
>reference to `hyperv_callback_vector'
>make: *** [vmlinux] Error 1
>
>because, of course:
>
># CONFIG_HYPERV is not set
>
>But, I have a more serious pet-peeve with the whole hypervisors
>detection stuff: we're building arch/x86/kernel/cpu/hypervisor.c
>unconditionally and yet, we have CONFIG_PARAVIRT_GUEST to ask the user
>whether she wants to enable some options for running linux as a guest.
>
>And actually, it would be better to put all that virt-related stuff
>under a config option called HYPERVISOR or whatever, under "Processor
>type and features" which opens a menu with all virt stuff for people
>and
>distros to select.
>
>This way, init_hypervisor_platform and the rest of hypervisors stuff
>won't run needlessly on baremetal and setups who don't want that.
>
>Any non-starter reasons for not doing that?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
