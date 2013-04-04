Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3DDCYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:24:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37275 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab3DDCYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:24:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Karel Srot <ksrot@redhat.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	<1365034777.13853.46.camel@edumazet-glaptop>
	<87li8zjf48.fsf@xmission.com>
	<CALCETrXo0zFMLpH6JkEdyO2pJW9E-07WBxDDh2mWewNy3xJLVg@mail.gmail.com>
Date: Wed, 03 Apr 2013 19:24:34 -0700
In-Reply-To: <CALCETrXo0zFMLpH6JkEdyO2pJW9E-07WBxDDh2mWewNy3xJLVg@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 3 Apr 2013 17:53:02 -0700")
Message-ID: <878v4zghi5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Ceihch1Dnva2+HST6jwSpBmXOEDXYF2E=
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

> On Wed, Apr 3, 2013 at 5:47 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> No.  The patch is still bogus.
>>
>> If the problem is that we are not coallescing messages in stream_recvmsg
>> we need a different fix.
>>
>> Probably something like:
>>
>>                   if (check_creds) {
>>                           /* Never glue messages from different writers */
>>                           if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
>>                               (UNIXCB(skb).cred != siocb->scm->cred))
>>                                   break;
>> -                 } else {
>> +                 } else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
>>                           /* Copy credentials */
>>                           scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
>>                           check_creds = 1;
>>                   }
>
> I'm confused.  Isn't this making the problem worse, not better?

For udev that is a don't care.

For the case where we are coallescing messages this ensures we always
collaesce messages if we don't care about the credentials.  Which turns
out to be a fix for a long standing pessimization, that no on has
bother to complain about.

> With my patches, the cost should go way down and it could be made
> unconditional, but that's still probably not a good -stable change.

Reducing the cost and the complexity as far as we can is good, but we
really want small steps as we optimize the case of sending credentials.

Eric

