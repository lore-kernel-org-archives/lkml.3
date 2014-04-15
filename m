Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaDOKix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:38:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43174 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDOKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:38:51 -0400
Date: Tue, 15 Apr 2014 13:38:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 2/2] lib/string.c: strlcpy() might read too far
Message-ID: <20140415103837.GV4963@mwanda>
References: <20140401.161838.1562296825577866979.davem@davemloft.net>
 <20140402084731.GB6018@mwanda>
 <20140414144615.8fd678c78389c19df4343049@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414144615.8fd678c78389c19df4343049@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 02:46:15PM -0700, Andrew Morton wrote:
> On Wed, 2 Apr 2014 11:47:31 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > Imagine you have a user controlled variable at the end of a struct which
> > is allocated at the end of a page.  The strlen() could read beyond the
> > mapped memory and cause an oops.
> 
> Well, it's hard to conceive of a situation where anything like this
> could happen.  Code which copies a string from userspace should
> immediately ensure that the kernel copy is null-terminated.  But...  I
> guess it's defense in depth.


The code which prompted this is in isdnloop_start().  I did a:

-	strcpy(card->s0num[0], sdef.num[0]);
+	strlcpy(card->s0num[0], sdef.num[0], sizeof(card->s0num[0]));

So that we wouldn't corrupt memory.  But the debate was whether that was
enough to solve the problem or it was better to null-terminate
sdef.num[0] before doing the strlcpy().  In the end, we decided to
reject input if it wasn't null terminated.

In this case sdef is declared on the stack so there lots NUL characters
so reading too far in the strlen() is not a problem.

regards,
dan carpenter

