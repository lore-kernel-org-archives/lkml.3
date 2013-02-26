Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3BZUeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:34:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999Ab3BZUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:34:10 -0500
Date: Tue, 26 Feb 2013 20:34:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ima: prevent dead lock when a file is opened for direct
 io
Message-ID: <20130226203408.GJ4503@ZenIV.linux.org.uk>
References: <1361395671.29360.26.camel@falcor1>
 <20130226162024.GI4503@ZenIV.linux.org.uk>
 <1361907128.2908.180.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361907128.2908.180.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:32:08PM -0500, Mimi Zohar wrote:
> Before anything gets access to the file, the file needs to be measured,
> appraised, and/or audited, based on policy.  If IMA-appraisal is enabled
> and the file is in policy, we enforce local file integrity and return
> -EINVAL on failure, similar to LSMs.
> 
> Appraising the file is a two step process.  Before appraising the file
> data's integrity, we verify the integrity of the file metadata. Included
> in the 'security.evm' calculation is the ino, generation, uid, gid,
> mode, uuid, and the security xattrs.  'security.ima' contains the file
> data hash or a signature based on the hash.
> 
> The i_mutex is held when making file metadata changes (eg. xattrs,
> chmod, ...).  We hold the i_mutex through the entire verification,
> preventing the file data/metadata from changing.

->i_mutex is *not* guaranteed to prevent file data changes.  It does
cover metadata, but that's it.  ->write() is not required to take it.
Note, BTW, that as soon as you've dropped ->i_mutex, the metadata can
be changed by somebody else.

What do you achieve by holding it over the vfs_read() call?

> I guess I wasn't clear here.  IMA always takes the i_mutex, regardless
> of the O_DIRECT flag.  When a file is opened for read,
> process_measurement() takes the i_mutex and then, if the file was opened
> with the O_DIRECT flag, do_blockdev_direct_IO() attempts to take the
> i_mutex again, causing the lockdep.

*sigh*
Do you actually disagree with my description of the locking rules you
implicitly rely upon?  Suppose wankfs_file_read() happens to grab
->i_mutex for some reason; without IMA it used to be perfectly legitimate.
With IMA it will deadlock as soon as IMA decides that such file is worth
its attention.  So these days the rule has (silently) become
	* ->read() on a regular file is not allowed to touch ->i_mutex
and with your proposed change it becomes (still undocumented)
	* ->read() on a regular file is not allowed to touch ->i_mutex unless
O_DIRECT is present in file flags at the moment of ->read()
Correct?
