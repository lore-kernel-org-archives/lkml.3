Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaJUQeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:34:50 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:32962 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaJUQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:34:49 -0400
Date: Tue, 21 Oct 2014 11:34:26 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v3] fs: Treat foreign mounts as nosuid
Message-ID: <20141021163426.GB68568@ubuntu-hedt>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net,
	Miklos Szeredi <miklos@szeredi.hu>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>
References: <252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:54:47PM -0700, Andy Lutomirski wrote:
> If a process gets access to a mount from a different namespace user
> namespace, that process should not be able to take advantage of
> setuid files or selinux entrypoints from that filesystem.
> Technically, trusting mounts created by the same or ancestor user
> namespaces ought to be safe, but it's simpler to distrust all
> foreign mounts.
> 
> This will make it safer to allow more complex filesystems to be
> mounted in non-root user namespaces.
> 
> This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
> setgid, and file capability bits can no longer be abused if code in
> a user namespace were to clear nosuid on an untrusted filesystem,
> but this patch, by itself, is insufficient to protect the system
> from abuse of files that, when execed, would increase MAC privilege.
> 
> As a more concrete explanation, any task that can manipulate a
> vfsmount associated with a given user namespace already has
> capabilities in that namespace and all of its descendents.  If they
> can cause a malicious setuid, setgid, or file-caps executable to
> appear in that mount, then that executable will only allow them to
> elevate privileges in exactly the set of namespaces in which they
> are already privileges.
> 
> On the other hand, if they can cause a malicious executable to
> appear with a dangerous MAC label, running it could change the
> caller's security context in a way that should not have been
> possible, even inside the namespace in which the task is confined.
> 
> As a hardening measure, this would have made CVE-2014-5207 much
> more difficult to exploit.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Now that I'm back from plumbers I've finally had a chance to play around
with this and it seems to be working as expected. I'll be considering
this patch a prerequisite for the next round of fuse userns patches.

Acked-by: Seth Forshee <seth.forshee@canonical.com>
