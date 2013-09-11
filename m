Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3IKUSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:18:09 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45784 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab3IKUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <1378929961.4714.21.camel@joe-AO722>
References: <20130911193040.GA16688@www.outflux.net>
	<1378929961.4714.21.camel@joe-AO722>
Date: Wed, 11 Sep 2013 13:18:05 -0700
X-Google-Sender-Auth: DfHQbpO816dM3m26WjY7utWe5-g
Message-ID: <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Jiri Kosina <jkosina@suse.cz>,
        Jan Beulich <jbeulich@suse.com>, Eldad Zack <eldad@fogrefinery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2013-09-11 at 12:30 -0700, Kees Cook wrote:
>> The %n format is not ignored, so remove the incorrect comment about it.
>
> I think it may be better to reimplement the ignoring.

Yeah, just had a quick look, and scanf doesn't use this code at all.
I'd much rather remove %n again instead.

> Maybe:
> ---
>  lib/vsprintf.c      | 18 +++++-------
>  net/ipv4/fib_trie.c | 30 +++++++++----------
>  net/ipv4/ping.c     | 19 ++++++------
>  net/ipv4/tcp_ipv4.c | 84 ++++++++++++++++++++++++++---------------------------
>  net/ipv4/udp.c      | 19 ++++++------
>  net/phonet/socket.c | 32 ++++++++++----------
>  net/sctp/objcnt.c   |  5 ++--
>  7 files changed, 99 insertions(+), 108 deletions(-)

This needs fs/proc/consoles.c, nommu.c, task_mmu.c, and task_nommu.c
added too, if I can believe my "git grep".

