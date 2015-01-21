Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbbAUBXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 20:23:12 -0500
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:40204 "EHLO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbbAUBXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 20:23:10 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eMruUbQVM1krNCrDzGoXN.6IuVlgkqHQM08s61LGRxsdxxR
 _iqb_7_MQFdN4018JWgg9gqpkQTveJAMMotQqq_KWywaghIXRzKfixgxVdby
 hpVw7TtMQURkUFojEtPXF.BncnGBAB87_fb2.OVMCR5kj4JeGYkIaJwdb5gl
 c8rAu13UWWG55w3GPuaLE4nczw7S5R.achwph_VVMlhfx0rTIxDL4nlJ3_cD
 rcEwxAXez7YlSDH_zl_xzqCvvtaDaK8BE1rXI5EhySYGgWhvzisr0VPhYINI
 CXYQ5a3wWd9_pkZuGRBMiIM1aaOThw9sE78gWPl_iYp1dA.1O17fgOPDXuCR
 hvu5IbB_e5MQ5IjKe4w6uT1qyj6o3MR.yE4CJFpPxqToJUVLkc_A.6FWJkcT
 CPAj.O.f3YEaSNREyJ6S4TE5xDA0MK2YntxMPQsgd_RuZ5ANn7onpg5E0w0U
 7lDWKhF2ga5VI9AhbB5E5ySjyhBWchj5ywMKhSTWe0t60u71.jC03Vo5FGjX
 v5EzjNhr.prPLZlNa6ZDvzJGE..LPWD2m
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54BEFF7A.1000709@schaufler-ca.com>
Date: Tue, 20 Jan 2015 17:23:06 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Iulia Manda <iulia.manda21@gmail.com>, serge.hallyn@canonical.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, mhocko@suse.cz,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] kernel: Conditionally support non-root users, groups
 and capabilities
References: <20150120233308.GA6256@winterfell> <54BEED2C.2000000@schaufler-ca.com> <20150121005006.GA1217@thin>
In-Reply-To: <20150121005006.GA1217@thin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/2015 4:50 PM, Josh Triplett wrote:
> On Tue, Jan 20, 2015 at 04:05:00PM -0800, Casey Schaufler wrote:
>> On 1/20/2015 3:33 PM, Iulia Manda wrote:
>>> There are a lot of embedded systems that run most or all of their functionality
>>> in init, running as root:root. For these systems, supporting multiple users is
>>> not necessary.
>>>
>>> This patch adds a new symbol, CONFIG_NON_ROOT, that makes support for non-root
>>> users, non-root groups, and capabilities optional.
>>>
>>> When this symbol is not defined, UID and GID are zero in any possible case
>>> and processes always have all capabilities.
>>>
>>> Also, the following syscalls are compiled out: setuid, setregid, setgid,
>>> setreuid, setresuid, getresuid, setresgid, getresgid, setgroups, getgroups,
>>> setfsuid, setfsgid, capget, capset.
>>>
>>> This change saves about 25 KB on a defconfig build.
>>>
>>> Bloat-o-meter output:
>>> add/remove: 7/66 grow/shrink: 21/421 up/down: 1701/-27172 (-25471)
>>>
>>> Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
>>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>> Authoritative LSM hooks were loudly rejected in or about 1999.
>> One of the primary reasons they were rejected was because you could
>> use them do exactly what this patch does, which is to remove the basic
>> Linux security policy. If attitudes have changed sufficiently that
>> removing the "classic" security behavior is now deemed acceptable,
>> I propose that we reintroduce the option of authoritative LSM hooks
>> instead. That would give you all this saving, and probably more.
> Wouldn't authoritative LSM hooks require *adding* the necessary hook
> logic, along with a hook module implementing such a policy?  Unless
> you're suggesting that compiling in LSM hooks without any providers
> would result in this behavior by default, which seems rather
> questionable.

The proposed default configuration would have included hooks implementing the
traditional UNIX/Linux discretionary access controls and Super User. Proposed
alternative configurations allowed the addition of POSIX capabilities, B&L MAC
and that new kid on the block, FLASK.

Your configuration would have required trivial "return success" policy functions,
much like what you find in security/capability.c today.

> Also note that this is compiling out the entire family of UID/GID system
> calls, which LSM hooks could not do.

Which breaks backward compatibility.
 

> In any case, I see two major problems with authoritative LSM hooks that
> this patch avoids:
>
> First, simplicity: I doubt authoritative LSM hooks could match this
> diffstat:
>
>>>  include/linux/capability.h |   12 ++++++++++++
>>>  include/linux/uidgid.h     |   12 ++++++++++++
>>>  init/Kconfig               |   19 ++++++++++++++++++-
>>>  kernel/capability.c        |    6 ++++++
>>>  kernel/groups.c            |    4 ++++
>>>  kernel/sys.c               |    2 ++
>>>  kernel/sys_ni.c            |   14 ++++++++++++++
>>>  7 files changed, 68 insertions(+), 1 deletion(-)

The size of the diffstat is no indication of the value of a change.
You're using a trivial amount of ifdefing to implement a very significant change.
If you removed the code you're blocking out your diffstat would be much indicative of
the impact, and much larger.

> Second, code size reduction: In addition to the concern above about
> adding hooks rather than removing code, this patch allows
> constant-folding away huge amounts of code, which any kind of "hook"
> mechanism would have a hard time doing.  This patch lets the compiler do
> almost all of the work.  Notice the "66 shrink" and "421 down" in the
> bloat-o-meter summary.

Yes, we all know (or should) that you can reduce the size of a change using

	#ifdef 0
	... 58,455 line of code ...
	#endif

instead of removing the 58,455 lines of code.

> The intent here is not to open the door to arbitrary replacement
> security policies.  The intent is to simply add a compile-time option to
> compile *out* security policies entirely, for systems that will not only
> never call setuid but in many cases never even call fork.

You are opening the door to creating a "Linux" kernel that does not
behave like Linux. This has been seriously considered and flat out rejected
in the past. It was not a matter of the mechanism used to achieve the
change in policy, it was in fact the ability to change the policy.

Again, attitudes may have changed since the turn of the century. If they
have, we should do a real job of allowing the existing policy to be
changed rather than whacking away code with the ifdef chainsaw.

> - Josh Triplett
>

