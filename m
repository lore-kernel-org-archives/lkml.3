Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab3GZRjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:39:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GZRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:38:59 -0400
Date: Fri, 26 Jul 2013 10:38:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] debugfs: debugfs_remove_recursive() must not rely on
 list_empty(d_subdirs)
Message-ID: <20130726173857.GB15013@kroah.com>
References: <20130723205854.GA9036@redhat.com>
 <20130724184640.GA21322@redhat.com>
 <20130725192742.GA14060@redhat.com>
 <20130725200423.GA22274@redhat.com>
 <20130725234357.GA14958@kroah.com>
 <20130726151151.GA19472@redhat.com>
 <20130726151256.GC19472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726151256.GC19472@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 05:12:56PM +0200, Oleg Nesterov wrote:
> debugfs_remove_recursive() is wrong,
> 
> 1. it wrongly assumes that !list_empty(d_subdirs) means that this
>    dir should be removed.
> 
>    This is not that bad by itself, but:
> 
> 2. if d_subdirs does not becomes empty after __debugfs_remove()
>    it gives up and silently fails, it doesn't even try to remove
>    other entries.
> 
>    However ->d_subdirs can be non-empty because it still has the
>    already deleted !debugfs_positive() entries.
> 
> 3. simple_release_fs() is called even if __debugfs_remove() fails.
> 
> Suppose we have
> 
> 	dir1/
> 		dir2/
> 			file2
> 		file1
> 
> and someone opens dir1/dir2/file2.
> 
> Now, debugfs_remove_recursive(dir1/dir2) succeeds, and dir1/di2 goes
> away.
> 
> But debugfs_remove_recursive(dir1) silently fails and doesn't remove
> this directory. Because it tries to delete (the already deleted)
> dir1/dir2/file2 again and then fails due to "Avoid infinite loop"
> logic.
> 
> Test-case:
> 
> 	#!/bin/sh
> 
> 	cd /sys/kernel/debug/tracing
> 	echo 'p:probe/sigprocmask sigprocmask' >> kprobe_events
> 	sleep 1000 < events/probe/sigprocmask/id &
> 	echo -n >| kprobe_events
> 
> 	[ -d events/probe ] && echo "ERR!! failed to rm probe"
> 
> And after that it is not possible to create another probe entry.
> 
> With this patch debugfs_remove_recursive() skips !debugfs_positive()
> files although this is not strictly needed. The most important change
> is that it does not try to make ->d_subdirs empty, it simply scans
> the whole list(s) recursively and removes as much as possible.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

