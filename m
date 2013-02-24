Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3BXUnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 15:43:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300Ab3BXUm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 15:42:59 -0500
Date: Sun, 24 Feb 2013 21:42:56 +0100
From: Michal Marek <mmarek@suse.cz>
To: rob@landley.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 3/3] convert headers_install.pl->headers_install.sh
Message-ID: <20130224204256.GK12402@pobox.suse.cz>
References: <50cfc313.6831b60a.0bc4.0604@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50cfc313.6831b60a.0bc4.0604@mx.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 05:12:51PM -0800, rob@landley.net wrote:
> From: Rob Landley <rob@landley.net>
> 
> Remove perl from make headers_install by replacing a perl script (doing
> a simple regex search and replace) with a smaller, faster, simpler,
> POSIX-2008 shell script implementation.  The new shell script is a single
> for loop calling sed and piping its output through unifdef to produce the
> target file.
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  scripts/Makefile.headersinst |    4 +-
>  scripts/headers_install.pl   |   63 ---------------------------------
>  scripts/headers_install.sh   |   43 ++++++++++++++++++++++
>  3 files changed, 45 insertions(+), 65 deletions(-)

Hi Rob,

sorry for the long delay. In general, the patch looks OK, I only have
two remarks:


> +		-e 's/(^|[ \t])(inline|asm|volatile)([ \t(]|$)/\1__\2__\3/g' \

This regexp does not match the 'volatile' in

#define XVMCLOCKPTR(saPriv,lockNo)					\
	((volatile struct drm_hw_lock *)(((((unsigned long) (saPriv)->XvMCLockArea) + \
				      (VIA_MAX_CACHELINE_SIZE - 1)) &	\
				     ~(VIA_MAX_CACHELINE_SIZE - 1)) +	\
				    VIA_MAX_CACHELINE_SIZE*(lockNo)))

in include/uapi/drm/via_drm.h.


> --- a/scripts/headers_install.pl
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -#!/usr/bin/perl -w
> -#
> -# headers_install prepare the listed header files for use in
> -# user space and copy the files to their destination.
> -#
> -# Usage: headers_install.pl readdir installdir arch [files...]
> -# installdir: dir to install the files to
> -# arch:       current architecture
> -#             arch is used to force a reinstallation when the arch
> -#             changes because kbuild then detect a command line change.

You are not passing $(SRCARCH) to the shell script. This seems OK, as
the list of files changes if needed, but the change should be mentioned
in the changelog.

Thanks,
Michal
