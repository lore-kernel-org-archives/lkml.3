Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbbA0AdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:33:02 -0500
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:37483 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754054AbbA0AdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:33:00 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2691:2895:3138:3139:3140:3141:3142:3291:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4362:5007:6119:6261:7875:7903:8660:9010:10004:10400:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12663:12740:13148:13230:13618:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mist85_4318f4396f427
X-Filterd-Recvd-Size: 3676
Date: Mon, 26 Jan 2015 18:37:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126183739.1d17fd82@gandalf.local.home>
In-Reply-To: <20150126214020.GO29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126214020.GO29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 21:40:20 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:


> Is the following correct?
> 	* only one directory in the entire tree (/instances) allows mkdir/rmdir.

yes

> 	* ftrace_trace_arrays always starts with global_trace and the rest
> is in 1-to-1 correspondence with subdirectories of /instances.

pretty much.

> 	* tr->name is NULL for global_trace and non-NULL for everything
> else.

yes.

> 	* all modifications of that list are happening from mkdir/rmdir

yes.

> 	* in the end of ->mkdir tr->dir set to the dentry of our subdirectory,
> and it's non-NULL (or trace_array creation simply fails)

yes.

> 	* global_array.dir is set to magical value ((struct dentry *)1) upon

This is new for this patch series. Currently, global_array.dir points
to the dentry of /sys/kernel/debug/tracing. 

> the first call of tracing_init_dentry().  Prior to that it's NULL.  BTW, may
> I politely inquire what the fuck are those contortions in
> tracing_init_dentry_tr() about?  Looks like a stunningly convoluted way
> to trigger that automount point creation early in tracer_init_tracefs().
> Why not do that right there explicitly?

Yeah, that could be cleaned up. Before the tracefs code, it made much
more sense to keep that as a single function. Now that global_array.dir
is treated differently as the subdirs, it does make sense to have
global_arry.dir initialized in a separate function.

I'll update my patch series to do this.


> 
> What are mount options doing?  I mean, sure, you set the mode/uid/gid
> of root.  Which is not modifiable anyway...  And AFAICS that's all those
> options are affecting.

You mean in tracefs.c/inode.c? I have no idea, they are there from
debugfs cut and paste ;-)

> 
> AFAICS, nothing ever removes files in debugfs root.  Right?  If so, you don't

I'm not sure about that. Well, not from tracing or from userspace. But
I believe things can be removed from debugfs root with module unload.
But are you talking about tracefs root?

> need the games with simple_pin_fs() - they are pointless in such situation
> anyway.  Just do tracefs_mount = kern_mount(&trace_fs_type); in tracefs_init()
> and be done with that; lose the tracefs_mount_count and all calls of
> simple_{pin,release}_fs().

OK, cool. Because I had no idea what hey were used for anyway. ;-)

> 
> While we are at it, what the hell is tracefs_file_operations about?  Looks
> like some bastard offspring of /dev/null, but I don't see anything that would
> use it...

Hehe, again, this is what debugfs did and I just brought it over
thinking I needed it.

Thanks,

-- Steve
