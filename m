Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3CBRyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 12:54:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57215 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3CBRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 12:54:42 -0500
Date: Sat, 2 Mar 2013 17:54:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: fasync race in fs/fcntl.c
Message-ID: <20130302175441.GB4503@ZenIV.linux.org.uk>
References: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 03:00:28AM -0800, Russ Dill wrote:

> CPU0 calls syscall fcntl(fd, F_SETFL, FASYNC)
> fcntl calls fdget_raw, the count on the filp is 1, so it is not
> incremented (no reference taken)
> fcntl calls do_fcntl, which calls setfl which calls filp->op->fasync
> which calls fasync_helper
> fasync_helper calls fasync_add_entry, which calls fasync_insert_entry
> fasync_insert_entry adds a fasync_struct to the list for the current
> filp and assigns the pointer,
> before getting to filp->f_flags |= FASYNC, we go to CPU1
> 
> CPU1 calls fput on the same filp, the counter is decremented to 0 and
> that filp is either added to the delayed_fput_list or scheduled for
> ____fput task_work.

Stop here.  Just how does CPU1 manage to do that?  fdget_raw() will not
increment ->f_count *only* if there's nobody else with reference to its
descriptor table.  And if ->f_count is 1, we'd better have no references
outside of that descriptor table.

So where had the reference dropped by process on CPU1 come from?
