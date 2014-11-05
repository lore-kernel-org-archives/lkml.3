Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKEULL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:11:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbaKEULH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:11:07 -0500
Date: Wed, 5 Nov 2014 21:11:05 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 05/13] backports: use BACKPORT_DIR prefix on kconfig
	sources
Message-ID: <20141105201105.GO12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-6-git-send-email-mcgrof@do-not-panic.com> <1415173905.2589.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415173905.2589.5.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:51:45AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:
> 
> > @@ -21,23 +22,53 @@ class ConfigTree(object):
> >          yield f
> >          for l in open(os.path.join(self.basedir, f), 'r'):
> >              m = src_line.match(l)
> > -            if m and os.path.exists(os.path.join(self.basedir, m.group('src'))):
> > -                for i in self._walk(m.group('src')):
> > -                    yield i
> > +            if m:
> > +                bm = bk_src_line.match(l)
> > +                if bm:
> > +                    if os.path.exists(os.path.join(self.basedir, bm.group('src'))):
> > +                        for i in self._walk(os.path.join(self.basedir, bm.group('src'))):
> > +                            yield i
> > +                    elif os.path.exists(os.path.join(self.basedir, 'backports/' + bm.group('src'))):
> > +                        for i in self._walk(os.path.join(self.basedir, 'backports/' + bm.group('src'))):
> > +                            yield i
> > +                else:
> > +                    if os.path.exists(os.path.join(self.basedir, m.group('src'))):
> > +                        for i in self._walk(m.group('src')):
> > +                            yield i
> 
> Shouldn't this depend on "integrate" rather than on existence?
> 
> Ah, this is what you were alluding to in the commit log? The fact that
> you hardcode "backports/" into this? IMHO it would make more sense to
> pass in the "base" directory (either "backports/" or "") though, instead
> of making *that* depend on the existence of the directory as well.
> 
> Remember, the existence check here serves to remove includes that cannot
> be satisfied; your existence check mixes in the differentiation between
> packaged and integrated, which doesn't seem right.
> 
> Regardless of whether you make the "backports/" prefix configurable or
> not, you should pass it to this library function and use it
> unconditionally instead of trying to determine package vs. integrated
> from the existence of directories.

Fair enough.

> >      def _prune_sources(self, f, ignore):
> >          for nf in self._walk(f):
> >              out = ''
> >              for l in open(os.path.join(self.basedir, nf), 'r'):
> > -                m = src_line.match(l)
> > -                if not m:
> > -                    out += l
> > -                    continue
> > -                src = m.group('src')
> > -                if src in ignore or os.path.exists(os.path.join(self.basedir, src)):
> > -                    out += l
> > +                bm = bk_src_line.match(l)
> > +                if bm:
> > +                    bp_src = bm.group('src')
> > +                    if bp_src in ignore or \
> > +                       os.path.exists(os.path.join(self.basedir, bp_src)) or \
> > +                       os.path.exists(os.path.join(self.basedir, 'backports/' + bp_src)):
> 
> same here.

Yeah I get it, good points.

This does mean that bp_prefix topic *can* also be tied down
with this other directory prefix as a form of 'builder' for
integration. Making the prefix configurable would make sense
then only if also making the directory prefix should be
configurable.

I think we're better off right now with just supporting two
approaches with their own directory prefix, and prefixes
for variables.

  Luis
