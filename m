Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaJPNlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:41:50 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:37018 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJPNls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:41:48 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH v1 08/10] kgdb: Remove "weak" from kgdb_arch_pc()
 declaration
Thread-Topic: [PATCH v1 08/10] kgdb: Remove "weak" from kgdb_arch_pc()
 declaration
Thread-Index: AQHP6NCzoZYP2peMAkS/4mrPQEMPvg==
Date: Thu, 16 Oct 2014 13:38:39 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5E7669@IN01WEMBXA.internal.synopsys.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170637.4063.22185.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <CAErSpo4j060imN0SOZM0LUc0hymDZMg4b3PcMhCChsubWfcNGA@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Thursday 16 October 2014 05:05 AM, Bjorn Helgaas wrote:
> [+cc Harvey, Vineet, linux-sh; arc, sh, and x86 have kgdb_arch_pc()
> definitions and could see issues from this]

Thanks for the heads up !

I compile tested arc tree (with kgdb) from linux-next of today, which has this
patch already and things seem to be ok.

As a hack I reverted the patch and see that kgdb_arch_pc() becomes weak, although
ARC version was still being pulled in final - it was recored as weak and that
cause bloat-o-meter to go awry.

bloat-o-meter vmlinux-with-fix vmlinux-before-fix
add/remove: 0/1 grow/shrink: 1/0 up/down: 1/-8 (-7)
function                                     old     new   delta
vermagic                                      36      37      +1
kgdb_arch_pc                                 8       -      -8

So functionally we are same as before - which is good.
If you need it.

Tested-by: Vineet Gupta <vgupta@synopsys.com>   #for ARC build

Thx,
-Vineet
>
> On Wed, Oct 15, 2014 at 11:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> kernel/debug/debug_core.c provides a default kgdb_arch_pc() definition
>> explicitly marked "weak".  Several architectures provide their own
>> definitions intended to override the default, but the "weak" attribute on
>> the declaration applied to the arch definitions as well, so the linker
>> chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
>> annotation from pcibios_get_phb_of_node decl")).
>>
>> Remove the "weak" attribute from the declaration so we always prefer a
>> non-weak definition over the weak one, independent of link order.
>>
>> Fixes: 688b744d8bc8 ("kgdb: fix signedness mixmatches, add statics, add declaration to header")
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> CC: Harvey Harrison <harvey.harrison@gmail.com>
>> ---
>>  include/linux/kgdb.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
>> index 6b06d378f3df..e465bb15912d 100644
>> --- a/include/linux/kgdb.h
>> +++ b/include/linux/kgdb.h
>> @@ -283,7 +283,7 @@ struct kgdb_io {
>>
>>  extern struct kgdb_arch                arch_kgdb_ops;
>>
>> -extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
>> +extern unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs);
>>
>>  #ifdef CONFIG_SERIAL_KGDB_NMI
>>  extern int kgdb_register_nmi_console(void);
>>

