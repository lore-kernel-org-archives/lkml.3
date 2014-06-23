Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaFWVEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:04:45 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39879 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaFWVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <53A88DE4.8050107@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com> <53A884B2.5070702@mit.edu>
 <53A88806.1060908@intel.com> <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
 <53A88DE4.8050107@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Jun 2014 14:04:22 -0700
Message-ID: <CALCETrWBbkFzQR3tz1TphqxiGYycvzrFrKc=ghzMynbem=d7rg@mail.gmail.com>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
To: Dave Hansen <dave.hansen@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:28 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 06/23/2014 01:06 PM, Andy Lutomirski wrote:
>> Can the new vm_operation "name" be use for this?  The magic "always
>> written to core dumps" feature might need to be reconsidered.
>
> One thing I'd like to avoid is an MPX vma getting merged with a non-MPX
> vma.  I don't see any code to prevent two VMAs with different
> vm_ops->names from getting merged.  That seems like a bit of a design
> oversight for ->name.  Right?

AFAIK there are no ->name users that don't also set ->close, for
exactly that reason.  I'd be okay with adding a check for ->name, too.

Hmm.  If MPX vmas had a real struct file attached, this would all come
for free.  Maybe vmas with non-default vm_ops and file != NULL should
never be mergeable?

>
> Thinking out loud a bit... There are also some more complicated but more
> performant cleanup mechanisms that I'd like to go after in the future.
> Given a page, we might want to figure out if it is an MPX page or not.
> I wonder if we'll ever collide with some other user of vm_ops->name.  It
> looks fairly narrowly used at the moment, but would this keep us from
> putting these pages on, say, a tmpfs mount?  Doesn't look that way at
> the moment.

You could always check the vm_ops pointer to see if it's MPX.

One feature I've wanted: a way to have special per-process vmas that
can be easily found.  For example, I want to be able to efficiently
find out where the vdso and vvar vmas are.  I don't think this is
currently supported.

--Andy
