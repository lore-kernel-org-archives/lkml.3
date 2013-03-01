Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3CAM1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:27:50 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57327 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3CAM1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:27:46 -0500
Message-ID: <1362140849.9158.108.camel@falcor1>
Subject: Re: security_inode_init_security() inode field requirements
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 07:27:29 -0500
In-Reply-To: <1362132778.2723.15.camel@menhir>
References: <1362132778.2723.15.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030112-5806-0000-0000-00002028C563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 10:12 +0000, Steven Whitehouse wrote:
> Hi,
> 
> I'm wondering whether there is a list somewhere of fields which
> security_inode_init_security() requires are set in an inode when it is
> called? In particular, does it matter if the inode number itself is
> unset when security_inode_init_security() is called?
> 
> The problem that I'm looking at is the use of multiple transactions
> during inode creation when some combination of ACLs/LSMs/IMA are turned
> on. What we have currently (in GFS2, there are other fs which follow
> broadly the same solution though) is this:
> 
> 1. Create inode in core
> 2. Create inode on disk
> 3. Add xattrs one at a time for ACLs/LSMs/IMA
> 4. Link inode into directory
> 
> Steps 2 through 4 require separate transactions at the moment. What I'd
> like to do is to be able to get the details of the xattrs ahead of time
> such that the allocation of the inode can be one and the same allocation
> as that for the xattr blocks. That allows merging of the transactions
> into one and a greatly simplified error path too. This would look
> something like:
> 
> 1. Create in-core inode and init required fields
> 2. Get details of all xattrs for the inode
> 3. Alloc on disk inode and blocks for xattrs as needed
> 4. Link into directory
> 
> In this case, steps 2 through 4 are within a single transaction. We
> don't actually need to have the content of the xattrs ahead of
> allocating the inode, just the length (or even just a max length, if it
> is not too large). However the easiest solution would just be to move
> the call to security_inode_init_security() to the point before we've
> allocated the inode (and thus we don't know its number yet) but after
> we've filled out all the remaining fields if that makes sense?
> 
> So I just wanted to check whether that would break anything,

Hi Steve,

Included in security_inode_init_security() is the call to
evm_inode_init_security() to write the 'security.evm' extended
attribute.  'security.evm' is an HMAC of the security extended
attributes and other file metadata, including the inode.  For an exact
list of other metadata included in the HMAC calculation refer to
hmac_add_misc().  (The UUID is being added to the HMAC calculation in
this open window.)

thanks,

Mimi

