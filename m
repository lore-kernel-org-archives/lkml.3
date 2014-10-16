Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaJQHDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:03:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:40794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaJQHC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="615951919"
Date: Thu, 16 Oct 2014 17:44:10 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 12/21] vfs: Remove get_xip_mem
Message-ID: <20141016214410.GH11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-13-git-send-email-matthew.r.wilcox@intel.com>
 <20141016121446.GJ19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016121446.GJ19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:14:46PM +0200, Mathieu Desnoyers wrote:
> > +++ b/fs/open.c
> > @@ -655,11 +655,8 @@ int open_check_o_direct(struct file *f)
> >  {
> >  	/* NB: we're sure to have correct a_ops only after f_op->open */
> >  	if (f->f_flags & O_DIRECT) {
> > -		if (!f->f_mapping->a_ops ||
> > -		    ((!f->f_mapping->a_ops->direct_IO) &&
> > -		    (!f->f_mapping->a_ops->get_xip_mem))) {
> > +		if (!f->f_mapping->a_ops || !f->f_mapping->a_ops->direct_IO)
> 
> Why is it OK to remove the check for get_xip_mem callback here, rather
> than replacing it with a IS_DAX check like the rest of this patch does ?
> I'm probably missing something.

XIP used to intercept I/Os by having the filesystem's ->read & ->write
methods call xip_file_read (/write).  That would do the I/O, and so there
was no need to have a ->direct_IO element in a_ops.  For DAX, we use the
generic VFS code to call back into the filesystem's ->direct_IO entry
point, so the check above for ->direct_IO now checks for both regular
and DAX support.

Or to put it another way, DAX now requires that the filesystem support
O_DIRECT.  Which is pretty much the way it has to be anyway, since DAX
is direct!
