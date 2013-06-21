Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161278Ab3FUBFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:05:08 -0400
Received: from out04.mta.xmission.com ([166.70.13.234]:44974 "EHLO
	out04.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965925Ab3FUBFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:05:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrey Wagin <avagin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
References: <1371457498-27241-1-git-send-email-avagin@openvz.org>
	<878v284iif.fsf@xmission.com>
	<CANaxB-zvPMZe932nAeyOCbdHmmXa76f12BRv0X0W7F0ULZMkTA@mail.gmail.com>
	<20130619213532.GA31165@gmail.com>
Date: Thu, 20 Jun 2013 18:04:28 -0700
In-Reply-To: <20130619213532.GA31165@gmail.com> (Andrey Wagin's message of
	"Thu, 20 Jun 2013 01:35:32 +0400")
Message-ID: <87y5a4l1er.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19PP0JY+kLvP2o7D/kEuvQlQrxynR6W5sw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrey Wagin <avagin@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [RFC] mnt: restrict a number of "struct mnt"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Wagin <avagin@gmail.com> writes:

> On Tue, Jun 18, 2013 at 02:56:51AM +0400, Andrey Wagin wrote:
>> 2013/6/17 Eric W. Biederman <ebiederm@xmission.com>:
>> > So for anyone seriously worried about this kind of thing in general we
>> > already have the memory control group, which is quite capable of
>> > limiting this kind of thing,
>> 
>> > and it limits all memory allocations not just mount.
>> 
>> And that is problem, we can't to limit a particular slab. Let's
>> imagine a real container with 4Gb of RAM. What is a kernel memory
>> limit resonable for it? I setup 64 Mb (it may be not enough for real
>> CT, but it's enough to make host inaccessible for some minutes).
>> 
>> $ mkdir /sys/fs/cgroup/memory/test
>> $ echo $((64 << 20)) > /sys/fs/cgroup/memory/test/memory.kmem.limit_in_bytes
>> $ unshare -m
>> $ echo $$ > /sys/fs/cgroup/memory/test/tasks
>> $ mount --make-rprivate /
>> $ mount -t tmpfs xxx /mnt
>> $ mount --make-shared /mnt
>> $ time bash -c 'set -m; for i in `seq 30`; do mount --bind /mnt
>> `mktemp -d /mnt/test.XXXXXX` & done;  for i in `seq 30`; do wait;
>> done'
>> real 0m23.141s
>> user 0m0.016s
>> sys 0m22.881s
>> 
>> While the last script is working, nobody can't to read /proc/mounts or
>> mount something. I don't think that users from other containers will
>> be glad. This problem is not so significant in compared with umounting
>> of this tree.
>> 
>> $ strace -T umount -l /mnt
>> umount("/mnt", MNT_DETACH)              = 0 <548.898244>
>> The host is inaccessible, it writes messages about soft lockup in
>> kernel log and eats 100% cpu.
>
> Eric, do you agree that
> * It is a problem
> * Currently we don't have a mechanism to prevent this problem
> * We need to find a way to prevent this problem

Ugh.  I knew mount propagation was annoying semantically but I had not
realized the implementation was quite so bad.

This doesn't happen in normal operation to normal folks.  So I don't
think this is something we need to rush in a fix at the last moment to
prevent the entire world from melting down.  Even people using mount
namespaces in containers.

I do think it is worth looking at.  Which kernel were you testing?.  I
haven't gotten as far as looking too closely but I just noticed that Al
Viro has been busy rewriting the lock of this.  So if you aren't testing
at least 2.10-rcX you probably need to retest.

My thoughts would be.  Improve the locking as much as possible,
and if that is not enough keep a measure of how many mounts will be
affected at least for the umount.  Possibly for the umount -l case.
Then just don't allow the complexity to exceed some limit so we know
things will happen in a timely manner.

Eric
