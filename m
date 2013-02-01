Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3BATeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:34:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51737 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3BATeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:34:05 -0500
Date: Fri, 1 Feb 2013 19:34:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: chenggang.qin@gmail.com
Cc: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@alibaba-inc.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Tracepoint: Add 'file name' as a parameter of tracepoint
 events ext4:ext4_direct_IO_enter&ext4:ext4_direct_IO_exit
Message-ID: <20130201193402.GQ4503@ZenIV.linux.org.uk>
References: <y>
 <510be15d.29bf440a.56c6.ffffb82e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510be15d.29bf440a.56c6.ffffb82e@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 11:37:38PM +0800, chenggang.qin@gmail.com wrote:
> @@ -3213,13 +3214,15 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
>  	if (ext4_has_inline_data(inode))
>  		return 0;
>  
> -	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
> +	fname = file->f_path.dentry->d_name.name;
> +	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw,
> +				   fname);

Oh, wonderful...  "your patch is racy; there's no warranty that fname will
not be freed right under you" -- "OK, we shouldn't do it in VFS... let's
try to do exact same thing in ext4, then"

Let me spell it out for you: opened files *can* be renamed while they are
in the middle of IO.  If both old and new names are short, the contents
of ->d_name.name will be overwritten, so dereferencing your fname can yield
a mix of old and new name, or something that isn't NUL-terminated.  If they
are long enough, they will be allocated separately from struct dentry and
your fname can bloody well end up pointing to freed memory by the time you
get around to dereferencing it.

Again, there is no exclusion between ext4_direct_IO() (or its callers) and
rename().  The NAK still stands.
