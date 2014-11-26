Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaKZOh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:37:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30284 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaKZOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:37:27 -0500
Date: Wed, 26 Nov 2014 17:37:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] tracing: off by one in __trace_array_vprintk()
Message-ID: <20141126143719.GT4893@mwanda>
References: <20141126140621.GA18740@mwanda>
 <20141126092706.5d4038d4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126092706.5d4038d4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:27:06AM -0500, Steven Rostedt wrote:
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
> 
> Oh, and the NUL character is never copied. We copy the string into the
> buffer with:
> 
> 	memcpy(&entry->buf, tbuffer, len);
> 
> Where len does not include NUL, and why we add it ourselves.

Yeah.  I noticed that.  Probably we should change the memcpy() to:

	memcpy(&entry->buf, tbuffer, len + 1);

and remove separate NUL assignment?  It's a speedup!  I'll do it in v2.

regards,
dan carpenter

