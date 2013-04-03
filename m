Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106Ab3DCSoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:44:03 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45595 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760626Ab3DCSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:44:00 -0400
Message-ID: <1365014637.13853.36.camel@edumazet-glaptop>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Apr 2013 11:43:57 -0700
In-Reply-To: <515C6DCD.50902@mit.edu>
References: <20130402221104.163133110@linuxfoundation.org>
	  <20130402221116.307254752@linuxfoundation.org>
	  <87vc833kpf.fsf@turtle.gmx.de>
	 <1364997630.13853.19.camel@edumazet-glaptop>
	  <87a9pfzm33.fsf@turtle.gmx.de>
	 <1365003300.13853.25.camel@edumazet-glaptop> <515C6DCD.50902@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 10:58 -0700, Andy Lutomirski wrote:

> 
> This sounds suspiciously like an SCM_CREDENTIALS bug triggered by a
> race.  There's a fix (that needs both a new version from me and a review
> by someone) here:
> 
> http://www.spinics.net/lists/netdev/msg229948.html

Hmm... this is not a stable candidate, IMHO.

This has to be fixed (if needed) in a more easy way. 

What about this one liner ?

CC Eric W. Biederman  as he wrote commit
dbe9a4173ea53b72b2c3
(scm: Don't use struct ucred in NETLINK_CB and struct scm_cookie.)

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


