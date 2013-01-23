Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3AWQeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:34:07 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:48489 "EHLO
	smtp6.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab3AWQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:34:04 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 11:34:04 EST
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp6.sgsi.ucl.ac.be 78FEF1C6543
From: Christoph Paasch <christoph.paasch@uclouvain.be>
To: Andrey Vagin <avagin@openvz.org>
Reply-To: christoph.paasch@uclouvain.be
Cc: netdev@vger.kernel.org, criu@openvz.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/2] tcp: make tcp_timestamp dependent on tcp_sock
Date: Wed, 23 Jan 2013 17:27:33 +0100
Message-ID: <3646608.EKqeVjQrS7@cpaasch-mac>
Organization: UCLouvain
User-Agent: KMail/4.9.4 (Linux/3.5.0-22-mptcp; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1358953314-12979-2-git-send-email-avagin@openvz.org>
References: <1358953314-12979-1-git-send-email-avagin@openvz.org> <1358953314-12979-2-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 78FEF1C6543.A4B27
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 19:01:53 Andrey Vagin wrote:
> This will be used for setting timestamp offset.
> 
> This patch converts the macros tcp_timestamp to a function with one
> argument "struct tcp_sock *tp" and nothing else.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  include/net/tcp.h       | 15 +++++++++-----
>  net/ipv4/syncookies.c   |  4 ++--
>  net/ipv4/tcp.c          |  2 +-
>  net/ipv4/tcp_bic.c      | 10 +++++-----
>  net/ipv4/tcp_cubic.c    | 14 ++++++-------
>  net/ipv4/tcp_htcp.c     |  2 +-
>  net/ipv4/tcp_input.c    | 53
> ++++++++++++++++++++++++++----------------------- net/ipv4/tcp_ipv4.c     |
> 19 ++++++++++--------
>  net/ipv4/tcp_lp.c       |  8 ++++----
>  net/ipv4/tcp_metrics.c  |  2 +-
>  net/ipv4/tcp_output.c   | 35 +++++++++++++++++---------------
>  net/ipv4/tcp_timer.c    |  9 +++++----
>  net/ipv4/tcp_westwood.c |  8 +++++---
>  net/ipv6/tcp_ipv6.c     | 22 +++++++++++---------
>  14 files changed, 112 insertions(+), 91 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index aed42c7..3e242ba 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -503,7 +503,7 @@ static inline __u32 cookie_v4_init_sequence(struct sock
> *sk, }
>  #endif
>  
> -extern __u32 cookie_init_timestamp(struct request_sock *req);
> +extern __u32 cookie_init_timestamp(struct tcp_sock *tp, struct request_sock
> *req); extern bool cookie_check_timestamp(struct tcp_options_received *opt,
> bool *); 
>  /* From net/ipv6/syncookies.c */
> @@ -675,7 +675,10 @@ void tcp_send_window_probe(struct sock *sk);
>   * to use only the low 32-bits of jiffies and hide the ugly
>   * casts with the following macro.
>   */
> -#define tcp_time_stamp         ((__u32)(jiffies))
> +static inline u32 tcp_time_stamp(const struct tcp_sock *tp)
> +{
> +       return (__u32)jiffies;
> +}

DCCP also accesses tcp_time_stamp. So, it won't compile with DCCP enabled.


Christoph


-- 
IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://mptcp.info.ucl.ac.be
UCLouvain
--
