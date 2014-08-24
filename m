Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaHXRuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:50:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49690 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaHXRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <53F9CC77.70009@t-online.de>
References: <53F9CC77.70009@t-online.de>
Date: Sun, 24 Aug 2014 10:50:08 -0700
X-Google-Sender-Auth: WmU7nN3UiEgiQCEu3PpquKCHDEo
Message-ID: <CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
Subject: Re: [Bug 3.14.17] inconsistent lock state
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Renninger <trenn@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 4:28 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
>
> Since months the postmaster wantonly blocks all mail traffic from the
> biggest german ISP t-online.de to all vger.kernel.org mailing lists,
> therefore I could not cc lkml.

Hmm.

> Please forward the following bug report to lkml and whomever it might of
> interest:

Added the guilty parties to the cc. The problem seems to be that first
/proc/acpi/event was removed in commit 1696d9dc57e0 ("ACPI: Remove the
old /proc/acpi/event interface") and then because that caused
problems, a horribly broken netlink interface was added instead in
commit 0bf6368ee8f2 ("ACPI / button: Add ACPI Button event via netlink
routine")

And that commit really seems to be horribly horribly broken.

It calls the netlink routines from interrupt context, which doesn't
work. Thus lockdep warns about "netlink_poll()" using bh-safe locking:

        spin_lock_bh(&sk->sk_receive_queue.lock);

but then __netlink_sendskb() is using that same queue lock from
interrupt context. Not some "subtly wrong" locking caught by lockdep,
but a major bug.

This seems to be going back to 3.14-rc7, which surprises me a bit.
It's been around for a while now, but I don't find a lot of reports.
And I don't see any subtle fixes for this anywhere, so it seems to be
still true today.

Rafael? Lan Tianyu? This is not some minor locking bug. This is a
*major* mistake unless I misread something.

                Linus
