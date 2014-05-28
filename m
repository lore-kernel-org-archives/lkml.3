Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaE1Vn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:43:57 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:38600 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaE1Vn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <538652EA.3040606@linux.intel.com>
References: <1401279583-1027-1-git-send-email-pkern@google.com>
 <53864B66.8030100@amacapital.net> <53864E91.4060207@linux.intel.com>
 <CALCETrWd9dbBt03u5cpJx+p3D7NeT-d2_=kTg94CRGMq7ji7kQ@mail.gmail.com> <538652EA.3040606@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 14:43:35 -0700
Message-ID: <CALCETrWOOFhusn6MACs=o+TqqjQDXyTwVTe-iE_4bQcJu-ez=w@mail.gmail.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Philipp Kern <pkern@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 2:19 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 05/28/2014 02:15 PM, Andy Lutomirski wrote:
>>>
>>>> 3. The OOPS you're fixing doesn't seem like it's fixed.  What if some
>>>> other random high bits are set?
>>>
>>> There is a range check in entry_*.S for the system call.
>>
>> I can imagine that causing a certain amount of confusion to fancy
>> seccomp users.  Oh, well.  No one that I know of has complained yet.
>>
>
> I don't know how seccomp or audit deal with out-of-range syscall
> numbers, so that might be worth taking a look at.

audit oopses, apparently.  seccomp will tell BPF about it and follow
directions, barring bugs.

However: are you sure that entry_64.S handles this?  It looks like
tracesys has higher priority than badsys.  And strace can certainly
see out-of-range syscalls.  And I can oops audit by doing:

auditctl -a exit,always -S open
./a.out

where a.out is this:

#include <stdio.h>
#include <sys/syscall.h>

int main()
{
  long i;
  for (i = 1000; ; i += 64 * 4096)
    syscall(i, 0, 0, 0, 0, 0, 0);
  return 0;
}

I would *love* to deprecate the entire syscall auditing mechanism.  Or
at least I'd love to have distros stop using it.

I'll go ask for a CVE number.  Sigh.


--Andy
