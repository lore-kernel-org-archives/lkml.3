Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3LZOOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:14:51 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:46091 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LZOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:14:50 -0500
Message-ID: <52BC39D6.3090908@gmail.com>
Date: Thu, 26 Dec 2013 09:14:46 -0500
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v2 1/2] [CLEANUP] perf-probe: Expand given path to
 absolute path
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal> <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13, 12:41 AM, Masami Hiramatsu wrote:
> @@ -180,7 +181,20 @@ static int opt_set_target(const struct option *opt, const char *str,
>   		else
>   			return ret;
>
> -		params.target = str;
> +		/* Expand given path to absolute path, except for modulename */
> +		if (params.uprobes || strchr(str, '/')) {
> +			tmp = realpath(str, NULL);
> +			if (!tmp) {
> +				pr_warning("Failed to find the path of %s.\n",
> +					   str);

That error message will be misleading if it is generated. How about:
     Failed to get the absolute path of %s: %d\n", str, errno.

> +				return ret;
> +			}
> +		} else {
> +			tmp = strdup(str);
> +			if (!tmp)
> +				return -ENOMEM;
> +		}
> +		params.target = tmp;

When is params.target freed?

David

