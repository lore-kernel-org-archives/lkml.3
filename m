Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaBNSIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:08:47 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54749 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaBNSIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:08:44 -0500
Message-ID: <52FE5A62.90100@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 23:33:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "paulus@samba.org" <paulus@samba.org>, oleg@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Michel Lespinasse <walken@google.com>, ego@linux.vnet.ibm.com,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 27/52] x86, pci, amd-bus: Fix CPU hotplug callback
 registration
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com> <20140214075511.22701.15084.stgit@srivatsabhat.in.ibm.com> <CAErSpo4nyoY8jCR5omywB06ka5T-qKMQURSO6c3_569o-WbOgw@mail.gmail.com>
In-Reply-To: <CAErSpo4nyoY8jCR5omywB06ka5T-qKMQURSO6c3_569o-WbOgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021418-8878-0000-0000-00000AE283CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 11:05 PM, Bjorn Helgaas wrote:
> On Fri, Feb 14, 2014 at 12:55 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>> initialization for the CPUs that are already online, often do it as shown
>> below:
>>
>>         get_online_cpus();
>>
>>         for_each_online_cpu(cpu)
>>                 init_cpu(cpu);
>>
>>         register_cpu_notifier(&foobar_cpu_notifier);
>>
>>         put_online_cpus();
>>
>> This is wrong, since it is prone to ABBA deadlocks involving the
>> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
>> with CPU hotplug operations).
>>
>> Instead, the correct and race-free way of performing the callback
>> registration is:
>>
>>         cpu_notifier_register_begin();
>>
>>         for_each_online_cpu(cpu)
>>                 init_cpu(cpu);
>>
>>         /* Note the use of the double underscored version of the API */
>>         __register_cpu_notifier(&foobar_cpu_notifier);
>>
>>         cpu_notifier_register_done();
>>
>>
>> Fix the amd-bus code in x86 by using this latter form of callback
>> registration.
>>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: linux-pci@vger.kernel.org
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> This looks fine to me.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> I think it makes sense for you to merge it along with all your other
> similar changes.  I don't foresee any conflicts with things in my PCI
> tree.
> 

Great! Thank you!

Regards,
Srivatsa S. Bhat

