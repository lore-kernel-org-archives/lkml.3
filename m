Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3CBSmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:42:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57272 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3CBSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:42:44 -0500
Date: Sat, 2 Mar 2013 18:42:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: fasync race in fs/fcntl.c
Message-ID: <20130302184243.GC4503@ZenIV.linux.org.uk>
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
> I'm seeing a race in fs/fcntl.c. I'm not sure exactly how the race is
> occurring, but the following is my best guess. A kernel log is
> attached.
> 
> The comment for fasync_insert_entry:
> 
>  * NOTE! It is very important that the FASYNC flag always
>  * match the state "is the filp on a fasync list".
> 
> Is not always true leading to deadlock.
> 
> CPU0 calls syscall fcntl(fd, F_SETFL, FASYNC)
> fcntl calls fdget_raw, the count on the filp is 1, so it is not
> incremented (no reference taken)

You misunderstand what fdget_raw() checks, but in any case...

> pointer points to freed memory. send_sigio is called with this
> pointer, which calls read_lock(&fown->lock), however, the memory used
> by that lock has been reused and the system hardlocks.

... what makes you think that it's fown->lock, in the first place?

> [172635.399651]  <<EOE>>  [<ffffffff816c3e13>] _raw_read_lock+0x13/0x20
> [172635.399654]  [<ffffffff811a4532>] send_sigio+0x52/0xf0

send_sigio() is
	[initialization of a local variable to 1]
	read_lock(&fown->lock);
	[getting type and pid, checking them]
	read_lock(&tasklist_lock);
	[loop doing the majority of work]
	read_unlock(&tasklist_lock);
	read_unlock(&fown->lock);
and you are at about 1/3 into the function.  Who said it's fown->lock and
not tasklist_lock?  Could you check (or post) disassembly of send_sigio
to see which one it is?
