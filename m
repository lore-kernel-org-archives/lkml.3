Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaLPOZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:25:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47534 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLPOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:25:46 -0500
Date: Tue, 16 Dec 2014 14:25:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216142542.GC22149@ZenIV.linux.org.uk>
References: <20141216115537.GA1259@hudson.localdomain>
 <20141216125615.GZ22149@ZenIV.linux.org.uk>
 <20141216132821.GA22149@ZenIV.linux.org.uk>
 <20141216140952.GA1224@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216140952.GA1224@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 06:09:52AM -0800, Jeremiah Mahler wrote:
> >  		ramdisk_execute_command = NULL;
> >  		prepare_namespace();
> > +		{
> > +		/* HACK */
> > +			struct path old, new;
> > +			get_fs_root(current->fs, &new);
> > +			get_fs_root(&init_fs, &old);
> > +			chroot_fs_refs(&old, &new);
> > +			path_put(&old);
> > +			path_put(&new);
> > +		}
> >  	}
> >  
> >  	/*
> 
> I tested the bad commit with your patch applied but it made no
> difference, the wireless is still down.

Interesting...  What happens if you move that added piece (i.e. call of
chroot_fs_refs()) just after that if, instead of the end of the body of
the if?

> Not sure if it helps, but the dmesg is included below.  There are errors
> about not being able to load the firmware that look interesting.

Errors about not being able to load the firmware clearly indicate that we
have an attempt to load it (from a kernel thread of some sort, e.g.
workqueue worker) getting failing with ENOENT.  So we have init_fs stuck
behind, presumably still on initramfs under the overmounting rootfs.
