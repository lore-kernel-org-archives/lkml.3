Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaBGVYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:24:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaBGVYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:24:31 -0500
Message-ID: <52F54F08.6060507@redhat.com>
Date: Fri, 07 Feb 2014 16:24:24 -0500
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, m@silodev.com,
        akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>
Subject: Re: Max number of posix queues in vanilla kernel (/proc/sys/fs/mqueue/queues_max)
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com> <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
X-Enigmail-Version: 1.6
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QF1PwThnkCAp6CbhouQH27LG7duXhWLMw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QF1PwThnkCAp6CbhouQH27LG7duXhWLMw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2/7/2014 3:11 PM, Davidlohr Bueso wrote:
> On Thu, 2014-02-06 at 12:21 +0200, m@silodev.com wrote:
>> Hi Folks,
>>
>> I have recently ported my multi-process application (like a classical =
open
>> system) which uses POSIX Queues as IPC to one of the latest Linux kern=
els,
>> and I have faced issue that number of maximum queues are dramatically
>> limited down to 1024 (see include/linux/ipc_namespace.h, #define
>> HARD_QUEUESMAX 1024).
>>
>> Previously the max number of queues was INT_MAX (on 64bit system was:
>> 2147483647).
>=20
> Hmm yes, 1024 is quite unrealistic for some workloads and breaks
> userspace - I don't see any reasons for _this_ specific value in the
> changelog or related changes in the patchset that introduced commits
> 93e6f119 and 02967ea0.

There wasn't a specific selection of that number other than a general
attempt to make the max more reasonable (INT_MAX isn't really reasonable
given the overhead of each individual queue, even if the queue number
and max msg size are small).

> And the fact that this limit is per namespace
> makes no difference really. Hell, if nothing else, the mq_overview(7)
> manpage description is evidence enough. For privileged users:
>=20
> The default value for queues_max is 256; it can be changed to any value=
 in the range 0 to INT_MAX.

That was obviously never updated to match the change.

In hindsight, I'm not sure we really even care though.  Since the limit
on queues is per namespace, and we can make as many namespaces as we
want, the limit is more or less meaningless and only serves as a
nuisance to people.  Since we have accounting on a per user basis that
spans across namespaces and across queues, maybe that should be
sufficient and the limit on queues should simply be removed and we
should instead just rely on memory limits.  When the user has exhausted
their allowed memory usage, whether by large queue sizes, large message
sizes, or large queue counts, then they are done.  When they haven't,
they can keep allocating.  Would make things considerably easier and
would avoid the breakage we are talking about here.

>>
>> This update imposes bad limits on our multi-process application. As ou=
r
>> app uses approaches that each process opens its own set of queues (usu=
ally
>> something about 3-5 queues per process). In some scenarios we might ru=
n up
>> to 3000 processes or more (which of-course for linux is not a problem)=
=2E
>> Thus we might need up to 9000 queues or more. All processes run under =
one
>> user.
>>
>> But now we have this limit, which limits our software down and we are
>> getting in trouble. We could patch the kernel manually, but not all
>> customers are capable of this and willing to do the patching.
>>
>> Thus I *kindly* ask you guys to increase this limit to something like =
1M
>> queues or more (or to technical limit i.e. leave the same INT_MAX).

Technically, INT_MAX isn't (and never was) a valid limit.  Because the
queue overhead memory size is accounted against the user when creating a
queue, they can never effectively get to INT_MAX whether it's allowed or
not.

>> If
>> user can screw up the system by setting or using maximums, let it leav=
e to
>> the user. As it is doing system tuning and he is responsible for kerne=
l
>> parameters.
>>
>> The kernel limit was introduced by:
>> -
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D93e6f119c0ce8a1bba6e81dc8dd97d67be360844
>>
>> Also I see other people are claiming issues with this, see:
>> - https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695 - fo=
r
>> them some database software is not working after the kernel upgrade...=

>=20
> Surprised we didn't hear about this earlier by Michael Kerrisk. At leas=
t
> the upstream manpages haven't been updated to reflect this new behavior=
,
> it would have been the wrong way to go.
>=20
>>
>> Also I think that when people will upgrade from RHEL 5 or RHEL 6 to ne=
xt
>> versions where this hard limit will be defined, I suspect that many wi=
ll
>> claim problem about it...
>=20
> Agreed, RHEL 7 will ship with some baseline version of the 3.10 kernel
> and users will be exposed to this. Of course, the same goes for just
> about any distro, and Ubuntu users are already complaining about it.
>=20
> I believe that instead of bumping up this HARD limit of 1024, we should=

> go back to the original behavior. If we just increase it, instead, then=

> how high is high enough?

I think it can be removed entirely myself.  The memory limit is really
all we need worry about unless Viro comes back and says 100s of
thousands of queues in a single namespace will kill queue lookup or
something like that.




--QF1PwThnkCAp6CbhouQH27LG7duXhWLMw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS9U8IAAoJELgmozMOVy/drpAQAL2xua15qriOCNELnzVIykxK
xOpod2s4R6ubl5POzg/BYrfcWta8Jc9Ul18WV94FMmNgFw53CG/ygDnpt1fUH/ie
G8xvCn0Vw+cihM8ZE1LIRRuiVAvM5/teBkX7YgzOXqzaR1c1sAOhXk5CnydaLsCY
itOAku9AcrfeaA94MEeuYDGmHU1BvGqpjvV7PNDI2H1fvl/88u/lBkTN7rJVJfDF
WJ1J6B7A3qjC0a1SthZpVfPqePAsJl2IaLfCQ4/AqEIaum9LmBDmy0UzJLDBc5sP
fsow/I6AqLvn0d+T04sEKUuCE87apn+8YLqeXELCIudYT2GkYGjhkRaECPFivuMs
WM/PllM/lNNYyMq//OyzU2JTP5qsUJg2nZRqSSuZjW3c5t0IZkX9Pek2LKMqtP9A
0UBfjWCdkDZjIwQZA0MAro7cE8E0b9DynVxmHd+wTO2WfV0d1L1ciXNvC9BTWhaP
ajN4gRZUWlNyT5Xx7ek3HJ/hiQD3x2HUfcO78EX8X7my9XxTYmwydkD7/2cSa3sq
HH6QEDMB+JaufbI3jetr04cmbejN22xXgFAeTHdea+ZeoaXaBr5W4oY6kefOKd38
4dZ4vend5AuOnUMi21M2o3atLao04HzS5jEqfB0+CaE97n6gkLZWqO5I3op9PhkN
bnLcLYNq4QMRC+OqUwHB
=6pTg
-----END PGP SIGNATURE-----

--QF1PwThnkCAp6CbhouQH27LG7duXhWLMw--
