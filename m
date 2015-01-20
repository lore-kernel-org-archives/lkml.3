Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbbATTyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:54:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40263 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbATTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:54:42 -0500
Date: Tue, 20 Jan 2015 19:54:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Paul Moore <pmoore@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120195432.GH29656@ZenIV.linux.org.uk>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120175135.GA25973@kria>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 06:51:35PM +0100, Sabrina Dubroca wrote:
> 2015-01-20, 12:39:08 -0500, Paul Moore wrote:
> > On Tuesday, January 20, 2015 05:56:55 PM Sabrina Dubroca wrote:
> > > Hello,
> > > 
> > > Today's linux-next doesn't boot on my qemu VM:
> > 
> > ...
> >  
> > > I bisected it down to:
> > > 
> > > 5dc5218840e1  fs: create proper filename objects using getname_kernel()
> > > 
> > > I reverted then reapplied each part of that patch.  It works if I
> > > leave out the hunk for do_path_lookup:
> > > 
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index eeb3b83661f8..c3d21b79090e 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -2001,9 +2001,15 @@ static int filename_lookup(int dfd, struct filename
> > > *name, static int do_path_lookup(int dfd, const char *name,
> > >  				unsigned int flags, struct nameidata *nd)
> > >  {
> > > -	struct filename filename = { .name = name };
> > > +	int retval;
> > > +	struct filename *filename;
> > > 
> > > -	return filename_lookup(dfd, &filename, flags, nd);
> > > +	filename = getname_kernel(name);
> > > +	if (unlikely(IS_ERR(filename)))
> > > +		return PTR_ERR(filename);
> > > +	retval = filename_lookup(dfd, filename, flags, nd);
> > > +	putname(filename);
> > > +	return retval;
> > >  }
> > > 
> > > I don't know what other info you may need.
> > > Full dmesg for the failed boot included below.
> > 
> > Thanks for testing this and reporting the problem, especially such a small 
> > bisection.  Unfortunately nothing is immediately obvious to me, would you mind 
> > sharing your kernel config so I can try to reproduce and debug the problem?
> 
> Sure.
> 
> I run qemu with:
> 
> qemu-system-x86_64 -enable-kvm -cpu host  -m 512 -kernel bzImage -append 'root=/dev/sda1' $IMG
> 
> and the image contains a single ext4 partition with a basic ArchLinux install.

Could you turn that return PTR_ERR(filename); into 
{
	printk(KERN_ERR "failed(%p -> %d)", name, PTR_ERR(filename));
	return PTR_ERR(filename);
}
reproduce the panic and see what has it produced?
