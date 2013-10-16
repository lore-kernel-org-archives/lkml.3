Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045Ab3JPWmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:42:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55849 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab3JPWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:42:53 -0400
Date: Wed, 16 Oct 2013 23:42:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jim Lieb <jlieb@panasas.com>
Cc: tytso@mit.edu, viro@zeniv.linux.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@redhat.com, jlayton@redhat.com
Subject: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file
 server ops
Message-ID: <20131016224248.GQ13318@ZenIV.linux.org.uk>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
 <1381960919-4542-2-git-send-email-jlieb@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381960919-4542-2-git-send-email-jlieb@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:01:57PM -0700, Jim Lieb wrote:
> File servers must do some operations with the credentials of
> their client.  This syscall switches the key credentials similar
> to nfsd_setuser() in fs/nfsd/auth.c  with the capability of retaining a
> handle to the credentials by way of an fd for an open anonymous file.
> This makes switching for subsequent operations for that client more efficient.

	Yet Another Untyped Multiplexor.  Inna bun.  Onna stick.
CMOT Dibbler special...

	Switching creds to those of opener of given file descriptor
is fine, but in any realistic situation you'll get all the real win
from that - you should cache those fds (which you seem to do), and
then setuid/etc. is done once per cache miss.  Making the magical
"set them all at once" mess (complete with non-trivial structure,
32/64bit compat, etc.) pointless.  Moreover, you don't need any magic
files at all - just set the creds and open /dev/null and there's your fd.
With proper creds associated with it.  While we are at it, just _start_
with opening /dev/null.  With your initial creds.  Voila - revert is
simply switch to that fd's creds.

	IOW, you really need only one syscall:

SYSCALL_DEFINE1(switch_cred, int, fd)
{
	struct fd f = fdget(fd);
	if (!f.file)
		return -EBADF;
	put_cred(override_creds(f.file->f_cred);
	fdput(f);
	return 0;
}

and that's all there is to it.
