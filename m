Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaAFUrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:47:18 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52668 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbaAFUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:47:17 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 6 Jan 2014 12:47:07 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: #pragma once?
Message-ID: <20140106204706.GA16924@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing build-system folks and others likely to know about potential
issues.]

Does anyone have any objection to the use of "#pragma once" instead of
the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
and the latest Sparse all support either method just fine.  (I added
support to Sparse myself.)  Both have equivalent performance.  "#pragma
once" is simpler, and avoids the possibility of a typo in the defined
guard symbol.

That's not a theoretical concern: I've found quite a few headers in the
kernel with typoed (and thus non-functional) include guards.  Rashika
Kheria (CCed) ran into one such header when attempting to add some
includes to fix some warnings (resulting in the broken header being
included twice), and that prompted me to look for other headers with
broken guards.  I've included a Python script at the end of this mail
that finds many such issues, though it does have a few false positives
on files that don't have include guards at all.

I'm not suggesting a mass conversion from include guards to "#pragma
once", though that *would* be fairly easy to script and review if
desired.  I'd just like to verify that "#pragma once" seems acceptable
before, for instance, converting the headers that already have broken
include guards, adding recommendations in Documentation to standardize
on the pragma for new headers, and possibly adding checks in checkpatch
or similar if I can come up with one that has minimal false positives.

Python script to check header guards (run with $(find -name '*.h') as
arguments, and grep for "mismatch" in the output if you don't care about
files without guards):

#!/usr/bin/python
import re
import sys

start = re.compile("[ \t]*#[ \t]*(ifndef|define)[ \t]+([a-zA-Z0-9_]*)")

def main(args):
    for header in args[1:]:
        symbol = None
        for line in open(header):
            m = start.match(line)
            if not m:
                if symbol:
                    print "{}: does not appear to use ifndef-based include guard".format(header)
                    break
                continue
            if m.group(1) == "ifndef":
                if symbol is not None:
                    print "{}: does not appear to use ifndef-based include guard".format(header)
                    break
                symbol = m.group(2)
            elif m.group(1) == "define":
                if symbol is None:
                    print "{}: does not appear to use ifndef-based include guard".format(header)
                    break
                if symbol != m.group(2):
                    print "{}: include guard symbol mismatch: #ifndef {} with #define {}".format(header, symbol, m.group(2))
                break
        else:
            if symbol:
                print "{}: ifndef {} with no subsequent define".format(header, symbol)

if __name__ == "__main__":
    sys.exit(main(sys.argv))
