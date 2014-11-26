Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaKZOnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:43:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:29923 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991AbaKZOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:43:08 -0500
Date: Wed, 26 Nov 2014 09:43:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] tracing: off by one in __trace_array_vprintk()
Message-ID: <20141126094306.4f465616@gandalf.local.home>
In-Reply-To: <20141126143719.GT4893@mwanda>
References: <20141126140621.GA18740@mwanda>
	<20141126092706.5d4038d4@gandalf.local.home>
	<20141126143719.GT4893@mwanda>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 17:37:19 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Wed, Nov 26, 2014 at 09:27:06AM -0500, Steven Rostedt wrote:
> > On Wed, 26 Nov 2014 17:06:21 +0300
> > Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > 
> > > This check says "goto out;" if we had to truncate the string.
> > > 
> > > The "tbuffer" buffer has TRACE_BUF_SIZE bytes.  The vsnprintf() function
> > > returns the number of characters (not counting the NUL char) which would
> > > have been printed if there were space.  If we we tried to print
> > > TRACE_BUF_SIZE characters, the last character would have been truncated
> > > to make space for the NUL character so we should "goto out;".
> > > 
> > 
> > Oh, and the NUL character is never copied. We copy the string into the
> > buffer with:
> > 
> > 	memcpy(&entry->buf, tbuffer, len);
> > 
> > Where len does not include NUL, and why we add it ourselves.
> 
> Yeah.  I noticed that.  Probably we should change the memcpy() to:
> 
> 	memcpy(&entry->buf, tbuffer, len + 1);
> 
> and remove separate NUL assignment?  It's a speedup!  I'll do it in v2.
> 

I highly doubt it's much of a speed up. And we do that by sacrificing
that one byte of buffer, which would lose the printk if len does equal
TRACE_BUF_SIZE.

I don't see a bug here. What exactly are you trying to fix?

-- Steve
