Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaHLLDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:03:44 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35308 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHLLDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <1407841148-9198-1-git-send-email-ionut.m.alexa@gmail.com>
References: <1407841148-9198-1-git-send-email-ionut.m.alexa@gmail.com>
Date: Tue, 12 Aug 2014 13:03:42 +0200
Message-ID: <CAFLxGvxVA-KshD6E7=Dg4hRc8sUZqDCoLLk4a8=Fwj0PTLXtdw@mail.gmail.com>
Subject: Re: [PATCH] kernel:audit Fixed some coding style errors and warnings.
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:59 PM, Ionut Alexa <ionut.m.alexa@gmail.com> wrote:
> Fixed coding style errors and warning. Changed 'printk_ratelimit' to
> pr_<level>_ratelimited. Changed 'simple_strtol' to 'kstrtol'.

Please one logical change per patch.

Also note that pure whitespaces cleanups are note very helpful.
In fact they pollute the kernel history.
There is one exception. Files in drivers/staging/.

> Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
> ---
>  kernel/audit.c |   63 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 38 insertions(+), 25 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index ba2ff5a..69ec6bd 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -55,6 +55,7 @@
>  #include <linux/syscalls.h>
>
>  #include <linux/audit.h>
> +#include <linux/ratelimit.h>
>
>  #include <net/sock.h>
>  #include <net/netlink.h>
> @@ -80,10 +81,10 @@ static int  audit_initialized;
>  #define AUDIT_ON       1
>  #define AUDIT_LOCKED   2
>  u32            audit_enabled;
> -u32            audit_ever_enabled;
> -
>  EXPORT_SYMBOL_GPL(audit_enabled);
>
> +u32            audit_ever_enabled;
> +
>  /* Default state when kernel boots without any parameters. */
>  static u32     audit_default;
>
> @@ -108,7 +109,7 @@ static u32  audit_rate_limit;
>  static u32     audit_backlog_limit = 64;
>  #define AUDIT_BACKLOG_WAIT_TIME (60 * HZ)
>  static u32     audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
> -static u32     audit_backlog_wait_overflow = 0;
> +static u32     audit_backlog_wait_overflow;
>
>  /* The identity of the user shutting down the audit system. */
>  kuid_t         audit_sig_uid = INVALID_UID;
> @@ -190,6 +191,7 @@ static void audit_set_portid(struct audit_buffer *ab, __u32 portid)
>  {
>         if (ab) {
>                 struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
> +
>                 nlh->nlmsg_pid = portid;
>         }
>  }
> @@ -200,8 +202,7 @@ void audit_panic(const char *message)
>         case AUDIT_FAIL_SILENT:
>                 break;
>         case AUDIT_FAIL_PRINTK:
> -               if (printk_ratelimit())
> -                       pr_err("%s\n", message);
> +               pr_err_ratelimited("%s\n", message);
>                 break;
>         case AUDIT_FAIL_PANIC:
>                 /* test audit_pid since printk is always losey, why bother? */
> @@ -213,15 +214,16 @@ void audit_panic(const char *message)
>
>  static inline int audit_rate_check(void)
>  {
> -       static unsigned long    last_check = 0;
> -       static int              messages   = 0;
> +       static unsigned long    last_check;
> +       static int              messages;
>         static DEFINE_SPINLOCK(lock);
>         unsigned long           flags;
>         unsigned long           now;
>         unsigned long           elapsed;
>         int                     retval     = 0;
>
> -       if (!audit_rate_limit) return 1;
> +       if (!audit_rate_limit)
> +               return 1;
>
>         spin_lock_irqsave(&lock, flags);
>         if (++messages < audit_rate_limit) {
> @@ -250,7 +252,7 @@ static inline int audit_rate_check(void)
>  */
>  void audit_log_lost(const char *message)
>  {
> -       static unsigned long    last_msg = 0;
> +       static unsigned long    last_msg;
>         static DEFINE_SPINLOCK(lock);
>         unsigned long           flags;
>         unsigned long           now;
> @@ -271,8 +273,7 @@ void audit_log_lost(const char *message)
>         }
>
>         if (print) {
> -               if (printk_ratelimit())
> -                       pr_warn("audit_lost=%u audit_rate_limit=%u audit_backlog_limit=%u\n",
> +               pr_warn_ratelimited("audit_lost=%u audit_rate_limit=%u audit_backlog_limit=%u\n",
>                                 atomic_read(&audit_lost),
>                                 audit_rate_limit,
>                                 audit_backlog_limit);
> @@ -344,6 +345,7 @@ static int audit_set_backlog_wait_time(u32 timeout)
>  static int audit_set_enabled(u32 state)
>  {
>         int rc;
> +
>         if (state < AUDIT_OFF || state > AUDIT_LOCKED)
>                 return -EINVAL;
>
> @@ -393,8 +395,9 @@ static void audit_printk_skb(struct sk_buff *skb)
>         char *data = nlmsg_data(nlh);
>
>         if (nlh->nlmsg_type != AUDIT_EOE) {
> -               if (printk_ratelimit())
> -                       pr_notice("type=%d %s\n", nlh->nlmsg_type, data);
> +               if (__printk_ratelimit(__func__))
> +                       pr_notice_ratelimited("type=%d %s\n", nlh->nlmsg_type,
> +                                               data);
>                 else
>                         audit_log_lost("printk limit exceeded");
>         }
> @@ -672,7 +675,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>         case AUDIT_MAKE_EQUIV:
>                 /* Only support auditd and auditctl in initial pid namespace
>                  * for now. */
> -               if ((task_active_pid_ns(current) != &init_pid_ns))
> +               if (task_active_pid_ns(current) != &init_pid_ns)
>                         return -EPERM;
>
>                 if (!netlink_capable(skb, CAP_AUDIT_CONTROL))
> @@ -834,6 +837,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>         switch (msg_type) {
>         case AUDIT_GET: {
>                 struct audit_status     s;
> +
>                 memset(&s, 0, sizeof(s));
>                 s.enabled               = audit_enabled;
>                 s.failure               = audit_failure;
> @@ -849,6 +853,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>         }
>         case AUDIT_SET: {
>                 struct audit_status     s;
> +
>                 memset(&s, 0, sizeof(s));
>                 /* guard against past and future API changes */
>                 memcpy(&s, data, min_t(size_t, sizeof(s), nlmsg_len(nlh)));
> @@ -1141,6 +1146,7 @@ static void __net_exit audit_net_exit(struct net *net)
>  {
>         struct audit_net *aunet = net_generic(net, audit_net_id);
>         struct sock *sock = aunet->nlsk;
> +
>         if (sock == audit_sock) {
>                 audit_pid = 0;
>                 audit_sock = NULL;
> @@ -1183,12 +1189,15 @@ static int __init audit_init(void)
>
>         return 0;
>  }
> -__initcall(audit_init);
> +device_initcall(audit_init);
>
>  /* Process kernel command-line parameter at boot time.  audit=0 or audit=1. */
>  static int __init audit_enable(char *str)
>  {
> -       audit_default = !!simple_strtol(str, NULL, 0);
> +       int rc = kstrtol(str, 0, (long *)&audit_default);
> +
> +       if (rc)
> +               return rc;
>         if (!audit_default)
>                 audit_initialized = AUDIT_DISABLED;
>
> @@ -1239,7 +1248,7 @@ static void audit_buffer_free(struct audit_buffer *ab)
>         spin_unlock_irqrestore(&audit_freelist_lock, flags);
>  }
>
> -static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
> +static struct audit_buffer *audit_buffer_alloc(struct audit_context *ctx,
>                                                 gfp_t gfp_mask, int type)
>  {
>         unsigned long flags;
> @@ -1302,7 +1311,7 @@ err:
>  unsigned int audit_serial(void)
>  {
>         static DEFINE_SPINLOCK(serial_lock);
> -       static unsigned int serial = 0;
> +       static unsigned int serial;
>
>         unsigned long flags;
>         unsigned int ret;
> @@ -1331,6 +1340,7 @@ static inline void audit_get_stamp(struct audit_context *ctx,
>  static long wait_for_auditd(long sleep_time)
>  {
>         DECLARE_WAITQUEUE(wait, current);
> +
>         set_current_state(TASK_UNINTERRUPTIBLE);
>         add_wait_queue_exclusive(&audit_backlog_wait, &wait);
>
> @@ -1394,8 +1404,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>                                         continue;
>                         }
>                 }
> -               if (audit_rate_check() && printk_ratelimit())
> -                       pr_warn("audit_backlog=%d > audit_backlog_limit=%d\n",
> +               if (audit_rate_check())
> +                       pr_warn_ratelimited("audit_backlog=%d > audit_backlog_limit=%d\n",
>                                 skb_queue_len(&audit_skb_queue),
>                                 audit_backlog_limit);
>                 audit_log_lost("backlog limit exceeded");
> @@ -1418,6 +1428,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>                          t.tv_sec, t.tv_nsec/1000000, serial);
>         return ab;
>  }
> +EXPORT_SYMBOL(audit_log_start);
>
>  /**
>   * audit_expand - expand skb in the audit buffer
> @@ -1505,6 +1516,7 @@ void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
>         audit_log_vformat(ab, fmt, args);
>         va_end(args);
>  }
> +EXPORT_SYMBOL(audit_log_format);
>
>  /**
>   * audit_log_hex - convert a buffer to hex and append it to the audit skb
> @@ -1586,6 +1598,7 @@ void audit_log_n_string(struct audit_buffer *ab, const char *string,
>  int audit_string_contains_control(const char *string, size_t len)
>  {
>         const unsigned char *p;
> +
>         for (p = string; p < (const unsigned char *)string + len; p++) {
>                 if (*p == '"' || *p < 0x21 || *p > 0x7e)
>                         return 1;
> @@ -1749,6 +1762,7 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
>                     struct path *path, int record_num, int *call_panic)
>  {
>         struct audit_buffer *ab;
> +
>         ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
>         if (!ab)
>                 return;
> @@ -1794,6 +1808,7 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
>         if (n->osid != 0) {
>                 char *ctx = NULL;
>                 u32 len;
> +
>                 if (security_secid_to_secctx(
>                         n->osid, &ctx, &len)) {
>                         audit_log_format(ab, " osid=%u", n->osid);
> @@ -1807,7 +1822,7 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
>
>         /* log the audit_names record type */
>         audit_log_format(ab, " nametype=");
> -       switch(n->type) {
> +       switch (n->type) {
>         case AUDIT_TYPE_NORMAL:
>                 audit_log_format(ab, "NORMAL");
>                 break;
> @@ -1982,6 +1997,7 @@ void audit_log_end(struct audit_buffer *ab)
>         }
>         audit_buffer_free(ab);
>  }
> +EXPORT_SYMBOL(audit_log_end);
>
>  /**
>   * audit_log - Log an audit record
> @@ -2009,6 +2025,7 @@ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
>                 audit_log_end(ab);
>         }
>  }
> +EXPORT_SYMBOL(audit_log);
>
>  #ifdef CONFIG_SECURITY
>  /**
> @@ -2036,7 +2053,3 @@ void audit_log_secctx(struct audit_buffer *ab, u32 secid)
>  EXPORT_SYMBOL(audit_log_secctx);
>  #endif
>
> -EXPORT_SYMBOL(audit_log_start);
> -EXPORT_SYMBOL(audit_log_end);
> -EXPORT_SYMBOL(audit_log_format);
> -EXPORT_SYMBOL(audit_log);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
