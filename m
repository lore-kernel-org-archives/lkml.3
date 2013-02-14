Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005Ab3BNVvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:51:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934909Ab3BNVvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:51:33 -0500
Date: Thu, 14 Feb 2013 13:51:29 -0800
From: Zach Brown <zab@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WIP v1] aio: experimental use of threads, demonstration
 of cancel method
Message-ID: <20130214215129.GH22221@lenny.home.zabbo.net>
References: <20130213221632.GA25312@kvack.org>
 <20130214193333.GG22221@lenny.home.zabbo.net>
 <20130214205328.GB25505@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214205328.GB25505@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 03:53:28PM -0500, Benjamin LaHaise wrote:
> On Thu, Feb 14, 2013 at 11:33:33AM -0800, Zach Brown wrote:
> > 1) The patch handles the processing thread's current->mm needing to
> >    match the submitting thread's.  What's the plan for the rest of the
> >    task_struct state that a processing thread might need to read from and
> >    write to the submitting thread?
> 
> The plan is to handle that with submit time helpers that get references to 
> the state that is required for the operation in question.  For example, 
> network operations would not need to get a reference on current->io_context, 
> while block based filesystem operations would.  Helpers like this would be 
> far simpler than writing fully asynchronous read/write ops.  Likely a 
> bitmask of state to clone would make this easier to implement.

Understood.

As you know, I'm worried about the uses of the state by aio threads
getting out of sync with the helpers.

Maybe this is the right thing to do.  I just want the patch to make it
very clear what it's asking of task_struct changes in the future. 

> > 2) Why do we want to put aio between userspace and a pool of threads
> >    that call syscalls?  Put another way: whatever the benefit is here,
> >    can't the kernel offer that benefit as some "thread pool
> >    coordination" interface and not force users to pass their work through
> >    aio contexts and iocbs and the ring?
> 
> I don't see any need to introduce a new API at this point in time, plus 
> the existing hooks allow for operations to do the submit in the caller's 
> thread (which things like DIO will likely continue to need), which in turn 
> will allow for only passing the state needed around.  There are problems 
> with a generic thread pool management facility that supports arbitrary 
> asynchronous syscalls: some syscalls assume particular thread-local state.  
> Any generic facility would need to cope with the state problem as much as 
> limited read/write operations do.  I don't see the complexity being much 
> different.

It would be really nice to see the hard numbers on how poorly a simple
pile of userspace threads does this same work.  If it's a skazillion
times slower it'd help put the benefit of maintaining this stuff in the
kernel in context.

> I said this was an ugly first attempt. =)

I'm excited to see how it turns out :).

- z
