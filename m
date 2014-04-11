Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaDKPIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:08:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35078 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaDKPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:08:05 -0400
Date: Fri, 11 Apr 2014 16:07:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, jason.low2@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: cred_guard_mutex vs seq_file::lock [was: Re: 3.14.0+/x86:
 lockdep and mutexes not getting along]
Message-ID: <20140411150724.GI18016@ZenIV.linux.org.uk>
References: <20140410142918.GU11096@twins.programming.kicks-ass.net>
 <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <26259.1397227827@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26259.1397227827@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 03:50:27PM +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Al, David, any bright ideas on how to best fix this?
> 
> Have the seq_xxx() code throw an error if current->in_execve is true.  I can't
> think of any circumstance where execve() should be reading anything that uses
> seq_xxx().

*cringe*

I don't like it.  That really should be a responsiblity of specific ->show();
"I'm going to take that mutex, bugger off if we are in execve()" makes a lot
more sense than having e.g. seq_read() care of that.  IOW, I would very
much prefer the patch you've sent last week.

And yes, it might leave lockdep false positives, but that's better dealt with
by annotating the sucker ("this guy has a separate lockdep class for its
->lock").  E.g. by splitting proc_single_file_operations in two and having
the one used for those files do lockdep_set_class() in its ->open().
