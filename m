Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaJaHqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:46:08 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:50343 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbaJaHqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:46:05 -0400
Message-ID: <1414741562.3014.8.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2 3/4] backports: use BACKPORT_DIR prefix on kconfig
 sources
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 31 Oct 2014 08:46:02 +0100
In-Reply-To: <1414570902-5675-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20141029_092321_193267_F4A1051E)
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141029_092321_193267_F4A1051E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 01:21 -0700, Luis R. Rodriguez wrote:

>  src_line = re.compile(r'^\s*source\s+"?(?P<src>[^\s"]*)"?\s*$')
> +bk_src_line = re.compile(r'^\s*source\s+"?\$BACKPORT_DIR/(?P<src>[^\s"]*)"?\s*$')
>  tri_line = re.compile(r'^(?P<spc>\s+)tristate')
>  bool_line = re.compile(r'^(?P<spc>\s+)bool')
>  cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
> @@ -21,23 +22,47 @@ class ConfigTree(object):
>          yield f
>          for l in open(os.path.join(self.basedir, f), 'r'):
>              m = src_line.match(l)
> -            if m and os.path.exists(os.path.join(self.basedir, m.group('src'))):
> -                for i in self._walk(m.group('src')):
> -                    yield i
> +            if m:
> +                bm = bk_src_line.match(l)
> +                if bm:
> +                    if os.path.exists(os.path.join(self.basedir, bm.group('src'))):
> +                        for i in self._walk(os.path.join(self.basedir, bm.group('src'))):
> +                            yield i
> +                    elif os.path.exists(os.path.join(self.basedir, 'backports/' + bm.group('src'))):
> +                        for i in self._walk(os.path.join(self.basedir, 'backports/' + bm.group('src'))):
> +                            yield i
> +                else:
> +                    if os.path.exists(os.path.join(self.basedir, m.group('src'))):
> +                        for i in self._walk(m.group('src')):
> +                            yield i

Are you even using the src_line regular expression any more? Seems like
you could just modify it though to make the (\$BACKPORT_DIR/) part
optional.

>      def _prune_sources(self, f, ignore):
>          for nf in self._walk(f):
>              out = ''
>              for l in open(os.path.join(self.basedir, nf), 'r'):
> -                m = src_line.match(l)
> -                if not m:
> -                    out += l
> -                    continue
> -                src = m.group('src')
> -                if src in ignore or os.path.exists(os.path.join(self.basedir, src)):
> -                    out += l
> +                bm = bk_src_line.match(l)
> +                if bm:
> +                    bp_src = bm.group('src')
> +                    if bp_src in ignore or \
> +                       os.path.exists(os.path.join(self.basedir, bp_src)) or \
> +                       os.path.exists(os.path.join(self.basedir, 'backports/' + bp_src)):

I'd prefer parentheses instead of \ line continuations :)

the backports/ part seems to be for integration only?

> +                    m = src_line.match(l)
> +                    # we should consider disallowing these as it could mean
> +                    # someone forgot to add the BACKPORT_DIR prefix to
> +                    # the kconfig source entries which we will need to
> +                    # support built-in integration.

If you put it in the same RE then you can just print a warning on this
if detected but skip it otherwise.

johannes

