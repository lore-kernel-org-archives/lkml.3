Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaJ0URl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:17:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:33322 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751802AbaJ0URk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:17:40 -0400
Date: Mon, 27 Oct 2014 16:17:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] dlm: Use seq_is_full - remove seq_printf returns
Message-ID: <20141027161724.0ec20325@gandalf.local.home>
In-Reply-To: <20140930103435.GC2707@dhcp128.suse.cz>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<43590057bcb83846acbbcc1fe641f792b2fb7773.1412031505.git.joe@perches.com>
	<20140930103435.GC2707@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, I've started with Joe's patches and I'm massaging them for
something I can work with.

On Tue, 30 Sep 2014 12:34:35 +0200
Petr Mladek <pmladek@suse.cz> wrote:


> > -		rv = seq_printf(s, "\"\nInvalid master %d\n",
> > -				res->res_nodeid);
> > -	if (rv)
> > +		seq_printf(s, "\"\nInvalid master %d\n", res->res_nodeid);
> > +	if (seq_is_full(s))
> >  		goto out;
> 
> I would check for seq_overflow()
> 
> Etc. There are needed many more changes if we agree on introducing
> seq_is_full() and seq_overflow().

As I'm looking at this code, I'm thinking that we never
really care about seq_is_full(). We only really care if
seq_overflowed(), in which the contents will be discarded.

Rational? Because if we break when seq_is_full(), my new logic wont
throw away the result. If we break out of the function when it's full
and not when it has overflowed, then we may never print out the rest of
the content, as the seq_file code will still use a full buffer that
hasn't overflowed.

I'm thinking of switching everything to use seq_has_overflowed() and
try again.

Thoughts?

-- Steve

