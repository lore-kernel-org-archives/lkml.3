Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3FDA7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 20:59:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57835 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab3FDA7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 20:59:06 -0400
Date: Tue, 4 Jun 2013 01:58:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
 proc_task_readdir() paths
Message-ID: <20130604005853.GA13110@ZenIV.linux.org.uk>
References: <20130603190640.GA11481@redhat.com>
 <20130603190705.GA11517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603190705.GA11517@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 09:07:05PM +0200, Oleg Nesterov wrote:
> 1. proc_task_readdir() truncates f_pos to long, this can lead
>    to wrong result on 32bit.
> 
> 2. first_tid() truncates f_pos to int, this is wrong even on
>    64bit.
> 
>    We could check that f_pos < PID_MAX or even INT_MAX in
>    proc_task_readdir(), but this patch simply checks the
>    potential overflow in first_tid(), this check is nop on
>    64bit. We do not care if it was negative and the new
>    unsigned value is huge, all we need to ensure is that we
>    never wrongly return !NULL.
> 
> 3. Remove the 2nd "nr != 0" check before get_nr_threads(),
>    nr_threads == 0 is not distinguishable from !pid_task()
>    above.

Oleg, please take a look at the series in vfs.git#experimental; at the very
least, we don't want to access file->f_pos in any foo_readdir() - it's too
messy and race-prone.  It's pretty much independent from the issues you
are dealing with, but let's avoid creating pointless conflicts...
