Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaI3QDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaI3QDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:03:45 -0400
Message-ID: <542AD43A.90706@redhat.com>
Date: Tue, 30 Sep 2014 12:03:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: pipe/page fault oddness.
References: <20140930033327.GA14558@redhat.com>	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>	<20140930043309.GA16196@redhat.com>	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com> <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
In-Reply-To: <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/30/2014 11:52 AM, Linus Torvalds wrote:
> On Mon, Sep 29, 2014 at 9:54 PM, Linus Torvalds 
> <torvalds@linux-foundation.org> wrote:
>> 
>> Odd. The 0x3b3 offset seems to be the single-byte write of zero,
>> which is just the initial probe (aka
>> "fault_in_pages_writeable()").
>> 
>> How *that* could loop, I have no idea. Unless the exception table
>> is broken. I'll take another look tomorrow.
> 
> Confirmed. It's the second write in fault_in_pages_writeable()
> (the one that writes to the "end" pointer).
> 
> And there's no loop in software. And in fact, the trace shows that 
> there is no exception case for the fault either, so the fault is 
> perfectly successful.
> 
> So if it's looping on that fault, what seems to happen is that the 
> page fault keeps happening.
> 
> Can you recreate this? Because if you can, please try to revert
> commit e4a1cc56e4d7 ("x86: mm: drop TLB flush from
> ptep_set_access_flags"). Maybe the TLB has it read-only, and it
> doesn't get flushed, and the page fault happens over and over
> again.
> 
> What kind of CPU is the problematic machine? There was some
> question about just how architectural the whole "TLB entry causing
> a page fault gets invalidated automatically" really is.

Intel people told me at the time that the guarantee was architectural.
I don't know whether other x86 manufacturers know this...

Doing a local tlb flush from ptep_set_access_flags seems appropriate,
if that is indeed the issue.

On the other hand, do_wp_page does not seem to do a tlb flush when
the old page is reused, so CPUs do get rid of inappropriate TLB
entries. We would have noticed do_wp_page not working right :)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUKtQ6AAoJEM553pKExN6D0r4H/088aviaZYq87YoWcHVkc0ld
MD9PhuKtQugDW+CahmkQ1CDchEo25NUNV2eZhOkEzj/kCqcxzGGFVfBYmtZowp7X
X7675LIqueESIqdmlxXt8zaxnTnaC1xFiqilnL1YNvx+11EfgjIKRY3bSjrvFhBh
XBPymhVXg0DlC7FBdX4+ekGrWPu0JpAfdjGaONtImO2hEbXuYAylYsbx/vpLRD6S
Fcml2oQYE+f2Mp2+SKYNL94XWh4yz7l6UaSd8aJWIr2ssqWAYgQJ7v/N2Sa/2qq8
WJkmMcHFDWCesH+Hw5OhRAEW48WbH7EZZmR/rzIfEOgs1LaxTkfsONqjUoi/6+g=
=cd+t
-----END PGP SIGNATURE-----
