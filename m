Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab3BZPZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:25:38 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44933 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361Ab3BZPZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:25:36 -0500
Date: Tue, 26 Feb 2013 09:25:31 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] convert headers_install.pl->headers_install.sh
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20130224204256.GK12402@pobox.suse.cz> (from mmarek@suse.cz on
	Sun Feb 24 14:42:56 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361892331.15497.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 02:42:56 PM, Michal Marek wrote:
> On Mon, Dec 17, 2012 at 05:12:51PM -0800, rob@landley.net wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Remove perl from make headers_install by replacing a perl script  
> (doing
> > a simple regex search and replace) with a smaller, faster, simpler,
> > POSIX-2008 shell script implementation.  The new shell script is a  
> single
> > for loop calling sed and piping its output through unifdef to  
> produce the
> > target file.
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
> > ---
> >
> >  scripts/Makefile.headersinst |    4 +-
> >  scripts/headers_install.pl   |   63  
> ---------------------------------
> >  scripts/headers_install.sh   |   43 ++++++++++++++++++++++
> >  3 files changed, 45 insertions(+), 65 deletions(-)
> 
> Hi Rob,
> 
> sorry for the long delay. In general, the patch looks OK, I only have
> two remarks:

Thanks for the review.

> > +		-e 's/(^|[ \t])(inline|asm|volatile)([  
> \t(]|$)/\1__\2__\3/g' \
> 
> This regexp does not match the 'volatile' in
> 
> #define XVMCLOCKPTR(saPriv,lockNo)					 
> \
> 	((volatile struct drm_hw_lock *)(((((unsigned long)  
> (saPriv)->XvMCLockArea) + \
> 				      (VIA_MAX_CACHELINE_SIZE - 1)) &	 
> \
> 				     ~(VIA_MAX_CACHELINE_SIZE - 1)) +	 
> \
> 				    VIA_MAX_CACHELINE_SIZE*(lockNo)))
> 
> in include/uapi/drm/via_drm.h.

Looks like the first range needs to be [ \t(], same as the second one.  
I'll redo the patches with that. (And rediff for offset noise.)

> > --- a/scripts/headers_install.pl
> > +++ /dev/null
> > @@ -1,63 +0,0 @@
> > -#!/usr/bin/perl -w
> > -#
> > -# headers_install prepare the listed header files for use in
> > -# user space and copy the files to their destination.
> > -#
> > -# Usage: headers_install.pl readdir installdir arch [files...]
> > -# installdir: dir to install the files to
> > -# arch:       current architecture
> > -#             arch is used to force a reinstallation when the arch
> > -#             changes because kbuild then detect a command line  
> change.
> 
> You are not passing $(SRCARCH) to the shell script. This seems OK, as
> the list of files changes if needed, but the change should be  
> mentioned
> in the changelog.

Yup. The script wasn't using it, and to invoke it to do different  
things the remaining command line arguments already had to change.

I'll be sure to mention it in the respin, which should be sometime  
after lunch.

> Thanks,
> Michal
> 

Thanks,

Rob