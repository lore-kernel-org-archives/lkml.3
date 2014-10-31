Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaJaUDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:03:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270AbaJaUDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:03:18 -0400
Date: Fri, 31 Oct 2014 21:03:16 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [RFC v2 3/4] backports: use BACKPORT_DIR prefix on kconfig
	sources
Message-ID: <20141031200316.GC12953@wotan.suse.de>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com> <1414570902-5675-4-git-send-email-mcgrof@do-not-panic.com> <1414741562.3014.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414741562.3014.8.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 08:46:02AM +0100, Johannes Berg wrote:
> On Wed, 2014-10-29 at 01:21 -0700, Luis R. Rodriguez wrote:
> 
> >  src_line = re.compile(r'^\s*source\s+"?(?P<src>[^\s"]*)"?\s*$')
> > +bk_src_line = re.compile(r'^\s*source\s+"?\$BACKPORT_DIR/(?P<src>[^\s"]*)"?\s*$')
> >  tri_line = re.compile(r'^(?P<spc>\s+)tristate')
> >  bool_line = re.compile(r'^(?P<spc>\s+)bool')
> >  cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
> > @@ -21,23 +22,47 @@ class ConfigTree(object):
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
> Are you even using the src_line regular expression any more? Seems like
> you could just modify it though to make the (\$BACKPORT_DIR/) part
> optional.

Sure make sense. I suppose we should be consistant too and use $BACKPORT_DIR.

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
> I'd prefer parentheses instead of \ line continuations :)

OK :)

> the backports/ part seems to be for integration only?

I think I went trigger happy since the bk_src_line should have picked
up on the fact that backports directory prefix would already have been
used. I'll re-test and remove not needed thing and try to consolidate
the regexp.

> > +                    m = src_line.match(l)
> > +                    # we should consider disallowing these as it could mean
> > +                    # someone forgot to add the BACKPORT_DIR prefix to
> > +                    # the kconfig source entries which we will need to
> > +                    # support built-in integration.
> 
> If you put it in the same RE then you can just print a warning on this
> if detected but skip it otherwise.

What I meant by this was more of the things that could go into a Kconfig
which we perhaps are not parsing yet which might depend on a path, so
its not clear to me what regexp to use. Right now it will just leave
the lines intact and I guess that's fine for now.

  Luis
