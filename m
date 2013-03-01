Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3CAVcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:32:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3CAVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:32:00 -0500
Date: Fri, 1 Mar 2013 13:31:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: markus@trippelsdorf.de
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
Message-Id: <20130301133159.0711f81a.akpm@linux-foundation.org>
In-Reply-To: <20130228090846.GA249@x4>
References: <20130228090846.GA249@x4>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013 10:08:46 +0100
markus@trippelsdorf.de wrote:

> Just hit the following warning on current git tree:
> 
> ------------[ cut here ]------------
> WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
> Hardware name: System Product Name
> Pid: 12366, comm: okular Not tainted 3.8.0-09633-g2a7d2b9-dirty #312
> Call Trace:
>  [<ffffffff8105b7a0>] ? warn_slowpath_common+0x60/0xa0
>  [<ffffffff811bf557>] ? idr_find_slowpath+0x97/0xc0
>  [<ffffffff811249f2>] ? inotify_idr_find_locked+0x32/0x80
>  [<ffffffff810ecf7d>] ? fput+0x1d/0xc0
>  [<ffffffff811254d0>] ? sys_inotify_rm_watch+0x50/0xc0
>  [<ffffffff814c9f58>] ? int_signal+0x12/0x17
>  [<ffffffff814c9d52>] ? system_call_fastpath+0x16/0x1b

okluar passed a negative `wd' into inotify_rm_watch()?

I wonder why it did that.  I doubt if inotify_add_watch() ever returns
negative descriptors, in which case I expect that okular's call to
inotify_add_watch() returned -1 and an errno and okular forgot to check
it, and later passed that -1 back into inotify_rm_watch().

Anyway, I guess we need to make inotify_add_watch() refuse to return
negative descriptors (presumably this is already the case due to idr
internals) and make inotify_rm_watch() trap negative values of `wd' up
front.

I wonder how many other such gremlins the IDR checking has added.
