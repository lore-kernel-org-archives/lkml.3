Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaFIVJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:09:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbaFIVJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:09:31 -0400
Date: Thu, 5 Jun 2014 17:56:15 +0200
From: Michal Marek <mmarek@suse.cz>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, rdunlap@infradead.org
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
Message-ID: <20140605155614.GA18376@sepie.suse.cz>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
 <1399639944-20551-4-git-send-email-mmarek@suse.cz>
 <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com>
 <538EEA3D.1080105@suse.cz>
 <538F1B41.3060904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F1B41.3060904@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 03:12:33PM +0200, Michal Marek wrote:
> On 2014-06-04 11:43, Michal Marek wrote:
> > On 2014-06-04 11:03, Richard Weinberger wrote:
> >> To reproduce run:
> >> make defconfig ARCH=um O=/mnt/o && make linux ARCH=um O=/mnt/
> >>
> >> If there is anything in UML which needs fixing, please tell. :-)
> > 
> > I'll have a look, thanks for the report.
> 
> Findings so far: For some reason, syscalls_32.h is generated in the
> source tree (which is wrong) and syscalls_64.h is not generated at all.
> Looking further.

Can you try the below patch? The same pattern is used in the rules for
tools/ and tools/% in the main Makefile, need to look into that as well.
But UML should work now.

Michal

>From d4bc590f8716f7dde6b7bca319097ac30a8cb0b4 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Thu, 5 Jun 2014 17:44:44 +0200
Subject: [PATCH] um: Fix for relative objtree when generating x86 headers

In an O= build, rely on the generated Makefile to call the main Makefile
properly. When building in the source tree, we do not need to specify
the -C and O= either. This fixes the problem when $(objtree) is a
relative path and the -C changes the directory.

Reported-by: Richard Weinberger <richard.weinberger@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/um/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 36e658a..e4b1a96 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -111,8 +111,7 @@ endef
 KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
 
 archheaders:
-	$(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
-		ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
+	$(Q)$(MAKE) KBUILD_SRC= ARCH=$(HEADER_ARCH) archheaders
 
 archprepare: include/generated/user_constants.h
 
-- 
1.8.4.5

