Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaI3PwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:52:11 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:64165 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaI3PwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
Date: Tue, 30 Sep 2014 08:52:08 -0700
X-Google-Sender-Auth: Pt9r4z7jkZP5Whv7mDJsAzIUKrE
Message-ID: <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 9:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Odd. The 0x3b3 offset seems to be the single-byte write of zero, which is
> just the initial probe (aka "fault_in_pages_writeable()").
>
> How *that* could loop, I have no idea. Unless the exception table is broken.
> I'll take another look tomorrow.

Confirmed. It's the second write in fault_in_pages_writeable() (the
one that writes to the "end" pointer).

And there's no loop in software. And in fact, the trace shows that
there is no exception case for the fault either, so the fault is
perfectly successful.

So if it's looping on that fault, what seems to happen is that the
page fault keeps happening.

Can you recreate this? Because if you can, please try to revert commit
e4a1cc56e4d7 ("x86: mm: drop TLB flush from ptep_set_access_flags").
Maybe the TLB has it read-only, and it doesn't get flushed, and the
page fault happens over and over again.

What kind of CPU is the problematic machine? There was some question
about just how architectural the whole "TLB entry causing a page fault
gets invalidated automatically" really is.

                    Linus