>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 26559bd..23f1eb1 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1683,18 +1683,16 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>                         break;
>
>                 case FORMAT_TYPE_NRCHARS: {
> +                       /* skip %n 's argument */
>                         u8 qualifier = spec.qualifier;
> +                       void *skip_arg;
>
> -                       if (qualifier == 'l') {
> -                               long *ip = va_arg(args, long *);
> -                               *ip = (str - buf);
> -                       } else if (_tolower(qualifier) == 'z') {
> -                               size_t *ip = va_arg(args, size_t *);
> -                               *ip = (str - buf);
> -                       } else {
> -                               int *ip = va_arg(args, int *);
> -                               *ip = (str - buf);
> -                       }
> +                       if (qualifier == 'l')
> +                               skip_arg = va_arg(args, long *);
> +                       else if (_tolower(qualifier) == 'z')
> +                               skip_arg = va_arg(args, size_t *);
> +                       else
> +                               skip_arg = va_arg(args, int *);

I think Dan's idea of a WARN_ON_ONCE() here is a good idea to help
anyone accidentally trying to use it.

-Kees

>                         break;
>                 }
>
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 3df6d3e..ddf1e9c 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -2537,24 +2537,20 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
>                                 continue;
>
>                         if (fi)
> -                               seq_printf(seq,
> -                                        "%s\t%08X\t%08X\t%04X\t%d\t%u\t"
> -                                        "%d\t%08X\t%d\t%u\t%u%n",
> -                                        fi->fib_dev ? fi->fib_dev->name : "*",
> -                                        prefix,
> -                                        fi->fib_nh->nh_gw, flags, 0, 0,
> -                                        fi->fib_priority,
> -                                        mask,
> -                                        (fi->fib_advmss ?
> -                                         fi->fib_advmss + 40 : 0),
> -                                        fi->fib_window,
> -                                        fi->fib_rtt >> 3, &len);
> +                               len = seq_printf(seq, "%s\t%08X\t%08X\t%04X\t%d\t%u\t%d\t%08X\t%d\t%u\t%u",
> +                                                (fi->fib_dev ?
> +                                                 fi->fib_dev->name : "*"),
> +                                                prefix,
> +                                                fi->fib_nh->nh_gw, flags,
> +                                                0, 0, fi->fib_priority, mask,
> +                                                (fi->fib_advmss ?
> +                                                 fi->fib_advmss + 40 : 0),
> +                                                fi->fib_window,
> +                                                fi->fib_rtt >> 3);
>                         else
> -                               seq_printf(seq,
> -                                        "*\t%08X\t%08X\t%04X\t%d\t%u\t"
> -                                        "%d\t%08X\t%d\t%u\t%u%n",
> -                                        prefix, 0, flags, 0, 0, 0,
> -                                        mask, 0, 0, 0, &len);
> +                               len = seq_printf(seq, "*\t%08X\t%08X\t%04X\t%d\t%u\t%d\t%08X\t%d\t%u\t%u",
> +                                                prefix, 0, flags, 0, 0, 0,
> +                                                mask, 0, 0, 0);
>
>                         seq_printf(seq, "%*s\n", 127 - len, "");
>                 }
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index d7d9882..ac8d79f 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -1081,16 +1081,15 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
>         __u16 destp = ntohs(inet->inet_dport);
>         __u16 srcp = ntohs(inet->inet_sport);
>
> -       seq_printf(f, "%5d: %08X:%04X %08X:%04X"
> -               " %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d%n",
> -               bucket, src, srcp, dest, destp, sp->sk_state,
> -               sk_wmem_alloc_get(sp),
> -               sk_rmem_alloc_get(sp),
> -               0, 0L, 0,
> -               from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
> -               0, sock_i_ino(sp),
> -               atomic_read(&sp->sk_refcnt), sp,
> -               atomic_read(&sp->sk_drops), len);
> +       *len = seq_printf(f, "%5d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
> +                         bucket, src, srcp, dest, destp, sp->sk_state,
> +                         sk_wmem_alloc_get(sp),
> +                         sk_rmem_alloc_get(sp),
> +                         0, 0L, 0,
> +                         from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
> +                         0, sock_i_ino(sp),
> +                         atomic_read(&sp->sk_refcnt), sp,
> +                         atomic_read(&sp->sk_drops));
>  }
>
>  static int ping_v4_seq_show(struct seq_file *seq, void *v)
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b14266b..1279c16 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2603,24 +2603,24 @@ static void get_openreq4(const struct sock *sk, const struct request_sock *req,
>         const struct inet_request_sock *ireq = inet_rsk(req);
>         long delta = req->expires - jiffies;
>
> -       seq_printf(f, "%4d: %08X:%04X %08X:%04X"
> -               " %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK%n",
> -               i,
> -               ireq->loc_addr,
> -               ntohs(inet_sk(sk)->inet_sport),
> -               ireq->rmt_addr,
> -               ntohs(ireq->rmt_port),
> -               TCP_SYN_RECV,
> -               0, 0, /* could print option size, but that is af dependent. */
> -               1,    /* timers active (only the expire timer) */
> -               jiffies_delta_to_clock_t(delta),
> -               req->num_timeout,
> -               from_kuid_munged(seq_user_ns(f), uid),
> -               0,  /* non standard timer */
> -               0, /* open_requests have no inode */
> -               atomic_read(&sk->sk_refcnt),
> -               req,
> -               len);
> +       *len = seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK",
> +                         i,
> +                         ireq->loc_addr,
> +                         ntohs(inet_sk(sk)->inet_sport),
> +                         ireq->rmt_addr,
> +                         ntohs(ireq->rmt_port),
> +                         TCP_SYN_RECV,
> +                         0, 0, /* could print option size,
> +                                * but that is af dependent.
> +                                */
> +                         1,    /* timers active (only the expire timer) */
> +                         jiffies_delta_to_clock_t(delta),
> +                         req->num_timeout,
> +                         from_kuid_munged(seq_user_ns(f), uid),
> +                         0,    /* non standard timer */
> +                         0,    /* open_requests have no inode */
> +                         atomic_read(&sk->sk_refcnt),
> +                         req);
>  }
>
>  static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
> @@ -2661,26 +2661,25 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
>                  */
>                 rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
>
> -       seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
> -                       "%08X %5u %8d %lu %d %pK %lu %lu %u %u %d%n",
> -               i, src, srcp, dest, destp, sk->sk_state,
> -               tp->write_seq - tp->snd_una,
> -               rx_queue,
> -               timer_active,
> -               jiffies_delta_to_clock_t(timer_expires - jiffies),
> -               icsk->icsk_retransmits,
> -               from_kuid_munged(seq_user_ns(f), sock_i_uid(sk)),
> -               icsk->icsk_probes_out,
> -               sock_i_ino(sk),
> -               atomic_read(&sk->sk_refcnt), sk,
> -               jiffies_to_clock_t(icsk->icsk_rto),
> -               jiffies_to_clock_t(icsk->icsk_ack.ato),
> -               (icsk->icsk_ack.quick << 1) | icsk->icsk_ack.pingpong,
> -               tp->snd_cwnd,
> -               sk->sk_state == TCP_LISTEN ?
> -                   (fastopenq ? fastopenq->max_qlen : 0) :
> -                   (tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh),
> -               len);
> +       *len = seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
> +                         i, src, srcp, dest, destp, sk->sk_state,
> +                         tp->write_seq - tp->snd_una,
> +                         rx_queue,
> +                         timer_active,
> +                         jiffies_delta_to_clock_t(timer_expires - jiffies),
> +                         icsk->icsk_retransmits,
> +                         from_kuid_munged(seq_user_ns(f), sock_i_uid(sk)),
> +                         icsk->icsk_probes_out,
> +                         sock_i_ino(sk),
> +                         atomic_read(&sk->sk_refcnt), sk,
> +                         jiffies_to_clock_t(icsk->icsk_rto),
> +                         jiffies_to_clock_t(icsk->icsk_ack.ato),
> +                         (icsk->icsk_ack.quick << 1) | icsk->icsk_ack.pingpong,
> +                         tp->snd_cwnd,
> +                         sk->sk_state == TCP_LISTEN ?
> +                         (fastopenq ? fastopenq->max_qlen : 0) :
> +                         (tcp_in_initial_slowstart(tp) ? -1 :
> +                          tp->snd_ssthresh));
>  }
>
>  static void get_timewait4_sock(const struct inet_timewait_sock *tw,
> @@ -2695,11 +2694,10 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
>         destp = ntohs(tw->tw_dport);
>         srcp  = ntohs(tw->tw_sport);
>
> -       seq_printf(f, "%4d: %08X:%04X %08X:%04X"
> -               " %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK%n",
> -               i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
> -               3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
> -               atomic_read(&tw->tw_refcnt), tw, len);
> +       *len = seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK",
> +                         i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
> +                         3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
> +                         atomic_read(&tw->tw_refcnt), tw);
>  }
>
>  #define TMPSZ 150
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 74d2c95..ddc24a2d 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2158,16 +2158,15 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
>         __u16 destp       = ntohs(inet->inet_dport);
>         __u16 srcp        = ntohs(inet->inet_sport);
>
> -       seq_printf(f, "%5d: %08X:%04X %08X:%04X"
> -               " %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d%n",
> -               bucket, src, srcp, dest, destp, sp->sk_state,
> -               sk_wmem_alloc_get(sp),
> -               sk_rmem_alloc_get(sp),
> -               0, 0L, 0,
> -               from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
> -               0, sock_i_ino(sp),
> -               atomic_read(&sp->sk_refcnt), sp,
> -               atomic_read(&sp->sk_drops), len);
> +       *len = seq_printf(f, "%5d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
> +                         bucket, src, srcp, dest, destp, sp->sk_state,
> +                         sk_wmem_alloc_get(sp),
> +                         sk_rmem_alloc_get(sp),
> +                         0, 0L, 0,
> +                         from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
> +                         0, sock_i_ino(sp),
> +                         atomic_read(&sp->sk_refcnt), sp,
> +                         atomic_read(&sp->sk_drops));
>  }
>
>  int udp4_seq_show(struct seq_file *seq, void *v)
> diff --git a/net/phonet/socket.c b/net/phonet/socket.c
> index 77e38f7..553f896 100644
> --- a/net/phonet/socket.c
> +++ b/net/phonet/socket.c
> @@ -598,21 +598,20 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
>         int len;
>
>         if (v == SEQ_START_TOKEN)
> -               seq_printf(seq, "%s%n", "pt  loc  rem rs st tx_queue rx_queue "
> -                       "  uid inode ref pointer drops", &len);
> +               len = seq_puts(seq, "pt  loc  rem rs st tx_queue rx_queue   uid inode ref pointer drops");
>         else {
>                 struct sock *sk = v;
>                 struct pn_sock *pn = pn_sk(sk);
>
> -               seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %lu "
> -                       "%d %pK %d%n",
> -                       sk->sk_protocol, pn->sobject, pn->dobject,
> -                       pn->resource, sk->sk_state,
> -                       sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
> -                       from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> -                       sock_i_ino(sk),
> -                       atomic_read(&sk->sk_refcnt), sk,
> -                       atomic_read(&sk->sk_drops), &len);
> +               len = seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %lu %d %pK %d",
> +                                sk->sk_protocol, pn->sobject, pn->dobject,
> +                                pn->resource, sk->sk_state,
> +                                sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
> +                                from_kuid_munged(seq_user_ns(seq),
> +                                                 sock_i_uid(sk)),
> +                                sock_i_ino(sk),
> +                                atomic_read(&sk->sk_refcnt), sk,
> +                                atomic_read(&sk->sk_drops));
>         }
>         seq_printf(seq, "%*s\n", 127 - len, "");
>         return 0;
> @@ -788,15 +787,16 @@ static int pn_res_seq_show(struct seq_file *seq, void *v)
>         int len;
>
>         if (v == SEQ_START_TOKEN)
> -               seq_printf(seq, "%s%n", "rs   uid inode", &len);
> +               len = seq_puts(seq, "rs   uid inode");
>         else {
>                 struct sock **psk = v;
>                 struct sock *sk = *psk;
>
> -               seq_printf(seq, "%02X %5u %lu%n",
> -                          (int) (psk - pnres.sk),
> -                          from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> -                          sock_i_ino(sk), &len);
> +               len = seq_printf(seq, "%02X %5u %lu",
> +                                (int) (psk - pnres.sk),
> +                                from_kuid_munged(seq_user_ns(seq),
> +                                                 sock_i_uid(sk)),
> +                                sock_i_ino(sk));
>         }
>         seq_printf(seq, "%*s\n", 63 - len, "");
>         return 0;
> diff --git a/net/sctp/objcnt.c b/net/sctp/objcnt.c
> index 5ea573b..8034325 100644
> --- a/net/sctp/objcnt.c
> +++ b/net/sctp/objcnt.c
> @@ -82,8 +82,9 @@ static int sctp_objcnt_seq_show(struct seq_file *seq, void *v)
>         int i, len;
>
>         i = (int)*(loff_t *)v;
> -       seq_printf(seq, "%s: %d%n", sctp_dbg_objcnt[i].label,
> -                               atomic_read(sctp_dbg_objcnt[i].counter), &len);
> +       len = seq_printf(seq, "%s: %d",
> +                        sctp_dbg_objcnt[i].label,
> +                        atomic_read(sctp_dbg_objcnt[i].counter));
>         seq_printf(seq, "%*s\n", 127 - len, "");
>         return 0;
>  }
>
>



-- 
Kees Cook
Chrome OS Security
