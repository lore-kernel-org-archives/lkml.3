Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaJQPwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:52:23 -0400
Received: from mail.efficios.com ([78.47.125.74]:48386 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbaJQPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:52:22 -0400
Date: Fri, 17 Oct 2014 15:52:14 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <616734389.10923.1413561134767.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141016223331.GA11169@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <1411677218-29146-8-git-send-email-matthew.r.wilcox@intel.com> <20141016095027.GE19075@thinkos.etherlink> <20141016195112.GE11522@wil.cx> <20141016223331.GA11169@wil.cx>
Subject: Re: [PATCH v11 07/21] dax,ext2: Replace XIP read and write with DAX
 I/O
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.156.150.204]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: dax,ext2: Replace XIP read and write with DAX I/O
Thread-Index: oex4SJn6nmauBhPWoQU9cciKvCyekw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
> linux-kernel@vger.kernel.org
> Sent: Friday, October 17, 2014 12:33:31 AM
> Subject: Re: [PATCH v11 07/21] dax,ext2: Replace XIP read and write with DAX I/O
> 
> On Thu, Oct 16, 2014 at 03:51:12PM -0400, Matthew Wilcox wrote:
> > On Thu, Oct 16, 2014 at 11:50:27AM +0200, Mathieu Desnoyers wrote:
> > > > +			if (rw == WRITE) {
> > > > +				if (!buffer_mapped(bh)) {
> > > > +					retval = -EIO;
> > > > +					/* FIXME: fall back to buffered I/O */
> > > 
> > > Fallback on buffered I/O would void guarantee about having data stored
> > > into persistent memory after write returns. Not sure we actually want
> > > that.
> > 
> > Yeah, I think that comment is just stale.  I can't see a way in which
> > buffered I/O would succeed after DAX I/O falis.
> 
> On further consideration, I think the whole thing is just foolish.
> I don't see how get_block(create == 1) can return success *and* a buffer
> that is !mapped.

Perhaps a safe approach could be to put a BUG_ON() to check this assumption ?

Thanks,

Mathieu

> 
> So I did this nice simplification:
> 
> -                       if (rw == WRITE) {
> -                               if (!buffer_mapped(bh)) {
> -                                       retval = -EIO;
> -                                       /* FIXME: fall back to buffered I/O
> */
> -                                       break;
> -                               }
> -                               hole = false;
> -                       } else {
> -                               hole = !buffer_written(bh);
> -                       }
> +                       hole = (rw != WRITE) && !buffer_written(bh);
> 
> (compile-tested only; I'm going to run all the changes through xfstests
> next week when I'm back home before sending out a v12).
> 



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
