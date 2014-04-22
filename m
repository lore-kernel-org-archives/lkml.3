Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaDVNkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:40:18 -0400
Received: from mail-wg0-f73.google.com ([74.125.82.73]:47206 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaDVNkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:40:12 -0400
X-Greylist: delayed 3056 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2014 09:40:12 EDT
Date: Tue, 22 Apr 2014 12:47:00 +0100
From: David Drysdale <drysdale@google.com>
To: Meredydd Luff <meredydd@senatehouse.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH signal#execve2] syscalls,x86: Add execveat() system call
 (v3)
Message-ID: <20140422114700.GA30475@google.com>
References: <1347411352-12392-1-git-send-email-meredydd@senatehouse.org>
 <20120912011654.GQ13973@ZenIV.linux.org.uk>
 <20130106163100.GI4939@ZenIV.linux.org.uk>
 <CAD=T17Fs4bMJedpuO9JEDbrzEBOQcd+5v3BxUDkNH_NRRkh64A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=T17Fs4bMJedpuO9JEDbrzEBOQcd+5v3BxUDkNH_NRRkh64A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 12:39:48PM +0000, Meredydd Luff wrote:
> On Sun, Jan 6, 2013 at 4:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK, now that sys_execve() unification has settled down, let's get back
> > to this one.

It's been a while, but I'd like to re-awaken this thread and patch;
given the radio silence I'm assuming that Meredydd didn't manage to
progress this any further.

> > The real problem is what you are doing with bprm->filename
> > and bprm->interp; blind use of ->d_name is completely wrong.
> ACK. I've blocked out tomorrow to dive in and figure out what I should
> be doing instead. My current plan is "look at how we get a string
> value out when readlink()ing /proc/self/fd/N, then copy that
> approach". Feel free to save me from wasting time if this is a bad
> idea.

Following Meredydd's plan, the procfs code (in do_proc_readlink()) uses
d_path(), so would using d_path(&file->f_path,...) on the file opened
from the (fd, filename) pair do what's needed here?  That looks like
it will be safe against renames (as it makes a copy of the name under
rcu_read_lock).
 
> > For what it's worth, how should it work for e.g. shell scripts?  That's
> > the main user of bprm->{filename,interp}, after all - other places are
> > either seriously exotic or are just using it for printks.
> >
> > For shell scripts, however, these guys are really used - we have the original
> > argv[0] removed and <shell name> <optional argument> <filename> pushed in
> > its place.
>
> As I see it, this is a question of how much can be supported.
> Fundamentally, a hash-bang interpreter is handed a filename. This will
> inevitably break in a world in which not everything you want to
> execute can be reliably named by a path in the interpreter's
> namespace. The demand for a "real" fexecve() argues that this world is
> desirable, and under those circumstances the best you can hope for is
> probably to fail gracefully, or at least predictably.
>
> > How will it work with execveat()?  If we have procfs in place, we can
> > cook an equivalent pathname (/proc/self/fd/<n>/<relative part of pathname>),
> > but then why not do just that in userland and be done with that?
> A pure-userland execveat() suffers all the problems of a pure-userland
> fexecve(). I think it's important to be able to use this in
> environments where /proc is absent or not trustworthy (weird embedded
> systems, sandboxes, etc).

As an aside, this is also why I'm interested in this patch -- in
particular for sandbox environments with /proc inaccessible.

Regards,
David

> If I'm understanding this right, the behaviour I was originally
> planning would leave the hash-bang interpreter with a pathname that
> "should" resolve to the script, barring jiggery-pokery with passing
> FDs between namespaces - but without the atomicity of the *at() call.
> This places execveat() into the category of "desirable things whose
> atomicity guarantees interact poorly with shell scripts" (a group with
> a long and [ig]noble history).
>
> I suppose the munging could be conditional: "If /proc is owned by root
> and mounted as procfs, we'll give you a /proc/self/fd/... path.
> Otherwise you're on your own and getting whatever
> readlink(/proc/self/fd/<n>) would have given you." But that would
> still require the kernel knowing something about the filesystem
> layout.
>
> Either way, it seems, we leave a rake in the grass for somebody...
>
> Meredydd

