Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3DDCNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:13:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34987 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3DDCNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:13:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "David S. Miller" <davem@davemloft.net>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>,
        <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	<1365034777.13853.46.camel@edumazet-glaptop>
	<1365035424.13853.48.camel@edumazet-glaptop>
	<878v4zjei0.fsf@xmission.com>
Date: Wed, 03 Apr 2013 19:13:35 -0700
In-Reply-To: <878v4zjei0.fsf@xmission.com> (Eric W. Biederman's message of
	"Wed, 03 Apr 2013 18:01:11 -0700")
Message-ID: <87li8zhwkw.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19W/mmSzN+Mow8DvmfdAIN0GyObmoP1Bbw=
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
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"David S. Miller" <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH 1/2] Revert "af_unix: dont send SCM_CREDENTIAL when dest socket is NULL"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit 14134f6584212d585b310ce95428014b653dfaf6.

The problem that the above patch was meant to address is that af_unix
messages are not being coallesced because we are sending unnecesarry
credentials.  Not sending credentials in maybe_add_creds totally
breaks unconnected unix domain sockets that wish to send credentails
to other sockets.

In practice this break some versions of udev because they receive a
message and the sending uid is bogus so they drop the message.

Cc: stable@vger.kernel.org
Reported-by: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/unix/af_unix.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 971282b..f153a8d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1412,8 +1412,8 @@ static void maybe_add_creds(struct sk_buff *skb, const struct socket *sock,
 	if (UNIXCB(skb).cred)
 		return;
 	if (test_bit(SOCK_PASSCRED, &sock->flags) ||
-	    (other->sk_socket &&
-	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags))) {
+	    !other->sk_socket ||
+	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags)) {
 		UNIXCB(skb).pid  = get_pid(task_tgid(current));
 		UNIXCB(skb).cred = get_current_cred();
 	}
-- 
1.7.5.4

