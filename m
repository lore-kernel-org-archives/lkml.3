Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab3BMQSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:18:51 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60756 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:18:49 -0500
Date: Wed, 13 Feb 2013 08:18:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Ben Myers <bpm@sgi.com>, CAI Qian <caiqian@redhat.com>
Subject: Re: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the
 filesystem end
Message-ID: <20130213161845.GA20916@kroah.com>
References: <20130201130207.444989281@linuxfoundation.org>
 <20130201130212.381996681@linuxfoundation.org>
 <511BB198.1080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511BB198.1080609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 04:30:32PM +0100, Paolo Bonzini wrote:
> Il 01/02/2013 14:08, Greg Kroah-Hartman ha scritto:
> > 3.7-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > commit eb178619f930fa2ba2348de332a1ff1c66a31424 upstream.
> > 
> > When _xfs_buf_find is passed an out of range address, it will fail
> > to find a relevant struct xfs_perag and oops with a null
> > dereference. This can happen when trying to walk a filesystem with a
> > metadata inode that has a partially corrupted extent map (i.e. the
> > block number returned is corrupt, but is otherwise intact) and we
> > try to read from the corrupted block address.
> > 
> > In this case, just fail the lookup. If it is readahead being issued,
> > it will simply not be done, but if it is real read that fails we
> > will get an error being reported.  Ideally this case should result
> > in an EFSCORRUPTED error being reported, but we cannot return an
> > error through xfs_buf_read() or xfs_buf_get() so this lookup failure
> > may result in ENOMEM or EIO errors being reported instead.
> 
> It looks like this breaks xfs_growfs.  See
> http://bugzilla.redhat.com/show_bug.cgi?id=909602.

Ick, not good.

Dave, any thoughts here?  Should I drop this from the 3.7-stable queue?

greg k-h
