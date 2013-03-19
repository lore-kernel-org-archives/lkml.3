Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3CST4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab3CST4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:56:49 -0400
Date: Tue, 19 Mar 2013 20:54:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH -mm] argv_split-teach-it-to-handle-mutable-strings-fix-2
Message-ID: <20130319195427.GA18670@redhat.com>
References: <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com> <20130316202327.GA18613@redhat.com> <20130316202353.GB18613@redhat.com> <20130318145333.abecd78f3dde5e1307a7e493@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318145333.abecd78f3dde5e1307a7e493@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Andrew Morton wrote:
>
> On Sat, 16 Mar 2013 21:23:53 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +	argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);
>
> kstrndup() does kmalloc_track_caller(len+1, gfp) so your
> KMALLOC_MAX_SIZE is off-by-one?

Yes... 'max' is strlen(), not sizeof()...

Actually we could even use ULONG_MAX, the last zero byte in "str" should
be never overwritten. Or we could use some "reasonable" and lower limit.

But I agree, kstrndup(KMALLOC_MAX_SIZE) doesn't look good, please find
fix-2 below.

> From reading the code it is rather unobvious why things were
> implemented in this fashion.  People may come along in five years and
> "clean it up".  Hence we should explain, no?

Yes, thanks for this comment!
---
 lib/argv_split.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/argv_split.c b/lib/argv_split.c
index cac7ec4..e927ed0 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -63,7 +63,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 	char **argv, **argv_ret;
 	int argc;
 
-	argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);
+	argv_str = kstrndup(str, KMALLOC_MAX_SIZE - 1, gfp);
 	if (!argv_str)
 		return NULL;
 
-- 
1.5.5.1


