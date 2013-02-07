Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3BGLwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:52:36 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:50691 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab3BGLwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:52:32 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87ip644bqh.fsf@xmission.com>
References: <CA+icZUXzh1S2+ZQ8vvPFSN8jXS62kijbAP+83F0hG9emLQzpQw@mail.gmail.com>
	<CA+icZUWQuLe1banpd9qzuvUtSep0GiyQWpu=yjhSao_9qAgaUA@mail.gmail.com>
	<CA+icZUWNXpta6PhVCMvEjZVTgi0H0AC4Ou+ysG+b5PMEF6kxXQ@mail.gmail.com>
	<87ip644bqh.fsf@xmission.com>
Date: Thu, 7 Feb 2013 12:52:30 +0100
Message-ID: <CA+icZUX=2w-hj8SHy8AG-3gQbmN2XCwx_XCSuJ8Gmp=z0gri9w@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 7 (fakeroot BROKEN due to SYSV IPC support?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 12:14 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> writes:
>
>> On Thu, Feb 7, 2013 at 11:20 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Thu, Feb 7, 2013 at 10:38 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> On Thu, Feb 7, 2013 at 7:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20130206:
>>>>>
>>>>> Removed tree: kvmtool (still present via the tip tree)
>>>>>
>>>>> The block tree lost its build failure.
>>>>>
>>>>> The tip tree gained a conflict against the s390 tree.
>>>>>
>>>>> The kvm tree gained a conflict against Linus' tree.
>>>>>
>>>>> The tty tree lost its build failure.
>>>>>
>>>>> The arm-soc tree gained conflicts against the iommu tree.
>>>>>
>>>>> The signal tree gained a conflict against the s390 tree.
>>>>>
>>>>> The akpm tree gained a conflict against the kvm tree and lost its build
>>>>> failure.
>>>>>
>>>>> ----------------------------------------------------------------------------
>>>>>
>>>>
>>>> My build-script uses fakeroot and does no more start:
>>>>
>>>> $ ./scripts/build_linux-next.sh
>>>> make options ...... CC=gcc-4.6 -j4
>>>> KBUILD_BUILD_USER=sedat.dilek@gmail.com
>>>> LOCALVERSION=-next20130207-2-iniza-small
>>>> dep-pkg options ... KDEB_PKGVERSION=3.8.0~rc6~next20130207-2~iniza+dileks1
>>>> fakeroot, while creating message channels: Invalid argument
>>>> This may be due to a lack of SYSV IPC support.
>>>> fakeroot: error while starting the `faked' daemon.
>>>> kill: usage: kill [-s sigspec | -n signum | -sigspec] pid | jobspec
>>>> ... or kill -l [sigspec]
>>>>
>>>>
>>>> Any hints?
>>>> ( I could run strace... )
>>>>
>>>> - Sedat -
>>>
>>> Attached strace outputs within yesterday's (GOOD) and today's (BAD) Linux-Next.
>>>
>>> - Sedat -
>>
>> [ CCing Al and Eric ]
>>
>> I compared quickly the diff between the -next versions and saw changes
>> coming from signal and userns trees.
>> ( Sorry for re-attaching the strace outputs. )
>
> It has been about a week and a half since I have pushed anything into
> the userns tree, and I don't have anything ipc related in my tree.
> So the reason for the suspicion seems odd.
>
> The straces are useless because all they show is that fakeroot was
> forked, but there is not a trace of fakeroot itself.
>
> Given the timing my initial suspect would be the idr_preload patches
> from Tejun that were merged via Andrew's akpm tree.  I didn't see
> anything in there that would kill ipc but that is likely the most recent
> touch to the ipc code.
>

[ CCing Tejun ]

Hmm, still stepping in the dark...

OK, fakeroot does PRELOADing so your assumption makes sense.

How can I trigger fakeroot calls?
Here I have...
/usr/bin/faked-sysv
/usr/bin/faked-tcp

I think that is the main commit but I am not sure if I can revert the
idr_preload part, otherwise it gets complicated:

commit e2802c2defba1e5c88d7d168eb5c66813c86f249
"idr: implement idr_preload[_end]() and idr_alloc()"

$ grep idr ../Linux-Next-v20130206-VS-v20130207.diff | grep ^'++Applying:'
++Applying: block: fix ext_devt_idr handling
++Applying: idr: fix a subtle bug in idr_get_next()
++Applying: nfsd: idr_destroy() no longer needs idr_remove_all()
++Applying: idr: cosmetic updates to struct / initializer definitions
++Applying: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new()
++Applying: idr: remove _idr_rc_to_errno() hack
++Applying: idr: refactor idr_get_new_above()
++Applying: idr: implement idr_preload[_end]() and idr_alloc()
++Applying: block: convert to idr_alloc()
++Applying: block/loop: convert to idr_alloc()
++Applying: atm/nicstar: convert to idr_alloc()
++Applying: drbd: convert to idr_alloc()
++Applying: dca: convert to idr_alloc()
++Applying: dmaengine: convert to idr_alloc()
++Applying: firewire: convert to idr_alloc()
++Applying: gpio: convert to idr_alloc()
++Applying: drm: convert to idr_alloc()
++Applying: drm/exynos: convert to idr_alloc()
++Applying: drm/i915: convert to idr_alloc()
++Applying: drm/sis: convert to idr_alloc()
++Applying: drm/via: convert to idr_alloc()
++Applying: drm/vmwgfx: convert to idr_alloc()
++Applying: i2c: convert to idr_alloc()
++Applying: IB/core: convert to idr_alloc()
++Applying: IB/amso1100: convert to idr_alloc()
++Applying: IB/cxgb3: convert to idr_alloc()
++Applying: IB/cxgb4: convert to idr_alloc()
++Applying: IB/ehca: convert to idr_alloc()
++Applying: IB/ipath: convert to idr_alloc()
++Applying: IB/mlx4: convert to idr_alloc()
++Applying: IB/ocrdma: convert to idr_alloc()
++Applying: IB/qib: convert to idr_alloc()
++Applying: dm: convert to idr_alloc()
++Applying: memstick: convert to idr_alloc()
++Applying: mfd: convert to idr_alloc()
++Applying: misc/c2port: convert to idr_alloc()
++Applying: misc/tifm_core: convert to idr_alloc()
++Applying: mmc: convert to idr_alloc()
++Applying: mtd: convert to idr_alloc()
++Applying: macvtap: convert to idr_alloc()
++Applying: ppp: convert to idr_alloc()
++Applying: power: convert to idr_alloc()
++Applying: pps: convert to idr_alloc()
++Applying: remoteproc: convert to idr_alloc()
++Applying: rpmsg: convert to idr_alloc()
++Applying: scsi/bfa: convert to idr_alloc()
++Applying: scsi: convert to idr_alloc()
++Applying: target/iscsi: convert to idr_alloc()
++Applying: scsi/lpfc: convert to idr_alloc()
++Applying: thermal: convert to idr_alloc()
++Applying: uio: convert to idr_alloc()
++Applying: vfio: convert to idr_alloc()
++Applying: dlm: convert to idr_alloc()
++Applying: inotify: convert to idr_alloc()
++Applying: ocfs2: convert to idr_alloc()
++Applying: ipc: convert to idr_alloc()
++Applying: cgroup: convert to idr_alloc()
++Applying: events: convert to idr_alloc()
++Applying: posix-timers: convert to idr_alloc()
++Applying: net/9p: convert to idr_alloc()
++Applying: mac80211: convert to idr_alloc()
++Applying: sctp: convert to idr_alloc()
++Applying: nfs4client: convert to idr_alloc()

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=e2802c2defba1e5c88d7d168eb5c66813c86f249

> Eric
