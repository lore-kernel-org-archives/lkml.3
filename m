Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaFVQ75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 12:59:57 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60127 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaFVQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 12:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140622084754.GA15094@gmail.com>
References: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net>
 <tip-5f56e7167e6d438324fcba87018255d81e201383@git.kernel.org> <20140622084754.GA15094@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 22 Jun 2014 09:59:34 -0700
Message-ID: <CALCETrW_U7z7RC-D5+Ji+PQd73nR-=xQGH5uieb7y3Z7yzYPRw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/vdso: Discard the __bug_table section
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 1:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * tip-bot for Andy Lutomirski <tipbot@zytor.com> wrote:
>
>> Commit-ID:  5f56e7167e6d438324fcba87018255d81e201383
>> Gitweb:     http://git.kernel.org/tip/5f56e7167e6d438324fcba87018255d81e201383
>> Author:     Andy Lutomirski <luto@amacapital.net>
>> AuthorDate: Wed, 18 Jun 2014 15:59:46 -0700
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Thu, 19 Jun 2014 15:44:51 -0700
>>
>> x86/vdso: Discard the __bug_table section
>>
>> It serves no purpose in user code.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Link: http://lkml.kernel.org/r/2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> ---
>>  arch/x86/vdso/vdso-layout.lds.S | 1 +
>>  1 file changed, 1 insertion(+)
>
> One of the recent x86/urgent vdso commits causes this build failure:
>
>  Error: too many copied sections (max = 13)

I can't reproduce this with your config, which suggestes a binutils
issue, which is annoying.  Can you tell me what version of ld you're
using and send me the output of:

for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done

To summarize, the issue is that, in 3.16, the vvar area is accessed in
a PC-relative manner from the vdso code.  So we have:

vdso page 1 | vdso page 2 | vvar page 1 | vvar page 2  (where the
number of vdso pages can vary)

The difficulty comes from the fact that a decent amount of userspace
code wants the vdso to have some section headers, and linkers don't
stick section headers into allocatable sections, since section headers
were never intended to be memory mapped.  So there's a risk that the
section headers dangle off the last loadable page in the vdso, at
which point they overlap the vvar area.  I've seen this happen.

The "solution" in tip is to move the section headers into a real
allocatable area reserved for that purpose.  The error you're seeing
is that I didn't allocate enough space for all the allocatable section
headers.

This crap almost makes me want to go back to something closer to
Stefani's implementation of sticking vvar before the vdso so we can
safely leave non-allocatable crap dangling off the end of the vdso.  I
don't really want to play section header whack-a-mole.  We could also
just give up on space efficiency and allocate space for several extra
section headers (and their associated names!).

--Andy
