Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbaKTJh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:37:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbaKTJhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:37:55 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH v2] tools: hv: ignore ENOBUFS and ENOMEM in the KVP daemon
References: <1416462682-28236-1-git-send-email-decui@microsoft.com>
Date: Thu, 20 Nov 2014 10:37:40 +0100
In-Reply-To: <1416462682-28236-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Wed, 19 Nov 2014 21:51:22 -0800")
Message-ID: <87fvdedxgb.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> Under high memory pressure and very high KVP R/W test pressure, the netlink
> recvfrom() may transiently return ENOBUFS to the daemon -- we found this
> during a 2-week stress test.
>
> We'd better not terminate the daemon on the failure, because a typical KVP
> user will re-try the R/W and hopefully it will succeed next time.
>
> We can also ignore the errors on sending.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>
> v2: I also ignore the errors on sending, as Vitaly suggested.

Thanks,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>
>  tools/hv/hv_kvp_daemon.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 22b0764..6a6432a 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1559,8 +1559,15 @@ int main(int argc, char *argv[])
>  				addr_p, &addr_l);
>
>  		if (len < 0) {
> +			int saved_errno = errno;
>  			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
>  					addr.nl_pid, errno, strerror(errno));
> +
> +			if (saved_errno == ENOBUFS) {
> +				syslog(LOG_ERR, "receive error: ignored");
> +				continue;
> +			}
> +
>  			close(fd);
>  			return -1;
>  		}
> @@ -1763,8 +1770,15 @@ kvp_done:
>
>  		len = netlink_send(fd, incoming_cn_msg);
>  		if (len < 0) {
> +			int saved_errno = errno;
>  			syslog(LOG_ERR, "net_link send failed; error: %d %s", errno,
>  					strerror(errno));
> +
> +			if (saved_errno == ENOMEM || saved_errno == ENOBUFS) {
> +				syslog(LOG_ERR, "send error: ignored");
> +				continue;
> +			}
> +
>  			exit(EXIT_FAILURE);
>  		}
>  	}

-- 
  Vitaly
