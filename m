Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaKEHvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:51:53 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:60084 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaKEHvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:51:50 -0500
Message-ID: <1415173905.2589.5.camel@sipsolutions.net>
Subject: Re: [PATCH v2 05/13] backports: use BACKPORT_DIR prefix on kconfig
 sources
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 05 Nov 2014 08:51:45 +0100
In-Reply-To: <1415157517-15442-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20141105_042146_840615_9D542D35)
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415157517-15442-6-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141105_042146_840615_9D542D35)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:

> @@ -21,23 +22,53 @@ class ConfigTree(object):
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

Shouldn't this depend on "integrate" rather than on existence?

Ah, this is what you were alluding to in the commit log? The fact that
you hardcode "backports/" into this? IMHO it would make more sense to
pass in the "base" directory (either "backports/" or "") though, instead
of making *that* depend on the existence of the directory as well.

Remember, the existence check here serves to remove includes that cannot
be satisfied; your existence check mixes in the differentiation between
packaged and integrated, which doesn't seem right.

Regardless of whether you make the "backports/" prefix configurable or
not, you should pass it to this library function and use it
unconditionally instead of trying to determine package vs. integrated
from the existence of directories.

 
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

same here.

johannes

