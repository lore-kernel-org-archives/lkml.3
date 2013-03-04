Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3CDUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:09:29 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42485 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3CDUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA9286AD381@sacexcmbx05-prd.hq.netapp.com>
References: <CACVXFVMKN6aeCvJcn7dyuonJYJDfYxWeW5KE6gfKRKJKFj2M4A@mail.gmail.com>
	<4FA345DA4F4AE44899BD2B03EEEC2FA9286AD113@sacexcmbx05-prd.hq.netapp.com>
	<CACVXFVM5VhU_ZgYr1KxERY7DXxMQpkWoiTyjyar91Hz=vU4-ug@mail.gmail.com>
	<20130304100432.5c7ea704@tlielax.poochiereds.net>
	<CACVXFVPvTnfH98KqAQxDzMi5Pbf1fbi5HEGb=ggWWg4FX_4G=g@mail.gmail.com>
	<4FA345DA4F4AE44899BD2B03EEEC2FA9286AD381@sacexcmbx05-prd.hq.netapp.com>
Date: Mon, 4 Mar 2013 12:09:26 -0800
X-Google-Sender-Auth: C-A6_uely9Lo792k9euRumKkKIQ
Message-ID: <CACBanvqfW7P-TfKnVGgsumPdLhx-Z4ZS8wUHyUNRA9mM=txK8A@mail.gmail.com>
Subject: Re: LOCKDEP: 3.9-rc1: mount.nfs/4272 still has locks held!
From: Mandeep Singh Baines <msb@chromium.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ben Chan <benchan@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 7:53 AM, Myklebust, Trond
<Trond.Myklebust@netapp.com> wrote:
> On Mon, 2013-03-04 at 23:33 +0800, Ming Lei wrote:
>> Hi,
>>
>> CC guys who introduced the lockdep change.
>>
>> On Mon, Mar 4, 2013 at 11:04 PM, Jeff Layton <jlayton@redhat.com> wrote:
>>
>> >
>> > I don't get it -- why is it bad to hold a lock across a freeze event?
>>
>> At least this may deadlock another mount.nfs during freezing, :-)
>>
>> See detailed explanation in the commit log:
>>
>> commit 6aa9707099c4b25700940eb3d016f16c4434360d
>> Author: Mandeep Singh Baines <msb@chromium.org>
>> Date:   Wed Feb 27 17:03:18 2013 -0800
>>
>>     lockdep: check that no locks held at freeze time
>>
>>     We shouldn't try_to_freeze if locks are held.  Holding a lock can cause a
>>     deadlock if the lock is later acquired in the suspend or hibernate path
>>     (e.g.  by dpm).  Holding a lock can also cause a deadlock in the case of
>>     cgroup_freezer if a lock is held inside a frozen cgroup that is later
>>     acquired by a process outside that group.
>>
>
> This is bloody ridiculous... If you want to add functionality to
> implement cgroup or per-process freezing, then do it through some other
> api instead of trying to push your problems onto others by adding new
> global locking rules.
>
> Filesystems are a shared resource that have _nothing_ to do with process
> cgroups. They need to be suspended when the network goes down or other
> resources that they depend on are suspended. At that point, there is no
> "what if I launch a new mount command?" scenario.
>

Hi Trond,

My intention was to introduce new rules. My change simply introduces a
check for a deadlock case that can already happen.

I think a deadlock could happen under the following scenario:

1) An administrator wants to freeze a container. Perhaps to checkpoint
it and it migrate it some place else.
2) An nfs mount was in progress so we hit this code path and freeze
with a lock held.
3) Another container tries to nfs mount.
4) Deadlock.

Regards,
Mandeep

> Trond
> --
> Trond Myklebust
> Linux NFS client maintainer
>
> NetApp
> Trond.Myklebust@netapp.com
> www.netapp.com
