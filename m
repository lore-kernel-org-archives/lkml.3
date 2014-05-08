Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaEHUoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:44:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbaEHUoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:44:10 -0400
Date: Thu, 8 May 2014 22:44:08 +0200
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kbuild: Use relative paths if possible
Message-ID: <20140508204408.GA1184@pobox.suse.cz>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz> <20140430161358.GB15320@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430161358.GB15320@ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 06:13:59PM +0200, Sam Ravnborg wrote:
> On Tue, Apr 29, 2014 at 04:08:08PM +0200, Michal Marek wrote:
> > Hi,
> > 
> > This series changes the Makefile to use relative paths for $(objtree),
> > always setting it to '.', and for $(srctree) setting either to '.' or
> > '..', when building in the source tree or a subdirectory thereof,
> > respectively. The goal is to make compiler messages and Ooopses more
> > readable by avoiding the full path to the source/object directory.
> > 
> > Patch 2/5 is just an unrelated cleanup.
> > 
> > Michal
> > 
> > Michal Marek (5):
> >   firmware: Simplify directory creation
> >   firmware: Use $(quote) in the Makefile
> >   kbuild: Use relative path for $(objtree)
> >   kbuild: Use relative path when building in the source tree
> >   kbuild: Use relative path when building in a subdir of the source tree
> 
> For patch 2,3,4 and 5 you can add my:
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Patch 1 also looks good, but I did not fully grasp it and this is MO
> implied by an ack. So please do not hold it back due to this as
> the cleanup looked good.

I found a bug caused by 3/5 and 4/5: The source and build symlinks
created by modules_install were wrong. The fix is simple:

diff --git a/Makefile b/Makefile
index 3d311b6..9872c53 100644
--- a/Makefile
+++ b/Makefile
@@ -1064,10 +1064,10 @@ _modinst_:
 	@rm -rf $(MODLIB)/kernel
 	@rm -f $(MODLIB)/source
 	@mkdir -p $(MODLIB)/kernel
-	@ln -s $(srctree) $(MODLIB)/source
+	@ln -s `cd $(srctree) && /bin/pwd` $(MODLIB)/source
 	@if [ ! $(objtree) -ef  $(MODLIB)/build ]; then \
 		rm -f $(MODLIB)/build ; \
-		ln -s $(objtree) $(MODLIB)/build ; \
+		ln -s $(CURDIR) $(MODLIB)/build ; \
 	fi
 	@cp -f $(objtree)/modules.order $(MODLIB)/
 	@cp -f $(objtree)/modules.builtin $(MODLIB)/

I will fold it into the respective patches and send a V2.

Michal
