Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaHUX1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:27:44 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54638 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaHUX1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140821070021.GA25888@gmail.com>
References: <1358804360-29639-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQX0bUdWz6bmqLKDHpY5mvjEYdobseroCRnu0-Ju0qmsPw@mail.gmail.com>
	<1f7d783e-5b26-495d-83d5-5d522eb3941e@email.android.com>
	<CAE9FiQWPiVb_hySAADQypuZtcTN+iEQb4hoO=-+iurdsmKqKrg@mail.gmail.com>
	<CAE9FiQUcq05K1mR5E7K-MT3+Z4xxckxO+o9RJ6QDwiGG1T_3aQ@mail.gmail.com>
	<CAE9FiQVHcPH3aOU3uD=PsWay1w+csSDzZk62tpMXVgsFVMW1wg@mail.gmail.com>
	<CAE9FiQVGZf_cRMK0spp9=YhG8SsrK+FY6fi00pCxZcEL1Ne-kg@mail.gmail.com>
	<CAE9FiQW6q860P4+qQWTwt0k0vjOJ-S6FdyZHv06=0qv1Z97C=g@mail.gmail.com>
	<20140821070021.GA25888@gmail.com>
Date: Thu, 21 Aug 2014 16:27:42 -0700
X-Google-Sender-Auth: K6tdPKn-AsB-sswj9JKBR8CWgfY
Message-ID: <CAE9FiQUXO_K1y2=L+neyjxDsoEXGQuTj0hdsR7T+KumqaaN3+w@mail.gmail.com>
Subject: Re: [PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at
 same time
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 12:00 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> (lkml Cc:-ed, in case someone wants to help out.)
>
> The changelog quality and organization of your submitted
> patches is still poor, they are hard to read and review. This
> is a repeat complaint against your patches, yet not much has
> happened over the last few years. Please improve them before
> resending your patches.
>
> As a positive example, here's a couple of x86 architecture
> commits with good changelogs:
>
> 95d76acc7518 ("x86, irq: Count legacy IRQs by legacy_pic->nr_legacy_irqs instead of NR_IRQS_LEGACY")
> 6b9fb7082409 ("x86, ACPI, irq: Consolidate algorithm of mapping (ioapic, pin) to IRQ number")
> 2e0ad0e2c135 ("x86, ACPI, irq: Fix possible error in GSI to IRQ mapping for legacy IRQ")
> 44a69f619562 ("acpi, apei, ghes: Make NMI error notification to be GHES architecture extension")
>
> Please match or exceed the changelog quality of these commits.

How about this version ?

Subject: [PATCH -v3] x86, acpi: Make cpu sequence to be consistent with MADT
From: Yinghai Lu <yinghai@kernel.org>

On 8 socket system that x2apic is pre-enabled, get following sequence:
CPU0: socket0, core0, thread0.
CPU1 - CPU 40: socket 4 - socket 7, thread 0
CPU41 - CPU 80: socket 4 - socket 7, thread 1
CPU81 - CPU 119: socket 0 - socket 3, thread 0
CPU120 - CPU 159: socket 0 - socket 3, thread 1

The system has mixing xapic and x2apic entries in MADT and SRAT.
Current kernel parse all x2apic entries before all xapic entries, and
the same reserve CPU0 slot for boot cpu, so we get out of order
cpu sqeuence.

Some users have scripts that just assume that that cpu sequence is same
as socket0, and then next sockets. According to socket number/core number
in the system, they have simple mapping from kernel cpu index to socket
index.

BIOS guys insist that ACPI 4.0 SPEC says if apic id < 255, even
the cpus are with x2apic mode pre-enabled, still need to use xapic entries
instead of x2apic entries.

We could check every entry in MADT with xapic and x2apic instead of
checking all entries with x2apic then check all entries with xapic.

After patch we have:
CPU0 - CPU 79: socket 0 - socket 7, thread 0
CPU80 - CPU 159: socket 0 - socket 7, thread 1
and we have same cpu sequence as that in MADT.

-v2: update some comments, and change to pass array pointer.
-v3: update changelog.
