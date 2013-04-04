Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3DDATl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:19:41 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:49003 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DDATj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:19:39 -0400
Message-ID: <1365034777.13853.46.camel@edumazet-glaptop>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>
Date: Wed, 03 Apr 2013 17:19:37 -0700
In-Reply-To: <87k3ojnosa.fsf@xmission.com>
References: <20130402221104.163133110@linuxfoundation.org>
	 <20130402221116.307254752@linuxfoundation.org>
	 <87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 17:05 -0700, Eric W. Biederman wrote:
> Sven Joachim <svenjoac@gmx.de> writes:
> 
> > On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> >
> >> 3.8-stable review patch.  If anyone has any objections, please let me know.
> >
> > I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> > 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> > patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> > here, and 65534 is the uid of user "nobody".
> 
> Hmm.
> 
> Ok.  I don't understand the commit that was being backported here.  I am
> pretty certain it a fix for a problem that did not exist.
> 
> Unless I am completely mis-reading scm_recv we only generate a
> SCM_CREDENTIALS message if the receiving socket asserts SOCK_PASSCRED.
> Which means that the only harm that can come from adding scm credentials
> to a disconnected af_unix socket is a loss in efficiency.
> 
> Not adding scm credentials to be passed to userspace as the commit below
> is doing can result is bogus data being passed to userspace.  Which is
> very actively WRONG.
> 
> Now before scm_recv does anything we first call scm_set_cred.  If no
> credential was passed to scm_set_cred we set the uid to INVALID_UID.
> Which scm_recv in the call from_kuid_munged translates into 65534 for
> reporting to userspace.
> 
> So this is is pretty clearly a case of us not sending the unix
> credentials.
> 
> Since not sending credential is just a performance optimization I can
> see no earthly reason why the commit below should have been applied in
> the first place, and no reason why it should have been backported in the
> second place.  So my vote is that we revert this bogus commit.  Upstream
> and then backport the revert.
> 
> Am I missing something?

Well, yes, this commit fixes a real bug : We were coalescing two
messages into a single one, even if the senders were different.

Copy of a reply I did :

So the problem is that two messages have different credentials,
because other->sk_socket changed between first and second message.

and unix_stream_recvmsg() has the following check :

                if (check_creds) {
                        /* Never glue messages from different writers */
                        if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
                            (UNIXCB(skb).cred != siocb->scm->cred))
                                break;
                } else {
                        /* Copy credentials */
                        scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
                        check_creds = 1;
                }

So the patch was good, and we need a followup, like the one I posted today ?

Some user apps dont know about uid 65534.

diff --git a/include/net/scm.h b/include/net/scm.h
index 975cca0..42359d8 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -120,7 +120,7 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 		return;
 	}
 
-	if (test_bit(SOCK_PASSCRED, &sock->flags)) {
+	if (test_bit(SOCK_PASSCRED, &sock->flags) && scm->creds.pid) {
 		struct user_namespace *current_ns = current_user_ns();
 		struct ucred ucreds = {
 			.pid = scm->creds.pid,




