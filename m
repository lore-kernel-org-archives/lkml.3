Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaJ1VNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:13:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46850 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJ1VNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:13:15 -0400
Date: Tue, 28 Oct 2014 21:13:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tim Tassonis <stuff@decentral.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: overlayfs: "filesystem of lowerdir is not supported" on cdrom
Message-ID: <20141028211313.GB7996@ZenIV.linux.org.uk>
References: <544FDC1C.9040908@decentral.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FDC1C.9040908@decentral.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 07:10:36PM +0100, Tim Tassonis wrote:
> Hi
> 
> Just installed 3.18-rc2 and tried to test the overlayfs stuff:
> 
> $ mkdir /ovtmp
> $ mount -t tmpfs tmpfs /ovtmp/
> $ mkdir /ovtmp/work
> $ mkdir /ovtmp/upper
> $ mkdir /cdrw
> $ mount /dev/sr0 /mnt
> $ mount |egrep "ovtmp|sr0"
> 
> /dev/sr0 on /mnt type iso9660 (ro,relatime)
> tmpfs on /ovtmp type tmpfs (rw,relatime)
> 
> $ mount -t overlayfs overlayfs \
>  -olowerdir=/mnt,upperdir=/ovtmp/upper,workdir=/ovtmp/work /cdrw

> [ 3266.793218] overlayfs: filesystem of lowerdir is not supported
> 
> However, the doc in Documentation/filesystems/overlayfs.txt states:
> 
> "The lower filesystem can be any filesystem supported by Linux and does
> not need to be writable.  The lower filesystem can even be another
> overlayfs.  The upper filesystem will normally be writable and if it
> is it must support the creation of trusted.* extended attributes, and
> must provide valid d_type in readdir responses, so NFS is not suitable."
> 
> So: Is the documentation wrong, the error message in dmesg wrong, or
> have missed something completely?

Documentation is wildly over-optimistic.  You are trying to use something
with non-trivial ->d_hash and ->d_compare as lower layer.

What should happen if you ask to mount an image with joliet extensions and
ask to create foo.txt.... when foo.txt is there?  From the isofs POV those
are the same; for overlayfs they are not (it's using default ->d_hash
and ->d_compare).

We probably ought to split the normal (case-sensitive, no joliet shite) case
out and leave it with NULL ->s_d_op, but that'll need to be done carefully,
or isofs_cmp() will blow up on us.
