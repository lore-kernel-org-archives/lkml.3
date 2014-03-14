Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaCNXtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:49:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53135 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaCNXtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:49:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Simo Sorce <ssorce@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
References: <1394658983.32465.203.camel@willson.li.ssimo.org>
	<CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
	<1394673476.32465.215.camel@willson.li.ssimo.org>
	<CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
	<1394675038.32465.223.camel@willson.li.ssimo.org>
	<CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
	<1394733077.32465.243.camel@willson.li.ssimo.org>
	<CALCETrXWzja6W6y=p9MrtynGZMsrD5KQu0KBK6Bs1dQxnesv2A@mail.gmail.com>
	<20140313195349.GM18914@redhat.com>
	<CALCETrUj4aPEd6ujXnUJNFq+BQkfQoF=XRChP1p5=ZysTN-zwg@mail.gmail.com>
	<20140313200649.GN18914@redhat.com>
Date: Fri, 14 Mar 2014 16:49:23 -0700
In-Reply-To: <20140313200649.GN18914@redhat.com> (Vivek Goyal's message of
	"Thu, 13 Mar 2014 16:06:49 -0400")
Message-ID: <8761ng2vek.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19l9Ae9rx9uWM+sn55BucOOjdU6c8vVZPQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3984]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Mar 13, 2014 at 12:58:14PM -0700, Andy Lutomirski wrote:
>> On Thu, Mar 13, 2014 at 12:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Mar 13, 2014 at 10:55:16AM -0700, Andy Lutomirski wrote:
>> >
>> > [..]
>> >> >> 2. Docker is a container system, so use the "container" (aka
>> >> >> namespace) APIs.  There are probably several clever things that could
>> >> >> be done with /proc/<pid>/ns.
>> >> >
>> >> > pid is racy, if it weren't I would simply go straight
>> >> > to /proc/<pid>/cgroups ...
>> >>
>> >> How about:
>> >>
>> >> open("/proc/self/ns/ipc", O_RDONLY);
>> >> send the result over SCM_RIGHTS?
>> >
>> > As I don't know I will ask. So what will server now do with this file
>> > descriptor of client's ipc namespace.
>> >
>> > IOW, what information/identifier does it contain which can be
>> > used to map to pre-configrued per container/per namespace policies.
>> 
>> Inode number, which will match that assigned to the container at runtime.
>> 
>
> But what would I do with this inode number. I am assuming this is
> generated dynamically when respective namespace was created. To me
> this is like assigning a pid dynamically and one does not create
> policies in user space based on pid. Similarly I will not be able
> to create policies based on an inode number which is generated
> dynamically.
>
> For it to be useful, it should map to something more static which
> user space understands.

But the mapping can be done in userspace.  stat all of the namespaces
you care about, get their inode numbers, and then do a lookup.

Hard coding string based names in the kernel the way cgroups does is
really pretty terrible and it seriously limits the flexibility of the
api, and so far breaks nested containers.

Eric
