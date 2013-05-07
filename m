Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3EGMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab3EGMJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:09:25 -0400
Date: Tue, 7 May 2013 14:09:14 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Isaku Yamahata <yamahata@valinux.co.jp>
Cc: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/4] madvise(MADV_USERFAULT) & sys_remap_anon_pages()
Message-ID: <20130507120914.GC12538@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
 <20130507100740.GC16873@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507100740.GC16873@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Isaku,

On Tue, May 07, 2013 at 07:07:40PM +0900, Isaku Yamahata wrote:
> On Mon, May 06, 2013 at 09:56:57PM +0200, Andrea Arcangeli wrote:
> > Hello everyone,
> > 
> > this is a patchset to implement two new kernel features:
> > MADV_USERFAULT and remap_anon_pages.
> > 
> > The combination of the two features are what I would propose to
> > implement postcopy live migration, and in general demand paging of
> > remote memory, hosted in different cloud nodes with KSM. It might also
> > be used without virt to offload parts of memory to different nodes
> > using some userland library and a network memory manager.
> 
> Interesting. The API you are proposing handles only user fault.
> How do you think about kernel case. I mean that KVM kernel module issues
> get_user_pages().
> Exit to qemu with dedicated reason?

Correct. It's possible we want a more meaningful retval from
get_user_pages too (right now sigbus would make gup return a too
generic -EFAULT) by introducing a FOLL_USERFAULT in gup_flags.

So the KVM bits are still missing at this point.

Gleb also wants to enable the async page fault in the postcopy stage,
so we immediately schedule a different guest process if the current
guest process hits an userfault within KVM.

So the protocol with the postcopy thread will tell it "fill this pfn
async" or "fill it synchronous". And Gleb likes kvm to talk to the
postcopy thread (through a pipe?) directly to avoid exiting to
userland.

But we could also return to userland, if we do, we don't need to teach
the kernel about the postcopy thread protocol to require new pages
synchronously (after running out of async page faults) or
asynchronously (when async page faults are still availbale).

Clearly staying in the kernel is more efficient as it avoids an
enter/exit cycle and kvm can be restarted immediately after a 9 byte
write to the pipe with the postcopy thread.

> In case of precopy + postcopy optimization, dirty bitmap is sent after 
> precopy phase and then clean pages are populated. In this population phase,
> vecotored API can be utilized. I'm not sure how much vectored API will
> contribute to shorten VM-switch time, though.

But the network transfer won't be vectored, would it? If we pay an
enter/exit kernel for the network transfer, I assume we'd run a
remap_anon_pages after each chunk.

Also the postcopy thread won't transfer in the background too much
data at once. It needs to react quick to a "urgent" userfault request
coming from a vcpu thread.

> It would be desirable to avoid complex thing in signal handler.
> Like sending page request to remote, receiving pages from remote.
> So signal handler would just queue requests to those dedicated threads
> and wait and requests would be serialized. Such strictness is not 

Exactly, that's the idea, a separate thread will do the network
transfer and then run remap_anon_pages. And if we immediately use
async page faults it won't need to block until we run out of async
page faults.

> very critical, I guess. But others might find other use case...

It's still somewhat useful to be strict in my view, as it will verify
that we handle correctly the case of many vcpus userfaulting on the
same address at the same time, everyone except the first shouldn't run
remap_anon_pages.

Thanks!
Andrea
