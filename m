Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab3DCLll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:41:41 -0400
Received: from mout.gmx.net ([212.227.15.19]:65205 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab3DCLlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:41:39 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18LITwSxEwLxctQ02uccjeS6IHV8tA9wLesAZgSSk
	IdRI2Ws2p8jsUw
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
Date: Wed, 03 Apr 2013 13:41:32 +0200
In-Reply-To: <20130402221116.307254752@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Tue, 2 Apr 2013 15:11:27 -0700")
Message-ID: <87vc833kpf.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:

> 3.8-stable review patch.  If anyone has any objections, please let me know.

I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
here, and 65534 is the uid of user "nobody".

Cheers,
       Sven


> From: dingtianhong <dingtianhong@huawei.com>
>
> [ Upstream commit 14134f6584212d585b310ce95428014b653dfaf6 ]
>
> SCM_SCREDENTIALS should apply to write() syscalls only either source or destination
> socket asserted SOCK_PASSCRED. The original implememtation in maybe_add_creds is wrong,
> and breaks several LSB testcases ( i.e. /tset/LSB.os/netowkr/recvfrom/T.recvfrom).
>
> Origionally-authored-by: Karel Srot <ksrot@redhat.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/unix/af_unix.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1414,8 +1414,8 @@ static void maybe_add_creds(struct sk_bu
>  	if (UNIXCB(skb).cred)
>  		return;
>  	if (test_bit(SOCK_PASSCRED, &sock->flags) ||
> -	    !other->sk_socket ||
> -	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags)) {
> +	    (other->sk_socket &&
> +	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags))) {
>  		UNIXCB(skb).pid  = get_pid(task_tgid(current));
>  		UNIXCB(skb).cred = get_current_cred();
>  	}
