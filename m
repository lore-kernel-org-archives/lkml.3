Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554Ab3DCR1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:27:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab3DCR1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:27:15 -0400
Date: Wed, 3 Apr 2013 19:27:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 2/3] perf: Add persistent event facilities
Message-ID: <20130403172712.GA4716@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Robert Richter <rric@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Borislav Petkov <bp@suse.de>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <1363352789-17991-3-git-send-email-bp@alien8.de>
 <20130328181516.GR11449@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130328181516.GR11449@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 07:15:16PM +0100, Robert Richter wrote:
> The mmap'ed region is already allocated by the kernel. How does a user
> know the buffer size of the mmap'ed region?

Right, so normal perf events get a buffer allocated at mmap time. The
size of that buffer is determined from the size of the vma which, in
turn, gets determined by perf (there's a default of 512K there).

Now, currently the size of the percpu buffers of a persistent event is
determined by the caller and this needs to be somehow better controlled
like limit them to a max size even when allocated from within the
kernel. Also maybe use perf's default when allocating the event from
perf. We can make them of a default size and keep them that way, which
would mean, perf would need to know about this. And there's the question
whether some persistent buffers would actually generate more samples and
need bigger buffers. Hmm...

We probably need to discuss this more though...

> Also, I wouldn't make too much use of -EINVAL, this should only be
> used if the syscall contains *wrong* data.

Ok.

> event must be set to an error code here.
>
> Better swap order of rb_alloc() and perf_event_create_kernel_
> counter(). Makes things easier.

Hehe, already done. I told you not to review that version of the
patches, remember? :-)

> > +static void rm_persistent_event(int cpu, struct perf_event_attr *attr)
>
> Would rather prefer del_... as this is actually used for deleting
> events in perf.

Done.

> > +	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist) {
> > +
> > +		if (desc->attr->config != attr->config)
> > +			continue;
> 
> Umm, the attr->config is not sufficient as a selector since it must be
> unique which is not granted (of course it works for one event only).

Right, so the tracepoints are enumerated by tracing code at boot
time. But not the hw events, for example. How can we select events
unambiguously?

> > +unwind:
> > +	while (--i >= 0)
> > +		rm_persistent_event(i, attr);
> > +
> > +	return -EINVAL;
> 
> Should return the actual error.

Done.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
