Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaKZOeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:34:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28177 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaKZOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:34:13 -0500
Date: Wed, 26 Nov 2014 17:34:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] tracing: off by one in __trace_array_vprintk()
Message-ID: <20141126143404.GS4893@mwanda>
References: <20141126140621.GA18740@mwanda>
 <20141126092537.14b6ea9f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126092537.14b6ea9f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:25:37AM -0500, Steven Rostedt wrote:
> On Wed, 26 Nov 2014 17:06:21 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > This check says "goto out;" if we had to truncate the string.
> > 
> > The "tbuffer" buffer has TRACE_BUF_SIZE bytes.  The vsnprintf() function
> > returns the number of characters (not counting the NUL char) which would
> > have been printed if there were space.  If we we tried to print
> > TRACE_BUF_SIZE characters, the last character would have been truncated
> > to make space for the NUL character so we should "goto out;".
> > 
> > My other concern here was that a few lines later we do:
> > 
> > 	entry->buf[len] = '\0';
> > 
> > I worried that maybe we were putting the NUL char past the end of the
> > array but I wasn't smart enough to figure out the size of entry->buf[].
> 
> entry is of type struct print_entry *, which is defined by macro magic
> (sorry),

I figure this bit out using make devel/kernel/trace/trace.i.

> and would look like this:
> 
> struct print_entry {
> 	unsigned long		ip;
> 	char			buf[];
> };
> 
> But then it is allocated like so:
> 
> 	size = sizeof(*entry) + len + 1;
> 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
> 					  flags, pc);
> 
> 	entry = ring_buffer_event_data(event);

I was so close to figuring this out on my own...  Let me send a v2 with
an amended changelog.

regards,
dan carpenter

