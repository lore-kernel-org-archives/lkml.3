Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3JFGLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:11:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3JFGLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:11:54 -0400
Date: Sat, 5 Oct 2013 17:40:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET v2] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20131006004032.GA3601@kroah.com>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 05:41:54PM -0400, Tejun Heo wrote:
> Hello,
> 
> Changes from the last take[L] are,
> 
> * bin file reads no longer go through seq_file.  It goes through a
>   separate read path implemented in sysfs_bin_read().  bin files
>   shouldn't see any behavior difference now.
> 
> * bin files now use a separate file_operations struct -
>   sysfs_bin_operations.  Open and write paths are still shared but
>   read path is separate and mmap exists only for the bin files.  While
>   this is less uniform than before, it should still render itself well
>   to extracting the core functionality.
> 
> * 0001-0008 are the same as before.

Nice, I've applied all of these now.

> Patchset description follows.
> 
> Currently, sysfs's file handling is a bit weird.
> 
> * Regular and bin file paths are similar but implemented completely
>   separately duplicating some hairy logics.
> 
> * Read path implements custom buffering which is essentially
>   degenerate seq_file.
> 
> In addition, sysfs core implementation is planned to be separated out
> so that it can be shared by other subsystems and the current file
> handling is too restrictive and quirky to spread further to other
> parts of the kernel.  It'd be a lot more desirable to have read path
> completely handled by seq_file which is a lot more versatile and would
> also increase overall behavior consistency.
> 
> This patchset updates file handling such that read is handled by
> seq_file and then merges bin file handling into regular file path.
> While some changes introduces behavior changes in extreme corner
> cases, they are highly unlikely to be noticeable (please refer to the
> description of each patch for details) and generally bring sysfs's
> behavior closer to those of procfs or any pseudo filesystem which
> makes use of seq_file.
> 
> After the conversion, LOC is reduced by ~150 lines and read path is
> fully handled by seq_file, which allows defining a new seq_file based
> core interface which will enable sharing sysfs from other subsystems.

I'm glad to see the sysfs cleanups, thanks for doing all of this, it's
much needed.

How are you going to use sysfs from another kernel subsystem?  Is this
for another filesystem, or do you want to use kobjects for some other
subsystem that doesn't export them using sysfs?

thanks,

greg k-h
