Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbaAIUZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:25:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53684 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbaAIUZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:25:39 -0500
Message-ID: <52CF05B5.5080700@amacapital.net>
Date: Thu, 09 Jan 2014 12:25:25 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
CC: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT
 locks
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com> <1389277187-18211-14-git-send-email-jlayton@redhat.com>
In-Reply-To: <1389277187-18211-14-git-send-email-jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 06:19 AM, Jeff Layton wrote:
> It's not really feasible to do deadlock detection with FL_FILE_PVT
> locks since they aren't owned by a single task, per-se. Deadlock
> detection also tends to be rather expensive so just skip it for
> these sorts of locks.

I just looked at the existing deadlock detector, and... eww.

When I think of deadlocks caused by r/w locks (which these are), I think
of two kinds.  First is what the current code tries to detect: two
processes that are each waiting for each other.  I don't know whether
POSIX enshrines the idea of detecting that, but I wouldn't be surprised,
considering how awful the old POSIX locks are.

The sensible kind of detectable deadlock involves just one lock, and it
happens when two processes both hold read locks and try to upgrade to
write locks.  This should be efficiently detectable and makes upgrading
locks safe(r).

I think I'd be happier if it's at least documented that the new fcntl
calls might (some day) detect that kind of deadlock.


All that being said, this patch series is awesome.  I've lost count of
the number of explosions I've seen to due POSIX lock crap.  Thanks!

--Andy

