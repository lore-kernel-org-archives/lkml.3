Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3CHHZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:25:17 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48872 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3CHHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:25:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130308070651.GN14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-5-git-send-email-yinghai@kernel.org>
	<20130308055023.GF14556@mtj.dyndns.org>
	<CAE9FiQVXOC71BGSK3t_xg+nP5Qq8ZKoup0sTMJDPnv-y8++=hg@mail.gmail.com>
	<20130308070651.GN14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 23:25:14 -0800
X-Google-Sender-Auth: 6Qtvj0Zc-f3JSYhEMOoIJ6MZ5w8
Message-ID: <CAE9FiQXWzYVeCJOGffsvp3-wUHEMP21f3EA8Qcswn-B4fXC5uQ@mail.gmail.com>
Subject: Re: [PATCH 04/14] x86, ACPI: make acpi override finding work with
 32bit flat mode
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:06 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Yinghai.
>
> On Thu, Mar 07, 2013 at 10:57:21PM -0800, Yinghai Lu wrote:
>> On Thu, Mar 7, 2013 at 9:50 PM, Tejun Heo <tj@kernel.org> wrote:
>> > On Thu, Mar 07, 2013 at 08:58:30PM -0800, Yinghai Lu wrote:
>> >> We will find acpi tables in initrd during head_32.S in 32bit flat mode.
>> >>
>> >> So need acpi_initrd_override_find could take phys directly.
>> >
>> > The patch description doesn't explain even half of what's going on.
>>
>> hope HPA could understand.
>>
>> Access initrd before relocate_initrd and init_memory mapping.
>
> I really hope the changelogs were better.  Eh well...
>
>> >> -/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
>> >> -static const char * const table_sigs[] = {
>> >> -     ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
>> >> -     ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
>> >> -     ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
>> >> -     ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
>> >> -     ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
>> >> -     ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
>> >> -     ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
>> >> -     ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
>> >> -     ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
>> >
>> > Why is this table made a stack variable?  What's the benefit of doing
>> > that?
>>
>> so I do need to switch global variables to phys and access it.
>
> I can't really understand what your response means.  Can you please
> elaborate?

sorry, I missed NOT.

so I do NOT need to switch global variables from kernel virtual addr
to phys address and access it
in 32bit flat mode.

>
>> > Is it really necessary to make the function take both virtual and
>> > physical addresses?  Can't we just make the function take phys_addr_t
>> > and update everyone to call with physaddr?  Also @is_phys isn't simple
>> > address switch.  It also changes error reporting.  If you're gonna
>> > keep @is_phys, let's at least write up a function comment explaining
>> > what's going on and why we need it.  But, really, if at all possible,
>> > let's change the function to take single type of argument and
>> > predicate error message printing on something else (e.g. early printk
>> > initialized or whatever).
>>
>> yes, one for 32bit from head_32.S, phys.
>> one for 64bit from head64.c. with _va.
>
> head64.c can't call with phys?  Why not?

HPA's #PF set up page table only handle kernel low mapping address.

and after reset_early_page_tables, only kernel high mapping address is
there. and other low mapping will be supported via #PF handler.

>
>> Not sure if I could use early_printk from head_32.S, as Fenghua does
>> not print out
>> from microcode updating early in the same parts.
>
> ISTR it works but it doens't have to (although it would be much nicer
> if it did).  You can test whether printk is online and skip if it
> isn't online yet.

ok, will give it try.

Thanks

Yinghai
