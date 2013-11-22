Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3KVU1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:27:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60899 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVU1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:27:19 -0500
Message-ID: <528FBE22.5030208@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 15:27:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: oleg@redhat.com, akpm@linux-foundation.org
CC: kosaki.motohiro@jp.fujitsu.com, viro@ZenIV.linux.org.uk,
        keescook@chromium.org, mhocko@suse.cz, snanda@chromium.org,
        dserrg@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] check_unsafe_exec: kill the dead -EAGAIN and clear_in_exec
 logic
References: <20131122175442.GA31453@redhat.com>
In-Reply-To: <20131122175442.GA31453@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/22/2013 12:54 PM), Oleg Nesterov wrote:
> fs_struct->in_exec == T means that this ->fs is used by a single
> process (thread group), and one of the treads does do_execve().
> 
> To avoid the mt-exec races this code has the following complications:
> 
> 	1. check_unsafe_exec() returns -EBUSY if ->in_exec was
> 	   already set by another thread.
> 
> 	2. do_execve_common() records "clear_in_exec" to ensure
> 	   that the error path can only clear ->in_exec if it was
> 	   set by current.
> 
> However, after 9b1bf12d5d51 "signals: move cred_guard_mutex from
> task_struct to signal_struct" we do not need these complications:
> 
> 	1. We can't race with our sub-thread, this is called under
> 	   per-process ->cred_guard_mutex. And we can't race with
> 	   another CLONE_FS task, we already checked that this fs
> 	   is not shared.
> 
> 	   We can remove the  dead -EAGAIN logic.
> 
> 	2. "out_unmark:" in do_execve_common() is either called
> 	   under ->cred_guard_mutex, or after de_thread() which
> 	   kills other threads, so we can't race with sub-thread
> 	   which could set ->in_exec. And if ->fs is shared with
> 	   another process ->in_exec should be false anyway.
> 
> 	   We can clear in_exec unconditionally.
> 
> This also means that check_unsafe_exec() can be void.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I have found no problem in this patch. However, I have a very basic question.
Why do we need to keep fs->in_exec? If I understand correctly, it is needed for
retrieving fork() and exec() race in the same process. If it is correct,
can't we move it it to signal->in_exec? It seems to match signal->cred_guard_mutex
and _I_ can easily understand what the code want.

In the other words, currently we have no protection against making new thread when
p->fs is shared w/ another process and I have no idea why multi process sharing influence
multi thread behavior.

I am not expert in this area and I may overlook something. Please correct me if I am silly.


