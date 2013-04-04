Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971Ab3DDAFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:05:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42469 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab3DDAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:05:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de>
Date: Wed, 03 Apr 2013 17:05:25 -0700
In-Reply-To: <87vc833kpf.fsf@turtle.gmx.de> (Sven Joachim's message of "Wed,
	03 Apr 2013 13:41:32 +0200")
Message-ID: <87k3ojnosa.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/FXeIELwMU2kXdTZDf9HmK3fOShNTG8+E=
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
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sven Joachim <svenjoac@gmx.de>
X-Spam-Relay-Country: 
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Joachim <svenjoac@gmx.de> writes:

> On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
>
>> 3.8-stable review patch.  If anyone has any objections, please let me know.
>
> I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> here, and 65534 is the uid of user "nobody".

Hmm.

Ok.  I don't understand the commit that was being backported here.  I am
pretty certain it a fix for a problem that did not exist.

Unless I am completely mis-reading scm_recv we only generate a
SCM_CREDENTIALS message if the receiving socket asserts SOCK_PASSCRED.
Which means that the only harm that can come from adding scm credentials
to a disconnected af_unix socket is a loss in efficiency.

Not adding scm credentials to be passed to userspace as the commit below
is doing can result is bogus data being passed to userspace.  Which is
very actively WRONG.

Now before scm_recv does anything we first call scm_set_cred.  If no
credential was passed to scm_set_cred we set the uid to INVALID_UID.
Which scm_recv in the call from_kuid_munged translates into 65534 for
reporting to userspace.

So this is is pretty clearly a case of us not sending the unix
credentials.

Since not sending credential is just a performance optimization I can
see no earthly reason why the commit below should have been applied in
the first place, and no reason why it should have been backported in the
second place.  So my vote is that we revert this bogus commit.  Upstream
and then backport the revert.

Am I missing something?

Eric

>> From: dingtianhong <dingtianhong@huawei.com>
>>
>> [ Upstream commit 14134f6584212d585b310ce95428014b653dfaf6 ]
>>
>> SCM_SCREDENTIALS should apply to write() syscalls only either source or destination
>> socket asserted SOCK_PASSCRED. The original implememtation in maybe_add_creds is wrong,
>> and breaks several LSB testcases ( i.e. /tset/LSB.os/netowkr/recvfrom/T.recvfrom).
>>
>> Origionally-authored-by: Karel Srot <ksrot@redhat.com>
>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> Acked-by: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  net/unix/af_unix.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -1414,8 +1414,8 @@ static void maybe_add_creds(struct sk_bu
>>  	if (UNIXCB(skb).cred)
>>  		return;
>>  	if (test_bit(SOCK_PASSCRED, &sock->flags) ||
>> -	    !other->sk_socket ||
>> -	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags)) {
>> +	    (other->sk_socket &&
>> +	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags))) {
>>  		UNIXCB(skb).pid  = get_pid(task_tgid(current));
>>  		UNIXCB(skb).cred = get_current_cred();
>>  	}
