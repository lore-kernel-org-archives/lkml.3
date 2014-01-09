Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaAIWTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:19:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaAIWTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:19:18 -0500
Message-ID: <1389305889.15209.75.camel@localhost>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Date: Thu, 09 Jan 2014 17:18:09 -0500
In-Reply-To: <20140109221303.GI10323@ZenIV.linux.org.uk>
References: <20140109101932.0508dec7@gandalf.local.home>
	 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
	 <20140109221303.GI10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 22:13 +0000, Al Viro wrote:
> On Thu, Jan 09, 2014 at 10:31:55AM -0500, Eric Paris wrote:
> > Didn't Al find this/something very similar.  I really hate this
> > solution.  Why should every LSM try to understand the intimate
> > lifetime rules of the parent subsystems?  The real problem is that
> > inode_free_security() is being called while the inode is still in use.
> >  While I agree with the assessment, I disagree with the solution.  Let
> > me try to find where Al and Christoph talked about this....
> 
> Because LSM has stuck its fingers into the guts of those filesystems,
> obviously.
> 
> Just RCU-delay freeing the damn thing and treat NULL ->i_security in
> ->permission() (which can happen only with MAY_NOT_BLOCK in mask) as
> "return -ECHILD and let the caller deal with that".
> 
> Modifying every ->destroy_inode() is obviously wrong - there's a lot more
> filesystems than LSM buggers in the tree.

We just want the same lifetime as the inode.  Allocate the security blob
when the inode is allocated and free the security blob when the inode is
freed.

If we -rcu delay the free'ing we shouldn't need the NULL check, right?

-Eric

