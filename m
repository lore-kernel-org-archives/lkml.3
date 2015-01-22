Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbbAVOcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:32:55 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:42001 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752215AbbAVOcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:32:53 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2693:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:5007:6119:6261:7875:7903:8660:9010:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13148:13161:13229:13230:13311:13357:13618:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pig34_18c1a6c3d8b59
X-Filterd-Recvd-Size: 3124
Date: Thu, 22 Jan 2015 09:32:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122093249.6f4041a8@gandalf.local.home>
In-Reply-To: <20150122123212.GB25645@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
	<20150121230007.GA10389@kroah.com>
	<20150121204725.71933044@grimm.local.home>
	<20150121220701.22231849@grimm.local.home>
	<20150122031819.GA16561@kroah.com>
	<20150121225109.6b27b555@grimm.local.home>
	<20150122123212.GB25645@htj.dyndns.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 07:32:12 -0500
Tejun Heo <tj@kernel.org> wrote:

> > That is, I need to create the following interface:
> > 
> >   tracefs_create_file()
> 
> kernfs_create_file()
> 
> >   tracefs_create_dir()
> 
> kernfs_create_dir()

The problem is that these do not return dentry. They return kernfs_node.

I see a kernfs_node_from_dentry() call but not the other way around.

Yes, the interface for tracefs is just these four functions, but then
the interaction of the kernfs versions use a completely different API.

Each of the created files expects to attach their own open, read,
write, and release functions. And yes, some even use the seq functions,
and they use it the vfs way. I do not intend on rewriting the users of
the debugfs file system. To use kernfs, it seems that I would need to
do that, and I don't have the time to make such a dramatic change to
the system. It will fall down on my TODO list and I probably wont get
to it for another decade.

I created tracefs with 700 lines of code and two files (inode.c and
tracefs.h), and for the users of tracefs, I just did
s/debugfs/tracefs/. If I can't make that substitution for the users,
that is a show stopper.

I don't see how I can use kernfs without it causing a lot of invasive
changes to the ftrace subsystem.

-- Steve


> 
> >   tracefs_remove()
> >   tracefs_remove_recursive()
> 
> kernfs_remove[_by_name]() - recursive by default
> 
> > and that's all I need for the filesystem. There doesn't seem to be any
> > documentation on kernfs about how to implement this.
> > 
> > Yes, I can study the code, but I was hoping that there was some
> > kernfs.txt that described how to create a new fs with it. It just saves
> > time if there was a document than having to read the code and perhaps
> > use it in a way it wasn't supposed to be used.
> 
> Yeah yeah, I hear you.  I'll write one up.
> 
> Thanks.
> 

