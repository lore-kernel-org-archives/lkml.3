Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab3CANNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:13:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab3CANNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:13:34 -0500
Subject: Re: security_inode_init_security() inode field requirements
From: Steven Whitehouse <swhiteho@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1362140849.9158.108.camel@falcor1>
References: <1362132778.2723.15.camel@menhir>
	 <1362140849.9158.108.camel@falcor1>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Mar 2013 13:11:52 +0000
Message-ID: <1362143512.2723.21.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2013-03-01 at 07:27 -0500, Mimi Zohar wrote:
> On Fri, 2013-03-01 at 10:12 +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > I'm wondering whether there is a list somewhere of fields which
> > security_inode_init_security() requires are set in an inode when it is
> > called? In particular, does it matter if the inode number itself is
> > unset when security_inode_init_security() is called?
> > 
> > The problem that I'm looking at is the use of multiple transactions
> > during inode creation when some combination of ACLs/LSMs/IMA are turned
> > on. What we have currently (in GFS2, there are other fs which follow
> > broadly the same solution though) is this:
> > 
> > 1. Create inode in core
> > 2. Create inode on disk
> > 3. Add xattrs one at a time for ACLs/LSMs/IMA
> > 4. Link inode into directory
> > 
> > Steps 2 through 4 require separate transactions at the moment. What I'd
> > like to do is to be able to get the details of the xattrs ahead of time
> > such that the allocation of the inode can be one and the same allocation
> > as that for the xattr blocks. That allows merging of the transactions
> > into one and a greatly simplified error path too. This would look
> > something like:
> > 
> > 1. Create in-core inode and init required fields
> > 2. Get details of all xattrs for the inode
> > 3. Alloc on disk inode and blocks for xattrs as needed
> > 4. Link into directory
> > 
> > In this case, steps 2 through 4 are within a single transaction. We
> > don't actually need to have the content of the xattrs ahead of
> > allocating the inode, just the length (or even just a max length, if it
> > is not too large). However the easiest solution would just be to move
> > the call to security_inode_init_security() to the point before we've
> > allocated the inode (and thus we don't know its number yet) but after
> > we've filled out all the remaining fields if that makes sense?
> > 
> > So I just wanted to check whether that would break anything,
> 
> Hi Steve,
> 
> Included in security_inode_init_security() is the call to
> evm_inode_init_security() to write the 'security.evm' extended
> attribute.  'security.evm' is an HMAC of the security extended
> attributes and other file metadata, including the inode.  For an exact
> list of other metadata included in the HMAC calculation refer to
> hmac_add_misc().  (The UUID is being added to the HMAC calculation in
> this open window.)
> 
> thanks,
> 
> Mimi
> 

Ok... but it is using inode->i_ino in that case, as well as the
generation number too. So that presumably can only be done after the
inode has been allocated, since we need to know its location in order to
know its inode number. Also the generation number is assigned at
allocation time. One potential issue though... the inode->i_ino is an
unsigned long, so that on 32 bit archs, that will be (on GFS2) a
truncated version of the full 64 bit inode number. I'm not sure if that
matters or not for EVM.

So since that appears to rule out doing the security init bits ahead of
the allocation of the inode, is it possible to get a maximum value for
the size of the xattr which EVM will add? Likewise for the other LSMs
too?

Steve.


