Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3CDHi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:38:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37538 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab3CDHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:38:55 -0500
Date: Mon, 4 Mar 2013 15:39:08 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Russ Dill <russ.dill@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: fasync race in fs/fcntl.c
Message-ID: <20130304073908.GA982@kroah.com>
References: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
 <20130302194923.GE4503@ZenIV.linux.org.uk>
 <CA+Bv8XY1Qr_zD1guQzeWVPCLw6JP=y5taJMwPUEO1AxPckgsjQ@mail.gmail.com>
 <CA+Bv8XaEBZz3RWh5=y-kLoEMdjxwNFBUBBxUKdq-NuV6iZ=QRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Bv8XaEBZz3RWh5=y-kLoEMdjxwNFBUBBxUKdq-NuV6iZ=QRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 10:16:10PM -0800, Russ Dill wrote:
> On Sat, Mar 2, 2013 at 4:09 PM, Russ Dill <russ.dill@gmail.com> wrote:
> > On Sat, Mar 2, 2013 at 11:49 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> On Sat, Mar 02, 2013 at 03:00:28AM -0800, Russ Dill wrote:
> >>> I'm seeing a race in fs/fcntl.c. I'm not sure exactly how the race is
> >>> occurring, but the following is my best guess. A kernel log is
> >>> attached.
> >>
> >> [snip the analysis - it's a different lock anyway]
> >>
> >> The traces below are essentially sys_execve() getting to get_random_bytes(),
> >> to kill_fasync(), to send_sigio(), which spins on tasklist_lock.
> >>
> >> Could you rebuild it with lockdep enabled and try to reproduce that?
> >> I very much doubt that this execve() is a part of deadlock - it's
> >> getting caught on one, but it shouldn't be holding any locks that
> >> nest inside tasklist_lock at that point, so even it hadn't been there,
> >> the process holding tasklist_lock probably wouldn't have progressed any
> >> further...
> >
> > ok, I did screw up the analysis quite badly, luckily, lockdep got it right away.
> >
> 
> So lockdep gives some clues, but seems a bit confused, so here's what happened.
> 
> mix_pool_bytes /* takes nonblocking_pool.lock */
> add_device_randomness
> posix_cpu_timers_exit
> __exit_signal
> release_task /* takes write lock on tasklist_lock */
> do_exit
> __module_put_and_exit
> cryptomgr_test
> 
> send_sigio /* takes read lock on tasklist_lock */
> kill_fasync_rcu
> kill_fasync
> account /* takes nonblocking_pool.lock */
> extract_entropy
> get_random_bytes
> create_elf_tables
> load_elf_binary
> load_elf_library
> search_binary_handler
> 
> This would mark the culprit as 613370549 'random: Mix cputime from
> each thread that exits to the pool'.  So long as I'm not as crazy on
> the last analysis as this one, may I suggest a revert of this commit
> for 3.8.3?

I'll revert it, but shouldn't we fix this properly upstream in Linus's
tree as well?  I'd rather take the fix than a revert so that we don't
have a problem that no one remembers to fix until 3.9-final is out.

thanks,

greg k-h
