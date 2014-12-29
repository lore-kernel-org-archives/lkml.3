Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaL2CS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 21:18:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40264 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2CSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 21:18:53 -0500
Date: Mon, 29 Dec 2014 02:18:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Ma, Xindong" <xindong.ma@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>, "mhocko@suse.cz" <mhocko@suse.cz>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "ionut.m.alexa@gmail.com" <ionut.m.alexa@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Di" <di.zhang@intel.com>,
        "Sun, Zhonghua" <zhonghua.sun@intel.com>
Subject: Re: [PATCH] move exit_task_work() before exit_fs().
Message-ID: <20141229021839.GK22149@ZenIV.linux.org.uk>
References: <y>
 <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
 <20141226193028.GE22149@ZenIV.linux.org.uk>
 <3917C05D9F83184EAA45CE249FF1B1DD0266FC80@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0266FC80@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 01:33:37AM +0000, Ma, Xindong wrote:
> > On Fri, Dec 26, 2014 at 03:45:25PM +0800, Leon Ma wrote:
> > > We encountered following panic. The scenario is the process is exiting
> > > and executing its task work. When closing dev node, the driver
> > > triggers a firmware reload according to device status. Because task->fs is
> > set to NULL in exit_fs(), panic happens.
> > > Task work is a common interface, we should not limite the resource the
> > user will utilize.
> > 
> > Fix your driver.  Forget ->fs being NULL; what will happen if your process is
> > chrooted?
> Thanks, But I'm not clear what is the limitation added to chroot env?

???

How about "the pathname of firmware apparently will be looked up inside the
chroot"?  Look, this is completely broken - you *can't* assume anything about
the fs context in which ->release() will be run, period.  It's not guaranteed
to have anything in common with the environment in which the file had been
opened, BTW - there might literally be not a single filesystem in common for
both.

This "reload firmware in ->release()" is absolutely braindead.  The fact that
it as much as dereferences current->fs demonstrates that it's broken.  Don't
do that.
