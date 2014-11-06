Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaKFPbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:31:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaKFPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:31:10 -0500
Date: Thu, 6 Nov 2014 16:31:07 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141106153107.GH2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.502133196@goodmis.org>
 <20141105163150.GI4570@pathway.suse.cz>
 <20141105152130.09779ccf@gandalf.local.home>
 <20141105160618.6c684f23@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105160618.6c684f23@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-05 16:06:18, Steven Rostedt wrote:
> On Wed, 5 Nov 2014 15:21:30 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>  
> > > 
> > > I wonder if we want this change at all. It means that we are not able to
> > > detect overflow in some functions. It is pity because the users
> > > might want to increase the buffer size and try again if the print
> > > was incomplete.
> > 
> > What do you mean we can't detect overflow? That's what
> > seq_buf_has_overflowed() does.
> > 
> 
> Although I'm looking at the seq_file versions of the bitmap code, which
> does only return the len of what was written and not what would have
> been written, and it does have this issue.
> 
> I hate to go back to the -1 of the size of buffer as that causes
> inconsistencies within the functions themselves, as proved with the
> seq_file code.

Yeah, the -1 and the unused byte is strange and it would be great to
avoid it.

On the other hand, I am slightly afraid of the "len = size + 1" that
signalizes the buffer overflow. It might be prone for creating security
bugs. If people forget to check seq_buf_has_overflowed() before
reading or if there is a race, they might read outside of the buffer.


> What I might do as just have the bitmap calls not be allowed to fill
> the buffer and keep the logic the same. That is, if the bitmap calls
> fill the rest of the length, assume we overflowed, otherwise we are
> fine.
> 
> I'm going to change seq_buf to do that instead of my new update with
> the bitmask code.

I like the idea of having the exception only in the bitmap code and filling
the whole buffer in other cases.

I am now in doubts about the overflow state. A solution would
be to add an "overflow" flag to struct seq_bug. I agree that it
is ugly but it looks more secure then "len = size + 1".

Well, I do not have that strong opinion about it. What do you think?


Best Regards,
Petr
