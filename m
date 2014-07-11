Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaGKSMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:12:10 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:56271 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaGKSMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:12:08 -0400
MIME-Version: 1.0
In-Reply-To: <3524198.dm6HbYTJqK@calvin>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
 <CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>
 <20140710200527.GA15190@google.com> <3524198.dm6HbYTJqK@calvin>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 11 Jul 2014 12:11:45 -0600
Message-ID: <CAErSpo4xH2hpPMhm-4F+jNGKeMPjA2Tr8bQEkbWQGXpbwX6W4g@mail.gmail.com>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 1:38 AM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> In data giovedì 10 luglio 2014 14:05:27, Bjorn Helgaas ha scritto:
>> ...
>> Fabio, can you pastebin your complete dmesg log?
>
> Sure, here you go:
>
> http://pastebin.com/FiL7N64b

I opened this bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=80041 and attached your
dmesg to it.  I see what the problem is, but I don't have a good idea
yet for how to fix it.

The problem is that we don't handle e820 and PNP device resource
information correctly.  From the attached dmesg, we have this:

  BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
  system 00:00: [mem 0xfed10000-0xfed17fff] could not be reserved

The 00:00 PNP device describes the correct 32K range for the Intel MCH
(see [1] for details).  But the [mem 0xfed10000-0xfed13fff] entry from
e820 was added to the resource map first, and it covers only the first
16K of the MCH range.  This caused the subsequent PNP reservation to
fail.  Then the snb_uncore_imc_init_box() reservation caused the
warning, because it would be a child of the e820 entry but it covers
more space.

[1] fixed a similar issue where the PNP device described only the
first 16K of the MCH range.  This case is slightly different because
here it's the e820 entry that is incorrect.

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=cb171f7abb9a
