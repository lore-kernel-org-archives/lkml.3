Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3K3OwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 09:52:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab3K3OwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 09:52:04 -0500
Date: Sat, 30 Nov 2013 15:52:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131130145245.GA15790@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <529974C9.6040607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529974C9.6040607@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, H. Peter Anvin wrote:
>
> On 11/29/2013 12:05 PM, Oleg Nesterov wrote:
> >
> > Can't we invalidate pte (so that any user will stuck in page fault),
> > update the page(s), restore the pte and drop the locks?
> >
> > This way sys_text_poke() won't be x86-specific, and it will be per-mm.
> >
>
> Hmmm... if we hold mmap_sem() this pretty much will be the net result,
> no?

Yes, down_write(mmap_sem) is enough to block the page faults.

But we need pte-lock anyway, to avoid the races with, say, try_to_unmap().
(and of course, we need to retry if page_check_address() fails).

This actually means that if we want to update a single page we could
use down_read(). But in general we need to update 2 pages. Or even more
if we generalize sys_text_poke(), perhaps it should be renamed in this
case, but this is off-topic.

> That would mean no additional tests needed on the page fault path.

Not sure I understand... but of course we should not change the fault
paths in any case.

>  What I'm not sure of is whether or not it is actually safe to hold
> mmap_sem across all the code we need

Let me repeat, I do not understand vm enough to answer authoritatively.

But I think this should be safe. I do not see why it should not, but
see above.

Oleg.

