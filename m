Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980Ab3DDAOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:14:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59702 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab3DDAOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:14:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de>
	<1364997630.13853.19.camel@edumazet-glaptop>
	<87a9pfzm33.fsf@turtle.gmx.de>
	<1365003300.13853.25.camel@edumazet-glaptop> <515C6DCD.50902@mit.edu>
	<1365014637.13853.36.camel@edumazet-glaptop>
	<CALCETrVWV=HEv7q5AUYeCjZOq52omz8moYTwympB6_G4Bz7p8Q@mail.gmail.com>
Date: Wed, 03 Apr 2013 17:14:31 -0700
In-Reply-To: <CALCETrVWV=HEv7q5AUYeCjZOq52omz8moYTwympB6_G4Bz7p8Q@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 3 Apr 2013 12:01:36 -0700")
Message-ID: <87a9pfm9so.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18CrTe3BVAvw0pGK+QA/DrWgINT+7aC02g=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Wed, Apr 3, 2013 at 11:43 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> On Wed, 2013-04-03 at 10:58 -0700, Andy Lutomirski wrote:
>>
>>>
>>> This sounds suspiciously like an SCM_CREDENTIALS bug triggered by a
>>> race.  There's a fix (that needs both a new version from me and a review
>>> by someone) here:
>>>
>>> http://www.spinics.net/lists/netdev/msg229948.html
>>
>> Hmm... this is not a stable candidate, IMHO.
>
> Agreed.
>
>>
>> This has to be fixed (if needed) in a more easy way.
>>
>> What about this one liner ?
>>
>> CC Eric W. Biederman  as he wrote commit
>> dbe9a4173ea53b72b2c3
>> (scm: Don't use struct ucred in NETLINK_CB and struct scm_cookie.)
>>
>> diff --git a/include/net/scm.h b/include/net/scm.h
>> index 975cca0..42359d8 100644
>> --- a/include/net/scm.h
>> +++ b/include/net/scm.h
>> @@ -120,7 +120,7 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>>                 return;
>>         }
>>
>> -       if (test_bit(SOCK_PASSCRED, &sock->flags)) {
>> +       if (test_bit(SOCK_PASSCRED, &sock->flags) && scm->creds.pid) {
>>                 struct user_namespace *current_ns = current_user_ns();
>>                 struct ucred ucreds = {
>>                         .pid = scm->creds.pid,
>>
>>
>
> That looks like it's correct.  If it gets applied, I'll respin my
> patches on top of it.
>
> (This approach may be a POSIX violation for all I know, and it's even
> possible that some really fragile userspace breaks.  But I doubt it,
> and anything that will break as a result is already operating in a
> highly confused state; hence the original problem.)

It certainly looks like we are not giving userspace what userspace asked
for, which can break in all kinds of subtle ways.  And I can't possibly
see how not giving udev any information will when udev asked for the
sender will fix anything.

I think we need to answer why in the world do we do not want to pass
credentials from an unconnected unix mode socket, before we ask
why don't we want to deliver credentials that we didn't pass when
passing of credentials was explicitly requested.

If the only concern about the LSB test case is performance I think we
need to revert the original commit and just stop passing a struct cred
pointer.  If there is a concern about the data I think we need a better
explanation of what those LSB test cases were that broke.

Eric
