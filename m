Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3JaSdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:33:49 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45478 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab3JaSdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:33:45 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20131017221450.GU13318@ZenIV.linux.org.uk>
Date: Thu, 31 Oct 2013 12:33:42 -0600
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A80E174D-DCB8-41B2-84DF-38CAB9473AEE@dilger.ca>
References: <20131009172336.GH13318@ZenIV.linux.org.uk> <20131017211143.1712.qmail@science.horizon.com> <20131017221450.GU13318@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
X-Mailer: Apple Mail (2.1816)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 17, 2013, at 4:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Oct 17, 2013 at 05:11:43PM -0400, George Spelvin wrote:
>> 
>> Well, it happened again (error appended).  Can you please clarify what you mean
>> by "such BUG_ON()"; I'm having a hard time following the RCU code and determining
>> all the situations under which __fput() might be called.
> 
> __fput() can be called via task_work_run() or via schedule_work().  That's
> all.  And it certainly should never be called with interrupts disabled.
> So stick BUG_ON(irqs_disabled()) in it (WARN_ON() might be better, but
> not by much).
> 
> There are two ways these traces could've happened:
> 	* exit_task_work() called by do_exit() with irqs disabled.
> Definitely buggy (and would do really nasty things to several functions
> called by do_exit() before that one). 
> 	* __fput() is called with irqs enabled, but somewhere on the
> way into ext4 (dput -> iput -> evict inode -> free blocks, now that
> unlinked file got closed -> ...) we manage to disable irqs and forget
> to enable them.

IMHO the most common case of "BUG: sleeping function called from
invalid context” is due to stack overflow.  This corrupts the task
struct, and incorrectly sets the “in_interrupt” bit.

What kind of storage stack is underneath this filesystem?  If
it is deep (e.g. DM + LVM + iSCSI) then the stack overflow is
definitely possible.

There were also a discussion by Christoph of page allocation
recursing into the fs again (in "xfs: prevent stack overflows
from page cache allocation”) though I’m not sure if that applies
to ext4 or not.

Cheers, Andreas





