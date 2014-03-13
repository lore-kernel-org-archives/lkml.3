Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaCMCMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:12:48 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:34304 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCMCMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <1394675038.32465.223.camel@willson.li.ssimo.org>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
 <1394657163-7472-3-git-send-email-vgoyal@redhat.com> <5320CAEC.6030008@amacapital.net>
 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
 <1394658983.32465.203.camel@willson.li.ssimo.org> <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
 <1394673476.32465.215.camel@willson.li.ssimo.org> <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
 <1394675038.32465.223.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 19:12:25 -0700
Message-ID: <CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
To: Simo Sorce <ssorce@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 6:43 PM, Simo Sorce <ssorce@redhat.com> wrote:
> On Wed, 2014-03-12 at 18:21 -0700, Andy Lutomirski wrote:
>> On Wed, Mar 12, 2014 at 6:17 PM, Simo Sorce <ssorce@redhat.com> wrote:
>> > On Wed, 2014-03-12 at 14:19 -0700, Andy Lutomirski wrote:
>> >> On Wed, Mar 12, 2014 at 2:16 PM, Simo Sorce <ssorce@redhat.com> wrote:
>> >>
>> >> >
>> >> > Connection time is all we do and can care about.
>> >>
>> >> You have not answered why.
>> >
>> > We are going to disclose information to the peer based on policy that
>> > depends on the cgroup the peer is part of. All we care for is who opened
>> > the connection, if the peer wants to pass on that information after it
>> > has obtained it there is nothing we can do, so connection time is all we
>> > really care about.
>>
>> Can you give a realistic example?
>>
>> I could say that I'd like to disclose information to processes based
>> on their rlimits at the time they connected, but I don't think that
>> would carry much weight.
>
> We want to be able to show different user's list from SSSD based on the
> docker container that is asking for it.
>
> This works by having libnsss_sss.so from the containerized application
> connect to an SSSD daemon running on the host or in another container.
>
> The only way to distinguish between containers "from the outside" is to
> lookup the cgroup of the requesting process. It has a unique container
> ID, and can therefore be mapped to the appropriate policy that will let
> us decide which 'user domain' to serve to the container.
>

I can think of at least three other ways to do this.

1. Fix Docker to use user namespaces and use the uid of the requesting
process via SCM_CREDENTIALS.

2. Docker is a container system, so use the "container" (aka
namespace) APIs.  There are probably several clever things that could
be done with /proc/<pid>/ns.

3. Given that Docker uses network namespaces, I assume that the socket
connection between the two sssd instances either comes from Docker
itself or uses socket inodes.  In either case, the same mechanism
should be usable for authentication.

On an unrelated note, since you seem to have found a way to get unix
sockets to connect the inside and outside of a Docker container, it
would be awesome if Docker could use the same mechanism to pass TCP
sockets around rather than playing awful games with virtual networks.

--Andy
