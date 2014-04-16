Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaDPQbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:31:49 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40716 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaDPQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <1397664837.19767.410.camel@willson.li.ssimo.org>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
 <20140416002010.GA5035@redhat.com> <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net> <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
 <1397664837.19767.410.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Apr 2014 09:31:25 -0700
Message-ID: <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
To: Simo Sorce <ssorce@redhat.com>
Cc: David Miller <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 9:13 AM, Simo Sorce <ssorce@redhat.com> wrote:
> On Wed, 2014-04-16 at 07:37 -0700, Andy Lutomirski wrote:
>> On Wed, Apr 16, 2014 at 5:57 AM, David Miller <davem@davemloft.net> wrote:
>> >
>> > Please, just stop.
>>
>> No.
>>
>> This thread is proposing an ABI.  This means that, if the ABI ends up
>> in Linus's kernel, then it has to be supported forever.  Now is the
>> time to find and fix any issues with it before they become much harder
>> to fix.
>
> Ok, but so far I haven't seen a single objection from you that has solid
> grounds.

CVE-2013-1959 was caused by a new kernel feature causing a call to
write(2) to behave as though the caller was authenticating itself to
something else where, in previous kernels, write(2) did not
authenticate.

Admittedly cgroups aren't currently as important as uid, but if this
changes, then SO_PASSCGROUP, as currently written, will have *exactly*
the same problem.

>
> The only one that *may* be reasonable is the "secret" cgroup name one,
> however nobody seem to come up with a reason why it is legitimate to
> allow to keep cgroup names secret.
>
> And if you can come up with such a good reason the SO_NOPASSCGROUP
> option seem the right solution.
>
>> This ABI is especially tricky because programs will use it even if
>> they don't explicitly try to.  So just adding the ABI may break
>> existing assumptions that are relevant to security or correctness.
>
> It's not clear to me what you mean by this, either you explicitly use
> SO_PASSCGROUP or not, it's not like you can involuntarily add a flag ...
>

The issue here is that the receiver sets SO_(PASS|PEER)CGROUP, forcing
the sender to identify or authenticate itself.  The sender might not
want to identify itself.  Even if you don't buy any secrecy arguments,
the sender might not intend to authenticate.  Certainly no existing
callers of connect or write intend to authenticate using their cgroup,
since current kernels don't have those semantics.

--Andy
