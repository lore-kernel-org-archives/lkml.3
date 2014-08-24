Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaHXRwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:52:47 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50204 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHXRwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140822015803.GG20529@madcap2.tricolour.ca>
References: <cover.1408581429.git.rgb@redhat.com> <cd6cd0622ce677b639afae18a69ff79c72490bab.1408581429.git.rgb@redhat.com>
 <CALCETrUnzG1V8w+H9ctAJP+Hvo8LQax=dhLG4bBpBKmVi+C1cQ@mail.gmail.com> <20140822015803.GG20529@madcap2.tricolour.ca>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 24 Aug 2014 10:52:24 -0700
Message-ID: <CALCETrUkFD0iNi1SV_6ypN5Kf4GYybT5tzjRjRQuLzT9iBnQAg@mail.gmail.com>
Subject: Re: [PATCH V4 3/8] namespaces: expose ns instance serial numbers in proc
To: Richard Guy Briggs <rgb@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        arozansk@redhat.com, linux-audit@redhat.com,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 6:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 14/08/21, Andy Lutomirski wrote:
>> On Aug 20, 2014 8:12 PM, "Richard Guy Briggs" <rgb@redhat.com> wrote:
>> > Expose the namespace instace serial numbers in the proc filesystem at
>> > /proc/<pid>/ns/<ns>_snum.  The link text gives the serial number in hex.
>>
>> What's the use case?
>>
>> I understand the utility of giving unique numbers to the audit code,
>> but I don't think this part is necessary for that, and I'd like to
>> understand what else will use this before committing to a duplicative
>> API like this.
>
> How does a container manager get those numbers?  It could provoke a task
> to cause an audit event that emits a NS_INFO message, or it could run a
> task in that container to report its namespace serial numbers directly
> from its /proc mount.

Why does a container manager need them?  Is there any reason that
keeping them entirely contained within the audit system would be a
problem?

>
> The discussion in this thread touches on the use cases:
>         https://lkml.org/lkml/2014/4/22/662
>
>> Note that this API is thoroughly incompatible with CRIU.  If we do
>> this, someone will ask for a namespace number namespace, and that way
>> lies madness.
>
> I had a very brief look at CRIU, but not enough to understand the issue.
> Others have hinted at this problem.
>
> Do you have a suggestion of a different approach that would be
> compatible with CRIU?
>
> I'd originally considered some sort of UUID that would be globally
> unique, but that would be very hard to devise or guarantee, and besides,
> namespaces aren't only used by containers and could be shared in other
> ways.  Tracking the usage and migration of namespaces should be the task
> of an upper layer.
>

CRIU wants to save the complete state of a namespace and then restore
it.  For that to work, any information exposed to things in the
namespace *cannot* be globally unique or unique per boot, since CRIU
needs to arrange for that information to match whatever it was when
CRIU saved it.

Also, I think that code running in a namespace has no business even
knowing a unique identity of that namespace from the perspective of
the host.

Here's a specific use case for *not* exposing this: Tor.  Ideally, Tor
clients would run in a namespace that does not know about any global
identity.  That means no IP addresses, but it also means no global
namespace serial numbers.

--Andy
