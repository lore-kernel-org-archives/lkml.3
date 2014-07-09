Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaGIVvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:51:54 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43471 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaGIVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <87a98inucv.fsf@tassilo.jf.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<87a98inucv.fsf@tassilo.jf.intel.com>
Date: Wed, 9 Jul 2014 14:51:52 -0700
Message-ID: <CAFQmdRZejRwbk90kZoN777EO+a5VN8+AaXcjeqLzSBT6U2QfRw@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:35 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Havard Skinnemoen <hskinnemoen@google.com> writes:
>
>> machine_check_poll() was modified to use spin_lock_irqsave independently
>> per bank when a valid MCE is found to prevent duplicated MCE reports by
>> the CMCI and polling methods. In the common case no MCE will be found,
>> so the lock is not acquired until a valid MCE is found. The status is
>> reread after the lock is acquired in case the MCE was already handled by
>> a different thread. A unique spinlock is used per bank number, so
>> contention should be mostly limited to non-shared banks.
>
> This doesn't make sense. Banks are either owned by CMCI or by poll,
> not by both. If you have true duplicates the bug must be somewhere else.

I don't think we got the description right here. I think the real
issue here was machine check polls happening on multiple CPUs with
shared banks, all reporting the same MCEs. This is very reproducible
when booting with mce=no_cmci, since all CPUs will handle all banks,
and there's AFAICT no good way to identify shared banks without
enabling CMCI.

There may have been an interaction with CMCI here too at some point,
but it's possible that went away with the timer patch (which we did a
bit later).

Havard
