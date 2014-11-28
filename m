Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaK1RKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:10:35 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:59530 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaK1RKe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 28 Nov 2014 12:10:34 -0500
Message-Id: <5478BA97020000780004B83E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 28 Nov 2014 17:10:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Steven Rostedt" <rostedt@goodmis.org>, <akpm@linux-foundation.org>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqflags: fix (at least latent) code generation
 issue
References: <54589AFA0200007800044A77@mail.emea.novell.com>
 <20141110121349.GA21120@gmail.com>
In-Reply-To: <20141110121349.GA21120@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.11.14 at 13:13, <mingo@kernel.org> wrote:
> * Jan Beulich <JBeulich@suse.com> wrote:
>> @@ -131,7 +131,7 @@
>>  	} while (0)
>>  
>>  
>> -#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
>> +#else /* !CONFIG_TRACE_IRQFLAGS */
>>  
>>  #define local_irq_enable()	do { raw_local_irq_enable(); } while (0)
>>  #define local_irq_disable()	do { raw_local_irq_disable(); } while (0)
>> @@ -145,6 +145,6 @@
>>  #define irqs_disabled_flags(flags) (raw_irqs_disabled_flags(flags))
>>  #define safe_halt()		do { raw_safe_halt(); } while (0)
>>  
>> -#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>> +#endif /* CONFIG_TRACE_IRQFLAGS */
> 
> So this breaks a couple of non-x86 architectures, such as MIPS:
> 
> /home/mingo/tip/include/acpi/platform/aclinuxex.h: In function 
> 'acpi_os_allocate':
> /home/mingo/tip/include/acpi/platform/aclinuxex.h:86: error: implicit 
> declaration of function 'arch_irqs_disabled'

Now that I finally found time to look into this a little, I wonder what
you expect: Code in linux/irqflags.h ahead of the above conditional
uses arch_irqs_disable():

#define raw_irqs_disabled()		(arch_irqs_disabled())

so it would seem to me that architectures are required to have the
latter available. And in fact it would seem very logical to me if pieces
like the definition of irqs_disabled() would be pulled out of that
conditional, as their behavior shouldn't (for this one) or already
doesn't (for e.g. irqs_disabled_flags() and local_save_flags()) differ
between the two cases. Would, short of adding arch_irqs_disabled()
for all architectures currently lacking it, uniformly using the definition
from the #if portion of the conditional be an acceptable thing? If not,
do you have any other suggestion on how to resolve this?

Jan

