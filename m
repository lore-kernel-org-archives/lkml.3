Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3LSHTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:19:12 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:49492 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3LSHTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:19:11 -0500
MIME-Version: 1.0
In-Reply-To: <52B1F75A.6090403@redhat.com>
References: <1384878243-5086-1-git-send-email-prarit@redhat.com>
	<CANVTcTZo8pN8y7UiSFyGNLWNwRm8nwQyzCFdQJy50z95vV15oQ@mail.gmail.com>
	<52B1F75A.6090403@redhat.com>
Date: Thu, 19 Dec 2013 15:19:08 +0800
Message-ID: <CANVTcTbCeQKa_cSY6XMg3OwMA2GJJCNWuExL_qQsBYe_Ozj6BQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before CPU down
From: rui wang <ruiv.wang@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        "Chen, Gong" <gong.chen@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 12/03/2013 09:48 PM, rui wang wrote:
>> On 11/20/13, Prarit Bhargava <prarit@redhat.com> wrote:
>> Have you considered the case when an IRQ is destined to more than one CPU?
>> e.g.:
>>
>> bash# cat /proc/irq/89/smp_affinity_list
>> 30,62
>> bash#
>>
>> In this case offlining CPU30 does not seem to require an empty vector
>> slot. It seems that we only need to change the affinity mask of irq89.
>> Your check_vectors() assumed that each irq on the offlining cpu
>> requires a new vector slot.
>>
>
> Rui,
>
> The smp_affinity_list only indicates a preferred destination of the IRQ, not
> the
> *actual* location of the CPU.  So the IRQ is on one of cpu 30 or 62 but not
> both
> simultaneously.
>

It depends on how IOAPIC (or MSI/MSIx) is configured. An IRQ can be
simultaneously broadcast to all destination CPUs (Fixed Mode) or
delivered to the CPU with the lowest priority task (Lowest Priority
Mode). It's programmed in the Delivery Mode bits of the IOAPIC's IO
Redirection table registers, or the Message Data Register in the case
of MSI/MSIx

> If the case is that 62 is being brought down, then the smp_affinity mask
> will be
> updated to reflect only cpu 30 (and vice versa).
>

Yes the affinity mask should be updated. But if it was destined to
more than one CPU, your "this_counter" does not seem to count the
right numbers. Are you saying that smp_affinity mask is broken on
Linux so that there's no way to configure an IRQ to target more than
one CPU?

Thanks
Rui

> P.
>
