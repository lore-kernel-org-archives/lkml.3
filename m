Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab3BTQM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:12:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab3BTQM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:12:56 -0500
Message-ID: <5124F5ED.9000608@oracle.com>
Date: Wed, 20 Feb 2013 11:12:29 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: peterz@infradead.org, jamie.iles@oracle.com, penberg@kernel.org,
        acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [liblockdep] Re: [PATCH v2 01/11] liblockdep: remove the need
 for liblockdep_init
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com> <20130219075825.GA3741@gmail.com> <5124E628.3020008@oracle.com> <20130220154627.GB13388@gmail.com>
In-Reply-To: <20130220154627.GB13388@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 10:46 AM, Ingo Molnar wrote:
> 
> * Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> On 02/19/2013 02:58 AM, Ingo Molnar wrote:
>>>
>>> * Sasha Levin <sasha.levin@oracle.com> wrote:
>>>
>>>> Use a constructor in the library instead of making the user manually
>>>> call liblockdep_init().
>>>>
>>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>>> ---
>>>>  tools/lib/lockdep/common.c                    | 2 +-
>>>>  tools/lib/lockdep/include/liblockdep/common.h | 1 -
>>>>  tools/lib/lockdep/tests/AA.c                  | 1 -
>>>>  tools/lib/lockdep/tests/ABBA.c                | 1 -
>>>>  tools/lib/lockdep/tests/ABBCCA.c              | 1 -
>>>>  tools/lib/lockdep/tests/ABBCCDDA.c            | 1 -
>>>>  tools/lib/lockdep/tests/ABCABC.c              | 1 -
>>>>  tools/lib/lockdep/tests/ABCDBCDA.c            | 1 -
>>>>  tools/lib/lockdep/tests/ABCDBDDA.c            | 1 -
>>>>  tools/lib/lockdep/tests/WW.c                  | 1 -
>>>>  tools/lib/lockdep/tests/unlock_balance.c      | 1 -
>>>>  tools/lib/lockdep/uinclude/linux/lockdep.h    | 1 -
>>>>  12 files changed, 1 insertion(+), 12 deletions(-)
>>>
>>> Note that due to the heavy objections in the kvmtool thread 
>>> I have removed the tools/lib/lockdep library and tooling 
>>> commits from the locking tree - to be able to merge the 
>>> other locking commits upstream.
>>
>> Understood.
>>
>>> I'm pretty sad about this outcome as your code really 
>>> brought new development life into lockdep - if you still 
>>> want to pursue this approach then you might want to try it 
>>> via the tools/kvm tree, or via a separate project.
>>
>> I'm most likely to just fold it into a standalone project 
>> since I'm not quite certain the purpose of tools/ at this 
>> point.
> 
> You could also tempt Linus with a standalone pull request - 
> altough at this point I'm not sure he'd take it.

So I've gone though the kvmtool thread and while liblockdep was
referenced several times Linus didn't share his opinion on it.

Linus, would you be interested in adding liblockdep to your
tree? I'm not looking to start another threadnaught about
pros and cons of userspace code in the kernel, I just want
to know how to proceed with liblockdep. Thanks!

> Sharing the source code between user-space and kernel space 
> makes quite a bit of sense, and copying files, while it works, 
> just encourages needless forking. The impact of your changes on 
> kernel/lockdep.c was minimal:
> 
>  47dd80e801c3 lockdep: Be nice about building from userspace
>   kernel/lockdep.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> So I don't see any substantial 'drag' or downside on the kernel 
> lockdep subsystem - and I see a lot of upsides from exposing 
> user-space to the lockdep code.
> 
> Have you tried to check the locking of something more complex, 
> such as Firefox? (assuming it uses pthread mutexes and rwlocks - 
> I'm not sure about that.)

Yup! I was actually working on that the day before you've sent this
mail :)

firefox does use pthread locks.

firefox/thunderbird use their own wrappers for malloc, which take locks
on the allocation path - this is quite problematic for the current
liblockdep code since it tries to allocate lock objects to store the
extra lockdep data - which results in a deadlock. The fix is quite
trivial, the discovery of this deadlock was quite interesting though :)

Once I got firefox to work properly with liblockdep there was one spew
showing up after browsing for a bit but I haven't dug into it yet - waiting
for a quiet weekend to do that.


Thanks,
Sasha


