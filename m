Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaKSKuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:50:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaKSKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:50:11 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, haiyangz@microsoft.com
Subject: Re: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
References: <1416394245-31717-1-git-send-email-decui@microsoft.com>
Date: Wed, 19 Nov 2014 11:49:56 +0100
In-Reply-To: <1416394245-31717-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Wed, 19 Nov 2014 02:50:45 -0800")
Message-ID: <87lhn7forv.fsf@vitty.brq.redhat.com>
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
> We'd better not terminate the daemon on this failure, because a typical KVP
> user can re-try the R/W and hopefully it will succeed next time.
>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 22b0764..9f4b303 100644
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

is it possible to meet EAGAIN (or EWOULDBLOCK) here as well? I'd suggest
we ignore these as well in such case. Ignoring ENOMEM here is doubtful,
I think. But possible.

> +				syslog(LOG_ERR, "error = ENOBUFS: ignored");
> +				continue;
> +			}
> +
>  			close(fd);
>  			return -1;
>  		}

-- 
  Vitaly
