Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3CCPet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 10:34:49 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:32449 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3CCPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 10:34:48 -0500
Date: Sun, 3 Mar 2013 16:34:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dhowells@redhat.com, mmarek@suse.c, arnd@arndb.de, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
Message-ID: <20130303153444.GA9329@merkur.ravnborg.org>
References: <24020.1353323415@warthog.procyon.org.uk> <26846.1353334165@warthog.procyon.org.uk> <201211202322.AED21884.FJtLHOFSOOQVMF@I-love.SAKURA.ne.jp> <26876.1354110914@warthog.procyon.org.uk> <20130303120221.GA32000@merkur.ravnborg.org> <201303040007.CCB29424.MHFOFtSFOJQVOL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303040007.CCB29424.MHFOFtSFOJQVOL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 12:07:31AM +0900, Tetsuo Handa wrote:
> Sam Ravnborg wrote:
> > On Wed, Nov 28, 2012 at 01:55:14PM +0000, David Howells wrote:
> > > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > > 
> > > > Tetsuo Handa wrote:
> > > > > Linux 3.6 builds fine. I can't use "git bisect" until Linux 3.7-rc6 but
> > > > > possibly caused by either commit 10b63956 "UAPI: Plumb the UAPI Kbuilds
> > > > > into the user header installation and checking" or commit 40f1d4c2 "UAPI:
> > > > > Remove the objhdr-y export list".
> > > > 
> > > > Bisected to commit 10b63956 "UAPI: Plumb the UAPI Kbuilds into the user header
> > > > installation and checking".
> > > 
> > > Indeed, but that doesn't help much.  The problem is that make's behaviour has
> > > apparently changed.  I could do with Sam Ravnborg's help to work around this
> > > since I think he's mainly responsible for the Makefile infrastructure.
> > 
> > Mical is the kbuild person these days.
> > Anyway - it this still relevant?
> > 
> Yes, as of commit a7c1120d "Merge tag 'ext4_for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4" in linux.git still
> has this problem.
> 
> > I took a quick look and my suspect is the use of $(or ..),
> > as this feature was added recently to make.

Hi Tetsuo.

If my guess is correct this patch should help.
I have gmake 3.81 and I do nto see the beforementioned problem.

	Sam

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 25f216a..477d137 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,7 +14,7 @@ kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
 # called may set destination dir (when installing to asm/)
-_dst := $(or $(destination-y),$(dst),$(obj))
+_dst := $(if $(destination-y),$(destination-y),$(if $(dst),$(dst),$(obj)))
 
 old-kbuild-file := $(srctree)/$(subst uapi/,,$(obj))/Kbuild
 ifneq ($(wildcard $(old-kbuild-file)),)
@@ -48,13 +48,14 @@ all-files     := $(header-y) $(genhdr-y) $(wrapper-files)
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
