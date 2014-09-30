Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaI3Q0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:26:43 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41465 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaI3Q0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <542AD43A.90706@redhat.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<542AD43A.90706@redhat.com>
Date: Tue, 30 Sep 2014 09:26:39 -0700
X-Google-Sender-Auth: xYBL7Zt26J04tc4Pc6CCdCjqbQE
Message-ID: <CA+55aFwOYzqPqVpU16PcKtQRQi67dPTcayp6b3Rp_WCHuPYNyA@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 9:03 AM, Rik van Riel <riel@redhat.com> wrote:
>
> On the other hand, do_wp_page does not seem to do a tlb flush when
> the old page is reused, so CPUs do get rid of inappropriate TLB
> entries. We would have noticed do_wp_page not working right :)

Hmm? do_wp_page() uses the same ptep_set_access_flags(). So it too
used to do the TLB flush before that got removed there..

I do agree that clearly the CPU must *usually* do a TLB flush, or we'd
have noticed the lack immediately. I just worry that there are some
very specific circumstances when it might be missed.

That said, I don't actually believe it's that commit. I would just
like to remove it from the list of suspects.

I'm wondering what else could cause us to take effectively the same
page fault over and over again on what is a very simple instruction:

    movb   $0x0,(%rdx)

where handle_mm_fault() doesn't see anything wrong with the page
tables, but the CPU does.

Hmm. We also have that

        if (unlikely((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)))
                return;

thing. It assumes that the fatal signal will kill the process, but
that's only true if returning to user space. So that looks like a
potential mis-feature (although it should sort itself out *eventually*
when the IO has completed), but the trace Dave had didn't go through
the retry paths.

Anybody see anyting else?

               Linus
