Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859Ab3DDAxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:53:24 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:61694 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab3DDAxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <87li8zjf48.fsf@xmission.com>
References: <20130402221104.163133110@linuxfoundation.org> <20130402221116.307254752@linuxfoundation.org>
 <87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
 <1365034777.13853.46.camel@edumazet-glaptop> <87li8zjf48.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Apr 2013 17:53:02 -0700
Message-ID: <CALCETrXo0zFMLpH6JkEdyO2pJW9E-07WBxDDh2mWewNy3xJLVg@mail.gmail.com>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Karel Srot <ksrot@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 5:47 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Eric Dumazet <eric.dumazet@gmail.com> writes:
>
>> On Wed, 2013-04-03 at 17:05 -0700, Eric W. Biederman wrote:
>>> Sven Joachim <svenjoac@gmx.de> writes:
>>>
>>> > On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
>>> >
>>> >> 3.8-stable review patch.  If anyone has any objections, please let me know.
>>> >
>>> > I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
>>> > 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
>>> > patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
>>> > here, and 65534 is the uid of user "nobody".
>>>
>>> Hmm.
>>>
>>> Ok.  I don't understand the commit that was being backported here.  I am
>>> pretty certain it a fix for a problem that did not exist.
>>>
>>> Unless I am completely mis-reading scm_recv we only generate a
>>> SCM_CREDENTIALS message if the receiving socket asserts SOCK_PASSCRED.
>>> Which means that the only harm that can come from adding scm credentials
>>> to a disconnected af_unix socket is a loss in efficiency.
>>>
>>> Not adding scm credentials to be passed to userspace as the commit below
>>> is doing can result is bogus data being passed to userspace.  Which is
>>> very actively WRONG.
>>>
>>> Now before scm_recv does anything we first call scm_set_cred.  If no
>>> credential was passed to scm_set_cred we set the uid to INVALID_UID.
>>> Which scm_recv in the call from_kuid_munged translates into 65534 for
>>> reporting to userspace.
>>>
>>> So this is is pretty clearly a case of us not sending the unix
>>> credentials.
>>>
>>> Since not sending credential is just a performance optimization I can
>>> see no earthly reason why the commit below should have been applied in
>>> the first place, and no reason why it should have been backported in the
>>> second place.  So my vote is that we revert this bogus commit.  Upstream
>>> and then backport the revert.
>>>
>>> Am I missing something?
>>
>> Well, yes, this commit fixes a real bug : We were coalescing two
>> messages into a single one, even if the senders were different.
>
> What???
>
> As far as I can tell this patch can only server to _allow_ coalescing two
> messages into a single one.
>
>> Copy of a reply I did :
>>
>> So the problem is that two messages have different credentials,
>> because other->sk_socket changed between first and second message.
>
>
>> and unix_stream_recvmsg() has the following check :
>>
>>                 if (check_creds) {
>>                         /* Never glue messages from different writers */
>>                         if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
>>                             (UNIXCB(skb).cred != siocb->scm->cred))
>>                                 break;
>>                 } else {
>>                         /* Copy credentials */
>>                         scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
>>                         check_creds = 1;
>>                 }
>>
>> So the patch was good, and we need a followup, like the one I posted
>> today ?
>
> No.  The patch is still bogus.
>
> If the problem is that we are not coallescing messages in stream_recvmsg
> we need a different fix.
>
> Probably something like:
>
>                   if (check_creds) {
>                           /* Never glue messages from different writers */
>                           if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
>                               (UNIXCB(skb).cred != siocb->scm->cred))
>                                   break;
> -                 } else {
> +                 } else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
>                           /* Copy credentials */
>                           scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
>                           check_creds = 1;
>                   }

I'm confused.  Isn't this making the problem worse, not better?

The original don't-always-pass-creds logic came from (I think):

commit 16e5726269611b71c930054ffe9b858c1cea88eb
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon Sep 19 05:52:27 2011 +0000

    af_unix: dont send SCM_CREDENTIALS by default

    Since commit 7361c36c5224 (af_unix: Allow credentials to work across
    user and pid namespaces) af_unix performance dropped a lot.

    This is because we now take a reference on pid and cred in each write(),
    and release them in read(), usually done from another process,
    eventually from another cpu. This triggers false sharing.

With my patches, the cost should go way down and it could be made
unconditional, but that's still probably not a good -stable change.

--Andy
