Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaHZUXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:23:41 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:36637 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaHZUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <1409083725.28990.115.camel@misato.fc.hp.com>
References: <1409033783-12136-1-git-send-email-jgross@suse.com>
 <53FCD68A.40509@amacapital.net> <1409083725.28990.115.camel@misato.fc.hp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 26 Aug 2014 13:23:16 -0700
Message-ID: <CALCETrVL-E0neRQq7AZhcmhJFPrLGHBkW+v39h9oM2onTEBpLA@mail.gmail.com>
Subject: Re: [PATCH 0/3] x86: Full support of PAT
To: Toshi Kani <toshi.kani@hp.com>
Cc: Juergen Gross <jgross@suse.com>, Stefan Bader <stefan.bader@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        ville.syrjala@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 1:08 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Tue, 2014-08-26 at 11:48 -0700, Andy Lutomirski wrote:
>> On 08/25/2014 11:16 PM, Juergen Gross wrote:
>> > The x86 architecture offers via the PAT (Page Attribute Table) a way to
>> > specify different caching modes in page table entries. The PAT MSR contains
>> > 8 entries each specifying one of 6 possible cache modes. A pte references one
>> > of those entries via 3 bits: _PAGE_PAT, _PAGE_PWT and _PAGE_PCD.
>> >
>> > The Linux kernel currently supports only 4 different cache modes. The PAT MSR
>> > is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
>> > top 4 entries in the PAT MSR are the same as the 4 lower entries.
>> >
>> > This results in the kernel not supporting e.g. write-through mode. Especially
>> > this cache mode would speed up drivers of video cards which now have to use
>> > uncached accesses.
>> >
>> > OTOH some old processors (Pentium) don't support PAT correctly and the Xen
>> > hypervisor has been using a different PAT MSR configuration for some time now
>> > and can't change that as this setting is part of the ABI.
>> >
>> > This patch set abstracts the cache mode from the pte and introduces tables to
>> > translate between cache mode and pte bits (the default cache mode "write back"
>> > is hard-wired to PAT entry 0). The tables are statically initialized with
>> > values being compatible to old processors and current usage. As soon as the
>> > PAT MSR is changed (or - in case of Xen - is read at boot time) the tables are
>> > changed accordingly. Requests of mappings with special cache modes are always
>> > possible now, in case they are not supported there will be a fallback to a
>> > compatible but slower mode.
>>
>> I feel like I'm missing something here.  Where's the support for the
>> high PAT bit on huge pages?  Once you start using the top four entries,
>> you'll need that.
>
> pgprot_4k_2_large() and pgprot_large_2_4k() provide the conversion of
> the PAT bit.

Whoops, I missed that.

>
>> Also, this probably needs errata handling.  IIRC there are a handful of
>> CPUs that support PAT but don't work correctly if the high bit is set.
>
> This patchset provides the infrastructure, but does not actually use the
> upper four entries.  I am working on additional patchset on top of this,
> which enables WT with the PAT bit except on the following Intel
> processors.  If I missed some processors affected, please let me know.
>
>   errata           cpuid
>   --------------------------------------
>   Pentium 2, A52   family 0x6, model 0x5
>   Pentium 3, E27   family 0x6, model 0x7
>   Pentium M, Y26   family 0x6, model 0x9
>   Pentium 4, N46   family 0xf, model 0x0
>

>From very vague memory, that sounds correct.

--Andy
