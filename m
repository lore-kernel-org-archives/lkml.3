Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab3JOSdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:33:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45242 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737Ab3JOSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:33:29 -0400
X-Sasl-enc: BQcSNuCn8TebOj9buTXOyPJZIAACoxTK3Mz1TCj4SwTy 1381862008
Date: Tue, 15 Oct 2013 11:33:27 -0700
From: Greg KH <greg@kroah.com>
To: Colin Cross <ccross@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arun KS <arunks.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, Bruce Fields <bfields@fieldses.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v1] seq_file: Fix overflow condition in seq_commit
Message-ID: <20131015183327.GE32076@kroah.com>
References: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
 <20130820055153.GH27005@ZenIV.linux.org.uk>
 <CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
 <20130820073622.GK27005@ZenIV.linux.org.uk>
 <20130820140447.GL27005@ZenIV.linux.org.uk>
 <CAMbhsRRMwhugwUX-jeo9q9t+RZNAcWj8BL-c_QuYYpJKd-2w5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRRMwhugwUX-jeo9q9t+RZNAcWj8BL-c_QuYYpJKd-2w5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 03:57:04PM -0700, Colin Cross wrote:
> On Tue, Aug 20, 2013 at 7:04 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Aug 20, 2013 at 08:36:22AM +0100, Al Viro wrote:
> >
> >> Aha.  _That_ is a bug, all right - dynamic_dname() is simply not suitable
> >> for that kind of uses.  ashmem.c is certainly abusing shmem_file_setup();
> >> feeding that kind of mess as dentry name is a Bad Idea(tm).  Anyway,
> >> I'd suggest this for a fix:
> >>
> >>       va_list args;
> >>       size_t sz;
> >>       va_start(args, fmt);
> >>       sz = vsnprintf(NULL, 0, fmt, args) + 1;
> >>       va_end(args);
> >>       if (sz > buflen)
> >>               return ERR_PTR(-ENAMETOOLONG);
> >>       va_start(args, fmt);
> >>       buffer += buflen - sz;
> >>       vsprintf(buffer, fmt, args);
> >>       va_end(args);
> >>       return buffer;
> >>
> >> Either right in dynamic_dname(), or as possibly_fucking_long_dname(),
> >> to be used by shmem.c...
> >
> > Actually, looking at the users of dynamic_dname()...  Most of them are
> > fine with dynamic_dname() as it is, with 2 possible exceptions:
> > hugetlb_dname() and shmem_dname().  Both are using "/%s (deleted)",
> > dentry->d_name.name as format...  So the solution above may very
> > well be an overkill; something like
> >
> > char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
> > {
> >         char *end = buffer + buflen;
> >         /* these dentries are never renamed, so d_lock is not needed */
> >         if (prepend(&end, &buflen, " (deleted)", 11) ||
> >             prepend_name(&end, &buflen, &dentry->d_name) ||
> >             prepend(&end, &buflen, "/", 1))
> >                 end = ERR_PTR(-ENAMETOOLONG);
> >         return end;
> > }
> >
> > will do for those two.  Care to test the diff below?
> >
> > cope with potentially long ->d_dname() output for shmem/hugetlb
> >
> > dynamic_dname() is both too much and too little for those - the
> > output may be well in excess of 64 bytes dynamic_dname() assumes
> > to be enough (thanks to ashmem feeding really long names to
> > shmem_file_setup()) and vsnprintf() is an overkill for those
> > guys.
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 87bdb53..83cfb83 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -2724,6 +2724,17 @@ char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
> >         return memcpy(buffer, temp, sz);
> >  }
> >
> > +char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
> > +{
> > +       char *end = buffer + buflen;
> > +       /* these dentries are never renamed, so d_lock is not needed */
> > +       if (prepend(&end, &buflen, " (deleted)", 11) ||
> > +           prepend_name(&end, &buflen, &dentry->d_name) ||
> > +           prepend(&end, &buflen, "/", 1))
> > +               end = ERR_PTR(-ENAMETOOLONG);
> > +       return end;
> > +}
> > +
> >  /*
> >   * Write full pathname from the root of the filesystem into the buffer.
> >   */
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index a3f868a..4e5f332 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -916,14 +916,8 @@ static int get_hstate_idx(int page_size_log)
> >         return h - hstates;
> >  }
> >
> > -static char *hugetlb_dname(struct dentry *dentry, char *buffer, int buflen)
> > -{
> > -       return dynamic_dname(dentry, buffer, buflen, "/%s (deleted)",
> > -                               dentry->d_name.name);
> > -}
> > -
> >  static struct dentry_operations anon_ops = {
> > -       .d_dname = hugetlb_dname
> > +       .d_dname = simple_dname
> >  };
> >
> >  /*
> > diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> > index b90337c..4a12532 100644
> > --- a/include/linux/dcache.h
> > +++ b/include/linux/dcache.h
> > @@ -336,6 +336,7 @@ extern int d_validate(struct dentry *, struct dentry *);
> >   * helper function for dentry_operations.d_dname() members
> >   */
> >  extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
> > +extern char *simple_dname(struct dentry *, char *, int);
> >
> >  extern char *__d_path(const struct path *, const struct path *, char *, int);
> >  extern char *d_absolute_path(const struct path *, char *, int);
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 8335dbd..e43dc55 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2909,14 +2909,8 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
> >
> >  /* common code */
> >
> > -static char *shmem_dname(struct dentry *dentry, char *buffer, int buflen)
> > -{
> > -       return dynamic_dname(dentry, buffer, buflen, "/%s (deleted)",
> > -                               dentry->d_name.name);
> > -}
> > -
> >  static struct dentry_operations anon_ops = {
> > -       .d_dname = shmem_dname
> > +       .d_dname = simple_dname
> >  };
> >
> >  /**
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Can this patch (committed as 118b23022512eb2f41ce42db70dc0568d00be4ba
> upstream) go in stable?  It fixes a regression introduced in 3.9
> dumping /proc/pid/maps for processes with ashmem regions with long
> names.

Looks good to me, now applied to 3.10-stable, thanks.

greg k-h
