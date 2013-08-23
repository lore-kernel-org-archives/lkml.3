Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3HWTjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:39:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39154 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab3HWTjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:39:39 -0400
Date: Fri, 23 Aug 2013 21:39:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vince Weaver <vince@deater.net>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130823193934.GB15521@pd.tnic>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
 <20130823113400.GA20310@nazgul.tnic>
 <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 01:07:54PM -0400, Vince Weaver wrote:
> If I had not read the man-page fragment and saw a
>    result=ioctl(fd,PERF_EVENT_IOC_ATTACH,0);
> I'd have no clue what it was doing (attach?  attach to what?)
> wheras if I saw
>    result=ioctl(fd,PERF_EVENT_IOC_UNPERSIST,0);
> it's a little more clearer and also indicates that the ioctl is only
> valid if you're dealing with a persistent event.

Maybe this makes it more understandable for you but this is beside the
point.

The main and the most important idea here is that we want to
attach/detach file descriptors to perf events and the resources
(buffers, etc) associated with them so that those events can be made
independent from processes.

But I have to say the reversed thing above does sound confusing, now
that I'm looking at the code. Actually, at the time we discussed this,
my idea was to do it like this:

1. we open a perf event and get its file descriptor
2. ioctl ATTACH to it so that it is attached to the process.

... do some tracing and collecting and fiddling...

3. ioctl DETACH from it so that it is "forked in the background" so to
speak, very similar to a background job in the shell.

4. The rest of the code continues and deallocates the event *BUT* (and
this is the key thing!) the counter/tracepoint remains operational in
the kernel, running all the time.

5. Now, after a certain point, you come back and ioctl ATTACH to this
already opened event and read/collect its buffers again.

And here's the deal - if you don't DETACH from the event at step 3, it
gets destroyed on process exit, i.e. what the current perf behavior is.

Robert, I think the above is more straight-forward and intuitive, no?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
