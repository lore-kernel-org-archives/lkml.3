Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaJOXYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:24:48 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42137 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaJOXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:24:38 -0400
Date: Thu, 16 Oct 2014 01:24:20 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v4 2/5] fuse: Support fuse filesystems outside of
 init_user_ns
Message-ID: <20141015232420.GA7630@ubuntu-mba51>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.sourceforge.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
 <1413296756-25071-3-git-send-email-seth.forshee@canonical.com>
 <543E8983.5090001@mit.edu>
 <20141015150512.GA22951@ubuntu-mba51>
 <CALCETrXtHGzBbxFjZ_S3Zb0KkN1y6Uqm6CNkYSY37BLLcocFGw@mail.gmail.com>
 <20141015225900.GC988@ubuntu-mba51>
 <CALCETrWuc8x60A9v9xSL1Jbk0ZgiXsL_o20wc0PyPDgO9g6BRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWuc8x60A9v9xSL1Jbk0ZgiXsL_o20wc0PyPDgO9g6BRg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 04:07:34PM -0700, Andy Lutomirski wrote:
> On Wed, Oct 15, 2014 at 3:59 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Wed, Oct 15, 2014 at 10:05:46AM -0700, Andy Lutomirski wrote:
> >> On Wed, Oct 15, 2014 at 8:05 AM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > On Wed, Oct 15, 2014 at 07:49:39AM -0700, Andy Lutomirski wrote:
> >> >> On 10/14/2014 07:25 AM, Seth Forshee wrote:
> >> >> > Update fuse to translate uids and gids to/from the user namspace
> >> >> > of the process servicing requests on /dev/fuse. Any ids which do
> >> >> > not map into the namespace will result in errors. inodes will
> >> >> > also be marked bad when unmappable ids are received from
> >> >> > userspace.
> >> >> >
> >> >> > Due to security concerns the namespace used should be fixed,
> >> >> > otherwise a user might be able to gain elevated privileges or
> >> >> > influence processes that the user would otherwise be unable to
> >> >> > manipulate. Thus the namespace of the mounting process is used
> >> >> > for all translations, and this namespace is required to be the
> >> >> > same as the one in use when /dev/fuse was opened.
> >> >> >
> >> >>
> >> >> I'm not sure that this is necessary if my nosuid patch goes in, but I
> >> >> also don't think it makes any sense to hold this up while we find a
> >> >> perfect solution.
> >> >>
> >> >> Is there a decent way to extend this to different translation schemes in
> >> >> the future (e.g. a flag at fs setup that could be used)?
> >> >
> >> > I think it would be possible to relax the translation scheme
> >> > restrictions in the future, certainly that's easier than tightening down
> >> > a looser restriction. I still favor picking one namespace to use for
> >> > translation (surely that's how it would work with other filesystems
> >> > anyway) rather than using the current namespace during /dev/fuse I/O. I
> >> > did an implementation using the latter technique, and it's far more
> >> > complex with no benefits that I can see.
> >>
> >> Long term, I think we'll want more flexible translations for
> >> filesystems on removable media, even when both the mounter and the
> >> accessing process are in the init user namespace.  But this can wait.
> >
> > You've piqued my interest. What are you thinking of which would require
> > this flexibility?
> >
> 
> For an easy example, if I stick a USB stick into my computer and copy
> a file to it, I probably want the file to be owned by uid 0 in the FS
> metadata (but still owned by me as reported by stat(2) and friends).
> 
> For a more complex example, tools like Sandstorm (http://sandstorm.io)
> probably want to use FUSE mounted by an outer (non-root) userns and
> accessed from an inner userns.  With your patches, this *might* work,
> but it might also be a little tricky.

This at least should work fine with my patches so long as the fuse mount
has the allow_other option the inner userns is a descendant of the outer
ns. I don't think there's anything tricky, though I do suspect you'll
also want the default_permissions option.

Thanks,
Seth

> 
> I can also see this ability being extremely useful for NFS and other
> network filesystems, where keeping all the uids in sync is currently a
> royal PITA.
> 
> --Andy
