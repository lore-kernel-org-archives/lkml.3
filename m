Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3IYUL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:11:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3IYUL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:11:27 -0400
Date: Wed, 25 Sep 2013 21:11:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-ID: <20130925201124.GA13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
 <20130925152432.GY13318@ZenIV.linux.org.uk>
 <1380123344.17366.5.camel@joe-AO722>
 <20130925161949.GZ13318@ZenIV.linux.org.uk>
 <1380136920.17366.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380136920.17366.15.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:22:00PM -0700, Joe Perches wrote:
> It's pretty obvious from fs/binfmt_misc.c that you have
> your own taste.
> 
> $ scripts/checkpatch.pl -f --strict fs/binfmt_misc.c
> [...]
> total: 45 errors, 39 warnings, 10 checks, 725 lines checked

*snort*

Most of those are whitespace noise, mostly having nothing whatsoever
to do with me or my taste.  The rest...  Let's see:

linux/uaccess.h instead of asm/uaccess.h.  Reasonable enough these
days.

Several instances of CamelCase that isn't.  Discussed upthread.

"WARNING: do not add new typedefs".  Agreed for non-locals, strongly
disagreed in cases like that.

CHECK: Blank lines aren't necessary after an open brace '{'
#137: FILE: binfmt_misc.c:137:
+       if (fmt->flags & MISC_FMT_OPEN_BINARY) {
+

Agreed, ain't mine...

CHECK: braces {} should be used on all arms of this statement
#187: FILE: binfmt_misc.c:187:
+       if (fmt->flags & MISC_FMT_CREDENTIALS) {
[...]
+       } else
[...]

Umm...  Again, that's not mine and while I agree in principle, in this case
I'm not sure it's worth bothering.

ERROR: switch and case should be at the same indent
#245: FILE: binfmt_misc.c:245:
+               switch (*p) {
+                       case 'P':
[...]
+                       case 'O':
[...]
+                       case 'C':
[...]
+                       default:

Not mine.  I agree about indentation level, but there's more serious
style problem with that sucker - while (cont) thing would be better off
as while (1) { ... { ...  default: return p; } }

CHECK: multiple assignments should be avoided
#291: FILE: binfmt_misc.c:291:
+       p = buf = (char *)e + sizeof(Node);

I hate it when they get religion.  Should be avoided because of...?

A lot of complaints about
+       switch (*p++) {
+               case 'E': e->flags = 1<<Enabled; break;
+               case 'M': e->flags = (1<<Enabled) | (1<<Magic); break;
+               default: goto Einval;
and several other switches like that.  IMO in a situation when all cases are
short, this kind of layout is OK.

WARNING: simple_strtoul is obsolete, use kstrtoul instead
#323: FILE: binfmt_misc.c:323:
+               e->offset = simple_strtoul(p, &p, 10);
Makes sense these days...

Several ones like this:
WARNING: braces {} are not necessary for single statement blocks
#438: FILE: binfmt_misc.c:438:
+       if (e->flags & MISC_FMT_PRESERVE_ARGV0) {
+               *dp++ = 'P';
+       }
Matter of taste...  I probably would've skipped {} here, but it's not something
I'd bother changing in somebody else's patch (and it hadn't passed through
my hands, BTW - hist.git seems to indicate that it was passed by akpm; guess
he also hadn't bothered changing that)

CHECK: multiple assignments should be avoided
#481: FILE: binfmt_misc.c:481:
+               inode->i_atime = inode->i_mtime = inode->i_ctime =
I *do* hate it when they get religion.

ERROR: do not use assignment in if condition
#522: FILE: binfmt_misc.c:522:
+       if (!(page = (char *)__get_free_page(GFP_KERNEL)))
Ditto.


Overall: checkpatch.pl has produced 2 reasonable suggestions and pointed to
a place that is badly written for reasons unrelated to ones mentioned in
the output.  That, along with some amount of BS was buried under tons of noise
about whitespace.
