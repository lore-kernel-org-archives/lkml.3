Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3DDKhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:37:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35282 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3DDKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:37:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: dingtianhong <dingtianhong@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>, Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>,
        <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	<1365034777.13853.46.camel@edumazet-glaptop>
	<1365035424.13853.48.camel@edumazet-glaptop>
	<878v4zjei0.fsf@xmission.com> <87li8zhwkw.fsf_-_@xmission.com>
	<87d2ubhwiw.fsf_-_@xmission.com> <515D3235.7080608@huawei.com>
Date: Thu, 04 Apr 2013 03:36:56 -0700
In-Reply-To: <515D3235.7080608@huawei.com> (dingtianhong@huawei.com's message
	of "Thu, 4 Apr 2013 15:56:37 +0800")
Message-ID: <874nfmeg53.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Aeug/ZBkIHbHhNGnzLww3hUJl/QUXkOM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.7 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;dingtianhong <dingtianhong@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] af_unix: If we don't care about credentials coallesce all messages
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dingtianhong <dingtianhong@huawei.com> writes:

> On 2013/4/4 10:14, Eric W. Biederman wrote:
>> 
>> It was reported that the following LSB test case failed
>> https://lsbbugs.linuxfoundation.org/attachment.cgi?id=2144 because we
>> were not coallescing unix stream messages when the application was
>> expecting us to.
>> 
>> The problem was that the first send was before the socket was accepted
>> and thus sock->sk_socket was NULL in maybe_add_creds, and the second
>> send after the socket was accepted had a non-NULL value for sk->socket
>> and thus we could tell the credentials were not needed so we did not
>> bother.
>> 
>> The unnecessary credentials on the first message cause
>> unix_stream_recvmsg to start verifying that all messages had the same
>> credentials before coallescing and then the coallescing failed because
>> the second message had no credentials.
>> 
>> Ignoring credentials when we don't care in unix_stream_recvmsg fixes a
>> long standing pessimization which would fail to coallesce messages when
>> reading from a unix stream socket if the senders were different even if
>> we did not care about their credentials.
>> 
>> I have tested this and verified that the in the LSB test case mentioned
>> above that the messages do coallesce now, while the were failing to
>> coallesce without this change.
>> 
>> Reported-by: Karel Srot <ksrot@redhat.com>
>> Reported-by: Ding Tianhong <dingtianhong@huawei.com>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  net/unix/af_unix.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index f153a8d..2db702d 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -1993,7 +1993,7 @@ again:
>>  			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
>>  			    (UNIXCB(skb).cred != siocb->scm->cred))
>>  				break;
>> -		} else {
>> +		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
>>  			/* Copy credentials */
>>  			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
>>  			check_creds = 1;
>> 
>
> As your opinion, I think the way is better:
>
> 		if (test_bit(SOCK_PASSCRED, &sock->flags)) {
>                         if (check_creds) {
>                                 /* Never glue messages from different writers */
>                                 if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
>                                 (UNIXCB(skb).cred != siocb->scm->cred))
>                                         break;
>                         } else {
>                                 /* Copy credentials */
>                                 scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
>                                 check_creds = 1;
>                         }
>                 }

It is a smidge clearer in intent, but there is no functional
difference.  The lines get really long.

Shrug.

Patches are always welcome.

Beyond getting something correct for the right reasons I don't care.

Eric

