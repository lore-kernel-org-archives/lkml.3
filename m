Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaIAJie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:38:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42707 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbaIAJib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:38:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] binfmt_misc: touch up documentation a bit
Date: Mon,  1 Sep 2014 05:38:29 -0400
Message-Id: <1409564309-2393-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409564309-2393-1-git-send-email-vapier@gentoo.org>
References: <1409564309-2393-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line wrap the content to 80 cols, and add more details to various
fields to match the code.  Drop reference to a website that does
not exist anymore.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/binfmt_misc.txt | 48 +++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/Documentation/binfmt_misc.txt b/Documentation/binfmt_misc.txt
index f64372b..6b1de70 100644
--- a/Documentation/binfmt_misc.txt
+++ b/Documentation/binfmt_misc.txt
@@ -15,39 +15,50 @@ First you must mount binfmt_misc:
 	mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc 
 
 To actually register a new binary type, you have to set up a string looking like
-:name:type:offset:magic:mask:interpreter:flags (where you can choose the ':' upon
-your needs) and echo it to /proc/sys/fs/binfmt_misc/register.
+:name:type:offset:magic:mask:interpreter:flags (where you can choose the ':'
+upon your needs) and echo it to /proc/sys/fs/binfmt_misc/register.
+
 Here is what the fields mean:
  - 'name' is an identifier string. A new /proc file will be created with this
-   name below /proc/sys/fs/binfmt_misc
+   name below /proc/sys/fs/binfmt_misc; cannot contain slashes '/' for obvious
+   reasons.
  - 'type' is the type of recognition. Give 'M' for magic and 'E' for extension.
  - 'offset' is the offset of the magic/mask in the file, counted in bytes. This
-   defaults to 0 if you omit it (i.e. you write ':name:type::magic...')
+   defaults to 0 if you omit it (i.e. you write ':name:type::magic...'). Ignored
+   when using filename extension matching.
  - 'magic' is the byte sequence binfmt_misc is matching for. The magic string
-   may contain hex-encoded characters like \x0a or \xA4. In a shell environment
-   you will have to write \\x0a to prevent the shell from eating your \.
+   may contain hex-encoded characters like \x0a or \xA4. Note that you must
+   escape any NUL bytes; parsing halts at the first one. In a shell environment
+   you might have to write \\x0a to prevent the shell from eating your \.
    If you chose filename extension matching, this is the extension to be
    recognised (without the '.', the \x0a specials are not allowed). Extension
-   matching is case sensitive!
+   matching is case sensitive, and slashes '/' are not allowed!
  - 'mask' is an (optional, defaults to all 0xff) mask. You can mask out some
    bits from matching by supplying a string like magic and as long as magic.
-   The mask is anded with the byte sequence of the file.
+   The mask is anded with the byte sequence of the file. Note that you must
+   escape any NUL bytes; parsing halts at the first one. Ignored when using
+   filename extension matching.
  - 'interpreter' is the program that should be invoked with the binary as first
    argument (specify the full path)
  - 'flags' is an optional field that controls several aspects of the invocation
-   of the interpreter. It is a string of capital letters, each controls a certain
-   aspect. The following flags are supported -
-      'P' - preserve-argv[0].  Legacy behavior of binfmt_misc is to overwrite the
-            original argv[0] with the full path to the binary.  When this flag is
-            included, binfmt_misc will add an argument to the argument vector for
-            this purpose, thus preserving the original argv[0].
+   of the interpreter. It is a string of capital letters, each controls a
+   certain aspect. The following flags are supported -
+      'P' - preserve-argv[0]. Legacy behavior of binfmt_misc is to overwrite
+            the original argv[0] with the full path to the binary. When this
+            flag is included, binfmt_misc will add an argument to the argument
+            vector for this purpose, thus preserving the original argv[0].
+            e.g. If your interp is set to /bin/foo and you run `blah` (which is
+            in /usr/local/bin), then the kernel will execute /bin/foo with
+            argv[] set to ["/bin/foo", "/usr/local/bin/blah", "blah"].  The
+            interp has to be aware of this so it can execute /usr/local/bin/blah
+            with argv[] set to ["blah"].
       'O' - open-binary. Legacy behavior of binfmt_misc is to pass the full path
             of the binary to the interpreter as an argument. When this flag is
             included, binfmt_misc will open the file for reading and pass its
             descriptor as an argument, instead of the full path, thus allowing
-            the interpreter to execute non-readable binaries. This feature should
-            be used with care - the interpreter has to be trusted not to emit
-            the contents of the non-readable binary.
+            the interpreter to execute non-readable binaries. This feature
+            should be used with care - the interpreter has to be trusted not to
+            emit the contents of the non-readable binary.
       'C' - credentials. Currently, the behavior of binfmt_misc is to calculate
             the credentials and security token of the new process according to
             the interpreter. When this flag is included, these attributes are
@@ -110,7 +121,4 @@ passes it the full filename (or the file descriptor) to use.  Using $PATH can
 cause unexpected behaviour and can be a security hazard.
 
 
-There is a web page about binfmt_misc at
-http://www.tat.physik.uni-tuebingen.de
-
 Richard Günther <rguenth@tat.physik.uni-tuebingen.de>
-- 
2.0.0

