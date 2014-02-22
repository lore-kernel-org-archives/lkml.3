Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaBVUwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 15:52:22 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:61042 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaBVUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 15:52:20 -0500
Date: Sat, 22 Feb 2014 15:52:17 -0500
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Greg KH <greg@kroah.com>, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
Message-ID: <20140222205217.GC16272@mtj.dyndns.org>
References: <5308E3AE.3040405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5308E3AE.3040405@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Feb 22, 2014 at 12:51:42PM -0500, Sasha Levin wrote:
> While fuzzing with trinity inside a KVM tools guest running the
> latest -next kernel I've stumbled on the following (now with pretty
> line numbers!) spew:

Heh, that's pretty awesome.

> [  218.132898] ======================================================
> [  218.133902] [ INFO: possible circular locking dependency detected ]
> [  218.134820] 3.14.0-rc3-next-20140221-sasha-00008-g0e660cf-dirty #116 Tainted: G        W
> [  218.135911] -------------------------------------------------------
> [  218.136842] trinity-c47/11528 is trying to acquire lock:
> [  218.137613]  (&rtc->ops_lock){+.+.+.}, at: [<drivers/rtc/interface.c:42>] rtc_read_time+0x2b/0x60
> [  218.138909]
> [  218.138909] but task is already holding lock:
> [  218.139802]  (s_active#20){++++.+}, at: [<fs/kernfs/file.c:99>] kernfs_seq_start+0x34/0xa0
> [  218.140087]
> [  218.140087] which lock already depends on the new lock.

The problem is rtc_device_unregister().  It grabs rtc->ops_lock and
then tries to remove the sysfs files.  Some of those sysfs file
implementations acquire rtc->ops_lock, so it of course can lead to
deadlocks.  One can't try to delete a sysfs file which acquires a lock
while holding the same lock.

Thanks.

-- 
tejun
