Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaGOUeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:34:07 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:53073 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbaGOUeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4xH2hpPMhm-4F+jNGKeMPjA2Tr8bQEkbWQGXpbwX6W4g@mail.gmail.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
 <CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>
 <20140710200527.GA15190@google.com> <3524198.dm6HbYTJqK@calvin> <CAErSpo4xH2hpPMhm-4F+jNGKeMPjA2Tr8bQEkbWQGXpbwX6W4g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 15 Jul 2014 14:33:41 -0600
Message-ID: <CAErSpo5u_KAfZL0EDVGCZ5nfvmiyv+V3+5Lw6aYoXvTouv_MeQ@mail.gmail.com>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Yinghai, Rafael]

On Fri, Jul 11, 2014 at 12:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jul 11, 2014 at 1:38 AM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
>> In data giovedì 10 luglio 2014 14:05:27, Bjorn Helgaas ha scritto:
>>> ...
>>> Fabio, can you pastebin your complete dmesg log?
>>
>> Sure, here you go:
>>
>> http://pastebin.com/FiL7N64b
>
> I opened this bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=80041 and attached your
> dmesg to it.  I see what the problem is, but I don't have a good idea
> yet for how to fix it.
>
> The problem is that we don't handle e820 and PNP device resource
> information correctly.  From the attached dmesg, we have this:
>
>   BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
>   system 00:00: [mem 0xfed10000-0xfed17fff] could not be reserved
>
> The 00:00 PNP device describes the correct 32K range for the Intel MCH
> (see [1] for details).  But the [mem 0xfed10000-0xfed13fff] entry from
> e820 was added to the resource map first, and it covers only the first
> 16K of the MCH range.  This caused the subsequent PNP reservation to
> fail.  Then the snb_uncore_imc_init_box() reservation caused the
> warning, because it would be a child of the e820 entry but it covers
> more space.
>
> [1] fixed a similar issue where the PNP device described only the
> first 16K of the MCH range.  This case is slightly different because
> here it's the e820 entry that is incorrect.
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=cb171f7abb9a

One of the reasons for iomem_resource is so we don't hand out the same
address space to two different devices.  We *could* do that by keeping
track of the union of all devices and reserved areas that we know
about.

But the current resource code is more strict: it enforces a hierarchy.
For example, in this case, it rejects the 00:00 PNP resource because
it is larger than the e820 entry.  The problem with rejecting it is
that we might hand out [mem 0xfed14000-0xfed17fff] to another device
even though PNP told us that it's in use.

I'm about to head out for a few weeks of vacation, so I won't be able
to do anything with this.

Bjorn
