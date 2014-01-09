Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaAIW0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:26:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39634 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaAIWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:25:58 -0500
Date: Thu, 9 Jan 2014 22:25:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
Message-ID: <20140109222555.GK10323@ZenIV.linux.org.uk>
References: <20140109101932.0508dec7@gandalf.local.home>
 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
 <20140109221303.GI10323@ZenIV.linux.org.uk>
 <1389305889.15209.75.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389305889.15209.75.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 05:18:09PM -0500, Eric Paris wrote:

> > Just RCU-delay freeing the damn thing and treat NULL ->i_security in
> > ->permission() (which can happen only with MAY_NOT_BLOCK in mask) as
> > "return -ECHILD and let the caller deal with that".
> > 
> > Modifying every ->destroy_inode() is obviously wrong - there's a lot more
> > filesystems than LSM buggers in the tree.
> 
> We just want the same lifetime as the inode.  Allocate the security blob
> when the inode is allocated and free the security blob when the inode is
> freed.

Ultimate freeing of struct inode can easily happen outside of VFS - that's
what ->destroy_inode() is for.  Moreover, filesystem might decide to do
very odd things to it, as long as it doesn't do so without RCU delay.
So no, there's no single place to do that.
