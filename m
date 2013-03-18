Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3CRVHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:07:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3CRVHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [ 49/75] kbuild: fix make headers_check with make 3.80
Date: Mon, 18 Mar 2013 14:07:12 -0700
Message-Id: <20130318210513.798143414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit c4619bc6fa5149a6ab39be845a39142b6a996ea5 upstream.

Commit 10b63956 ("UAPI: Plumb the UAPI Kbuilds into the user header
installation and checking") introduced a dependency of make 3.81
due to use of $(or ...)

We do not want to lift the requirement to gmake 3.81 just yet...
Included are a straightforward conversion to $(if ...)

Bisected-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.headersinst |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -8,7 +8,7 @@
 # ==========================================================================
 
 # called may set destination dir (when installing to asm/)
-_dst := $(or $(destination-y),$(dst),$(obj))
+_dst := $(if $(destination-y),$(destination-y),$(if $(dst),$(dst),$(obj)))
 
 # generated header directory
 gen := $(if $(gen),$(gen),$(subst include/,include/generated/,$(obj)))
@@ -48,13 +48,14 @@ all-files     := $(header-y) $(genhdr-y)
 output-files  := $(addprefix $(installdir)/, $(all-files))
 
 input-files   := $(foreach hdr, $(header-y), \
-		   $(or \
+		   $(if $(wildcard $(srcdir)/$(hdr)), \
 			$(wildcard $(srcdir)/$(hdr)), \
-			$(wildcard $(oldsrcdir)/$(hdr)), \
-			$(error Missing UAPI file $(srcdir)/$(hdr)) \
+			$(if $(wildcard $(oldsrcdir)/$(hdr)), \
+				$(wildcard $(oldsrcdir)/$(hdr)), \
+				$(error Missing UAPI file $(srcdir)/$(hdr))) \
 		   )) \
 		 $(foreach hdr, $(genhdr-y), \
-		   $(or \
+		   $(if	$(wildcard $(gendir)/$(hdr)), \
 			$(wildcard $(gendir)/$(hdr)), \
 			$(error Missing generated UAPI file $(gendir)/$(hdr)) \
 		   ))


