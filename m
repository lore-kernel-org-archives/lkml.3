Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3LMXEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:04:34 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44342 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3LMXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:04:32 -0500
Message-ID: <52AB9317.7080602@gmail.com>
Date: Sat, 14 Dec 2013 10:07:03 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <52AA4BC8.1080207@gmail.com> <20131213130648.GA10870@gmail.com>
In-Reply-To: <20131213130648.GA10870@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/13 00:06, Ingo Molnar wrote:

> 
> * Ryan Mallon <rmallon@gmail.com> wrote:
> 
>> On 13/12/13 08:13, Kees Cook wrote:
>>> On Thu, Dec 12, 2013 at 11:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>>> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>>>>> From: Vegard Nossum <vegard.nossum@oracle.com>
>>>>>
>>>>> The idea is simple -- since different kernel versions are vulnerable to
>>>>> different root exploits, hackers most likely try multiple exploits before
>>>>> they actually succeed.
>>>
>>> I like this idea. It serves a few purposes, not the least of which is
>>> very clearly marking in code where we've had problems, regardless of
>>> the fact that it reports badness to the system owner. And I think
>>> getting any additional notifications about bad behavior is a nice idea
>>> too.
>>
>> Though, if an attacker is running through a series of exploits, and 
>> one eventually succeeds then the first thing to do would be to clean 
>> traces of the _exploit() notifications from the syslog. [...]
> 
> There are several solutions to that:
> 
> 1)
> 
> Critical sites use remote logging over a fast LAN, so a successful 
> exploit would have to zap the remote logging daemon pretty quickly 
> before the log message goes out over the network.
> 
> 2)
> 
> Some sites also log to append-only media [such as a printer] or other 
> append-only storage interfaces - which cannot be manipulated from the 
> attacked system alone after a successful break-in.
> 
> 3)
> 
> In future the exploit() code could trigger actual active defensive 
> measures, such as immediately freezing all tasks of that UID and 
> blocking further fork()s/exec()s of that UID.
> 
> Depending on how critical the security of the system is, such active 
> measures might still be a preferable outcome even if there's a chance 
> of false positives. (Such active measures that freeze the UID will 
> also help with forensics, if the attack is indeed real.)
> 
>> [...] Since running through a series of exploits is pretty quick, 
>> this can probably all be done before the sysadmin ever notices.
> 
> It's not necessarily the sysadmin the attacker is racing against, but 
> against append-only logging and other defensive measures - which too 
> are programs.
> 
>> The _exploit() notifications could also be used to spam the syslogs. 
>> Although they are individually ratelimited, if there are enough 
>> _exploit() markers in the kernel then an annoying person can cycle 
>> through them all to generate large amounts of useless syslog.
> 
> AFAICS they are globally rate-limited, just like many other 
> attacker-triggerable printk()s the kernel may generate.


Actually, that opens another possibility for an attacker. Since they
know the logging is rate-limited, they can first attempt a low risk
CVE (or one that is known to have false positives, see comments from
others about dumb user-space/corrupted file-systems, etc). So that
attempt gets logged, and possibly ignored, but then more attempts
can be quickly made that will not be logged.

Of course, if you have some policy that kicks the user or some such 
then that would limit this approach, but just rate-limited logging
by itself might not be enough. The problem with policy based 
solutions, though, is that if the attacker knows what the policy
is then they can game it. E.g. don't bother trying the known exploits
which will immediately get you kicked; add sufficient delay between
attempts, etc.

~Ryan
 



