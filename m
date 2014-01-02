Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaABSPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:15:18 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:43908
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaABSPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:15:16 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=LcaDllckn3IA:10 a=Rttt9Z-za7sA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=-PkhLDywX0wA:10
 a=YdvjBBeHVNuEF_OPMyQA:9 a=yO5KfVRaFDHA_cZ7:21 a=5RMLR-f8Oa0lT8Ls:21
 a=QEXdDO2ut3YA:10
Date: Thu, 2 Jan 2014 18:15:13 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect
 failed
Message-ID: <20140102181513.GA9391@milliways>
References: <201401011752.00267.gheskett@wdtv.com>
 <20140102040815.GA25619@milliways>
 <20140102044534.GA26440@milliways>
 <201401020024.56566.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201401020024.56566.gheskett@wdtv.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 12:24:56AM -0500, Gene Heskett wrote:
> On Wednesday 01 January 2014, Ken Moffat wrote:
> >On Thu, Jan 02, 2014 at 04:08:15AM +0000, Ken Moffat wrote:
> >>  Anyway, best of luck and I hope you get it sorted.
> >
> > One further suggestion, since you appear to be at the "running
> >round in circles" stage -
> >
> >1. Start with a good kernel.  In this case, I suppose 3.8.2 is the
> >right place to begin.
> 
> That has since died, won't boot, don't recall changing a thing in the 
> .config either.
> 

 That makes things harder.  Do you have any backups from when it
booted ? (kernel, modules, and grub.cfg might all have been
accidentally overwritten).

 To reply to your earlier post about a lack of local tarballs : try
installing wget (if you don't already have it), or use a firefox
variant on a desktop machine and then transfer it to the phenom.

 For convenience, I always download the 3.x.0 kernel as a tarball,
and then 3.x.{1..n} as patches.  And I usually rename the directory
as linux-3.x-stable so that I can remember what it is, and also so
that it doesn't get overwritten if I untar a fresh copy for other
reasons.  So, first I use 'head Makefile' to confirm the current
version.  I then remove any stable patch using 'xzcat | patch -R
-p1' so that I'm back to 3.x.0 and then apply the patch for the next
version I want to test.

 Lots of possible variations on this exist, particularly when I'm
bisecting.  The important thing is to have a process which works for
you - for stable kernels, some people will prefer to use a fresh
3.x.y tarball each time.
> >2. But then change the .config to -
> >
> >2.1 ensure that your disk filesystems are built in - e.g. all of
> >ext2, ext3, ext4 and anything else you know you are using.
> 
> Should I edit in the /etc/grub.d to remove the modprobe ext2, or will it 
> more or less silently shake its head and go on. 
> 
 I think the modprobe instructions in the grub files are used to
ensure that grub can load its own modules before it tries to read
the specified kernel.  So no, I would not change that.  The kernel's
own modules (specifically ext2/3/4) are something else - without an
initrd, the kernel needs the filesystem used for '/' to be built in.

 So : if the kernel starts to boot, the grub part is ok.
> >Normally, only the fs for '/' needs to be built in, but you seem to
> >have seen other issues so I would just build in everything you need.
> >
> >2.2 build in everything else you need to boot (normally, the disk
> >controller(s) ) so that you don't need an initrd.
> 
> That would be forcedeath, nouveau, v4l1 and 2 and hda_audio for starters.
> 

 Nouveau and forcedeath will probably be convenient, but the rest
ought to be ok as modules.  In this context, I mean whatever you need
for the kernel to get to a position where it can load modules.  So,
it needs the disk driver(s) and the root filesystem (where
/lib/modules lives).
> Since this kernel isn't near new enough for the config tricks mentioned, 
> maybe I'll see if the linux-stable I have can do a 3.11.0 checkout.
> 

> >2.4 for your convenience, ensure that you have enabled the config to
> >be stored in /proc/config.gz - once you are building your own
> >slimmed-down kernels, you probably won't want to mess about with
> >distro "install" scripts so just copying the bzimage to
> >/boot/vmlinuz-x.y.z, make modules_install, and editing
> >/boot/grub/grub.cfg (yes, really!) will save a lot of time.
> 
> My present script does everything but edit grub.cfg.
> 
[...]
> >3.  That might take two or three attempts to get to a good config,
> >but after that you should be able to use the slimmer config (from
> >zcat /proc/config.gz) to create .config for any newer version you
> >want to test or bisect, and then just run make oldconfig before you
> >build.
> >
> > Also, when you get back to bisecting, the version in the kernel
> >Makefile might not be what you expect.  If in doubt, you can change
> >it to something which doesn't overwrite any existing modules, e.g.
> >3.8.bisect-1 etc.
> 
> Presently it uses a + sign for in between versions.
> 
 I'm more familiar with bisecting in -rc versions : for those, the
Makefile version will jump back to what it was when the code was
developed.  Very confusing if you weren't expecting it.
> > HTH
> 
> It will, if I don't lose my place...
> >ؤ¸en
> 
> My "makeit" script does cd's here and there, so its vital that the Makefile 
> version matches the makeit version.  I've thought of that, and fixed it in 
> the copy I use to make a linux-stable install, but I haven't moved that 
> line of script into the tarball builds yet.
> 

 I haven't bothered to script my own kernel builds/installs for many
years - as you say, make sure everything matches.
> Having an automatic increment, I could eventually fill up the /boot 
> partition too. ;-)

 Been there (when /boot was small and used by several available test
systems).  For me, clearing out the old stuff by hand works well
enough.  For scripts, I guess that you already check $?.
> 
> I take it that /proc/config.gz only keeps the lsmod output?  That would be 
> sweet!  Great idea.
> 

 No, it has everything from .config - but gzipped.  Provided the
kernel boots, it will tell you how it was configured.  If it doesn't
boot, the problematic config is in the source tree.  Also saves
space in wherever a distro stores the config.
> Thanks Ken & Cheers, Gene

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
